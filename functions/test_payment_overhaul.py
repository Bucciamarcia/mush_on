"""Failing tests for the payment / reseller overhaul.

These encode the desired behaviour described in payment_overhaul.md. They reuse
the fake Firestore / Stripe infrastructure defined in test_main.py (importing it
installs the module stubs and imports `main`). Until the spec is implemented,
the referenced `main.*` symbols do not exist and these tests fail.

Run with:  python -m unittest functions/test_payment_overhaul.py
"""

import os
import types
import unittest
from datetime import date, datetime, timezone
from unittest.mock import patch

# Importing test_main installs the firebase/stripe stubs and imports `main`.
import test_main
from test_main import (  # noqa: E402
    _FakeCheckoutSession,
    _FakeDb,
    _FakeStripeAccount,
    _FakeTaxRate,
    _HttpsError,
    main,
)


def _stripe_ready(db):
    """Set up an active Stripe integration + kennel info for `account-1`."""
    db.documents["accounts/account-1/integrations/stripe"] = {
        "accountId": "acct_123",
        "isActive": True,
    }
    db.documents["accounts/account-1/data/bookingManager"] = {
        "name": "Husky Kennel",
        "url": "https://huskies.example",
        "email": "hello@huskies.example",
        "cancellationPolicy": "No refunds within 24h",
        "commissionRate": 0.035,
        "vatRate": 0.255,
        "timezone": "Europe/Helsinki",
    }


def _with_two_adult_prices(db):
    db.documents["accounts/account-1/data/bookingManager/customerGroups/cg-1"] = {
        "id": "cg-1",
        "tourTypeId": "tour-1",
        "maxCapacity": 4,
        "datetime": datetime(2026, 7, 1, 10, 0, tzinfo=timezone.utc),
    }
    db.collections["accounts/account-1/data/bookingManager/tours/tour-1/prices"] = [
        {
            "id": "adult",
            "isArchived": False,
            "displayName": "Adult",
            "priceCents": 10000,
            "vatRate": 0,
        }
    ]


def _partner(db, **overrides):
    partner = {
        "id": "partner-1",
        "name": "Acme Tours",
        "code": "acme",
        "email": "ops@acme.example",
        "discountRate": 0.1,
        "allowDeferred": True,
        "deferredDays": 7,
        "archived": False,
    }
    partner.update(overrides)
    db.documents[
        f"accounts/account-1/data/bookingManager/partners/{partner['id']}"
    ] = partner
    return partner


class PartnerDiscountCheckoutTests(unittest.TestCase):
    def test_partner_discount_reduces_line_items_total_and_fee(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, discountRate=0.1)
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = _FakeTaxRate()
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "partner": "partner-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        main.create_booking_checkout_session(request)

        call = checkout.calls[0]
        # 10000 with 10% off == 9000 per ticket.
        self.assertEqual(call["line_items"][0]["price_data"]["unit_amount"], 9000)
        # fee = 9000 * 0.035 * (1 + 0.255) == 395 (int truncation).
        self.assertEqual(
            call["payment_intent_data"], {"application_fee_amount": 395}
        )
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["total"], 9000)
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["commission"], 395)

    def test_partner_id_persisted_on_booking_and_checkout_session(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, discountRate=0.0)
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = _FakeCheckoutSession()
        main.stripe.TaxRate = _FakeTaxRate()
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "partner": "partner-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        main.create_booking_checkout_session(request)

        booking_path = (
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        )
        self.assertEqual(db.documents[booking_path]["partner"], "partner-1")
        self.assertEqual(db.documents[booking_path]["totalCents"], 10000)
        self.assertEqual(
            db.documents["checkoutSessions/cs_123"]["partner"], "partner-1"
        )


class CreateDeferredBookingTests(unittest.TestCase):
    def _request(self):
        return types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "partner": "partner-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

    def test_creates_deferred_booking_with_partner_and_total(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, discountRate=0.1, allowDeferred=True)
        main.firestore.client = lambda: db
        sent = []
        with patch.object(
            main, "send_deferred_payment_email_for_booking", lambda **k: sent.append(k)
        ):
            result = main.create_deferred_booking(self._request())

        self.assertEqual(result, {"bookingId": "booking-1"})
        booking = db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]
        self.assertEqual(booking["paymentStatus"], "deferredPayment")
        self.assertEqual(booking["partner"], "partner-1")
        self.assertEqual(booking["totalCents"], 9000)
        # deferred bookings hold the seat permanently — no expiry.
        self.assertNotIn("expiresAt", booking)
        # partner confirmation email triggered exactly once.
        self.assertEqual(len(sent), 1)

    def test_rejects_partner_without_deferred_permission(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, allowDeferred=False)
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError) as error:
            main.create_deferred_booking(self._request())
        self.assertEqual(error.exception.code, "failed-precondition")

    def test_rejects_full_group(self):
        db = _FakeDb()
        _stripe_ready(db)
        _with_two_adult_prices(db)
        db.documents["accounts/account-1/data/bookingManager/customerGroups/cg-1"][
            "maxCapacity"
        ] = 1
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/existing"
        ] = {
            "id": "existing",
            "customerGroupId": "cg-1",
            "paymentStatus": "paid",
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/existing-c"
        ] = {"id": "existing-c", "bookingId": "existing", "pricingId": "adult"}
        _partner(db, allowDeferred=True)
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError) as error:
            main.create_deferred_booking(self._request())
        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertEqual(error.exception.message, "This group is now full")


class DeferredPayLinkTests(unittest.TestCase):
    def _seed_deferred_booking(self, db):
        _stripe_ready(db)
        _with_two_adult_prices(db)
        _partner(db, discountRate=0.1)
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "paymentStatus": "deferredPayment",
            "partner": "partner-1",
            "totalCents": 9000,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/customer-1"
        ] = {"id": "customer-1", "bookingId": "booking-1", "pricingId": "adult"}

    def test_pay_link_reapplies_discount_and_creates_session(self):
        db = _FakeDb()
        self._seed_deferred_booking(db)
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = _FakeTaxRate()

        result = main._create_deferred_checkout_session(db, "account-1", "booking-1")

        self.assertEqual(result["url"], "https://checkout.test/session")
        self.assertEqual(
            checkout.calls[0]["line_items"][0]["price_data"]["unit_amount"], 9000
        )
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["total"], 9000)

    def test_pay_link_rejects_already_paid_booking(self):
        db = _FakeDb()
        self._seed_deferred_booking(db)
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]["paymentStatus"] = "paid"
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError):
            main._create_deferred_checkout_session(db, "account-1", "booking-1")


class DeferredPaymentEmailTests(unittest.TestCase):
    def test_email_goes_to_partner_with_pay_link_amount_and_custom_fields(self):
        db = _FakeDb()
        _stripe_ready(db)
        db.documents["accounts/account-1/data/bookingManager"][
            "bookingCustomFields"
        ] = [{"name": "Pickup"}]
        db.documents["accounts/account-1/data/bookingManager/customerGroups/cg-1"] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "datetime": datetime(2026, 7, 1, 10, 0, tzinfo=timezone.utc),
        }
        _partner(db, email="ops@acme.example", deferredDays=7)
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
            "name": "Acme group",
            "paymentStatus": "deferredPayment",
            "partner": "partner-1",
            "totalCents": 9000,
            "otherBookingData": {"Pickup": "Hotel Aurora"},
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/customer-1"
        ] = {"id": "customer-1", "bookingId": "booking-1", "pricingId": "adult"}
        main.firestore.client = lambda: db

        calls = []

        def fake_post(url, json, headers):
            calls.append({"url": url, "json": json, "headers": headers})
            return types.SimpleNamespace(
                status_code=200, raise_for_status=lambda: None
            )

        env = {
            "ZEPTOMAIL_AUTHORIZATION": "Zoho-token",
            "PAY_BASE_URL": "https://mush-on.web.app/pay",
        }
        request = types.SimpleNamespace(
            data={"account": "account-1", "bookingId": "booking-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )
        db.documents["users/user-1"] = {"account": "account-1"}

        with patch.dict(os.environ, env, clear=False):
            with patch.object(main_requests(), "post", fake_post):
                main.send_deferred_payment_email(request)

        self.assertEqual(len(calls), 1)
        payload = calls[0]["json"]
        recipient = payload["to"][0]["email_address"]["address"]
        self.assertEqual(recipient, "ops@acme.example")
        merge = payload["merge_info"]
        self.assertIn("account=account-1", merge["pay_url"])
        self.assertIn("bookingId=booking-1", merge["pay_url"])
        self.assertIn("90", merge["amount"])  # 9000 cents -> 90.00
        self.assertIn("Hotel Aurora", merge["booking_other_info"])


class CancelAndMarkPaidTests(unittest.TestCase):
    def _seed(self, db, status):
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ] = {"id": "booking-1", "customerGroupId": "cg-1", "paymentStatus": status}
        db.documents[
            "accounts/account-1/data/bookingManager/customers/customer-1"
        ] = {"id": "customer-1", "bookingId": "booking-1", "pricingId": "adult"}

    def _request(self):
        return types.SimpleNamespace(
            data={"account": "account-1", "bookingId": "booking-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

    def test_cancel_deletes_deferred_booking_and_customers(self):
        db = _FakeDb()
        self._seed(db, "deferredPayment")
        main.firestore.client = lambda: db

        main.cancel_booking(self._request())

        self.assertNotIn(
            "accounts/account-1/data/bookingManager/bookings/booking-1",
            db.documents,
        )
        self.assertNotIn(
            "accounts/account-1/data/bookingManager/customers/customer-1",
            db.documents,
        )

    def test_cancel_rejects_paid_booking(self):
        db = _FakeDb()
        self._seed(db, "paid")
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError) as error:
            main.cancel_booking(self._request())
        self.assertEqual(error.exception.code, "failed-precondition")

    def test_mark_paid_off_platform_sets_status(self):
        db = _FakeDb()
        self._seed(db, "deferredPayment")
        main.firestore.client = lambda: db

        main.mark_booking_paid_off_platform(self._request())

        self.assertEqual(
            db.documents[
                "accounts/account-1/data/bookingManager/bookings/booking-1"
            ]["paymentStatus"],
            "paidOffPlatform",
        )


class CapacityTests(unittest.TestCase):
    def test_paid_off_platform_booking_fills_capacity(self):
        db = _FakeDb()
        _stripe_ready(db)
        # Seed prices so the ONLY reason to fail is the capacity check, not a
        # missing pricing lookup.
        _with_two_adult_prices(db)
        db.documents["accounts/account-1/data/bookingManager/customerGroups/cg-1"] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "maxCapacity": 1,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/existing"
        ] = {
            "id": "existing",
            "customerGroupId": "cg-1",
            "paymentStatus": "paidOffPlatform",
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/existing-c"
        ] = {"id": "existing-c", "bookingId": "existing", "pricingId": "adult"}
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        checkout = _FakeCheckoutSession()
        main.stripe.checkout.Session = checkout
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        with self.assertRaises(_HttpsError) as error:
            main.create_booking_checkout_session(request)
        self.assertEqual(error.exception.message, "This group is now full")
        self.assertEqual(checkout.calls, [])


class DeferredReminderDateMathTests(unittest.TestCase):
    def test_due_date_is_tour_date_minus_deferred_days(self):
        self.assertEqual(
            main._deferred_payment_due_date(date(2026, 7, 10), 7),
            date(2026, 7, 3),
        )

    def test_reminder_fires_one_day_before_due(self):
        due = date(2026, 7, 3)
        self.assertTrue(main._should_send_deferred_reminder(due, date(2026, 7, 2)))
        self.assertFalse(main._should_send_deferred_reminder(due, date(2026, 7, 3)))
        self.assertFalse(main._should_send_deferred_reminder(due, date(2026, 7, 1)))


class FinancialRecordsTests(unittest.TestCase):
    def _seed(self, db):
        db.documents["accounts/account-1/data/bookingManager/customerGroups/cg-1"] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "datetime": datetime(2026, 7, 1, 10, 0, tzinfo=timezone.utc),
        }
        # On-platform paid: total + commission come from the checkoutSession.
        db.documents["accounts/account-1/data/bookingManager/bookings/b-paid"] = {
            "id": "b-paid",
            "customerGroupId": "cg-1",
            "paymentStatus": "paid",
            "partner": "partner-1",
            "totalCents": 9000,
        }
        db.documents["checkoutSessions/cs-1"] = {
            "checkoutSessionId": "cs-1",
            "account": "account-1",
            "bookingId": "b-paid",
            "total": 9000,
            "commission": 395,
            "partner": "partner-1",
        }
        # Off-platform: no session, no commission.
        db.documents["accounts/account-1/data/bookingManager/bookings/b-off"] = {
            "id": "b-off",
            "customerGroupId": "cg-1",
            "paymentStatus": "paidOffPlatform",
            "totalCents": 5000,
        }
        # Deferred: outstanding, no commission.
        db.documents["accounts/account-1/data/bookingManager/bookings/b-def"] = {
            "id": "b-def",
            "customerGroupId": "cg-1",
            "paymentStatus": "deferredPayment",
            "totalCents": 8000,
        }
        # Waiting: not revenue-bearing, must be skipped.
        db.documents["accounts/account-1/data/bookingManager/bookings/b-wait"] = {
            "id": "b-wait",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
            "totalCents": 1000,
        }

    def _request(self):
        return types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

    def test_musher_gets_joined_records_with_commission(self):
        db = _FakeDb()
        self._seed(db)
        db.documents["users/user-1"] = {
            "account": "account-1",
            "userLevel": "musher",
        }
        main.firestore.client = lambda: db

        result = main.get_financial_records(self._request())
        records = {r["status"]: r for r in result["records"]}

        # waiting booking is excluded.
        self.assertEqual(len(result["records"]), 3)
        self.assertNotIn("waiting", records)

        paid = records["paid"]
        self.assertEqual(paid["totalCents"], 9000)
        self.assertEqual(paid["commissionCents"], 395)
        self.assertEqual(paid["partner"], "partner-1")
        self.assertEqual(paid["tourTypeId"], "tour-1")
        self.assertTrue(paid["date"].startswith("2026-07-01"))

        # Off-platform / deferred never carry commission.
        self.assertEqual(records["paidOffPlatform"]["commissionCents"], 0)
        self.assertEqual(records["deferredPayment"]["commissionCents"], 0)
        self.assertEqual(records["deferredPayment"]["totalCents"], 8000)

    def test_non_musher_is_rejected(self):
        db = _FakeDb()
        self._seed(db)
        db.documents["users/user-1"] = {
            "account": "account-1",
            "userLevel": "handler",
        }
        main.firestore.client = lambda: db

        with self.assertRaises(_HttpsError) as error:
            main.get_financial_records(self._request())
        self.assertEqual(error.exception.code, "permission-denied")


def main_requests():
    """The `requests` module object used inside main, for patching .post."""
    return main.requests


if __name__ == "__main__":
    unittest.main()
