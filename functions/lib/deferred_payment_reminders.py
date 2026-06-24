"""Payment-due reminders for deferred bookings.

Separate from trip reminders (`booking_reminders.py`):
- Only for bookings with paymentStatus == "deferredPayment".
- Recipient is always the PARTNER email.
- Fires the day before the balance is due (tour date − deferredDays − 1 day).
"""

import logging
from datetime import date, datetime, timedelta, timezone

from firebase_admin import firestore

from lib.deferred_payment_email import send_deferred_payment_email_for_booking


def _deferred_payment_due_date(tour_date: date, deferred_days: int) -> date:
    return tour_date - timedelta(days=deferred_days)


def _should_send_deferred_reminder(due_date: date, today: date) -> bool:
    # send exactly one day before the balance is due
    return today == due_date - timedelta(days=1)


def send_deferred_payment_reminders() -> None:
    db = firestore.client()
    today = datetime.now(timezone.utc).date()
    accounts = [doc.id for doc in db.collection("accounts").stream()]
    for account in accounts:
        try:
            _process_account(db, account, today)
        except Exception as e:
            logging.error(
                f"Error processing deferred payment reminders for {account}: {e}"
            )


def _process_account(db, account: str, today: date) -> None:
    bm_ref = db.document(f"accounts/{account}/data/bookingManager")
    bookings = (
        bm_ref.collection("bookings")
        .where("paymentStatus", "==", "deferredPayment")
        .stream()
    )
    for booking_doc in bookings:
        booking = booking_doc.to_dict() or {}
        booking_id = booking.get("id") or booking_doc.id
        partner_id = booking.get("partner")
        if not partner_id:
            continue
        partner = (
            bm_ref.collection("partners").document(partner_id).get().to_dict() or {}
        )
        customer_group = (
            bm_ref.collection("customerGroups")
            .document(booking.get("customerGroupId"))
            .get()
            .to_dict()
            or {}
        )
        tour_dt = customer_group.get("datetime")
        if not isinstance(tour_dt, datetime):
            continue
        deferred_days = int(partner.get("deferredDays") or 0)
        due = _deferred_payment_due_date(tour_dt.date(), deferred_days)
        if not _should_send_deferred_reminder(due, today):
            continue
        try:
            send_deferred_payment_email_for_booking(
                db=db, account=account, booking_id=booking_id
            )
        except Exception as e:
            logging.error(
                f"Failed to send deferred payment reminder for {booking_id}: {e}"
            )
