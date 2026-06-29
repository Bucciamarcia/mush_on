import importlib
import json as std_json
import os
import pathlib
import sys
import types
import unittest
from datetime import datetime, timezone
from unittest.mock import patch
from urllib.parse import parse_qs, urlparse


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
    stripe.Account = types.SimpleNamespace(
        create=lambda **kwargs: None,
        retrieve=lambda *args, **kwargs: None,
    )
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
os.environ.setdefault("STRIPE_TEST_KEY", "sk_test")
os.environ.setdefault("STRIPE_LIVE_KEY", "sk_live")
main = importlib.import_module("main")
send_invitation_email = importlib.import_module("lib.send_invitation_email")


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

    def delete(self):
        self.db.documents.pop(self.path, None)
        parent = self.path.rsplit("/", 1)[0]
        doc_id = self.path.rsplit("/", 1)[-1]
        collection = self.db.collections.get(parent)
        if collection is not None:
            self.db.collections[parent] = [
                item for item in collection if (item.get("id") or doc_id) != doc_id
            ]
        self.db.deletes.append(self.path)

    def collection(self, name):
        return _Query(self.db, f"{self.path}/{name}")


class _Query:
    def __init__(self, db, collection_name):
        self.db = db
        self.collection_name = collection_name
        self.filters = []
        self.order_field = None
        self.limit_value = None

    def where(self, field, op, value):
        self.filters.append((field, op, value))
        return self

    def order_by(self, field):
        self.order_field = field
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
                else data.get(field) >= value
                if op == ">="
                else data.get(field) <= value
                if op == "<="
                else False
                for field, op, value in self.filters
            )
            if matches:
                doc_id = data.get("id")
                reference = _DocRef(self.db, f"{self.collection_name}/{doc_id}")
                docs.append(_Snapshot(data, doc_id=doc_id, reference=reference))
        if self.order_field is not None:
            docs.sort(
                key=lambda doc: (
                    doc.to_dict() or {}
                ).get(self.order_field, 0)
            )
        if self.limit_value is not None:
            docs = docs[: self.limit_value]
        return iter(docs)

    def document(self, doc_id):
        return _DocRef(self.db, f"{self.collection_name}/{doc_id}")


class _FakeTransaction:
    def __init__(self):
        self.gets = []
        self.sets = []
        self.updates = []

    def get(self, ref_or_query):
        if hasattr(ref_or_query, "stream"):
            return list(ref_or_query.stream())
        self.gets.append(ref_or_query.path)
        return ref_or_query.get()

    def set(self, ref, data):
        self.sets.append((ref.path, data))
        ref.set(data)

    def update(self, ref, data):
        self.updates.append((ref.path, data))
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
        self.deletes = []
        self.batches = []
        self.transactions = []

    def document(self, path):
        return _DocRef(self, path)

    def collection(self, name):
        return _Query(self, name)

    def transaction(self):
        transaction = _FakeTransaction()
        self.transactions.append(transaction)
        return transaction

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
    def __init__(self, failures=None):
        self.calls = []
        self.failures = list(failures or [])

    def create(self, **kwargs):
        self.calls.append(kwargs)
        if self.failures:
            raise self.failures.pop(0)
        return types.SimpleNamespace(id="cs_123", url="https://checkout.test/session")


class _FakeStripeAccount:
    def __init__(
        self,
        charges_enabled=True,
        payouts_enabled=True,
        details_submitted=True,
        disabled_reason=None,
        currently_due=None,
    ):
        self.calls = []
        self.retrieve_calls = []
        self.charges_enabled = charges_enabled
        self.payouts_enabled = payouts_enabled
        self.details_submitted = details_submitted
        self.disabled_reason = disabled_reason
        self.currently_due = currently_due or []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(id="acct_new")

    def retrieve(self, account_id):
        self.retrieve_calls.append(account_id)
        return types.SimpleNamespace(
            charges_enabled=self.charges_enabled,
            payouts_enabled=self.payouts_enabled,
            details_submitted=self.details_submitted,
            requirements={
                "disabled_reason": self.disabled_reason,
                "currently_due": self.currently_due,
            },
        )


class _FakeAccountLink:
    def __init__(self):
        self.calls = []

    def create(self, **kwargs):
        self.calls.append(kwargs)
        return types.SimpleNamespace(url="https://connect.stripe.test/onboarding")


class _FakeTaxRate:
    def __init__(self, ids=None):
        self.calls = []
        self.ids = list(ids or ["txr_123"])

    def create(self, **kwargs):
        self.calls.append(kwargs)
        tax_rate_id = self.ids.pop(0) if self.ids else "txr_123"
        return types.SimpleNamespace(id=tax_rate_id)


class _FakeInvitationEmail:
    calls = []

    def __init__(self, **kwargs):
        self.kwargs = kwargs

    def run(self):
        self.__class__.calls.append(self.kwargs)


class _FakePostmarkResponse:
    status_code = 200
    text = ""

    def raise_for_status(self):
        return None


class InvitationEmailTests(unittest.TestCase):
    def _send_invitation_and_get_action_url(
        self,
        *,
        base_signup_url="https://app.mush-on.com/accept_invitation",
        receiver_email="plus+user@example.com",
        security_code="a+b&c=d",
    ):
        calls = []

        def fake_post(url, headers, json):
            calls.append({"url": url, "headers": headers, "json": json})
            return _FakePostmarkResponse()

        env = {
            "POSTMARK_SERVER_TOKEN": "server-token",
            "POSTMARK_ACCOUNT_TOKEN": "account-token",
            "POSTMARK_TEMPLATE_INVITE_USER": "123",
            "PRIVACY_POLICY_URL": "https://app.mush-on.com/privacy",
            "SIGNUP_URL": base_signup_url,
            "SUPPORT_EMAIL": "support@mush-on.com",
        }
        with patch.dict(os.environ, env, clear=False):
            with patch.object(send_invitation_email.requests, "post", fake_post):
                send_invitation_email.SendInvitationEmail(
                    sender_email="sender@example.com",
                    receiver_email=receiver_email,
                    account="account-1",
                    security_code=security_code,
                ).run()

        self.assertEqual(len(calls), 1)
        return calls[0]["json"]["TemplateModel"]["action_url"]

    def test_invitation_email_action_url_encodes_query_values(self):
        action_url = self._send_invitation_and_get_action_url()

        parsed = urlparse(action_url)
        query = parse_qs(parsed.query)

        self.assertEqual(
            action_url,
            "https://app.mush-on.com/accept_invitation?"
            "email=plus%2Buser%40example.com&securityCode=a%2Bb%26c%3Dd",
        )
        self.assertEqual(query["email"], ["plus+user@example.com"])
        self.assertEqual(query["securityCode"], ["a+b&c=d"])
        self.assertNotIn("c", query)

    def test_invitation_email_action_url_preserves_existing_query_parameters(self):
        action_url = self._send_invitation_and_get_action_url(
            base_signup_url="https://app.mush-on.com/accept_invitation?source=email",
            receiver_email="new.user@example.com",
            security_code="code-1",
        )

        parsed = urlparse(action_url)
        query = parse_qs(parsed.query)

        self.assertEqual(parsed.scheme, "https")
        self.assertEqual(parsed.netloc, "app.mush-on.com")
        self.assertEqual(parsed.path, "/accept_invitation")
        self.assertEqual(query["source"], ["email"])
        self.assertEqual(query["email"], ["new.user@example.com"])
        self.assertEqual(query["securityCode"], ["code-1"])


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

    def test_team_groups_workspace_uses_snapshot_with_rank_order(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        date = datetime(2026, 1, 2, 10, 0, tzinfo=timezone.utc)
        history = "accounts/account-1/data/teams/history"
        db.documents[f"{history}/tg-1"] = {
            "id": "tg-1",
            "date": date,
            "runType": "training",
            "notes": "",
            "name": "Morning",
            "distance": 10,
            "teamsSnapshot": {
                "team-wheel": {
                    "name": "Wheel",
                    "capacity": 2,
                    "rank": 1,
                    "dogPairs": {
                        "pair-wheel": {
                            "firstDogId": "dog-3",
                            "secondDogId": "dog-4",
                            "rank": 1,
                        },
                        "pair-lead": {
                            "firstDogId": "dog-1",
                            "secondDogId": "dog-2",
                            "rank": 0,
                        },
                    },
                },
                "team-lead": {
                    "name": "Lead",
                    "capacity": 1,
                    "rank": 0,
                    "dogPairs": {},
                },
            },
        }

        response = main.team_groups_workspace_from_date_range(
            types.SimpleNamespace(
                data={
                    "account": "account-1",
                    "start": "2026-01-01T00:00:00+00:00",
                    "end": "2026-01-03T00:00:00+00:00",
                }
            )
        )

        teams = response["teamGroups"][0]["teams"]
        self.assertEqual([team["id"] for team in teams], ["team-lead", "team-wheel"])
        self.assertEqual(
            [pair["id"] for pair in teams[1]["dogPairs"]],
            ["pair-lead", "pair-wheel"],
        )

    def test_team_groups_workspace_falls_back_to_legacy_for_invalid_snapshot(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        date = datetime(2026, 1, 2, 10, 0, tzinfo=timezone.utc)
        history = "accounts/account-1/data/teams/history"
        db.documents[f"{history}/tg-1"] = {
            "id": "tg-1",
            "date": date,
            "runType": "training",
            "notes": "",
            "name": "Morning",
            "distance": 10,
            "teamsSnapshot": {
                "team-bad": {
                    "name": "Bad",
                    "capacity": 1,
                    "rank": "not-a-rank",
                    "dogPairs": {},
                },
            },
        }
        db.documents[f"{history}/tg-1/teams/team-wheel"] = {
            "id": "team-wheel",
            "name": "Wheel",
            "capacity": 2,
            "rank": 1,
        }
        db.documents[f"{history}/tg-1/teams/team-lead"] = {
            "id": "team-lead",
            "name": "Lead",
            "capacity": 1,
            "rank": 0,
        }
        db.documents[f"{history}/tg-1/teams/team-wheel/dogPairs/pair-wheel"] = {
            "id": "pair-wheel",
            "firstDogId": "dog-3",
            "secondDogId": "dog-4",
            "rank": 1,
        }
        db.documents[f"{history}/tg-1/teams/team-wheel/dogPairs/pair-lead"] = {
            "id": "pair-lead",
            "firstDogId": "dog-1",
            "secondDogId": "dog-2",
            "rank": 0,
        }

        response = main.team_groups_workspace_from_date_range(
            types.SimpleNamespace(
                data={
                    "account": "account-1",
                    "start": "2026-01-01T00:00:00+00:00",
                    "end": "2026-01-03T00:00:00+00:00",
                }
            )
        )

        teams = response["teamGroups"][0]["teams"]
        self.assertEqual([team["id"] for team in teams], ["team-lead", "team-wheel"])
        self.assertEqual(
            [pair["id"] for pair in teams[1]["dogPairs"]],
            ["pair-lead", "pair-wheel"],
        )

    def test_team_groups_workspace_fetches_legacy_fallbacks_in_one_bulk_pass(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        date = datetime(2026, 1, 2, 10, 0, tzinfo=timezone.utc)
        history = "accounts/account-1/data/teams/history"
        db.documents[f"{history}/tg-snapshot"] = {
            "id": "tg-snapshot",
            "date": date,
            "runType": "training",
            "notes": "",
            "name": "Snapshot",
            "distance": 10,
            "teamsSnapshot": {
                "team-snapshot": {
                    "name": "Snapshot team",
                    "capacity": 1,
                    "rank": 0,
                    "dogPairs": {},
                },
            },
        }
        db.documents[f"{history}/tg-legacy"] = {
            "id": "tg-legacy",
            "date": date,
            "runType": "training",
            "notes": "",
            "name": "Legacy",
            "distance": 10,
        }
        db.documents[f"{history}/tg-invalid"] = {
            "id": "tg-invalid",
            "date": date,
            "runType": "training",
            "notes": "",
            "name": "Invalid",
            "distance": 10,
            "teamsSnapshot": {
                "team-invalid": {
                    "name": "Invalid team",
                    "capacity": 1,
                    "rank": "bad",
                    "dogPairs": {},
                },
            },
        }

        calls = []

        def fake_bulk_legacy(db_arg, history_path, team_group_ids):
            calls.append(
                {
                    "db": db_arg,
                    "history_path": history_path,
                    "team_group_ids": list(team_group_ids),
                }
            )
            return {
                team_group_id: [
                    {
                        "id": f"{team_group_id}-team",
                        "name": "Legacy team",
                        "capacity": 1,
                        "dogPairs": [],
                    }
                ]
                for team_group_id in team_group_ids
            }

        with patch.object(
            main,
            "_workspace_teams_by_team_group_from_legacy",
            side_effect=fake_bulk_legacy,
        ):
            response = main.team_groups_workspace_from_date_range(
                types.SimpleNamespace(
                    data={
                        "account": "account-1",
                        "start": "2026-01-01T00:00:00+00:00",
                        "end": "2026-01-03T00:00:00+00:00",
                    }
                )
            )

        self.assertEqual(len(calls), 1)
        self.assertEqual(calls[0]["history_path"], history)
        self.assertEqual(
            set(calls[0]["team_group_ids"]), {"tg-legacy", "tg-invalid"}
        )
        self.assertNotIn("tg-snapshot", calls[0]["team_group_ids"])
        teams_by_group = {
            team_group["id"]: team_group["teams"]
            for team_group in response["teamGroups"]
        }
        self.assertEqual(teams_by_group["tg-snapshot"][0]["id"], "team-snapshot")
        self.assertEqual(teams_by_group["tg-legacy"][0]["id"], "tg-legacy-team")
        self.assertEqual(teams_by_group["tg-invalid"][0]["id"], "tg-invalid-team")

    def test_create_account_requires_authentication(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(data={"account": "account-1"}, auth=None)

        with self.assertRaises(_HttpsError) as error:
            main.create_account(request)

        self.assertEqual(error.exception.code, "unauthenticated")

    def test_create_account_rejects_existing_user_account(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {
            "uid": "user-1",
            "email": "user@example.com",
            "account": "existing-account",
            "userLevel": "handler",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.create_account(request)

        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertNotIn("accounts/account-1", db.documents)

    def test_create_account_rejects_missing_user_profile(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.create_account(request)

        self.assertEqual(error.exception.code, "not-found")
        self.assertNotIn("accounts/account-1", db.documents)

    def test_create_account_rejects_invalid_account_names(self):
        invalid_accounts = [
            "",
            "  ",
            "ab",
            "bad/name",
            "bad$name",
            "a" * 51,
        ]
        for account in invalid_accounts:
            with self.subTest(account=account):
                db = _FakeDb()
                db.documents["users/user-1"] = {
                    "uid": "user-1",
                    "email": "user@example.com",
                    "account": None,
                    "userLevel": "handler",
                }
                main.firestore.client = lambda: db
                request = types.SimpleNamespace(
                    data={"account": account},
                    auth=types.SimpleNamespace(uid="user-1"),
                )

                with self.assertRaises(_HttpsError) as error:
                    main.create_account(request)

                self.assertEqual(error.exception.code, "invalid-argument")
                self.assertEqual(db.transactions, [])

    def test_create_account_rejects_existing_normalized_account(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {
            "uid": "user-1",
            "email": "user@example.com",
            "account": None,
            "userLevel": "handler",
        }
        db.documents["accounts/my-kennel"] = {"createdByUid": "other-user"}
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": " My Kennel "},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.create_account(request)

        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertNotIn("users/user-1", [path for path, _ in db.updates])

    def test_create_account_creates_account_and_promotes_authenticated_user(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {
            "uid": "user-1",
            "email": "user@example.com",
            "account": None,
            "userLevel": "handler",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": " My   Kennel "},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.create_account(request)

        self.assertEqual(result, {"account": "my-kennel"})
        account = db.documents["accounts/my-kennel"]
        self.assertEqual(account["createdByUid"], "user-1")
        self.assertIsInstance(account["createdAt"], datetime)
        self.assertEqual(db.documents["users/user-1"]["account"], "my-kennel")
        self.assertEqual(db.documents["users/user-1"]["userLevel"], "musher")
        self.assertEqual(len(db.transactions), 1)
        transaction = db.transactions[0]
        self.assertEqual(
            transaction.gets,
            ["users/user-1", "accounts/my-kennel"],
        )
        self.assertEqual(transaction.sets[0][0], "accounts/my-kennel")
        self.assertEqual(
            transaction.updates,
            [
                (
                    "users/user-1",
                    {"account": "my-kennel", "userLevel": "musher"},
                )
            ],
        )

    def test_accept_invitation_rejects_bad_code(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com", "securityCode": "bad-code"},
            auth=types.SimpleNamespace(
                uid="user-1",
                token={"email": "new.user@example.com"},
            ),
        )

        with self.assertRaises(_HttpsError) as error:
            main.accept_invitation(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertNotIn("users/user-1", db.documents)

    def test_accept_invitation_writes_membership_from_stored_invitation(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "musher",
            "securityCode": "good-code",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={
                "email": " New.User@Example.com ",
                "securityCode": "good-code",
                "account": "attacker-account",
                "userLevel": "musher",
            },
            auth=types.SimpleNamespace(
                uid="user-1",
                token={"email": "new.user@example.com"},
            ),
        )

        result = main.accept_invitation(request)

        self.assertEqual(result, {"account": "account-1", "userLevel": "musher"})
        self.assertEqual(
            db.documents["users/user-1"],
            {
                "uid": "user-1",
                "email": "new.user@example.com",
                "account": "account-1",
                "userLevel": "musher",
            },
        )
        invitation = db.documents["userInvitations/new.user@example.com"]
        self.assertTrue(invitation["accepted"])
        self.assertEqual(invitation["acceptedUid"], "user-1")
        self.assertIsInstance(invitation["acceptedAt"], datetime)

    def test_accept_invitation_rejects_already_accepted_invitation(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
            "accepted": True,
            "acceptedUid": "existing-user",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com", "securityCode": "good-code"},
            auth=types.SimpleNamespace(
                uid="user-1",
                token={"email": "new.user@example.com"},
            ),
        )

        with self.assertRaises(_HttpsError) as error:
            main.accept_invitation(request)

        self.assertEqual(error.exception.code, "failed-precondition")
        self.assertNotIn("users/user-1", db.documents)
        self.assertEqual(
            db.documents["userInvitations/new.user@example.com"]["acceptedUid"],
            "existing-user",
        )

    def test_accept_invitation_rejects_missing_authenticated_email(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com", "securityCode": "good-code"},
            auth=types.SimpleNamespace(uid="user-1", token={}),
        )

        with self.assertRaises(_HttpsError) as error:
            main.accept_invitation(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertNotIn("users/user-1", db.documents)

    def test_accept_invitation_rejects_authenticated_email_mismatch(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com", "securityCode": "good-code"},
            auth=types.SimpleNamespace(
                uid="user-1",
                token={"email": "other.user@example.com"},
            ),
        )

        with self.assertRaises(_HttpsError) as error:
            main.accept_invitation(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertNotIn("users/user-1", db.documents)

    def test_invite_user_requires_authentication(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"receiverEmail": "new.user@example.com", "userLevel": "handler"},
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.invite_user(request)

        self.assertEqual(error.exception.code, "unauthenticated")
        self.assertNotIn("userInvitations/new.user@example.com", db.documents)

    def test_invite_user_rejects_missing_sender_profile(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"receiverEmail": "new.user@example.com", "userLevel": "handler"},
            auth=types.SimpleNamespace(uid="sender-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.invite_user(request)

        self.assertEqual(error.exception.code, "not-found")

    def test_invite_user_rejects_non_musher_sender(self):
        db = _FakeDb()
        db.documents["users/sender-1"] = {
            "uid": "sender-1",
            "email": "sender@example.com",
            "account": "account-1",
            "userLevel": "handler",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"receiverEmail": "new.user@example.com", "userLevel": "handler"},
            auth=types.SimpleNamespace(uid="sender-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.invite_user(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertNotIn("userInvitations/new.user@example.com", db.documents)

    def test_invite_user_builds_invitation_from_authenticated_sender(self):
        db = _FakeDb()
        db.documents["users/sender-1"] = {
            "uid": "sender-1",
            "email": "sender@example.com",
            "account": "account-1",
            "userLevel": "musher",
        }
        main.firestore.client = lambda: db
        main.SendInvitationEmail = _FakeInvitationEmail
        _FakeInvitationEmail.calls = []
        request = types.SimpleNamespace(
            data={
                "senderEmail": "attacker@example.com",
                "receiverEmail": " New.User@Example.com ",
                "account": "attacker-account",
                "userLevel": "handler",
                "payload": {
                    "account": "attacker-account",
                    "senderUid": "attacker",
                    "securityCode": "attacker-code",
                    "userLevel": "musher",
                },
            },
            auth=types.SimpleNamespace(uid="sender-1"),
        )

        result = main.invite_user(request)

        self.assertEqual(result, {"result": "ok"})
        invitation = db.documents["userInvitations/new.user@example.com"]
        self.assertEqual(invitation["email"], "new.user@example.com")
        self.assertEqual(invitation["account"], "account-1")
        self.assertEqual(invitation["senderUid"], "sender-1")
        self.assertEqual(invitation["userLevel"], "handler")
        self.assertFalse(invitation["accepted"])
        self.assertNotEqual(invitation["securityCode"], "attacker-code")
        self.assertEqual(
            _FakeInvitationEmail.calls,
            [
                {
                    "sender_email": "sender@example.com",
                    "receiver_email": "new.user@example.com",
                    "account": "account-1",
                    "security_code": invitation["securityCode"],
                }
            ],
        )

    def test_get_user_invitation_db_requires_security_code(self):
        db = _FakeDb()
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com"},
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.get_user_invitation_db(request)

        self.assertEqual(error.exception.code, "invalid-argument")

    def test_get_user_invitation_db_rejects_bad_security_code(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
            "accepted": False,
            "senderUid": "sender-1",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"email": "new.user@example.com", "securityCode": "bad-code"},
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.get_user_invitation_db(request)

        self.assertEqual(error.exception.code, "permission-denied")

    def test_get_user_invitation_db_returns_safe_preview(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
            "accepted": False,
            "senderUid": "sender-1",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={
                "email": " New.User@Example.com ",
                "securityCode": "good-code",
            },
            auth=None,
        )

        result = main.get_user_invitation_db(request)

        self.assertEqual(
            result,
            {
                "email": "new.user@example.com",
                "account": "account-1",
                "userLevel": "handler",
                "accepted": False,
            },
        )
        self.assertNotIn("securityCode", result)
        self.assertNotIn("senderUid", result)

    def test_get_user_invitation_db_rejects_accepted_invitation(self):
        db = _FakeDb()
        db.documents["userInvitations/new.user@example.com"] = {
            "email": "new.user@example.com",
            "account": "account-1",
            "userLevel": "handler",
            "securityCode": "good-code",
            "accepted": True,
            "senderUid": "sender-1",
            "acceptedUid": "user-1",
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={
                "email": "new.user@example.com",
                "securityCode": "good-code",
            },
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.get_user_invitation_db(request)

        self.assertEqual(error.exception.code, "failed-precondition")

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
                "vatRate": 0.255,
                "stripeTaxRateId": "txr_stale_adult",
            },
            {
                "id": "child",
                "isArchived": False,
                "displayName": "Child",
                "priceCents": 5000,
                "vatRate": 0.255,
                "stripeTaxRateId": "txr_stale_child",
            },
        ]
        checkout = _FakeCheckoutSession()
        tax_rate = _FakeTaxRate()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = tax_rate
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
                    "tax_rates": ["txr_123"],
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
                    "tax_rates": ["txr_123"],
                },
            ],
        )
        self.assertEqual(len(tax_rate.calls), 1)
        self.assertEqual(tax_rate.calls[0]["percentage"], 25.5)
        self.assertEqual(tax_rate.calls[0]["stripe_account"], "acct_123")
        self.assertEqual(
            db.documents["checkoutSessions/cs_123"]["total"],
            25000,
        )
        self.assertEqual(
            db.documents["checkoutSessions/cs_123"]["commission"],
            1098,
        )

    def test_create_checkout_session_deactivates_stale_stripe_connection(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {"accountId": "acct_123", "isActive": True},
        }
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=False)
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
        self.assertFalse(
            db.documents["accounts/account-1/integrations/stripe"]["isActive"]
        )

    def test_create_checkout_session_rejects_inactive_stripe_integration(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": False,
        }
        checkout = _FakeCheckoutSession()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
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
        stripe_doc = db.documents["accounts/account-1/integrations/stripe"]
        self.assertEqual(stripe_doc["selectedMode"], "test")
        self.assertFalse(stripe_doc["isActive"])
        account_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_new"
        ]
        self.assertEqual(
            account_doc["accountId"],
            "acct_new",
        )
        self.assertEqual(account_doc["mode"], "test")
        self.assertFalse(account_doc["archived"])
        self.assertNotIn("isActive", account_doc)
        self.assertIn("connectedAt", account_doc)

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
            (main.disconnect_stripe_account, {"account": "account-1"}),
            (main.get_stripe_integration_data, {"account": "account-1"}),
            (main.get_stripe_connection_status, {"account": "account-1"}),
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
        return_url = account_link.calls[0]["return_url"]
        return_query = parse_qs(urlparse(return_url).query)
        attempt_id = return_query["attemptId"][0]
        token = return_query["token"][0]
        attempt = db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ]
        self.assertEqual(attempt["account"], "account-1")
        self.assertEqual(attempt["stripeMode"], "test")
        self.assertEqual(attempt["stripeAccountId"], "acct_123")
        self.assertEqual(attempt["tokenHash"], main._hash_onboarding_token(token))
        self.assertNotIn("token", attempt)
        refresh_query = parse_qs(urlparse(account_link.calls[0]["refresh_url"]).query)
        self.assertEqual(refresh_query["result"], ["refresh"])
        self.assertEqual(refresh_query["attemptId"], [attempt_id])

    def test_finalize_stripe_onboarding_activates_when_charges_enabled(self):
        db = _FakeDb()
        now = datetime.now(timezone.utc)
        attempt_id = "attempt-1"
        token = "secret-token"
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {
                "accountId": "acct_123",
                "isActive": False,
                "connectedAt": "connected-date",
            },
        }
        db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ] = {
            "account": "account-1",
            "stripeMode": "test",
            "stripeAccountId": "acct_123",
            "tokenHash": main._hash_onboarding_token(token),
            "createdAt": now,
            "expiresAt": now + main.timedelta(minutes=10),
            "consumedAt": None,
        }
        stripe_account = _FakeStripeAccount(charges_enabled=True)
        main.firestore.client = lambda: db
        main.stripe.Account = stripe_account
        request = types.SimpleNamespace(
            data={"account": "account-1", "attemptId": attempt_id, "token": token},
            auth=None,
        )

        result = main.finalize_stripe_onboarding(request)

        self.assertEqual(
            result,
            {"activeMode": "test", "isActive": True, "chargesEnabled": True},
        )
        self.assertEqual(stripe_account.retrieve_calls, ["acct_123"])
        self.assertTrue(
            db.documents["accounts/account-1/integrations/stripe"]["isActive"]
        )
        account_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_123"
        ]
        self.assertNotIn("isActive", account_doc)
        self.assertEqual(account_doc["connectedAt"], "connected-date")
        attempt = db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ]
        self.assertIsNotNone(attempt["consumedAt"])

    def test_finalize_stripe_onboarding_keeps_inactive_when_charges_disabled(self):
        db = _FakeDb()
        now = datetime.now(timezone.utc)
        attempt_id = "attempt-1"
        token = "secret-token"
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {"accountId": "acct_123", "isActive": False},
        }
        db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ] = {
            "account": "account-1",
            "stripeMode": "test",
            "stripeAccountId": "acct_123",
            "tokenHash": main._hash_onboarding_token(token),
            "createdAt": now,
            "expiresAt": now + main.timedelta(minutes=10),
            "consumedAt": None,
        }
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=False)
        request = types.SimpleNamespace(
            data={"account": "account-1", "attemptId": attempt_id, "token": token},
            auth=None,
        )

        result = main.finalize_stripe_onboarding(request)

        self.assertFalse(result["isActive"])
        self.assertFalse(
            db.documents["accounts/account-1/integrations/stripe"]["isActive"]
        )

    def test_finalize_stripe_onboarding_rejects_invalid_token(self):
        db = _FakeDb()
        now = datetime.now(timezone.utc)
        attempt_id = "attempt-1"
        db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ] = {
            "account": "account-1",
            "stripeMode": "test",
            "stripeAccountId": "acct_123",
            "tokenHash": main._hash_onboarding_token("right-token"),
            "createdAt": now,
            "expiresAt": now + main.timedelta(minutes=10),
            "consumedAt": None,
        }
        stripe_account = _FakeStripeAccount()
        main.firestore.client = lambda: db
        main.stripe.Account = stripe_account
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "attemptId": attempt_id,
                "token": "wrong-token",
            },
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.finalize_stripe_onboarding(request)

        self.assertEqual(error.exception.code, "permission-denied")
        self.assertEqual(stripe_account.retrieve_calls, [])

    def test_finalize_stripe_onboarding_rejects_consumed_attempt(self):
        db = _FakeDb()
        now = datetime.now(timezone.utc)
        attempt_id = "attempt-1"
        token = "secret-token"
        db.documents[
            f"accounts/account-1/integrations/stripe/onboardingAttempts/{attempt_id}"
        ] = {
            "account": "account-1",
            "stripeMode": "test",
            "stripeAccountId": "acct_123",
            "tokenHash": main._hash_onboarding_token(token),
            "createdAt": now,
            "expiresAt": now + main.timedelta(minutes=10),
            "consumedAt": now,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1", "attemptId": attempt_id, "token": token},
            auth=None,
        )

        with self.assertRaises(_HttpsError) as error:
            main.finalize_stripe_onboarding(request)

        self.assertEqual(error.exception.code, "failed-precondition")

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

    def test_disconnect_stripe_account_removes_active_test_mode_only(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {
                "accountId": "acct_test",
                "isActive": True,
                "connectedAt": "test-date",
            },
            "live": {
                "accountId": "acct_live",
                "isActive": True,
                "connectedAt": "live-date",
            },
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.disconnect_stripe_account(request)

        self.assertEqual(result, {"activeMode": "test"})
        stripe_doc = db.documents["accounts/account-1/integrations/stripe"]
        self.assertEqual(stripe_doc["selectedMode"], "test")
        self.assertNotIn("test", stripe_doc)
        test_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_test"
        ]
        live_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_live"
        ]
        self.assertTrue(test_doc["archived"])
        self.assertFalse(live_doc["archived"])

    def test_disconnect_stripe_account_removes_active_live_mode_only(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "live",
            "test": {"accountId": "acct_test", "isActive": True},
            "live": {"accountId": "acct_live", "isActive": True},
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.disconnect_stripe_account(request)

        self.assertEqual(result, {"activeMode": "live"})
        stripe_doc = db.documents["accounts/account-1/integrations/stripe"]
        self.assertEqual(stripe_doc["selectedMode"], "live")
        self.assertNotIn("live", stripe_doc)
        test_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_test"
        ]
        live_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_live"
        ]
        self.assertFalse(test_doc["archived"])
        self.assertTrue(live_doc["archived"])

    def test_disconnect_stripe_account_cleans_legacy_flat_test_connection(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_legacy",
            "isActive": True,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.disconnect_stripe_account(request)

        self.assertEqual(result, {"activeMode": "test"})
        stripe_doc = db.documents["accounts/account-1/integrations/stripe"]
        self.assertEqual(stripe_doc, {"selectedMode": "test", "isActive": True})
        legacy_doc = db.documents[
            "accounts/account-1/integrations/stripe/accounts/acct_legacy"
        ]
        self.assertTrue(legacy_doc["archived"])

    def test_disconnect_stripe_account_rejects_wrong_account_user(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "other-account"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {"accountId": "acct_test", "isActive": True},
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.disconnect_stripe_account(request)

        self.assertEqual(error.exception.code, "permission-denied")

    def test_disconnect_stripe_account_rejects_missing_active_connection(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "live",
            "test": {"accountId": "acct_test", "isActive": True},
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        with self.assertRaises(_HttpsError) as error:
            main.disconnect_stripe_account(request)

        self.assertEqual(error.exception.code, "failed-precondition")

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

    def test_get_stripe_connection_status_returns_not_connected(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test"
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.get_stripe_connection_status(request)

        self.assertEqual(result["activeMode"], "test")
        self.assertFalse(result["hasAccount"])
        self.assertFalse(result["isReady"])

    def test_get_stripe_connection_status_returns_ready_from_stripe(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {"accountId": "acct_123", "isActive": True},
        }
        stripe_account = _FakeStripeAccount(charges_enabled=True)
        main.firestore.client = lambda: db
        main.stripe.Account = stripe_account
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.get_stripe_connection_status(request)

        self.assertTrue(result["hasAccount"])
        self.assertTrue(result["isReady"])
        self.assertTrue(result["chargesEnabled"])
        self.assertEqual(result["reason"], "Stripe is ready to accept payments.")
        self.assertEqual(stripe_account.retrieve_calls, ["acct_123"])

    def test_get_stripe_connection_status_deactivates_stale_connection(self):
        db = _FakeDb()
        db.documents["users/user-1"] = {"account": "account-1"}
        db.documents["accounts/account-1/integrations/stripe"] = {
            "activeMode": "test",
            "test": {"accountId": "acct_123", "isActive": True},
        }
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(
            charges_enabled=False,
            disabled_reason="requirements.past_due",
            currently_due=["business_profile.url"],
        )
        request = types.SimpleNamespace(
            data={"account": "account-1"},
            auth=types.SimpleNamespace(uid="user-1"),
        )

        result = main.get_stripe_connection_status(request)

        self.assertTrue(result["hasAccount"])
        self.assertFalse(result["isReady"])
        self.assertEqual(result["disabledReason"], "requirements.past_due")
        self.assertIn("requirements.past_due", result["reason"])
        self.assertFalse(
            db.documents["accounts/account-1/integrations/stripe"]["isActive"]
        )

    def test_get_public_stripe_status_does_not_return_account_id(self):
        db = _FakeDb()
        db.documents["accounts/account-1/integrations/stripe"] = {
            "accountId": "acct_123",
            "isActive": True,
        }
        main.firestore.client = lambda: db
        request = types.SimpleNamespace(data={"account": "account-1"}, auth=None)

        result = main.get_public_stripe_status(request)

        self.assertEqual(result, {"activeMode": "test", "isActive": True})

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
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
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
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
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
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
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
        created_on = db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]["createdOn"]
        expires_at = db.documents[
            "accounts/account-1/data/bookingManager/bookings/booking-1"
        ]["expiresAt"]
        self.assertEqual(created_on, created_at)
        self.assertEqual(expires_at - created_at, main.timedelta(minutes=37))

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
                "vatRate": 0.255,
                "stripeTaxRateId": "txr_stale_adult",
            },
            {
                "id": "child",
                "isArchived": False,
                "displayName": "Child",
                "priceCents": 5000,
                "vatRate": 0,
            },
        ]
        checkout = _FakeCheckoutSession()
        tax_rate = _FakeTaxRate()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = tax_rate
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
                    "tax_rates": ["txr_123"],
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
        self.assertEqual(len(tax_rate.calls), 1)
        self.assertEqual(tax_rate.calls[0]["percentage"], 25.5)
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["stripeId"], "acct_123")
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["total"], 15000)
        self.assertEqual(db.documents["checkoutSessions/cs_123"]["commission"], 658)

    def test_create_booking_checkout_session_reuses_cached_tax_rate(self):
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
                "vatRate": 0.255,
            }
        ]
        cache_ref = main._tax_rate_cache_ref(
            db, "account-1", "test", "acct_123", 25.5
        )
        db.documents[cache_ref.path] = {"taxRateId": "txr_cached"}
        checkout = _FakeCheckoutSession()
        tax_rate = _FakeTaxRate()
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = tax_rate
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        main.create_booking_checkout_session(request)

        self.assertEqual(tax_rate.calls, [])
        self.assertEqual(
            checkout.calls[0]["line_items"][0]["tax_rates"],
            ["txr_cached"],
        )

    def test_create_booking_checkout_session_replaces_stale_cached_tax_rate(self):
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
                "vatRate": 0.255,
            }
        ]
        cache_ref = main._tax_rate_cache_ref(
            db, "account-1", "test", "acct_123", 25.5
        )
        db.documents[cache_ref.path] = {"taxRateId": "txr_stale"}
        checkout = _FakeCheckoutSession(
            failures=[Exception("No such tax rate: 'txr_stale'")]
        )
        tax_rate = _FakeTaxRate(ids=["txr_fresh"])
        main.firestore.client = lambda: db
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)
        main.stripe.checkout.Session = checkout
        main.stripe.TaxRate = tax_rate
        request = types.SimpleNamespace(
            data={
                "account": "account-1",
                "tourId": "tour-1",
                "booking": {"id": "booking-1", "customerGroupId": "cg-1"},
                "customers": [{"id": "customer-1", "pricingId": "adult"}],
            }
        )

        main.create_booking_checkout_session(request)

        self.assertEqual(len(checkout.calls), 2)
        self.assertEqual(checkout.calls[0]["line_items"][0]["tax_rates"], ["txr_stale"])
        self.assertEqual(checkout.calls[1]["line_items"][0]["tax_rates"], ["txr_fresh"])
        self.assertEqual(len(tax_rate.calls), 1)
        self.assertEqual(db.documents[cache_ref.path]["taxRateId"], "txr_fresh")

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
