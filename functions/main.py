# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app
import stripe
from lib.add_booking.add_booking import add_booking_main

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10, region="europe-north1")

initialize_app()


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


#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")
