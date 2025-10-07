from firebase_admin import firestore
from pydantic import BaseModel
from datetime import datetime


class CheckoutSession(BaseModel):
    checkoutSessionId: str
    account: str
    stripeId: str
    bookingId: str
    createdAt: datetime
    webhookProcessed: bool


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


def payment_processed(checkout_session_id: str) -> None:
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
    booking = booking_ref.get()
    data = booking.to_dict()
    if data is None:
        raise Exception("Couldn't find booking")
    email = data["email"]
    batch.update(booking_ref, {"paymentStatus": "paid"})
    batch.commit()
