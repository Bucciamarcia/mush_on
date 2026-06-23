from firebase_admin import firestore
import os
from datetime import datetime, timezone


STRIPE_MODE_TEST = "test"
STRIPE_MODE_LIVE = "live"


def get_stripe_data(account: str) -> dict:
    try:
        db = firestore.client()
        ref = db.document(f"accounts/{account}/integrations/stripe")
        snapshot = ref.get()
        stripe_data = snapshot.to_dict()
        if stripe_data is None:
            return {"error": "stripe data is null"}
        stripe_data = _migrate_legacy_stripe_data(db, ref, account, stripe_data)
        return stripe_data
    except Exception as e:
        raise Exception(f"Couldn't get stripe data: {str(e)}")


def normalize_stripe_mode(value) -> str:
    return STRIPE_MODE_LIVE if value == STRIPE_MODE_LIVE else STRIPE_MODE_TEST


def get_stripe_api_key(stripe_mode: str) -> str:
    stripe_mode = normalize_stripe_mode(stripe_mode)
    env_name = "STRIPE_LIVE_KEY" if stripe_mode == STRIPE_MODE_LIVE else "STRIPE_TEST_KEY"
    api_key = os.getenv(env_name)
    if not api_key:
        raise Exception(f"{env_name} is not configured")
    return api_key


def get_checkout_stripe_api_key(checkout_data: dict) -> str:
    return get_stripe_api_key(checkout_data.get("stripeMode"))


def get_selected_stripe_mode(account: str) -> str:
    db = firestore.client()
    ref = db.document(f"accounts/{account}/integrations/stripe")
    data = ref.get().to_dict() or {}
    data = _migrate_legacy_stripe_data(db, ref, account, data)
    return normalize_stripe_mode(data.get("selectedMode"))


def get_stripe_integration_is_active(account: str) -> bool:
    db = firestore.client()
    ref = db.document(f"accounts/{account}/integrations/stripe")
    data = ref.get().to_dict() or {}
    data = _migrate_legacy_stripe_data(db, ref, account, data)
    return bool(data.get("isActive"))


def get_connected_account_doc(account: str, stripe_mode: str) -> dict | None:
    stripe_mode = normalize_stripe_mode(stripe_mode)
    db = firestore.client()
    parent_ref = db.document(f"accounts/{account}/integrations/stripe")
    _migrate_legacy_stripe_data(db, parent_ref, account, parent_ref.get().to_dict() or {})
    docs = list(
        db.collection(f"accounts/{account}/integrations/stripe/accounts")
        .where("mode", "==", stripe_mode)
        .where("archived", "==", False)
        .limit(2)
        .stream()
    )
    if not docs:
        return None
    data = docs[0].to_dict() or {}
    data.setdefault("accountId", getattr(docs[0], "id", None))
    return data


def get_account_doc(account: str, account_id: str) -> dict | None:
    db = firestore.client()
    parent_ref = db.document(f"accounts/{account}/integrations/stripe")
    _migrate_legacy_stripe_data(db, parent_ref, account, parent_ref.get().to_dict() or {})
    ref = db.document(f"accounts/{account}/integrations/stripe/accounts/{account_id}")
    data = ref.get().to_dict()
    if data is None:
        return None
    data.setdefault("accountId", account_id)
    return data


def _legacy_connection_docs(stripe_data: dict) -> list[tuple[str, dict]]:
    docs = []
    for mode in (STRIPE_MODE_TEST, STRIPE_MODE_LIVE):
        connection = stripe_data.get(mode)
        if isinstance(connection, dict) and connection.get("accountId"):
            docs.append((mode, connection))
    if stripe_data.get("accountId"):
        docs.append(
            (
                STRIPE_MODE_TEST,
                {
                    "accountId": stripe_data.get("accountId"),
                    "isActive": bool(stripe_data.get("isActive")),
                    "connectedAt": stripe_data.get("connectedAt"),
                },
            )
        )
    return docs


def _migrate_legacy_stripe_data(db, ref, account: str, stripe_data: dict) -> dict:
    legacy_docs = _legacy_connection_docs(stripe_data)
    has_legacy_mode = any(key in stripe_data for key in ("activeMode", "test", "live"))
    has_legacy_flat = "accountId" in stripe_data

    selected_mode = normalize_stripe_mode(
        stripe_data.get("selectedMode") or stripe_data.get("activeMode")
    )
    selected_connection = next(
        (
            connection
            for mode, connection in legacy_docs
            if normalize_stripe_mode(mode) == selected_mode
        ),
        None,
    )
    migrated_account_active = None
    selected_docs = list(
        db.collection(f"accounts/{account}/integrations/stripe/accounts")
        .where("mode", "==", selected_mode)
        .where("archived", "==", False)
        .limit(1)
        .stream()
    )
    if selected_docs:
        selected_doc_data = selected_docs[0].to_dict() or {}
        if "isActive" in selected_doc_data:
            migrated_account_active = bool(selected_doc_data.get("isActive"))

    if "isActive" in stripe_data:
        integration_is_active = bool(stripe_data.get("isActive"))
    elif selected_connection is not None:
        integration_is_active = bool(selected_connection.get("isActive"))
    elif migrated_account_active is not None:
        integration_is_active = migrated_account_active
    else:
        integration_is_active = False

    if (
        not legacy_docs
        and not has_legacy_mode
        and not has_legacy_flat
        and stripe_data.get("isActive") is integration_is_active
    ):
        return stripe_data

    now = datetime.now(timezone.utc)
    seen = set()
    for mode, connection in legacy_docs:
        account_id = connection.get("accountId")
        if not account_id or account_id in seen:
            continue
        seen.add(account_id)
        account_ref = db.document(
            f"accounts/{account}/integrations/stripe/accounts/{account_id}"
        )
        existing = account_ref.get().to_dict() or {}
        cleaned_existing = {
            key: value for key, value in existing.items() if key != "isActive"
        }
        account_ref.set(
            {
                "id": account_id,
                "accountId": account_id,
                "mode": normalize_stripe_mode(mode),
                "archived": False,
                "connectedAt": connection.get("connectedAt") or now,
                "archivedAt": None,
                **cleaned_existing,
            }
        )

    for doc in selected_docs:
        doc_data = doc.to_dict() or {}
        if "isActive" in doc_data:
            cleaned_doc = {key: value for key, value in doc_data.items() if key != "isActive"}
            doc.reference.set(cleaned_doc)

    cleaned = {
        key: value
        for key, value in stripe_data.items()
        if key not in {"activeMode", "test", "live", "accountId", "isActive"}
    }
    cleaned["selectedMode"] = selected_mode
    cleaned["isActive"] = integration_is_active
    ref.set(cleaned)
    return cleaned
