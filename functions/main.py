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
import asyncio
from datetime import datetime
from firebase_functions import https_fn
from firebase_admin import firestore
from concurrent.futures import ThreadPoolExecutor
from typing import List, Dict, Any
from lib.send_invitation_email import SendInvitationEmail
from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
from lib.stripe.utils import get_stripe_data
from lib.utils.firebase import FirestoreUtils

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
def team_groups_workspace_from_date_range(req: https_fn.CallableRequest):
    """
    Fetch team groups with nested teams and dog pairs for a date range.

    Expected data:
    {
        "account": "account_id",
        "start": "ISO datetime string",
        "end": "ISO datetime string"
    }
    """
    # Parse request data
    data = req.data
    account = data.get("account")
    start_str = data.get("start")
    end_str = data.get("end")

    # Validate inputs
    if not account or not start_str or not end_str:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="Missing required fields: account, start, end",
        )

    # Parse datetime strings
    start = datetime.fromisoformat(start_str.replace("Z", "+00:00"))
    end = datetime.fromisoformat(end_str.replace("Z", "+00:00"))

    db = firestore.client()
    path = f"accounts/{account}/data/teams/history"

    # Step 1: Get all team groups
    team_groups_ref = (
        db.collection(path).where("date", ">=", start).where("date", "<=", end)
    )
    team_groups_snapshot = team_groups_ref.stream()
    team_groups = list(team_groups_snapshot)

    # Step 2: Get all teams in parallel
    def get_teams(team_group_id):
        teams_ref = db.collection(f"{path}/{team_group_id}/teams")
        return list(teams_ref.stream())

    with ThreadPoolExecutor(max_workers=10) as executor:
        teams_for_teamgroup = list(
            executor.map(get_teams, [tg.id for tg in team_groups])
        )

    # Step 3: Build list of all team references for dog pairs fetch
    all_team_refs = []
    for i, team_group in enumerate(team_groups):
        teams = teams_for_teamgroup[i]
        for team in teams:
            all_team_refs.append({"teamGroupId": team_group.id, "teamId": team.id})

    # Step 4: Fetch all dog pairs in parallel
    def get_dog_pairs(team_ref):
        tg_id = team_ref["teamGroupId"]
        t_id = team_ref["teamId"]
        dog_pairs_ref = db.collection(f"{path}/{tg_id}/teams/{t_id}/dogPairs")
        dog_pairs = [doc.to_dict() for doc in dog_pairs_ref.stream()]
        return {"teamGroupId": tg_id, "teamId": t_id, "dogPairs": dog_pairs}

    with ThreadPoolExecutor(max_workers=50) as executor:
        dog_pairs_results = list(executor.map(get_dog_pairs, all_team_refs))

    # Step 5: Build lookup map for dog pairs
    dog_pairs_map = {}
    for result in dog_pairs_results:
        tg_id = result["teamGroupId"]
        t_id = result["teamId"]

        if tg_id not in dog_pairs_map:
            dog_pairs_map[tg_id] = {}

        dog_pairs_map[tg_id][t_id] = [
            {
                "id": dp.get("id"),
                "firstDogId": dp.get("firstDogId"),
                "secondDogId": dp.get("secondDogId"),
            }
            for dp in result["dogPairs"]
        ]

    # Step 6: Build final structure
    to_return = []
    for i, team_group_doc in enumerate(team_groups):
        tg_data = team_group_doc.to_dict()
        if tg_data is None:
            continue
        team_docs = teams_for_teamgroup[i]

        teams_workspace = []
        for team_doc in team_docs:
            team_data = team_doc.to_dict()
            if team_data is None:
                continue
            dog_pairs = dog_pairs_map.get(tg_data["id"], {}).get(team_data["id"], [])

            teams_workspace.append(
                {
                    "id": team_data.get("id"),
                    "name": team_data.get("name"),
                    "capacity": team_data.get("capacity"),
                    "dogPairs": dog_pairs,
                }
            )

        to_return.append(
            {
                "date": tg_data.get("date"),
                "runType": tg_data.get("runType"),
                "notes": tg_data.get("notes"),
                "name": tg_data.get("name"),
                "id": tg_data.get("id"),
                "teams": teams_workspace,
                "distance": tg_data.get("distance"),
            }
        )

    return {"teamGroups": to_return}
