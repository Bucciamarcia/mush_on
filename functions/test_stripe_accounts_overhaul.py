"""Failing tests that describe the Stripe account archival / reconnection overhaul.

These tests are written BEFORE the implementation exists. They are the
executable specification of the goal described in `stripe_config_worksheet.md`.
Run with:

    cd functions && python -m unittest test_stripe_accounts_overhaul

Every test in this file is expected to FAIL (or error with AttributeError for
callables that do not exist yet) against the current code base. They pass once
the worksheet is implemented.

Target Firestore layout
------------------------
Parent doc:  accounts/{account}/integrations/stripe
    {
        "selectedMode": "test" | "live",    # persisted UI toggle
        "isActive": bool,                   # global user intent to accept payments
    }

Per-account subcollection (doc id == stripe account id):
    accounts/{account}/integrations/stripe/accounts/{acct_id}
    {
        "accountId":  "acct_id",
        "mode":       "test" | "live",
        "archived":   bool,    # False == currently connected. Only ONE False per mode.
        "connectedAt": <timestamp>,
        "archivedAt":  <timestamp|None>,
    }
"""

import types
import unittest

# Importing test_main installs all the module stubs (firebase_functions,
# firebase_admin, stripe, ...) and builds the `main` module, and gives us the
# in-memory Firestore/Stripe fakes used across the existing backend test-suite.
from test_main import (  # noqa: E402
    _FakeAccountLink,
    _FakeDb,
    _FakeStripeAccount,
    _HttpsError,
    main,
)

STRIPE_DOC = "accounts/account-1/integrations/stripe"
ACCOUNTS_COLLECTION = f"{STRIPE_DOC}/accounts"


def _request(data, uid="user-1"):
    auth = None if uid is None else types.SimpleNamespace(uid=uid)
    return types.SimpleNamespace(data=data, auth=auth)


def _account_doc(
    account_id,
    mode="test",
    archived=False,
    connected_at="connected-date",
    archived_at=None,
):
    return {
        "id": account_id,
        "accountId": account_id,
        "mode": mode,
        "archived": archived,
        "connectedAt": connected_at,
        "archivedAt": archived_at,
    }


class _Base(unittest.TestCase):
    def setUp(self):
        self.db = _FakeDb()
        self.db.documents["users/user-1"] = {"account": "account-1"}
        main.firestore.client = lambda: self.db

    def seed_account(self, account_id, **kwargs):
        doc = _account_doc(account_id, **kwargs)
        self.db.documents[f"{ACCOUNTS_COLLECTION}/{account_id}"] = doc
        return doc

    def seed_parent(self, selected_mode="test", is_active=False):
        self.db.documents[STRIPE_DOC] = {
            "selectedMode": selected_mode,
            "isActive": is_active,
        }

    def account_doc(self, account_id):
        return self.db.documents.get(f"{ACCOUNTS_COLLECTION}/{account_id}")


class DisconnectArchivesTests(_Base):
    def test_disconnect_archives_connected_account_instead_of_deleting(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)

        main.disconnect_stripe_account(
            _request({"account": "account-1", "stripeMode": "test"})
        )

        doc = self.account_doc("acct_test")
        # The whole point of the overhaul: the account row survives.
        self.assertIsNotNone(doc, "Disconnect must NOT delete the account document")
        self.assertTrue(doc["archived"], "Disconnect must archive the account")
        self.assertIsNotNone(doc["archivedAt"], "archivedAt must be stamped")

    def test_disconnect_only_affects_selected_mode(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)
        self.seed_account("acct_live", mode="live", archived=False)

        main.disconnect_stripe_account(
            _request({"account": "account-1", "stripeMode": "test"})
        )

        self.assertTrue(self.account_doc("acct_test")["archived"])
        self.assertFalse(
            self.account_doc("acct_live")["archived"],
            "Live connection must be untouched when disconnecting test",
        )

    def test_disconnect_rejects_when_no_connected_account(self):
        self.seed_parent("test")
        self.seed_account("acct_old", mode="test", archived=True)

        with self.assertRaises(_HttpsError) as ctx:
            main.disconnect_stripe_account(
                _request({"account": "account-1", "stripeMode": "test"})
            )
        self.assertEqual(ctx.exception.code, "failed-precondition")

    def test_disconnect_requires_account_membership(self):
        self.db.documents["users/user-1"] = {"account": "other-account"}
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)

        with self.assertRaises(_HttpsError) as ctx:
            main.disconnect_stripe_account(
                _request({"account": "account-1", "stripeMode": "test"})
            )
        self.assertEqual(ctx.exception.code, "permission-denied")
        self.assertFalse(self.account_doc("acct_test")["archived"])


class CreateAccountTests(_Base):
    def test_create_account_writes_subcollection_doc_archived_false(self):
        self.seed_parent("test")
        main.stripe.Account = _FakeStripeAccount(charges_enabled=False)

        result = main.stripe_create_account(
            _request({"account": "account-1", "stripeMode": "test"})
        )

        self.assertEqual(result, {"account": "acct_new"})
        doc = self.account_doc("acct_new")
        self.assertIsNotNone(doc, "Create must write a per-account subcollection doc")
        self.assertEqual(doc["accountId"], "acct_new")
        self.assertEqual(doc["mode"], "test")
        self.assertFalse(doc["archived"], "A freshly created account is the connected one")
        self.assertNotIn("isActive", doc)
        self.assertFalse(self.db.documents[STRIPE_DOC]["isActive"])
        self.assertIsNotNone(doc["connectedAt"])

    def test_create_account_archives_previous_connected_account_same_mode(self):
        self.seed_parent("test")
        self.seed_account("acct_old", mode="test", archived=False)
        main.stripe.Account = _FakeStripeAccount(charges_enabled=False)

        main.stripe_create_account(
            _request({"account": "account-1", "stripeMode": "test"})
        )

        self.assertTrue(
            self.account_doc("acct_old")["archived"],
            "Creating a new account must archive the previously connected one",
        )
        self.assertFalse(self.account_doc("acct_new")["archived"])


class ReconnectTests(_Base):
    def test_reconnect_sets_archived_false_and_archives_previous(self):
        self.seed_parent("test")
        self.seed_account("acct_history", mode="test", archived=True)
        self.seed_account("acct_current", mode="test", archived=False)

        main.reconnect_stripe_account(
            _request(
                {
                    "account": "account-1",
                    "accountId": "acct_history",
                    "stripeMode": "test",
                }
            )
        )

        self.assertFalse(
            self.account_doc("acct_history")["archived"],
            "Reconnected account becomes the connected one",
        )
        self.assertTrue(
            self.account_doc("acct_current")["archived"],
            "Previously connected account is archived on reconnect",
        )

    def test_reconnect_rejects_unknown_account(self):
        self.seed_parent("test")
        with self.assertRaises(_HttpsError) as ctx:
            main.reconnect_stripe_account(
                _request(
                    {
                        "account": "account-1",
                        "accountId": "acct_missing",
                        "stripeMode": "test",
                    }
                )
            )
        self.assertEqual(ctx.exception.code, "not-found")

    def test_reconnect_requires_account_membership(self):
        self.db.documents["users/user-1"] = {"account": "other-account"}
        self.seed_parent("test")
        self.seed_account("acct_history", mode="test", archived=True)

        with self.assertRaises(_HttpsError) as ctx:
            main.reconnect_stripe_account(
                _request(
                    {
                        "account": "account-1",
                        "accountId": "acct_history",
                        "stripeMode": "test",
                    }
                )
            )
        self.assertEqual(ctx.exception.code, "permission-denied")


class DeleteTests(_Base):
    def test_delete_removes_specific_archived_account_only(self):
        self.seed_parent("test")
        self.seed_account("acct_keep", mode="test", archived=True)
        self.seed_account("acct_drop", mode="test", archived=True)

        main.delete_stripe_account(
            _request({"account": "account-1", "accountId": "acct_drop"})
        )

        self.assertIsNone(
            self.account_doc("acct_drop"), "Targeted archived account must be deleted"
        )
        self.assertIsNotNone(
            self.account_doc("acct_keep"), "Other archived accounts are untouched"
        )

    def test_delete_rejects_connected_account(self):
        self.seed_parent("test")
        self.seed_account("acct_connected", mode="test", archived=False)

        with self.assertRaises(_HttpsError) as ctx:
            main.delete_stripe_account(
                _request({"account": "account-1", "accountId": "acct_connected"})
            )
        self.assertEqual(ctx.exception.code, "failed-precondition")
        self.assertIsNotNone(self.account_doc("acct_connected"))

    def test_delete_requires_account_membership(self):
        self.db.documents["users/user-1"] = {"account": "other-account"}
        self.seed_parent("test")
        self.seed_account("acct_drop", mode="test", archived=True)

        with self.assertRaises(_HttpsError) as ctx:
            main.delete_stripe_account(
                _request({"account": "account-1", "accountId": "acct_drop"})
            )
        self.assertEqual(ctx.exception.code, "permission-denied")
        self.assertIsNotNone(self.account_doc("acct_drop"))


class ActivationTests(_Base):
    def test_change_activation_toggles_global_isactive(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)

        main.change_stripe_integration_activation(
            _request(
                {"account": "account-1", "isActive": True}
            )
        )

        doc = self.account_doc("acct_test")
        self.assertNotIn("isActive", doc)
        self.assertTrue(self.db.documents[STRIPE_DOC]["isActive"])
        self.assertFalse(doc["archived"], "Activation must not change connection state")

    def test_change_activation_does_not_require_connected_account(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=True)

        main.change_stripe_integration_activation(
            _request(
                {"account": "account-1", "isActive": True}
            )
        )

        self.assertTrue(self.db.documents[STRIPE_DOC]["isActive"])


class SelectedModeTests(_Base):
    def test_set_selected_mode_persists_to_parent_doc(self):
        self.seed_parent("test")

        main.set_selected_stripe_mode(
            _request({"account": "account-1", "stripeMode": "live"})
        )

        self.assertEqual(self.db.documents[STRIPE_DOC]["selectedMode"], "live")

    def test_set_selected_mode_requires_account_membership(self):
        self.db.documents["users/user-1"] = {"account": "other-account"}
        self.seed_parent("test")

        with self.assertRaises(_HttpsError) as ctx:
            main.set_selected_stripe_mode(
                _request({"account": "account-1", "stripeMode": "live"})
            )
        self.assertEqual(ctx.exception.code, "permission-denied")
        self.assertEqual(self.db.documents[STRIPE_DOC]["selectedMode"], "test")


class FinalizeTests(_Base):
    def _seed_attempt(self, account_id="acct_test", token="secret-token"):
        now = main.datetime.now(main.timezone.utc)
        attempt_id = "attempt-1"
        self.db.documents[
            f"{STRIPE_DOC}/onboardingAttempts/{attempt_id}"
        ] = {
            "account": "account-1",
            "stripeMode": "test",
            "stripeAccountId": account_id,
            "tokenHash": main._hash_onboarding_token(token),
            "createdAt": now,
            "expiresAt": now + main.timedelta(minutes=10),
            "consumedAt": None,
        }
        return attempt_id, token

    def test_finalize_activates_connected_account_when_charges_enabled(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)
        attempt_id, token = self._seed_attempt()
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)

        main.finalize_stripe_onboarding(
            _request(
                {"account": "account-1", "attemptId": attempt_id, "token": token},
                uid=None,
            )
        )

        doc = self.account_doc("acct_test")
        self.assertNotIn("isActive", doc)
        self.assertTrue(self.db.documents[STRIPE_DOC]["isActive"])
        self.assertFalse(doc["archived"])

    def test_finalize_keeps_inactive_when_charges_disabled(self):
        self.seed_parent("test")
        self.seed_account("acct_test", mode="test", archived=False)
        attempt_id, token = self._seed_attempt()
        main.stripe.Account = _FakeStripeAccount(charges_enabled=False)

        main.finalize_stripe_onboarding(
            _request(
                {"account": "account-1", "attemptId": attempt_id, "token": token},
                uid=None,
            )
        )

        self.assertFalse(self.db.documents[STRIPE_DOC]["isActive"])


class ConnectionStatusTests(_Base):
    def test_status_reads_connected_subcollection_account(self):
        self.seed_parent("test", is_active=True)
        self.seed_account("acct_test", mode="test", archived=False)
        main.stripe.Account = _FakeStripeAccount(charges_enabled=True)

        status = main.get_stripe_connection_status(_request({"account": "account-1"}))

        self.assertTrue(status["hasAccount"])
        self.assertTrue(status["isReady"])
        self.assertEqual(status["activeMode"], "test")

    def test_status_not_connected_when_only_archived_accounts_exist(self):
        self.seed_parent("test")
        self.seed_account("acct_old", mode="test", archived=True)

        status = main.get_stripe_connection_status(_request({"account": "account-1"}))

        self.assertFalse(status["hasAccount"])
        self.assertFalse(status["isReady"])

    def test_public_status_uses_connected_account_and_hides_id(self):
        self.seed_parent("test", is_active=True)
        self.seed_account("acct_test", mode="test", archived=False)

        status = main.get_public_stripe_status(_request({"account": "account-1"}, uid=None))

        self.assertEqual(status["activeMode"], "test")
        self.assertTrue(status["isActive"])
        self.assertNotIn("accountId", status)


class CheckoutResolverTests(_Base):
    def test_checkout_rejects_when_selected_mode_has_no_connected_account(self):
        self.seed_parent("test", is_active=True)
        # Only an archived (previously used) account exists for the selected mode.
        self.seed_account("acct_old", mode="test", archived=True)

        result = main.create_checkout_session(
            _request(
                {
                    "account": "account-1",
                    "bookingId": "booking-1",
                    "tourId": "tour-1",
                    "customerGroupId": "cg-1",
                },
                uid=None,
            )
        )

        self.assertIn("error", result)


if __name__ == "__main__":
    unittest.main()
