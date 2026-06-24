"""Deferred-payment email: sends a Stripe pay link to the PARTNER.

Both `create_deferred_booking` and `send_deferred_payment_email` (the on_call
"resend" used by the booking editor) reuse `send_deferred_payment_email_for_booking`.

Per product decision: trip reminders go to the booking email set in the cart;
**payment** emails always go to the partner.
"""

import os
from datetime import date, datetime, timedelta
from urllib.parse import urlencode
from zoneinfo import ZoneInfo

import requests

from lib.booking_email_html import (
    build_booking_other_info_html,
    build_customers_other_info_html,
)

# ⚑ see payment_overhaul.md — replace with the real ZeptoMail template key (or,
# preferably, read it from ZEPTOMAIL_DEFERRED_PAYMENT_TEMPLATE).
DEFERRED_PAYMENT_TEMPLATE_KEY = (
    "13ef.6aad5fef53bb6a8.k1.7879e3d0-6f10-11f1-b0bf-dad70ff08860.19ef4e6528d"
)

_ZEPTOMAIL_URL = "https://api.zeptomail.eu/v1.1/email/template"
_DEFAULT_PAY_BASE_URL = "https://pay-deferred-booking-gauajn5wvq-lz.a.run.app"


def _booking_manager_doc(db, account: str) -> dict:
    return db.document(f"accounts/{account}/data/bookingManager").get().to_dict() or {}


def _get_doc(db, path: str) -> dict:
    return db.document(path).get().to_dict() or {}


def _get_customers(db, account: str, booking_id: str) -> list[dict]:
    customers_ref = (
        db.document(f"accounts/{account}/data/bookingManager")
        .collection("customers")
        .where("bookingId", "==", booking_id)
    )
    return [doc.to_dict() for doc in customers_ref.stream() if doc.to_dict()]


def _format_amount(total_cents) -> str:
    try:
        amount = float(total_cents or 0) / 100.0
    except (TypeError, ValueError):
        amount = 0.0
    return f"€{amount:.2f}"


def _tour_datetime(customer_group: dict) -> datetime | None:
    value = customer_group.get("datetime")
    return value if isinstance(value, datetime) else None


def send_deferred_payment_email_for_booking(
    *, db, account: str, booking_id: str
) -> None:
    bm = _booking_manager_doc(db, account)
    booking = _get_doc(
        db, f"accounts/{account}/data/bookingManager/bookings/{booking_id}"
    )
    if not booking:
        raise Exception(f"Booking {booking_id} not found")

    partner = _get_doc(
        db,
        f"accounts/{account}/data/bookingManager/partners/{booking.get('partner')}",
    )
    partner_email = partner.get("email")
    if not partner_email:
        raise Exception("Partner has no email to send the payment link to")

    customer_group = _get_doc(
        db,
        f"accounts/{account}/data/bookingManager/customerGroups/{booking.get('customerGroupId')}",
    )
    customers = _get_customers(db, account, booking_id)

    timezone = bm.get("timezone", "Europe/Helsinki")
    tour_dt = _tour_datetime(customer_group)
    if tour_dt is not None:
        local_dt = tour_dt.astimezone(ZoneInfo(timezone))
        tour_date_str = local_dt.strftime("%B %-d, %Y at %H:%M")
        deferred_days = int(partner.get("deferredDays") or 0)
        due = (local_dt.date()) - timedelta(days=deferred_days)
        due_date_str = due.strftime("%B %-d, %Y")
    else:
        tour_date_str = ""
        due_date_str = ""

    pay_base_url = os.getenv("PAY_BASE_URL", _DEFAULT_PAY_BASE_URL)
    pay_url = (
        f"{pay_base_url}?{urlencode({'account': account, 'bookingId': booking_id})}"
    )

    picture_url = (
        f"https://firebasestorage.googleapis.com/v0/b/mush-on.firebasestorage.app"
        f"/o/accounts%2F{account}%2FbookingManager%2Fbanner?alt=media"
    )

    merge_info = {
        "partner_name": partner.get("name", ""),
        "kennel_name": bm.get("name", ""),
        "booking_name": booking.get("name", ""),
        "tour_date": tour_date_str,
        "amount": _format_amount(booking.get("totalCents")),
        "pay_url": pay_url,
        "due_date": due_date_str,
        "cancellation_policy": bm.get("cancellationPolicy", ""),
        "kennel_url": bm.get("url", ""),
        "kennel_header_picture_url": picture_url,
        "booking_other_info": build_booking_other_info_html(
            booking, bm.get("bookingCustomFields", [])
        ),
        "customers_other_info": build_customers_other_info_html(
            customers, bm.get("customerCustomFields", [])
        ),
    }

    template_key = (
        os.getenv("ZEPTOMAIL_DEFERRED_PAYMENT_TEMPLATE")
        or DEFERRED_PAYMENT_TEMPLATE_KEY
    )
    authorization = os.getenv("ZEPTOMAIL_AUTHORIZATION")
    payload = {
        "template_key": template_key,
        "from": {"address": "noreply@mush-on.com", "name": bm.get("name", "")},
        "to": [
            {
                "email_address": {
                    "address": partner_email,
                    "name": partner.get("name", ""),
                }
            }
        ],
        "merge_info": merge_info,
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": authorization,
    }
    response = requests.post(_ZEPTOMAIL_URL, json=payload, headers=headers)
    response.raise_for_status()
