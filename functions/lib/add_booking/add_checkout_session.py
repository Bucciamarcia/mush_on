from firebase_admin import firestore
from pydantic import BaseModel, Field
from datetime import datetime
from zoneinfo import ZoneInfo
from enum import Enum
import os
from typing import Any
from lib.booking_email_html import (
    build_booking_other_info_html,
    build_customers_other_info_html,
)
from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
import requests


class StripeMode(str, Enum):
    LIVE = "live"
    TEST = "test"


class CheckoutSession(BaseModel):
    checkoutSessionId: str
    stripeMode: StripeMode = StripeMode.TEST
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
    otherBookingData: dict[str, str] = Field(default_factory=dict)


class Customer(BaseModel):
    id: str
    bookingId: str
    pricingId: str | None = Field(default=None)
    customerOtherInfo: dict[str, str] = Field(default_factory=dict)


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
    timezone: str = "Europe/Helsinki"
    bookingCustomFields: list[dict[str, Any]] = Field(default_factory=list)
    customerCustomFields: list[dict[str, Any]] = Field(default_factory=list)


def add_checkout_session_to_db(
    checkout_session_id: str,
    account: str,
    stripe_id: str,
    stripe_mode: str,
    booking_id: str,
    total_amount_cents: int,
    commission: int,
) -> None:
    firestore.client().document(f"checkoutSessions/{checkout_session_id}").set(
        {
            "checkoutSessionId": checkout_session_id,
            "stripeMode": stripe_mode,
            "account": account,
            "stripeId": stripe_id,
            "bookingId": booking_id,
            "createdAt": datetime.now(),
            "webhookProcessed": False,
            "total": total_amount_cents,
            "commission": commission,
        }
    )


def _transaction_snapshot(transaction, doc_ref):
    result = transaction.get(doc_ref)
    if hasattr(result, "exists"):
        return result
    return next(iter(result), None)


def _claim_payment(session_ref, booking_ref, session_updates: dict) -> bool:
    """Atomically mark the session processed and the booking paid.

    Returns False if another webhook delivery already did it, so concurrent
    duplicate deliveries can't both send emails / generate invoices."""
    db = firestore.client()
    transaction = db.transaction()

    @firestore.transactional
    def claim(transaction) -> bool:
        snapshot = _transaction_snapshot(transaction, session_ref)
        data = (snapshot.to_dict() if snapshot is not None else None) or {}
        if data.get("webhookProcessed"):
            return False
        transaction.update(
            session_ref,
            {
                **session_updates,
                "webhookProcessed": True,
                "confirmationEmail": "pending",
            },
        )
        transaction.update(booking_ref, {"paymentStatus": "paid"})
        return True

    return claim(transaction)


def _claim_confirmation_email(session_ref) -> bool:
    """Atomically move confirmationEmail from "pending" to "sending".

    Sessions processed before this flag existed have no value: treat them as
    already emailed."""
    db = firestore.client()
    transaction = db.transaction()

    @firestore.transactional
    def claim(transaction) -> bool:
        snapshot = _transaction_snapshot(transaction, session_ref)
        data = (snapshot.to_dict() if snapshot is not None else None) or {}
        if data.get("confirmationEmail") != "pending":
            return False
        transaction.update(session_ref, {"confirmationEmail": "sending"})
        return True

    return claim(transaction)


def payment_processed(
    checkout_session_id: str,
    stripe_account: str,
    stripe_api_key: str,
    payment_intent_id: str,
    stripe_email: str | None,
    post_payment_callback=None,
) -> None:
    """Mark the booking paid and send the customer confirmation email.

    Safe under Stripe's at-least-once delivery: the payment and the email are
    each claimed in a transaction. If the email fails, the claim is released
    and the error re-raised so Stripe retries the webhook and only the email
    is attempted again."""
    db = firestore.client()
    doc_ref = db.document(f"checkoutSessions/{checkout_session_id}")
    data = doc_ref.get().to_dict()
    if data is None:
        raise Exception("Couldn't find db")
    checkout_session = CheckoutSession.model_validate(data)
    account = checkout_session.account
    if checkout_session.webhookProcessed and data.get("confirmationEmail") != "pending":
        print(f"Payment {checkout_session_id} already processed, skipping")
        return
    booking_path = f"accounts/{account}/data/bookingManager/bookings/{checkout_session.bookingId}"
    booking_ref = db.document(booking_path)
    data = booking_ref.get().to_dict()
    if data is None:
        raise Exception("Couldn't find booking")
    booking = Booking.model_validate(data)
    cg_data = db.document(
        f"accounts/{account}/data/bookingManager/customerGroups/{booking.customerGroupId}"
    ).get().to_dict()
    cg = CustomerGroup.model_validate(cg_data)
    payment_receipt_url = get_payment_receipt_url(
        stripe_id=stripe_account,
        checkout_session_id=checkout_session_id,
        stripe_api_key=stripe_api_key,
    )
    receipt_url = payment_receipt_url["url"]
    total = payment_receipt_url["total"]
    booking_info = get_booking_info(account=account)
    customers = get_customers(account=account, booking_id=booking.id)

    if not checkout_session.webhookProcessed:
        claimed = _claim_payment(
            doc_ref,
            booking_ref,
            {
                "paymentIntentId": payment_intent_id,
                "stripeEmail": stripe_email,
                "total": total,
            },
        )
        if claimed and post_payment_callback is not None:
            post_payment_callback(
                db=firestore.client(),
                account=account,
                booking_id=booking.id,
            )

    if not _claim_confirmation_email(doc_ref):
        return
    try:
        send_postmark_email(
            account=account,
            kennel_name=booking_info.name,
            booking_date=cg.datetime,
            timezone=booking_info.timezone,
            total_amount=total,
            currency="€",
            receipt_url=receipt_url,
            kennel_url=booking_info.url,
            receiver_email=booking.email,
            sender_email=booking_info.email,
            cancellation_policy=booking_info.cancellationPolicy,
            booking_other_info=build_booking_other_info_html(
                booking.model_dump(),
                booking_info.bookingCustomFields,
            ),
            customers_other_info=build_customers_other_info_html(
                [customer.model_dump() for customer in customers],
                booking_info.customerCustomFields,
            ),
        )
    except Exception:
        doc_ref.update({"confirmationEmail": "pending"})
        raise
    doc_ref.update({"confirmationEmail": "sent"})


def _waiting_booking_ref_for_session(checkout_session_id: str):
    """Booking ref for a checkout session, or None if it isn't waiting anymore."""
    db = firestore.client()
    session = db.document(f"checkoutSessions/{checkout_session_id}").get().to_dict()
    if not session:
        return None
    booking_ref = db.document(
        f"accounts/{session['account']}/data/bookingManager/bookings/{session['bookingId']}"
    )
    booking = booking_ref.get().to_dict()
    if not booking or booking.get("paymentStatus") != "waiting":
        return None
    return booking_ref


def payment_pending(checkout_session_id: str) -> None:
    """Checkout completed with a delayed method (e.g. SEPA debit): no money
    yet. Keep the booking "waiting" but hold the seat until Stripe reports
    async_payment_succeeded / async_payment_failed."""
    booking_ref = _waiting_booking_ref_for_session(checkout_session_id)
    if booking_ref is not None:
        booking_ref.update({"expiresAt": None})


def payment_failed(checkout_session_id: str) -> None:
    """Delayed payment failed: expire the waiting booking to free the seat."""
    booking_ref = _waiting_booking_ref_for_session(checkout_session_id)
    if booking_ref is not None:
        booking_ref.update({"expiresAt": datetime.now(ZoneInfo("UTC"))})


def send_postmark_email(
    account: str,
    kennel_name: str,
    booking_date: datetime,
    timezone: str,
    total_amount: int,
    currency: str,
    receipt_url: str,
    kennel_url: str,
    receiver_email: str,
    sender_email: str,
    cancellation_policy: str,
    booking_other_info: str = "",
    customers_other_info: str = "",
) -> None:
    authorization = os.getenv("ZEPTOMAIL_AUTHORIZATION")
    if authorization is None:
        raise Exception("No ZeptoMail authorization token set in env")
    local_dt = booking_date.astimezone(ZoneInfo(timezone))
    booking_date_string = local_dt.strftime("%B %-d, %Y at %H:%M")
    picture_url = f"https://firebasestorage.googleapis.com/v0/b/mush-on.firebasestorage.app/o/accounts%2F{account}%2FbookingManager%2Fbanner?alt=media"
    url = "https://api.zeptomail.eu/v1.1/email/template"
    body = {
        "template_key": "13ef.6aad5fef53bb6a8.k1.c71e9720-30e9-11f1-96bc-66e0c45c7bae.19d5d960192",
        "from": {"address": "noreply@mush-on.com", "name": kennel_name},
        "to": [{"email_address": {"address": receiver_email, "name": ""}}],
        "reply_to": [{"address": sender_email}],
        "merge_info": {
            "kennel_header_picture_url": picture_url,
            "kennel_name": kennel_name,
            "cancellation_policy": cancellation_policy,
            "booking_date": booking_date_string,
            "total_amount_number": str(total_amount / 100.0),
            "total_amout_currency": currency,
            "receipt_url": receipt_url,
            "kennel_url": kennel_url,
            "booking_other_info": booking_other_info,
            "customers_other_info": customers_other_info,
        },
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": authorization,
    }
    try:
        response = requests.post(url, headers=headers, json=body)
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        print(f"HTTP error sending email via ZeptoMail: {e}")
        print(f"Response body: {response.text}")
        raise e
    except Exception as e:
        print(f"Error sending email via ZeptoMail: {e}")
        raise e


def get_booking_info(account: str) -> BookingInfo:
    path = f"accounts/{account}/data/bookingManager"
    print(f"Getting from: {path}")
    db = firestore.client()
    doc = db.document(path).get()
    data = doc.to_dict()
    print(str(data))
    return BookingInfo.model_validate(data)


def get_customers(account: str, booking_id: str) -> list[Customer]:
    db = firestore.client()
    customers_ref = (
        db.document(f"accounts/{account}/data/bookingManager")
        .collection("customers")
        .where("bookingId", "==", booking_id)
    )
    customers: list[Customer] = []
    for doc in customers_ref.stream():
        data = doc.to_dict()
        if data is not None:
            customers.append(Customer.model_validate(data))
    return customers
