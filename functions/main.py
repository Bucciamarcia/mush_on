# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app, firestore
from flask import json
import stripe
from lib.add_booking.add_booking import add_booking_main
from lib.add_booking import add_checkout_session
from dotenv import load_dotenv
import os

from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
from lib.stripe.utils import get_stripe_data

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
            country="fi",
            capabilities={
                "transfers": {"requested": True},
                "card_payments": {"requested": True},
                "sepa_debit_payments": {"requested": True},
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
        return get_stripe_data(account)
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def create_checkout_session(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data or {}
        account = data.get("account")
        line_items = data.get("lineItems") or []
        fee_amount_raw = data.get("feeAmount")
        booking_id = data.get("bookingId")

        if not account or not line_items or fee_amount_raw is None or not booking_id:
            return {"error": "account, line items, bookingId or fee amount is null"}

        # Sanitize int-like values
        fee_amount = _unwrap_int64_wrappers(fee_amount_raw)
        for item in line_items:
            # quantity
            if "quantity" in item:
                item["quantity"] = _unwrap_int64_wrappers(item["quantity"])
            # unit_amount
            pd = item.get("price_data") or {}
            if "unit_amount" in pd:
                pd["unit_amount"] = _unwrap_int64_wrappers(pd["unit_amount"])

        stripe_data = get_stripe_data(account)
        stripe_account_id = stripe_data["accountId"]

        session = stripe.checkout.Session.create(
            line_items=line_items,
            client_reference_id=booking_id,
            payment_intent_data={"application_fee_amount": fee_amount},
            mode="payment",
            success_url=f"https://mush-on.web.app/booking_success?bookingId={booking_id}&account={account}",
            stripe_account=stripe_account_id,
        )
        checkout_session = session.id
        if checkout_session is None:
            return {"error": f"Checkout session is None. Session: {session}"}
        add_checkout_session.add_checkout_session_to_db(
            checkout_session, account, stripe_account_id, booking_id
        )

        return {"url": session.url}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def create_stripe_tax_rate(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        stripe_account_id = data["stripeAccountId"]
        percentage = data["percentage"]
        percentage = round(percentage, 2)
        response = stripe.TaxRate.create(
            display_name="VAT",
            inclusive=True,
            percentage=percentage,
            tax_type="vat",
            stripe_account=stripe_account_id,
        )
        return {"tax_id": response.id}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_request()
def stirpe_webhook_checkout_session_succeeded(
    req: https_fn.Request,
) -> https_fn.Response:
    payload = req.data
    event = None
    endpoint_secret = os.getenv("STRIPE_PAYMENT_SUCCESS_WEBHOOK_SECRET")
    try:
        event = json.loads(payload)
    except Exception as e:
        return https_fn.Response(f"Invalid payload: {str(e)}", status=400)
    sig_header = req.headers.get("stripe-signature")
    try:
        event: stripe.Event = stripe.Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    except Exception as e:
        print("Webhook signature verification failed." + str(e))
        return https_fn.Response(f"Unauthenticated: {str(e)}", status=400)
    if event and event.type == "checkout.session.completed":
        checkout_session_id = event.data.object["id"]
        account = event.account
        stripe_api = os.getenv("STRIPE_KEY")
        if account is None or stripe_api is None:
            raise Exception("Account is None in webhook")
        add_checkout_session.payment_processed(
            checkout_session_id=checkout_session_id,
            stripe_account=account,
            stripe_api_key=stripe_api,
            payment_intent_id=event.data.object["payment_intent"],
            stripe_email=event.data.object["customer_details"]["email"],
        )

    return https_fn.Response("ok for event")


@https_fn.on_call()
def stripe_get_payment_receipt_url(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data
    booking_id = data["bookingId"]
    db = firestore.client()
    ref = db.collection("checkoutSessions").where("bookingId", "==", booking_id)
    docs = ref.stream()
    first_doc = next(docs, None)
    if first_doc is None:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.NOT_FOUND, "No checkout session found"
        )
    data = first_doc.to_dict()
    return get_payment_receipt_url(
        data["stripeId"], data["checkoutSessionId"], os.getenv("STRIPE_KEY")
    )


@https_fn.on_call()
def refund_payment(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data
    payment_intent: str = data["paymentIntent"]
    amount: int = data["amount"]
    refund = stripe.Refund.create(payment_intent=payment_intent, amount=amount)
    return {"refundId": refund.id}
