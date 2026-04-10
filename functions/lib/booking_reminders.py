import logging
import os
from datetime import date, datetime, timedelta, timezone
from zoneinfo import ZoneInfo

import requests
from firebase_admin import firestore

from lib.stripe.get_payment_receipt_url import get_payment_receipt_url


def send_booking_reminders() -> None:
    """Check all accounts and send reminder emails for bookings that match reminder rules."""
    db = firestore.client()
    today = datetime.now(timezone.utc).date()

    accounts = [doc.id for doc in db.collection("accounts").stream()]
    for account in accounts:
        try:
            _process_account(db, account, today)
        except Exception as e:
            logging.error(f"Error processing reminders for account {account}: {e}")


def _process_account(db, account: str, today: date) -> None:
    bm_doc = db.document(f"accounts/{account}/data/bookingManager").get()
    if not bm_doc.exists:
        return

    bm_data = bm_doc.to_dict()
    reminders = bm_data.get("bookingReminders", [])
    if not reminders:
        return

    kennel_name = bm_data.get("name", "")
    kennel_url = bm_data.get("url", "")
    kennel_timezone = bm_data.get("timezone", "Europe/Helsinki")
    picture_url = (
        f"https://firebasestorage.googleapis.com/v0/b/mush-on.firebasestorage.app"
        f"/o/accounts%2F{account}%2FbookingManager%2Fbanner?alt=media"
    )

    for reminder in reminders:
        days_before = reminder.get("daysBefore", 0)
        target_date = today + timedelta(days=days_before)
        _process_reminder(
            db, account, target_date, kennel_name, kennel_url, kennel_timezone, picture_url
        )


def _process_reminder(
    db,
    account: str,
    target_date: date,
    kennel_name: str,
    kennel_url: str,
    kennel_timezone: str,
    picture_url: str,
) -> None:
    start_dt = datetime(
        target_date.year, target_date.month, target_date.day, tzinfo=timezone.utc
    )
    end_dt = start_dt + timedelta(days=1)

    cg_collection = db.document(f"accounts/{account}/data/bookingManager").collection(
        "customerGroups"
    )
    customer_groups = list(
        cg_collection.where("datetime", ">=", start_dt)
        .where("datetime", "<", end_dt)
        .stream()
    )

    for cg_doc in customer_groups:
        cg_data = cg_doc.to_dict()
        cg_id = cg_doc.id

        raw_dt = cg_data.get("datetime")
        if isinstance(raw_dt, datetime):
            local_dt = raw_dt.astimezone(ZoneInfo(kennel_timezone))
            booking_date_str = local_dt.strftime("%B %-d, %Y at %H:%M")
        else:
            booking_date_str = str(raw_dt)

        bookings_ref = (
            db.document(f"accounts/{account}/data/bookingManager")
            .collection("bookings")
            .where("customerGroupId", "==", cg_id)
        )
        for booking_doc in bookings_ref.stream():
            booking_data = booking_doc.to_dict()
            booking_id = booking_doc.id

            if booking_data.get("paymentStatus") not in ["paid", "deferredPayment"]:
                continue

            booking_email = booking_data.get("email")
            if not booking_email:
                continue

            booking_name = booking_data.get("name", "")

            receipt_url = _get_receipt_url(db, booking_id)

            try:
                _send_reminder_email(
                    to_email=booking_email,
                    to_name=booking_name,
                    kennel_name=kennel_name,
                    receipt_url=receipt_url,
                    booking_date=booking_date_str,
                    kennel_url=kennel_url,
                    kennel_header_picture_url=picture_url,
                )
                logging.info(
                    f"Sent reminder email for booking {booking_id} to {booking_email}"
                )
            except Exception as e:
                logging.error(
                    f"Failed to send reminder email for booking {booking_id}: {e}"
                )


def _get_receipt_url(db, booking_id: str) -> str:
    try:
        checkout_docs = list(
            db.collection("checkoutSessions")
            .where("bookingId", "==", booking_id)
            .stream()
        )
        if not checkout_docs:
            return ""
        checkout_data = checkout_docs[0].to_dict()
        result = get_payment_receipt_url(
            checkout_data["stripeId"],
            checkout_data["checkoutSessionId"],
            os.getenv("STRIPE_KEY"),
        )
        return result.get("url", "")
    except Exception as e:
        logging.warning(f"Couldn't get receipt URL for booking {booking_id}: {e}")
        return ""


def _send_reminder_email(
    to_email: str,
    to_name: str,
    kennel_name: str,
    receipt_url: str,
    booking_date: str,
    kennel_url: str,
    kennel_header_picture_url: str,
) -> None:
    authorization = os.getenv("ZEPTOMAIL_AUTHORIZATION")
    payload = {
        "template_key": "13ef.6aad5fef53bb6a8.k1.7feb8ce0-30ea-11f1-96bc-66e0c45c7bae.19d5d9abcae",
        "from": {"address": "noreply@mush-on.com", "name": "noreply"},
        "to": [{"email_address": {"address": to_email, "name": to_name}}],
        "merge_info": {
            "kennel_name": kennel_name,
            "receipt_url": receipt_url,
            "booking_date": booking_date,
            "kennel_url": kennel_url,
            "kennel_header_picture_url": kennel_header_picture_url,
        },
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": authorization,
    }
    response = requests.post(
        "https://api.zeptomail.eu/v1.1/email/template", json=payload, headers=headers
    )
    response.raise_for_status()
