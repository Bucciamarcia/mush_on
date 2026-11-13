"""Tests for the payment/booking fixes from the November 2026 code review.

Reuses the fake Firestore / Stripe stubs from test_main.py.

Run with:  venv/bin/python -m unittest test_payment_review_fixes
"""

import types
import unittest
from datetime import datetime, timezone
from unittest.mock import patch

import test_main  # noqa: F401  (installs stubs)
from test_main import (  # noqa: E402
    _FakeCheckoutSession,
    _FakeDb,
    _FakeRefund,
    _FakeStripeAccount,
    _FakeTaxRate,
    _HttpsError,
    main,
)
from test_payment_overhaul import _partner, _stripe_ready, _with_two_adult_prices

BM = "accounts/account-1/data/bookingManager"


def _member_request(**data):
    return types.SimpleNamespace(
        data={"account": "account-1", "bookingId": "booking-1", **data},
        auth=types.SimpleNamespace(uid="user-1"),
    )


def _unpaid_session(session_id="cs_unpaid"):
    return {
        "id": session_id,
        "checkoutSessionId": session_id,
        "bookingId": "booking-1",
        "account": "account-1",
        "stripeId": "acct_123",
        "webhookProcessed": False,
    }


def _paid_session(session_id="cs_paid"):
    return {
        **_unpaid_session(session_id),
        "paymentIntentId": "pi_paid",
        "webhookProcessed": True,
    }


class CheckoutSessionLookupTests(unittest.TestCase):
    def test_refund_uses_the_paid_session_when_booking_has_several(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "paymentStatus": "paid",
        }
        # Unpaid session listed first: the old limit(1) query picked it.
        db.collections["checkoutSessions"] = [_unpaid_session(), _paid_session()]
        refund = _FakeRefund()
        main.firestore.client = lambda: db
        main.stripe.Refund = refund

        result = main.refund_payment(_member_request())

        self.assertEqual(result["refundId"], "refund-1")
        self.assertEqual(refund.calls[0]["payment_intent"], "pi_paid")
        self.assertEqual(
            db.documents[f"{BM}/bookings/booking-1"]["paymentStatus"], "refunded"
        )

    def test_receipt_url_uses_the_paid_session(self):
        db = _FakeDb()
        db.collections["checkoutSessions"] = [_unpaid_session(), _paid_session()]
        main.firestore.client = lambda: db
        with patch.object(
            main, "get_payment_receipt_url", return_value={"url": "u"}
        ) as receipt:
            main.stripe_get_payment_receipt_url(
                types.SimpleNamespace(
                    data={"account": "account-1", "bookingId": "booking-1"}
                )
            )
        self.assertEqual(receipt.call_args.args[1], "cs_paid")

    def test_financial_records_use_the_paid_session(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {
            "account": "account-1",
            "userLevel": "musher",
        }
        db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "paid",
        }
        db.collections["checkoutSessions"] = [
            {**_paid_session(), "total": 9000, "commission": 395},
            {**_unpaid_session(), "total": 12000, "commission": 999},
        ]
        main.firestore.client = lambda: db

        result = main.get_financial_records(
            types.SimpleNamespace(
                data={"account": "account-1"},
                auth=types.SimpleNamespace(uid="user-1"),
            )
        )

        record = result["records"][0]
        self.assertEqual(record["totalCents"], 9000)
        self.assertEqual(record["commissionCents"], 395)


class ManualPaidBookingRefundTests(unittest.TestCase):
    def test_paid_booking_without_stripe_payment_is_marked_refunded(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "paymentStatus": "paid",
        }
        refund = _FakeRefund()
        main.firestore.client = lambda: db
        main.stripe.Refund = refund

        result = main.refund_payment(_member_request())

        self.assertEqual(result, {"refundId": None, "refundStatus": "offPlatform"})
        self.assertEqual(refund.calls, [])
        self.assertEqual(
            db.documents[f"{BM}/bookings/booking-1"]["paymentStatus"], "refunded"
        )

    def test_unpaid_booking_without_session_is_still_not_found(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "paymentStatus": "waiting",
        }
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError) as error:
            main.refund_payment(_member_request())
        self.assertEqual(error.exception.code, "not-found")


class _ExpiringCheckoutSession(_FakeCheckoutSession):
    def __init__(self):
        super().__init__()
        self.expired = []

    def expire(self, session_id, **kwargs):
        self.expired.append((session_id, kwargs))


class ReservationOverwriteTests(unittest.TestCase):
    def setUp(self):
        self.db = _FakeDb()
        _stripe_ready(self.db)
        _with_two_adult_prices(self.db)  # maxCapacity 4
        main.firestore.client = lambda: self.db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.TaxRate = _FakeTaxRate()
        self.checkout = _ExpiringCheckoutSession()
        main.stripe.checkout.Session = self.checkout

    def _book(self, customer_ids):
        return main.create_booking_checkout_session(
            types.SimpleNamespace(
                data={
                    "account": "account-1",
                    "tourId": "tour-1",
                    "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                    "customers": [
                        {"id": cid, "pricingId": "adult"} for cid in customer_ids
                    ],
                }
            )
        )

    def _customers_of_booking(self):
        return sorted(
            path.rsplit("/", 1)[-1]
            for path, data in self.db.documents.items()
            if path.startswith(f"{BM}/customers/")
            and data.get("bookingId") == "booking-1"
        )

    def test_retry_replaces_previous_attempt_customers(self):
        self._book(["c1", "c2"])
        self._book(["c3", "c4", "c5"])

        self.assertEqual(self._customers_of_booking(), ["c3", "c4", "c5"])
        # 3 x 100 EUR, not 5.
        self.assertEqual(self.db.documents["checkoutSessions/cs_123"]["total"], 30000)

    def test_retry_does_not_count_own_previous_attempt_for_capacity(self):
        self._book(["c1", "c2", "c3"])
        # 3 already held by this same booking + 4 requested > 4 would fail if
        # the previous attempt were counted.
        self._book(["c4", "c5", "c6", "c7"])
        self.assertEqual(len(self._customers_of_booking()), 4)

    def test_retry_expires_previous_unpaid_stripe_session(self):
        self.db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
        }
        self.db.documents["checkoutSessions/cs_old"] = _unpaid_session("cs_old")

        self._book(["c1"])

        self.assertEqual(self.checkout.expired[0][0], "cs_old")

    def test_paid_booking_cannot_be_overwritten(self):
        self.db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "paid",
        }

        with self.assertRaises(_HttpsError) as error:
            self._book(["c1"])

        self.assertEqual(error.exception.code, "already-exists")
        self.assertEqual(
            self.db.documents[f"{BM}/bookings/booking-1"]["paymentStatus"], "paid"
        )
        self.assertEqual(self.checkout.calls, [])

    def test_cannot_take_over_customers_of_another_booking(self):
        self.db.documents[f"{BM}/customers/c1"] = {
            "id": "c1",
            "bookingId": "other-booking",
            "pricingId": "adult",
        }

        with self.assertRaises(_HttpsError) as error:
            self._book(["c1"])

        self.assertEqual(error.exception.code, "already-exists")
        self.assertEqual(
            self.db.documents[f"{BM}/customers/c1"]["bookingId"], "other-booking"
        )

    def test_deferred_booking_cannot_be_overwritten(self):
        self.db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "deferredPayment",
        }

        with self.assertRaises(_HttpsError) as error:
            self._book(["c1"])
        self.assertEqual(error.exception.code, "already-exists")


def _event(event_type, payment_status="paid"):
    return types.SimpleNamespace(
        type=event_type,
        account="acct_123",
        data=types.SimpleNamespace(
            object={
                "id": "cs_paid",
                "payment_status": payment_status,
                "payment_intent": "pi_paid",
                "customer_details": {"email": "guest@example.com"},
            }
        ),
    )


class WebhookPaymentStatusTests(unittest.TestCase):
    def setUp(self):
        self.db = _FakeDb()
        self.db.documents["checkoutSessions/cs_paid"] = _unpaid_session("cs_paid")
        self.db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
            "expiresAt": datetime(2026, 1, 1, tzinfo=timezone.utc),
        }
        main.firestore.client = lambda: self.db
        patcher = patch.object(main.add_checkout_session, "payment_processed")
        self.processed = patcher.start()
        self.addCleanup(patcher.stop)

    def _booking(self):
        return self.db.documents[f"{BM}/bookings/booking-1"]

    def test_completed_and_paid_processes_payment(self):
        main._handle_checkout_webhook_event(
            _event("checkout.session.completed"), "test"
        )
        self.processed.assert_called_once()

    def test_completed_but_unpaid_does_not_mark_paid_and_holds_seat(self):
        main._handle_checkout_webhook_event(
            _event("checkout.session.completed", payment_status="unpaid"), "test"
        )
        self.processed.assert_not_called()
        self.assertEqual(self._booking()["paymentStatus"], "waiting")
        self.assertIsNone(self._booking()["expiresAt"])

    def test_async_payment_succeeded_processes_payment(self):
        main._handle_checkout_webhook_event(
            _event("checkout.session.async_payment_succeeded"), "test"
        )
        self.processed.assert_called_once()

    def test_async_payment_failed_releases_seat(self):
        self._booking()["expiresAt"] = None
        main._handle_checkout_webhook_event(
            _event("checkout.session.async_payment_failed", "unpaid"), "test"
        )
        self.processed.assert_not_called()
        self.assertEqual(self._booking()["paymentStatus"], "waiting")
        self.assertIsNotNone(self._booking()["expiresAt"])

    def test_other_events_are_ignored(self):
        main._handle_checkout_webhook_event(
            _event("checkout.session.expired", "unpaid"), "test"
        )
        self.processed.assert_not_called()


class DeferredBookingRollbackTests(unittest.TestCase):
    def test_failed_partner_email_releases_the_seat(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, allowDeferred=True)
        main.firestore.client = lambda: db

        def fail(**kwargs):
            raise RuntimeError("mail provider down")

        with patch.object(main, "send_deferred_payment_email_for_booking", fail):
            with self.assertRaises(_HttpsError) as error:
                main.create_deferred_booking(
                    types.SimpleNamespace(
                        data={
                            "account": "account-1",
                            "tourId": "tour-1",
                            "partner": "partner-1",
                            "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                            "customers": [{"id": "customer-1", "pricingId": "adult"}],
                        }
                    )
                )

        self.assertEqual(error.exception.code, "internal")
        self.assertNotIn(f"{BM}/bookings/booking-1", db.documents)
        self.assertNotIn(f"{BM}/customers/customer-1", db.documents)


class TaxRateRetryTests(unittest.TestCase):
    def test_retry_keeps_stored_vat_treatment_and_matching_fee(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        db.collections[f"{BM}/tours/tour-1/prices"][0].update(
            {"priceCents": 12550, "vatRate": 0.255}
        )
        # Partner has since switched to reverse charge; the booking was
        # stored (and must be charged) with VAT.
        partner = _partner(db, discountRate=0.0, reverseChargeVat=True)
        db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "deferredPayment",
        }
        db.documents[f"{BM}/customers/c1"] = {
            "id": "c1",
            "bookingId": "booking-1",
            "pricingId": "adult",
        }
        cache_ref = main._tax_rate_cache_ref(db, "account-1", "test", "acct_123", 25.5)
        db.documents[cache_ref.path] = {"taxRateId": "txr_stale"}
        checkout = _FakeCheckoutSession(
            failures=[Exception("No such tax rate: 'txr_stale'")]
        )
        main.firestore.client = lambda: db
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = _FakeTaxRate(ids=["txr_fresh"])
        payload = main._build_server_checkout_payload(
            db,
            "account-1",
            "booking-1",
            "tour-1",
            "cg-1",
            "test",
            "acct_123",
            partner=partner,
            reverse_charge_vat_override=False,
        )

        main._create_checkout_session_with_tax_rate_retry(
            db, "account-1", "test", "acct_123", payload, "booking-1"
        )

        first, retry = checkout.calls
        self.assertEqual(retry["line_items"][0]["tax_rates"], ["txr_fresh"])
        self.assertEqual(
            retry["line_items"][0]["price_data"]["unit_amount"],
            first["line_items"][0]["price_data"]["unit_amount"],
        )
        self.assertEqual(payload["total_amount_cents"], 12550)
        self.assertEqual(
            retry["payment_intent_data"],
            {"application_fee_amount": payload["fee_amount"]},
        )


class PaymentProcessedIdempotencyTests(unittest.TestCase):
    def setUp(self):
        self.db = _FakeDb()
        _stripe_ready(self.db)
        _with_two_adult_prices(self.db)
        self.db.documents["checkoutSessions/cs_paid"] = {
            **_unpaid_session("cs_paid"),
            "createdAt": datetime(2026, 1, 1, tzinfo=timezone.utc),
        }
        self.db.documents[f"{BM}/bookings/booking-1"] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
            "name": "Guest",
            "email": "guest@example.com",
            "phone": "1",
            "streetAddress": "s",
            "zipCode": "z",
            "city": "c",
            "country": "FI",
        }
        self.db.documents[f"{BM}/customerGroups/cg-1"].update(
            {"name": "Morning tour"}
        )
        main.firestore.client = lambda: self.db
        self.module = main.add_checkout_session
        self.emails = []
        self.callbacks = []
        for name, value in {
            "get_payment_receipt_url": lambda **k: {"url": "r", "total": 10000},
            "send_postmark_email": lambda **k: self.emails.append(k),
        }.items():
            patcher = patch.object(self.module, name, value)
            patcher.start()
            self.addCleanup(patcher.stop)

    def _process(self):
        self.module.payment_processed(
            checkout_session_id="cs_paid",
            stripe_account="acct_123",
            stripe_api_key="sk_test",
            payment_intent_id="pi_paid",
            stripe_email="guest@example.com",
            post_payment_callback=lambda **k: self.callbacks.append(k),
        )

    def _session(self):
        return self.db.documents["checkoutSessions/cs_paid"]

    def test_duplicate_delivery_sends_one_email_and_one_invoice(self):
        self._process()
        self._process()

        self.assertEqual(len(self.emails), 1)
        self.assertEqual(len(self.callbacks), 1)
        self.assertEqual(
            self.db.documents[f"{BM}/bookings/booking-1"]["paymentStatus"], "paid"
        )
        self.assertEqual(self._session()["paymentIntentId"], "pi_paid")
        self.assertEqual(self._session()["confirmationEmail"], "sent")

    def test_concurrent_delivery_that_loses_the_claim_does_nothing(self):
        # Both deliveries read webhookProcessed=False; the other one commits
        # its claim first.
        self._session().update(
            {"webhookProcessed": True, "confirmationEmail": "sending"}
        )
        with patch.object(
            self.module.CheckoutSession,
            "model_validate",
            lambda data: self.module.CheckoutSession(
                **{**data, "webhookProcessed": False}
            ),
        ):
            self._process()

        self.assertEqual(self.emails, [])
        self.assertEqual(self.callbacks, [])

    def test_failed_email_is_retried_on_next_delivery(self):
        def fail(**kwargs):
            raise RuntimeError("mail provider down")

        with patch.object(self.module, "send_postmark_email", fail):
            with self.assertRaises(RuntimeError):
                self._process()
        self.assertEqual(self._session()["confirmationEmail"], "pending")
        self.assertEqual(
            self.db.documents[f"{BM}/bookings/booking-1"]["paymentStatus"], "paid"
        )

        self._process()

        self.assertEqual(len(self.emails), 1)
        self.assertEqual(len(self.callbacks), 1)
        self.assertEqual(self._session()["confirmationEmail"], "sent")

    def test_sessions_processed_before_the_email_flag_are_skipped(self):
        self._session()["webhookProcessed"] = True

        self._process()

        self.assertEqual(self.emails, [])


if __name__ == "__main__":
    unittest.main()
