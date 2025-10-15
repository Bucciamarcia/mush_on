from firebase_admin import firestore
from pydantic import BaseModel, Field
from datetime import datetime
import os
from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
import requests


class CheckoutSession(BaseModel):
    checkoutSessionId: str
    account: str
    stripeId: str
    bookingId: str
    createdAt: datetime
    webhookProcessed: bool


class Booking(BaseModel):
    city: str
    country: str
    customerGroupId: str
    email: str
    id: str
    name: str
    paymentStatus: str
    phone: str
    streetAddress: str
    zipCode: str


class CustomerGroup(BaseModel):
    datetime: datetime
    id: str
    maxCapacity: int
    name: str
    teamGroupId: str | None = Field(default=None)
    tourTypeId: str | None = Field(default=None)


class BookingInfo(BaseModel):
    cancellationPolicy: str
    email: str
    name: str
    url: str


def add_checkout_session_to_db(
    checkout_session_id: str, account: str, stripe_id: str, booking_id: str
) -> None:
    firestore.client().document(f"checkoutSessions/{checkout_session_id}").set(
        {
            "checkoutSessionId": checkout_session_id,
            "account": account,
            "stripeId": stripe_id,
            "bookingId": booking_id,
            "createdAt": datetime.now(),
            "webhookProcessed": False,
        }
    )


def payment_processed(
    checkout_session_id: str,
    stripe_account: str,
    stripe_api_key: str,
    payment_intent_id: str,
    stripe_email: str,
) -> None:
    """Sets webook processed in checkout sessions and changes payment
    status in booking"""
    path = f"checkoutSessions/{checkout_session_id}"
    doc_ref = firestore.client().document(path)
    snapshot = doc_ref.get()
    data = snapshot.to_dict()
    if data is None:
        raise Exception("Couldn't find db")
    checkout_session = CheckoutSession.model_validate(data)
    account = checkout_session.account
    # Skip if already processed (idempotency)
    if checkout_session.webhookProcessed:
        print(f"Payment {checkout_session_id} already processed, skipping")
        return
    batch = firestore.client().batch()
    booking_path = f"accounts/{checkout_session.account}/data/bookingManager/bookings/{checkout_session.bookingId}"
    booking_ref = firestore.client().document(booking_path)
    booking_obj = booking_ref.get()
    data = booking_obj.to_dict()
    booking = Booking.model_validate(data)
    if data is None:
        raise Exception("Couldn't find booking")
    batch.update(booking_ref, {"paymentStatus": "paid"})
    cg_obj = (
        firestore.client()
        .document(
            f"accounts/{checkout_session.account}/data/bookingManager/customerGroups/{booking.customerGroupId}"
        )
        .get()
    )
    cg_data = cg_obj.to_dict()
    cg = CustomerGroup.model_validate(cg_data)
    payment_receipt_url = get_payment_receipt_url(
        stripe_id=stripe_account,
        checkout_session_id=checkout_session_id,
        stripe_api_key=stripe_api_key,
    )
    receipt_url = payment_receipt_url["url"]
    total = payment_receipt_url["total"]
    booking_info = get_booking_info(account=account)
    batch.update(
        doc_ref,
        {
            "webhookProcessed": True,
            "paymentIntentId": payment_intent_id,
            "stripeEmail": stripe_email,
            "total": total,
        },
    )
    batch.commit()
    send_postmark_email(
        account=account,
        kennel_name=booking_info.name,
        booking_date=cg.datetime,
        total_amount=total,
        currency="€",
        receipt_url=receipt_url,
        kennel_url=booking_info.url,
        receiver_email=booking.email,
        sender_email=booking_info.email,
        cancellation_policy=booking_info.cancellationPolicy,
    )


def send_postmark_email(
    account: str,
    kennel_name: str,
    booking_date: datetime,
    total_amount: int,
    currency: str,
    receipt_url: str,
    kennel_url: str,
    receiver_email: str,
    sender_email: str,
    cancellation_policy: str,
) -> None:
    server_token = os.getenv("POSTMARK_SERVER_TOKEN")
    account_token = os.getenv("POSTMARK_ACCOUNT_TOKEN")
    booking_date_string = booking_date.strftime("%B %d, %Y")
    if server_token is None:
        raise Exception("No Postmark server token set in env")
    if account_token is None:
        raise Exception("No Postmark account token set in env")
    url = "https://api.postmarkapp.com/email/withTemplate"
    picture_url = f"https://firebasestorage.googleapis.com/v0/b/mush-on.firebasestorage.app/o/accounts%2F{account}%2FbookingManager%2Fbanner?alt=media"
    kennel_name_escaped = kennel_name.replace('"', '\\"')
    template_model = {
        "kennel_header_picture_url": picture_url,
        "kennel_name": kennel_name,
        "cancellation_policy": cancellation_policy,
        "booking_date": booking_date_string,
        "total_amount_number": str(total_amount),
        "total_amout_currency": currency,
        "receipt_url": receipt_url,
        "kennel_url": kennel_url,
    }
    body = {
        "TemplateId": "41742284",
        "TemplateModel": template_model,
        "From": f"{kennel_name_escaped} <confirmations@mush-on.com>",
        "To": receiver_email,
        "ReplyTo": sender_email,
    }
    header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Postmark-Server-Token": server_token,
    }
    try:
        response = requests.post(url, headers=header, json=body)
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        if response.status_code == 422:
            print(f"Postmark API error (422): {response.json()}")
        else:
            print(f"HTTP error sending email via Postmark: {e}")
            print(f"Response body: {response.text}")
        raise e
    except Exception as e:
        print(f"Error sending email via Postmark: {e}")
        raise e


def get_booking_info(account: str) -> BookingInfo:
    path = f"accounts/{account}/data/bookingManager"
    print(f"Getting from: {path}")
    db = firestore.client()
    doc = db.document(path).get()
    data = doc.to_dict()
    print(str(data))
    return BookingInfo.model_validate(data)
