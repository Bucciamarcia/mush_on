from firebase_admin import firestore
import os


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


def get_active_stripe_mode(stripe_data: dict) -> str:
    return normalize_stripe_mode(stripe_data.get("activeMode"))


def get_mode_connection(stripe_data: dict, stripe_mode: str) -> dict:
    stripe_mode = normalize_stripe_mode(stripe_mode)
    connection = stripe_data.get(stripe_mode)
    if isinstance(connection, dict):
        return connection

    # Legacy fallback for pre-test/live documents.
    if stripe_mode == STRIPE_MODE_TEST and stripe_data.get("accountId"):
        return {
            "accountId": stripe_data.get("accountId"),
            "isActive": bool(stripe_data.get("isActive")),
        }
    return {}


def get_active_mode_connection(stripe_data: dict) -> tuple[str, dict]:
    stripe_mode = get_active_stripe_mode(stripe_data)
    return stripe_mode, get_mode_connection(stripe_data, stripe_mode)
