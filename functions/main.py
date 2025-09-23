# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app
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


@https_fn.on_request()
def stripe_create_account(req: https_fn.Request) -> https_fn.Response:
    try:
        account = stripe.Account.create()
        return https_fn.Response(
            {"account": account.id}, mimetype="application/json", status=200
        )
    except Exception as e:
        return https_fn.Response(
            response={"error": str(e)}, status=500, mimetype="application/json"
        )


@https_fn.on_request()
def stripe_create_account_link(req: https_fn.Request) -> https_fn.Response:
    try:
        connected_account_id = req.args.get("account")
        if connected_account_id is None:
            return https_fn.Response(
                {"error": "account param is not present"},
                status=400,
                mimetype="application/json",
            )
        account_link = stripe.AccountLink.create(
            account=connected_account_id,
            return_url="https://lapponiatravel.com",
            refresh_url="https://lapponiatravel.com/refresh",
            type="account_onboarding",
        )
        return https_fn.Response(
            {"url": account_link.url}, mimetype="application/json", status=200
        )
    except Exception as e:
        return https_fn.Response(
            response={"error": str(e)}, status=500, mimetype="application/json"
        )


#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")
