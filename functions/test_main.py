import importlib
import json as std_json
import pathlib
import sys
import types
import unittest
from datetime import datetime, timezone


class _HttpsError(Exception):
    def __init__(self, code, message):
        super().__init__(message)
        self.code = code
        self.message = message


class _CallableRequest:
    def __class_getitem__(cls, item):
        return cls


class _Request:
    pass


class _Response:
    def __init__(self, body="", status=200):
        self.body = body
        self.status = status


class _ScheduledEvent:
    pass


def _identity_decorator(*args, **kwargs):
    if args and callable(args[0]) and not kwargs:
        return args[0]

    def decorate(fn):
        return fn

    return decorate


def _install_stubs():
    root = pathlib.Path(__file__).resolve().parent
    if str(root) not in sys.path:
        sys.path.insert(0, str(root))

    https_fn = types.SimpleNamespace(
        CallableRequest=_CallableRequest,
        Request=_Request,
        Response=_Response,
        HttpsError=_HttpsError,
        FunctionsErrorCode=types.SimpleNamespace(
            INVALID_ARGUMENT="invalid-argument",
            UNAUTHENTICATED="unauthenticated",
            PERMISSION_DENIED="permission-denied",
            NOT_FOUND="not-found",
            FAILED_PRECONDITION="failed-precondition",
            INTERNAL="internal",
        ),
        on_call=_identity_decorator,
        on_request=_identity_decorator,
    )
    scheduler_fn = types.SimpleNamespace(
        ScheduledEvent=_ScheduledEvent,
        on_schedule=_identity_decorator,
    )

    firebase_functions = types.ModuleType("firebase_functions")
    firebase_functions.https_fn = https_fn
    firebase_functions.scheduler_fn = scheduler_fn
    sys.modules["firebase_functions"] = firebase_functions

    firebase_options = types.ModuleType("firebase_functions.options")
    firebase_options.set_global_options = lambda *args, **kwargs: None
    sys.modules["firebase_functions.options"] = firebase_options

    firebase_admin = types.ModuleType("firebase_admin")
    firebase_admin.initialize_app = lambda *args, **kwargs: None
    firebase_admin.firestore = types.SimpleNamespace(
        client=lambda: None,
        transactional=_identity_decorator,
    )
    sys.modules["firebase_admin"] = firebase_admin

    google = types.ModuleType("google")
    google_cloud = types.ModuleType("google.cloud")
    google_firestore = types.ModuleType("google.cloud.firestore")
    google_firestore.DocumentSnapshot = object
    google_firestore_v1 = types.ModuleType("google.cloud.firestore_v1")
    google_query_results = types.ModuleType("google.cloud.firestore_v1.query_results")
    google_query_results.QueryResultsList = list
    sys.modules["google"] = google
    sys.modules["google.cloud"] = google_cloud
    sys.modules["google.cloud.firestore"] = google_firestore
    sys.modules["google.cloud.firestore_v1"] = google_firestore_v1
    sys.modules["google.cloud.firestore_v1.query_results"] = google_query_results

    flask = types.ModuleType("flask")
    flask.json = std_json
    sys.modules["flask"] = flask

    dotenv = types.ModuleType("dotenv")
    dotenv.load_dotenv = lambda *args, **kwargs: None
    sys.modules["dotenv"] = dotenv

    stripe = types.ModuleType("stripe")
    stripe.api_key = None
    stripe.Account = types.SimpleNamespace(create=lambda **kwargs: None)
    stripe.AccountLink = types.SimpleNamespace(create=lambda **kwargs: None)
    stripe.TaxRate = types.SimpleNamespace(create=lambda **kwargs: None)
    stripe.Webhook = types.SimpleNamespace(construct_event=lambda *args, **kwargs: None)
    stripe.Event = object
    stripe.checkout = types.SimpleNamespace(
        Session=types.SimpleNamespace(
            create=lambda **kwargs: None,
            retrieve=lambda *args, **kwargs: None,
        )
    )
    stripe.PaymentIntent = types.SimpleNamespace(retrieve=lambda *args, **kwargs: None)
    stripe.Charge = types.SimpleNamespace(retrieve=lambda *args, **kwargs: None)
    stripe.Refund = types.SimpleNamespace(create=lambda **kwargs: None)
    sys.modules["stripe"] = stripe


_install_stubs()
main = importlib.import_module("main")


class _Snapshot:
    def __init__(self, data=None, exists=True, doc_id=None):
        self._data = data
        self.exists = exists
        self.id = doc_id

    def to_dict(self):
        return self._data


class _DocRef:
    def __init__(self, db, path):
        self.db = db
        self.path = path

    def get(self):
        return _Snapshot(
            self.db.documents.get(self.path),
            self.path in self.db.documents,
            self.path.rsplit("/", 1)[-1],
        )

    def update(self, data):
        self.db.documents.setdefault(self.path, {}).update(data)
        self.db.updates.append((self.path, data))

    def set(self, data):
        self.db.documents[self.path] = data
        parent = self.path.rsplit("/", 1)[0]
        collection = self.db.collections.setdefault(parent, [])
        doc_id = self.path.rsplit("/", 1)[-1]
        without_existing = [
            item for item in collection if (item.get("id") or doc_id) != doc_id
        ]
        without_existing.append(data)
        self.db.collections[parent] = without_existing
        self.db.sets.append((self.path, data))

    def collection(self, name):
        return _Query(self.db, f"{self.path}/{name}")


class _Query:
    def __init__(self, db, collection_name):
        self.db = db
        self.collection_name = collection_name
        self.filters = []
        self.limit_value = None

    def where(self, field, op, value):
        self.filters.append((field, op, value))
        return self

    def limit(self, value):
        self.limit_value = value
        return self

    def stream(self):
        docs = []
        collection_data = list(self.db.collections.get(self.collection_name, []))
        prefix = f"{self.collection_name}/"
        for path, data in self.db.documents.items():
            if not path.startswith(prefix):
                continue
            remainder = path[len(prefix) :]
            if "/" not in remainder and data not in collection_data:
                collection_data.append(data)
        for data in collection_data:
            matches = all(
                data.get(field) == value
                if op == "=="
                else data.get(field) in value
                if op == "in"
                else False
                for field, op, value in self.filters
            )
            if matches:
                docs.append(_Snapshot(data, doc_id=data.get("id")))
        if self.limit_value is not None:
            docs = docs[: self.limit_value]
        return iter(docs)

    def document(self, doc_id):
        return _DocRef(self.db, f"{self.collection_name}/{doc_id}")


class _FakeTransaction:
    def get(self, ref_or_query):
        if hasattr(ref_or_query, "stream"):
            return list(ref_or_query.stream())
        return iter([ref_or_query.get()])

    def set(self, ref, data):
        ref.set(data)

    def update(self, ref, data):
        ref.update(data)


class _FakeDb:
    def __init__(self):
        self.documents = {}
        self.collections = {}
        self.updates = []
        self.sets = []

    def document(self, path):
        return _DocRef(self, path)

    def collection(self, name):
        return _Query(self, name)

    def transaction(self):
        return _FakeTransaction()


class _FakeRefund:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="refund-1")


class _FakeCheckoutSession:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="cs_123", url="https://checkout.test/session")


class BackendSecurityTests(unittest.TestCase):
    def test_callable_safe_firestore_data_converts_datetimes_recursively(self):
        dt = datetime(2026, 4, 25, 12, 30, tzinfo=timezone.utc)

        result = main._callable_safe_firestore_data({"items": [{"at": dt}]})

        self.assertEqual(
            result,
            {"items": [{"at": {"_millisecondsSinceEpoch": 1777120200000}}]},
        )

    def test_chunks_splits_values_for_firestore_in_queries(self):
        self.assertEqual(
            list(main._chunks(["a", "b", "c", "d", "e"], size=2)),
            [["a", "b"], ["c", "d"], ["e"]],
        )

    def test_create_checkout_session_calculates_price_and_fee_server_side(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        db.documents["accounts/account-1/data/bookingManager"] = {
            "commissionRate": 0.035,
            "vatRate": 0.255,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ] = {
            "id": "booking-1",
            "customerGroupId": "cg-1",
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customerGroups/cg-1"
        ] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "maxCapacity": 10,
        }
        db.collections["accounts/account-1/data/bookingManager/customers"] = [
            {"id": "customer-1", "bookingId": "booking-1", "pricingId": "adult"},
            {"id": "customer-2", "bookingId": "booking-1", "pricingId": "adult"},
            {"id": "customer-3", "bookingId": "booking-1", "pricingId": "child"},
        ]
        db.collections[
            "accounts/account-1/data/bookingManager/tours/tour-1/prices"
        ] = [
            {
                "id": "adult",
                "isArchived": False,
                "displayName": "Adult",
                "priceCents": 10000,
                "stripeTaxRateId": "txr_adult",
            },
            {
                "id": "child",
                "isArchived": False,
                "displayName": "Child",
                "priceCents": 5000,
                "stripeTaxRateId": "txr_child",
            },
        ]
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.checkout.Session = checkout
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "bookingId": "booking-1",
                "tourId": "tour-1",
                "customerGroupId": "cg-1",
                "lineItems": [{"price_data": {"unit_amount": 1}, "quantity": 1}],
                "feeAmount": 1,
                "totalAmount": 1,
            }
        )

        result = main.create_checkout_session(request)

        self.assertEqual(result, {"url": "https://checkout.test/session"})
        self.assertEqual(len(checkout.calls), 1)
        call = checkout.calls[0]
        self.assertEqual(call["stripe_account"], "acct_123")
        self.assertEqual(call["payment_intent_data"], {"application_fee_amount": 1098})
        self.assertCountEqual(
            call["line_items"],
            [
                {
                    "price_data": {
                        "tax_behavior": "inclusive",
                        "currency": "eur",
                        "product_data": {
                            "name": "Adult",
                            "metadata": {"pricing_id": "adult"},
                        },
                        "unit_amount": 10000,
                    },
                    "quantity": 2,
                    "tax_rates": ["txr_adult"],
                },
                {
                    "price_data": {
                        "tax_behavior": "inclusive",
                        "currency": "eur",
                        "product_data": {
                            "name": "Child",
                            "metadata": {"pricing_id": "child"},
                        },
                        "unit_amount": 5000,
                    },
                    "quantity": 1,
                    "tax_rates": ["txr_child"],
                },
            ],
        )
        self.assertEqual(
            db.documents["checkoutSessions/cs_123"]["total"],
            25000,
        )
        self.assertEqual(
            db.documents["checkoutSessions/cs_123"]["commission"],
            1098,
        )

    def test_create_checkout_session_rejects_inactive_stripe_integration(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": False,
        }
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.checkout.Session = checkout
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "bookingId": "booking-1",
                "tourId": "tour-1",
                "customerGroupId": "cg-1",
            }
        )

        result = main.create_checkout_session(request)

        self.assertEqual(result, {"error": "Stripe integration is not active"})
        self.assertEqual(checkout.calls, [])

    def test_create_booking_checkout_session_rejects_full_customer_group(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customerGroups/cg-1"
        ] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "maxCapacity": 2,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/existing-booking"
        ] = {
            "id": "existing-booking",
            "customerGroupId": "cg-1",
            "paymentStatus": "paid",
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/existing-customer"
        ] = {
            "id": "existing-customer",
            "bookingId": "existing-booking",
            "pricingId": "adult",
        }
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.checkout.Session = checkout
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [
                    {"id": "customer-1", "pricingId": "adult"},
                    {"id": "customer-2", "pricingId": "adult"},
                ],
            }
        )

        with self.assertRaises(_HttpsError) as error:
            main.create_booking_checkout_session(request)

        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertEqual(error.exception.message, "This group is now full")
        self.assertEqual(checkout.calls, [])

    def test_create_booking_checkout_session_ignores_expired_waiting_bookings(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        db.documents["accounts/account-1/data/bookingManager"] = {
            "commissionRate": 0.035,
            "vatRate": 0.255,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customerGroups/cg-1"
        ] = {
            "id": "cg-1",
            "tourTypeId": "tour-1",
            "maxCapacity": 1,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/expired-booking"
        ] = {
            "id": "expired-booking",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
            "expiresAt": datetime(2026, 1, 1, tzinfo=timezone.utc),
        }
        db.documents[
            "accounts/account-1/data/bookingManager/customers/expired-customer"
        ] = {
            "id": "expired-customer",
            "bookingId": "expired-booking",
            "pricingId": "adult",
        }
        db.collections[
            "accounts/account-1/data/bookingManager/tours/tour-1/prices"
        ] = [
            {
                "id": "adult",
                "isArchived": False,
                "displayName": "Adult",
                "priceCents": 10000,
            }
        ]
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.checkout.Session = checkout
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "booking": {
                    "id": "booking-1",
                    "customerGroupId": "cg-1",
                    "email": "customer@example.com",
                },
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        result = main.create_booking_checkout_session(request)

        self.assertEqual(
            result,
            {
                "url": "https://checkout.test/session",
                "bookingId": "booking-1",
                "checkoutSessionId": "cs_123",
            },
        )
        self.assertEqual(len(checkout.calls), 1)
        self.assertEqual(
            db.documents[
                "accounts/account-1/data/bookingManager/bookings/booking-1"
            ]["paymentStatus"],
            "waiting",
        )
        self.assertIn(
            "expiresAt",
            db.documents[
                "accounts/account-1/data/bookingManager/bookings/booking-1"
            ],
        )
        self.assertEqual(
            db.documents[
                "accounts/account-1/data/bookingManager/bookings/booking-1"
            ]["checkoutSessionId"],
            "cs_123",
        )

    def test_refund_payment_reads_secret_payment_data_server_side_and_updates_booking(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.collections["checkoutSessions"] = [
            {
                "bookingId": "booking-1",
                "account": "account-1",
                "paymentIntentId": "pi_123",
                "stripeId": "acct_123",
            }
        ]
        refund = _FakeRefund()
        main.firestore.client = lambda: db
        main.stripe.Refund = refund
        request = types.SimpleNamespace(
            data={"account": "account-1", "bookingId": "booking-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.refund_payment(request)

        self.assertEqual(result, {"refundId": "refund-1"})
        self.assertEqual(
            refund.calls,
            [
                {
                    "payment_intent": "pi_123",
                    "stripe_account": "acct_123",
                    "refund_application_fee": True,
                }
            ],
        )
        self.assertEqual(
            db.updates,
            [
                (
                    "accounts/account-1/data/bookingManager/bookings/booking-1",
                    {"paymentStatus": "refunded"},
                )
            ],
        )

    def test_refund_payment_rejects_users_from_other_accounts(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1", "bookingId": "booking-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.refund_payment(request)

        self.assertEqual(error.exception.code, "permission-denied")


if __name__ == "__main__":
    unittest.main()
