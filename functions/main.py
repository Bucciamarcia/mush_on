# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app, firestore
import stripe
from lib.add_booking.add_booking import add_booking_main
from dotenv import load_dotenv
import os

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10, region="europe-north1")

initialize_app()
load_dotenv()
stripe.api_key = os.getenv("STRIPE_KEY")


def _unwrap_int64_wrappers(x):
    if isinstance(x, dict):
        # unwrap google.protobuf.Int64Value
        if (
            x.get("@type") == "type.googleapis.com/google.protobuf.Int64Value"
            and "value" in x
        ):
            try:
                return int(x["value"])
            except Exception:
                return x
        return {k: _unwrap_int64_wrappers(v) for k, v in x.items()}
    if isinstance(x, list):
        return [_unwrap_int64_wrappers(v) for v in x]
    return x


@https_fn.on_call()
def add_booking(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        booking = _unwrap_int64_wrappers(data["booking"])
        customers = _unwrap_int64_wrappers(data["customers"])
        account: str = data["account"]
    except Exception as e:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INVALID_ARGUMENT, str(e))

    try:
        add_booking_main(booking, customers, account)
        return {}
    except Exception as e:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INTERNAL, str(e))


@https_fn.on_call()
def stripe_create_account(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        account = stripe.Account.create(
            controller={
                "stripe_dashboard": {
                    "type": "express",
                },
                "losses": {"payments": "application"},
                "fees": {"payer": "application"},
            },
        )
        return {"account": account.id}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def stripe_create_account_link(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        connected_account_id = req.data.get("stripeAccount")
        account = req.data.get("account")
        if connected_account_id is None:
            return {"error": "account param is not present"}
        account_link = stripe.AccountLink.create(
            account=connected_account_id,
            return_url=f"https://mush-on.web.app/stripe_connection?kennel={account}&result=success",
            refresh_url=f"https://mush-on.web.app/stripe_connection?kennel={account}&result=failed",
            type="account_onboarding",
        )
        return {"url": account_link.url}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def change_stripe_integration_activation(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        account = data["account"]
        is_active = data["isActive"]
        if account is None or is_active is None:
            return {"error": "account or isActive is null"}
        db = firestore.client()
        ref = db.document(f"accounts/{account}/integrations/stripe")
        ref.update({"isActive": is_active})
        return {}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def get_stripe_integration_data(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        account = data["account"]
        if account is None:
            return {"error": "account is null"}
        db = firestore.client()
        ref = db.document(f"accounts/{account}/integrations/stripe")
        snapshot = ref.get()
        stripe_data = snapshot.to_dict()
        if stripe_data is None:
            return {"error": "stripe data is null"}
        return stripe_data
    except Exception as e:
        return {"error": str(e)}


#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")
