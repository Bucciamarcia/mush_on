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
    firebase_admin.firestore = types.SimpleNamespace(client=lambda: None)
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
    def __init__(self, data=None, exists=True):
        self._data = data
        self.exists = exists

    def to_dict(self):
        return self._data


class _DocRef:
    def __init__(self, db, path):
        self.db = db
        self.path = path

    def get(self):
        return _Snapshot(self.db.documents.get(self.path), self.path in self.db.documents)

    def update(self, data):
        self.db.updates.append((self.path, data))


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
        for data in self.db.collections.get(self.collection_name, []):
            matches = all(data.get(field) == value for field, op, value in self.filters)
            if matches:
                docs.append(_Snapshot(data))
        if self.limit_value is not None:
            docs = docs[: self.limit_value]
        return iter(docs)


class _FakeDb:
    def __init__(self):
        self.documents = {}
        self.collections = {}
        self.updates = []

    def document(self, path):
        return _DocRef(self, path)

    def collection(self, name):
        return _Query(self, name)


class _FakeRefund:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="refund-1")


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
