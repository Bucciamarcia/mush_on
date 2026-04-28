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
    def __init__(self, data=None, exists=True, doc_id=None, reference=None):
        self._data = data
        self.exists = exists
        self.id = doc_id
        self.reference = reference

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
            self,
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
                doc_id = data.get("id")
                reference = _DocRef(self.db, f"{self.collection_name}/{doc_id}")
                docs.append(_Snapshot(data, doc_id=doc_id, reference=reference))
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


class _FakeBatch:
    def __init__(self, db):
        self.db = db
        self.operations = []
        self.committed = False

    def update(self, ref, data):
        self.operations.append((ref, data))

    def commit(self):
        self.committed = True
        for ref, data in self.operations:
            ref.update(data)


class _FakeDb:
    def __init__(self):
        self.documents = {}
        self.collections = {}
        self.updates = []
        self.sets = []
        self.batches = []

    def document(self, path):
        return _DocRef(self, path)

    def collection(self, name):
        return _Query(self, name)

    def transaction(self):
        return _FakeTransaction()

    def batch(self):
        batch = _FakeBatch(self)
        self.batches.append(batch)
        return batch


class _FakeRefund:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="refund-1", status="succeeded")


class _FakeCheckoutSession:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="cs_123", url="https://checkout.test/session")


class _FakeStripeAccount:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="acct_new")


class _FakeAccountLink:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(url="https://connect.stripe.test/onboarding")


class _FakeTaxRate:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="txr_123")


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

    def test_add_booking_rejects_legacy_public_write_path(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            },
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.add_booking(request)

        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertEqual(
            error.exception.message,
            "Legacy add_booking is disabled. Use create_booking_checkout_session.",
        )
        self.assertEqual(db.documents, {})
        self.assertEqual(db.collections, {})

    def test_stripe_create_account_requires_account_membership_and_saves_server_side(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        account = _FakeStripeAccount()
        main.firestore.client = lambda: db
        main.stripe.Account = account
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.stripe_create_account(request)

        self.assertEqual(result, {"account": "acct_new"})
        self.assertEqual(len(account.calls), 1)
        self.assertEqual(
            db.documents["accounts/account-1/integrations/stripe"],
            {"accountId": "acct_new"},
        )

    def test_stripe_create_account_rejects_wrong_account_user(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        account = _FakeStripeAccount()
        main.firestore.client = lambda: db
        main.stripe.Account = account
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.stripe_create_account(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertEqual(account.calls, [])

    def test_stripe_admin_callables_reject_unauthenticated_requests(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        cases = [
            (main.stripe_create_account, {"account": "account-1"}),
            (
                main.stripe_create_account_link,
                {"account": "account-1", "stripeAccount": "acct_123"},
            ),
            (
                main.change_stripe_integration_activation,
                {"account": "account-1", "isActive": True},
            ),
            (main.get_stripe_integration_data, {"account": "account-1"}),
            (main.create_stripe_tax_rate, {"account": "account-1", "percentage": 25.5}),
        ]

        for fn, data in cases:
            with self.subTest(fn=fn.__name__):
                request = types.SimpleNamespace(data=data, auth=None)
                with self.assertRaises(_HttpsError) as error:
                    fn(request)
                self.assertEqual(error.exception.code, "unauthenticated")

    def test_stripe_create_account_link_requires_account_membership(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123"
        }
        account_link = _FakeAccountLink()
        main.firestore.client = lambda: db
        main.stripe.AccountLink = account_link
        request = types.SimpleNamespace(
            data={"account": "account-1", "stripeAccount": "acct_123"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.stripe_create_account_link(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertEqual(account_link.calls, [])

    def test_stripe_create_account_link_uses_stored_account_id(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123"
        }
        account_link = _FakeAccountLink()
        main.firestore.client = lambda: db
        main.stripe.AccountLink = account_link
        request = types.SimpleNamespace(
            data={"account": "account-1", "stripeAccount": "acct_attacker"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.stripe_create_account_link(request)

        self.assertEqual(result, {"url": "https://connect.stripe.test/onboarding"})
        self.assertEqual(len(account_link.calls), 1)
        self.assertEqual(account_link.calls[0]["account"], "acct_123")

    def test_change_stripe_integration_activation_requires_account_membership(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": False,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1", "isActive": True},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.change_stripe_integration_activation(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertEqual(
            db.documents["accounts/account-1/integrations/stripe"]["isActive"],
            False,
        )

    def test_get_stripe_integration_data_requires_account_membership(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.get_stripe_integration_data(request)

        self.assertEqual(error.exception.code, "permission-denied")

    def test_get_public_stripe_status_does_not_return_account_id(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(data={"account": "account-1"}, auth=None)

        result = main.get_public_stripe_status(request)

        self.assertEqual(result, {"isActive": True})

    def test_create_stripe_tax_rate_requires_membership_and_uses_stored_account_id(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        tax_rate = _FakeTaxRate()
        main.firestore.client = lambda: db
        main.stripe.TaxRate = tax_rate
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "percentage": 25.5,
                "stripeAccountId": "acct_attacker",
            },
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.create_stripe_tax_rate(request)

        self.assertEqual(result, {"tax_id": "txr_123"})
        self.assertEqual(len(tax_rate.calls), 1)
        self.assertEqual(tax_rate.calls[0]["stripe_account"], "acct_123")

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

    def test_create_booking_checkout_session_counts_unexpired_waiting_bookings(self):
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
            "maxCapacity": 1,
        }
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/existing-booking"
        ] = {
            "id": "existing-booking",
            "customerGroupId": "cg-1",
            "paymentStatus": "waiting",
            "expiresAt": datetime(2099, 1, 1, tzinfo=timezone.utc),
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
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
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
        created_at = db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]["createdAt"]
        expires_at = db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]["expiresAt"]
        self.assertEqual(expires_at - created_at, main.timedelta(minutes=30))

    def test_create_booking_checkout_session_calculates_payment_data_server_side(self):
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
            "maxCapacity": 4,
        }
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
            },
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
                    "lineItems": [{"price_data": {"unit_amount": 1}}],
                    "paymentIntentId": "pi_attacker",
                    "stripeId": "acct_attacker",
                    "total": 1,
                    "commission": 1,
                },
                "customers": [
                    {
                        "id": "customer-1",
                        "pricingId": "adult",
                        "bookingId": "other-booking",
                        "paymentIntentId": "pi_attacker",
                    },
                    {"id": "customer-2", "pricingId": "child"},
                ],
                "lineItems": [{"price_data": {"unit_amount": 1}}],
                "feeAmount": 1,
                "totalAmount": 1,
                "stripeAccount": "acct_attacker",
                "stripeAccountId": "acct_attacker",
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
        call = checkout.calls[0]
        self.assertEqual(call["stripe_account"], "acct_123")
        self.assertEqual(call["payment_intent_data"], {"application_fee_amount": 658})
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
                    "quantity": 1,
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
                },
            ],
        )
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["stripeId"], "acct_123")
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["total"], 15000)
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["commission"], 658)

    def test_refund_payment_reads_secret_payment_data_server_side_and_updates_booking(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.collections["checkoutSessions"] = [
            {
                "id": "cs_123",
                "checkoutSessionId": "cs_123",
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

        self.assertEqual(result, {"refundId": "refund-1", "refundStatus": "succeeded"})
        self.assertEqual(
            refund.calls,
            [
                {
                    "payment_intent": "pi_123",
                    "stripe_account": "acct_123",
                    "refund_application_fee": True,
                    "idempotency_key": "refund:account-1:booking-1",
                }
            ],
        )
        self.assertEqual(
            db.updates[0],
            (
                "accounts/account-1/data/bookingManager/bookings/booking-1",
                {"paymentStatus": "refunded"},
            ),
        )
        self.assertEqual(db.updates[1][0], "checkoutSessions/cs_123")
        self.assertEqual(db.updates[1][1]["refundId"], "refund-1")
        self.assertEqual(db.updates[1][1]["refundStatus"], "succeeded")
        self.assertEqual(db.updates[1][1]["refundedBy"], "user-1")
        self.assertIsInstance(db.updates[1][1]["refundedAt"], datetime)

    def test_refund_payment_returns_existing_refund_without_calling_stripe(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.collections["checkoutSessions"] = [
            {
                "id": "cs_123",
                "checkoutSessionId": "cs_123",
                "bookingId": "booking-1",
                "account": "account-1",
                "paymentIntentId": "pi_123",
                "stripeId": "acct_123",
                "refundId": "refund-existing",
                "refundStatus": "succeeded",
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

        self.assertEqual(
            result,
            {"refundId": "refund-existing", "refundStatus": "succeeded"},
        )
        self.assertEqual(refund.calls, [])
        self.assertEqual(db.updates, [])

    def test_refund_payment_returns_already_refunded_booking_without_calling_stripe(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ] = {
            "id": "booking-1",
            "paymentStatus": "refunded",
        }
        db.collections["checkoutSessions"] = [
            {
                "id": "cs_123",
                "checkoutSessionId": "cs_123",
                "bookingId": "booking-1",
                "account": "account-1",
                "paymentIntentId": "pi_123",
                "stripeId": "acct_123",
                "refundStatus": "succeeded",
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

        self.assertEqual(
            result,
            {
                "refundId": None,
                "refundStatus": "succeeded",
                "alreadyRefunded": True,
            },
        )
        self.assertEqual(refund.calls, [])
        self.assertEqual(db.updates, [])

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

    def test_get_booking_success_data_rejects_checkout_session_from_other_account(self):
        db = _FakeDb()
        db.collections["checkoutSessions"] = [
            {
                "id": "cs_123",
                "checkoutSessionId": "cs_123",
                "bookingId": "booking-1",
                "account": "other-account",
            }
        ]
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1", "bookingId": "booking-1"}
        )

        with self.assertRaises(_HttpsError) as error:
            main.get_booking_success_data(request)

        self.assertEqual(error.exception.code, "permission-denied")

    def test_payment_processed_skips_already_processed_checkout_session(self):
        db = _FakeDb()
        db.documents["checkoutSessions/cs_123"] = {
            "checkoutSessionId": "cs_123",
            "account": "account-1",
            "stripeId": "acct_123",
            "bookingId": "booking-1",
            "createdAt": datetime(2026, 1, 1, tzinfo=timezone.utc),
            "webhookProcessed": True,
        }
        main.firestore.client = lambda: db

        main.add_checkout_session.payment_processed(
            checkout_session_id="cs_123",
            stripe_account="acct_123",
            stripe_api_key="sk_test",
            payment_intent_id="pi_123",
            stripe_email="customer@example.com",
        )

        self.assertEqual(db.updates, [])
        self.assertEqual(db.batches, [])


if __name__ == "__main__":
    unittest.main()
