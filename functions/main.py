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

from lib.send_invitation_email import SendInvitationEmail
from lib.send_reseller_invitation_email import SendResellerInvitationEmail
from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
from lib.stripe.utils import get_stripe_data
from lib.utils.firebase import FirestoreUtils
from logger import BasicLogger

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
        total_amount_cents_wrapped = data.get("totalAmount")

        if not account or not line_items or fee_amount_raw is None or not booking_id:
            return {"error": "account, line items, bookingId or fee amount is null"}

        total_amount_cents = _unwrap_int64_wrappers(total_amount_cents_wrapped)
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
            checkout_session,
            account,
            stripe_account_id,
            booking_id,
            total_amount_cents,
            fee_amount,
        )

        return {"url": session.url}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def create_checkout_session_reseller(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data or {}
        account = data.get("account")
        line_items = data.get("lineItems") or []
        fee_amount_raw = data.get("feeAmount")
        booking_id = data.get("bookingId")
        total_amount_cents_wrapped = data.get("totalAmount")

        if not account or not line_items or fee_amount_raw is None or not booking_id:
            return {"error": "account, line items, bookingId or fee amount is null"}

        total_amount_cents = _unwrap_int64_wrappers(total_amount_cents_wrapped)
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
            success_url=f"https://mush-on.web.app/booking_reseller_success?bookingId={booking_id}&account={account}",
            stripe_account=stripe_account_id,
        )
        checkout_session = session.id
        if checkout_session is None:
            return {"error": f"Checkout session is None. Session: {session}"}
        add_checkout_session.add_checkout_session_to_db(
            checkout_session,
            account,
            stripe_account_id,
            booking_id,
            total_amount_cents,
            fee_amount,
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
    stripe_account: str = data["stripeAccount"]
    refund = stripe.Refund.create(
        payment_intent=payment_intent,
        stripe_account=stripe_account,
        refund_application_fee=True,
    )
    return {"refundId": refund.id}


@https_fn.on_call()
def invite_user(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data
    sender_email = data["senderEmail"]
    receiver_email = data["receiverEmail"]
    account = data["account"]
    payload = data["payload"]
    security_code = payload["securityCode"]

    FirestoreUtils().set_doc(path=f"userInvitations/{receiver_email}", data=payload)
    runner = SendInvitationEmail(
        sender_email=sender_email,
        receiver_email=receiver_email,
        account=account,
        security_code=security_code,
    )
    runner.run()
    return {"result": "ok"}


@https_fn.on_call()
def get_user_invitation_db(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data
    email = data["email"]
    return FirestoreUtils().read_doc(f"userInvitations/{email}")


@https_fn.on_call()
def get_list_of_accounts(req: https_fn.CallableRequest[dict]) -> dict:
    client = firestore.client()
    collection = client.collection("accounts")
    accounts = collection.get()
    to_return = []
    number = 0
    for account in accounts:
        to_return.append(account.id)
        number = number + 1
    return {"accounts": to_return, "number": number}


@https_fn.on_call()
def invite_reseller(req: https_fn.CallableRequest[dict]) -> dict:
    logger = BasicLogger("invite_reseller")
    logger.info("Starting invite reseler")
    data = req.data
    email: str = data["email"]
    discount_str: str = data["discount"]
    account: str = data["account"]
    security_code: str = data["securityCode"]
    sender_email: str = data["senderEmail"]
    discount = int(discount_str)
    FirestoreUtils().set_doc(
        path=f"resellerInvitations/{email}",
        data={
            "email": email,
            "discount": discount,
            "account": account,
            "securityCode": security_code,
            "accepted": False,
        },
    )
    SendResellerInvitationEmail(
        email=email, security_code=security_code, sender_email=sender_email
    ).run()
    logger.info("DONE")
    return {"status": "ok"}


@https_fn.on_call()
def reseller_invitation_accepted(req: https_fn.CallableRequest[dict]) -> dict:
    logger = BasicLogger("reseller_invitation_accepted")
    logger.info("Starting invitation reseller accepted")
    data = req.data
    email = data["email"]
    db = firestore.client()
    path = f"resellerInvitations/{email}"
    doc = db.document(path)
    try:
        doc.update({"accepted": True})
        return {"status": "ok"}
    except Exception as e:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INTERNAL,
            f"Failed to update document: {str(e)}",
        )


@https_fn.on_call()
def get_firebase_document(req: https_fn.CallableRequest[dict]) -> dict:
    """
    Returns the dict of a single firestore document if the client doesn't have,
    or can't be granted direct access to the database.
    Requires the `path` of the document.
    """
    logger = BasicLogger("get_firebase_document")
    logger.info("Starting get firebase document")
    data = req.data
    db = firestore.client()
    path = data["path"]
    doc = db.document(path)
    try:
        response = doc.get()
        to_return = response.to_dict()
        if to_return is None:
            raise Exception("The document fetched is None")
        return to_return
    except Exception as e:
        logger.error(f"Failed to fetch document: {str(e)}")
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INTERNAL,
            f"Failed to fetch the document: {str(e)}",
        )


@https_fn.on_call()
def get_firebase_collection(req: https_fn.CallableRequest[dict]) -> list[dict]:
    """
    Returns the list of dicts of a firestore collection if the client doesn't have,
    or can't be granted direct access to the database.
    Requires the `path` of the collection.
    """
    logger = BasicLogger("get_firebase_collection")
    logger.info("Starting get firebase collection")
    data = req.data
    path = data["path"]
    db = firestore.client()
    collection = db.collection(path)
    try:
        response = collection.stream()
        to_return = []
        for doc in response:
            to_return.append(doc.to_dict())
        return to_return
    except Exception as e:
        logger.error(f"Failed to fetch collection: {str(e)}")
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INTERNAL,
            f"Failed to fetch the collection: {str(e)}",
        )
