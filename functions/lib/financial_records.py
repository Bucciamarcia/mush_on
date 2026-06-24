"""Assemble revenue-bearing records for the financial dashboard.

The dashboard needs commission data, which lives on the server-only
``checkoutSessions`` collection (clients cannot read it per the Firestore
rules). So aggregation runs in a callable; this module holds the pure join
logic so it can be unit tested with the fake Firestore.

Each record joins a booking (status, partner, stored total) with its customer
group (date, tour type) and, for on-platform paid bookings, the matching
checkoutSession (authoritative total + commission).
"""

# Statuses that carry meaning for the financial summary. ``waiting`` / unknown
# bookings have not resolved into anything revenue-bearing and are skipped.
_REVENUE_STATUSES = ("paid", "paidOffPlatform", "deferredPayment", "refunded")


def build_financial_records(*, db, account: str) -> list[dict]:
    """Return a list of record dicts (JSON-serialisable) for ``account``."""
    bm = db.document(f"accounts/{account}/data/bookingManager")

    # customerGroupId -> group dict (for datetime + tourTypeId).
    groups: dict[str, dict] = {}
    for snap in bm.collection("customerGroups").stream():
        data = snap.to_dict() or {}
        groups[data.get("id") or snap.id] = data

    # bookingId -> checkoutSession dict (for total + commission). Only
    # on-platform payments have one.
    sessions_by_booking: dict[str, dict] = {}
    for snap in (
        db.collection("checkoutSessions").where("account", "==", account).stream()
    ):
        data = snap.to_dict() or {}
        booking_id = data.get("bookingId")
        if booking_id:
            sessions_by_booking[booking_id] = data

    records: list[dict] = []
    for snap in bm.collection("bookings").stream():
        booking = snap.to_dict() or {}
        status = booking.get("paymentStatus")
        if status not in _REVENUE_STATUSES:
            continue
        booking_id = booking.get("id") or snap.id
        group = groups.get(booking.get("customerGroupId")) or {}
        session = sessions_by_booking.get(booking_id) or {}

        # Prefer the authoritative checkoutSession total for on-platform paid
        # bookings; fall back to the value mirrored onto the booking otherwise
        # (deferred / off-platform never have a session at this point).
        total = booking.get("totalCents")
        if status == "paid" and session.get("total") is not None:
            total = session.get("total")

        # Commission is only earned on money that flowed through Stripe.
        commission = (
            int(session.get("commission") or 0) if status == "paid" else 0
        )

        records.append(
            {
                "date": _iso(group.get("datetime")),
                "status": status,
                "totalCents": int(total or 0),
                "commissionCents": commission,
                "partner": booking.get("partner"),
                "tourTypeId": group.get("tourTypeId"),
            }
        )
    return records


def _iso(value):
    """Serialise a Firestore timestamp / datetime to an ISO 8601 string."""
    if value is None:
        return None
    isoformat = getattr(value, "isoformat", None)
    if callable(isoformat):
        return isoformat()
    return str(value)
