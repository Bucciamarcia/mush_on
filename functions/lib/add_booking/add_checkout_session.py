from firebase_admin import firestore
from pydantic import BaseModel, Field
from datetime import datetime

from lib.stripe.get_payment_receipt_url import get_payment_receipt_url


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
    checkout_session_id: str, account: str, stripe_api_key: str
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
    # Skip if already processed (idempotency)
    if checkout_session.webhookProcessed:
        print(f"Payment {checkout_session_id} already processed, skipping")
        return
    batch = firestore.client().batch()
    batch.update(doc_ref, {"webhookProcessed": True})
    booking_path = f"accounts/{checkout_session.account}/data/bookingManager/bookings/{checkout_session.bookingId}"
    booking_ref = firestore.client().document(booking_path)
    booking_obj = booking_ref.get()
    data = booking_obj.to_dict()
    booking = Booking.model_validate(data)
    if data is None:
        raise Exception("Couldn't find booking")
    batch.update(booking_ref, {"paymentStatus": "paid"})
    batch.commit()
    email = booking.email
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
        stripe_id=account,
        checkout_session_id=checkout_session_id,
        stripe_api_key=stripe_api_key,
    )
    url = payment_receipt_url["url"]
    total = payment_receipt_url["total"]
    # TODO: Add postmark integration
