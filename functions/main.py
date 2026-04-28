# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn, scheduler_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app, firestore
from flask import json
import stripe
from lib.add_booking import add_checkout_session
from dotenv import load_dotenv
import os
import asyncio
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from firebase_functions import https_fn
from firebase_admin import firestore
from concurrent.futures import ThreadPoolExecutor
from typing import List, Dict, Any
from lib.booking_reminders import send_booking_reminders
from lib.send_invitation_email import SendInvitationEmail
from lib.stripe.get_payment_receipt_url import get_payment_receipt_url
from lib.stripe.utils import get_stripe_data
from lib.team_groups import rebuild_teamgroup_snapshot
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


def _callable_safe_firestore_data(value):
    if isinstance(value, datetime):
        return {"_millisecondsSinceEpoch": int(value.timestamp() * 1000)}
    if isinstance(value, dict):
        return {k: _callable_safe_firestore_data(v) for k, v in value.items()}
    if isinstance(value, list):
        return [_callable_safe_firestore_data(v) for v in value]
    return value


def _chunks(values, size=25):
    for i in range(0, len(values), size):
        yield values[i : i + size]


def _booking_manager_ref(db, account: str):
    return db.document(f"accounts/{account}/data/bookingManager")


def _booking_manager_collection_path(account: str, collection: str) -> str:
    return f"accounts/{account}/data/bookingManager/{collection}"


def _get_required_document(db, path: str, label: str) -> dict:
    data = db.document(path).get().to_dict()
    if data is None:
        raise ValueError(f"{label} not found")
    return data


def _get_booking_customers(db, account: str, booking_id: str) -> list[dict]:
    return [
        snapshot.to_dict() or {}
        for snapshot in db.collection(
            _booking_manager_collection_path(account, "customers")
        )
        .where("bookingId", "==", booking_id)
        .stream()
    ]


def _get_query_snapshots(source, query):
    if source is not None and hasattr(source, "get"):
        return list(source.get(query))
    return list(query.stream())


def _get_document_snapshot(source, doc_ref):
    if source is not None and hasattr(source, "get"):
        result = source.get(doc_ref)
        if hasattr(result, "exists"):
            return result
        return next(iter(result), None)
    return doc_ref.get()


def _parse_firestore_datetime(value):
    if value is None:
        return None
    if isinstance(value, datetime):
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)
        return value
    return None


def _booking_counts_for_capacity(booking: dict, now: datetime) -> bool:
    status = booking.get("paymentStatus")
    if status in {"paid", "deferredPayment"}:
        return True
    if status != "waiting":
        return False
    expires_at = _parse_firestore_datetime(booking.get("expiresAt"))
    return expires_at is None or expires_at > now


def _count_reserved_customers_for_group(
    db, account: str, customer_group_id: str, now: datetime, transaction=None
) -> int:
    bm_ref = _booking_manager_ref(db, account)
    booking_query = (
        bm_ref.collection("bookings")
        .where("customerGroupId", "==", customer_group_id)
    )
    reserved = 0
    for booking_doc in _get_query_snapshots(transaction, booking_query):
        booking = booking_doc.to_dict() or {}
        if not _booking_counts_for_capacity(booking, now):
            continue
        booking_id = booking.get("id") or getattr(booking_doc, "id", None)
        if not booking_id:
            continue
        customer_query = bm_ref.collection("customers").where(
            "bookingId", "==", booking_id
        )
        reserved += len(_get_query_snapshots(transaction, customer_query))
    return reserved


def _quantity_by_pricing(customers: list[dict]) -> dict[str, int]:
    quantities: dict[str, int] = {}
    for customer in customers:
        pricing_id = customer.get("pricingId")
        if not pricing_id:
            raise ValueError("Customer pricing is missing")
        quantities[pricing_id] = quantities.get(pricing_id, 0) + 1
    return quantities


def _get_active_prices_by_id(db, account: str, tour_id: str) -> dict[str, dict]:
    price_docs = (
        db.collection(
            f"{_booking_manager_collection_path(account, 'tours')}/{tour_id}/prices"
        )
        .where("isArchived", "==", False)
        .stream()
    )
    return {
        (price_data.get("id") or ""): price_data
        for price_data in [doc.to_dict() or {} for doc in price_docs]
        if price_data.get("id")
    }


def _build_checkout_line_items(
    prices_by_id: dict[str, dict], quantities_by_pricing: dict[str, int]
) -> tuple[list[dict], int]:
    line_items = []
    total_amount_cents = 0
    for pricing_id, quantity in quantities_by_pricing.items():
        if quantity <= 0:
            raise ValueError("Pricing quantity must be positive")
        pricing = prices_by_id.get(pricing_id)
        if pricing is None:
            raise ValueError(f"Active pricing not found: {pricing_id}")
        unit_amount = int(_unwrap_int64_wrappers(pricing.get("priceCents", 0)))
        total_amount_cents += unit_amount * quantity
        line_item = {
            "price_data": {
                "tax_behavior": "inclusive",
                "currency": "eur",
                "product_data": {
                    "name": pricing.get("displayName") or pricing.get("name") or "Ticket",
                    "metadata": {"pricing_id": pricing_id},
                },
                "unit_amount": unit_amount,
            },
            "quantity": quantity,
        }
        tax_rate_id = pricing.get("stripeTaxRateId")
        if tax_rate_id:
            line_item["tax_rates"] = [tax_rate_id]
        line_items.append(line_item)
    if not line_items:
        raise ValueError("No pricing selections found")
    return line_items, total_amount_cents


def _calculate_platform_fee(total_amount_cents: int, kennel_info: dict) -> int:
    commission_rate = Decimal(str(kennel_info.get("commissionRate", 0.035)))
    vat_multiplier = Decimal("1") + Decimal(str(kennel_info.get("vatRate", 0)))
    return int(Decimal(total_amount_cents) * commission_rate * vat_multiplier)


def _build_server_checkout_payload(
    db, account: str, booking_id: str, tour_id: str, customer_group_id: str
) -> dict:
    booking = _get_required_document(
        db,
        f"{_booking_manager_collection_path(account, 'bookings')}/{booking_id}",
        "Booking",
    )
    if booking.get("customerGroupId") != customer_group_id:
        raise ValueError("Booking does not belong to the requested customer group")

    customer_group = _get_required_document(
        db,
        f"{_booking_manager_collection_path(account, 'customerGroups')}/{customer_group_id}",
        "Customer group",
    )
    if customer_group.get("tourTypeId") != tour_id:
        raise ValueError("Customer group does not belong to the requested tour")

    customers = _get_booking_customers(db, account, booking_id)
    quantities_by_pricing = _quantity_by_pricing(customers)
    selected_capacity = sum(quantities_by_pricing.values())
    max_capacity = int(_unwrap_int64_wrappers(customer_group.get("maxCapacity", 0)))
    if max_capacity > 0 and selected_capacity > max_capacity:
        raise ValueError("Selected quantity exceeds customer group capacity")

    prices_by_id = _get_active_prices_by_id(db, account, tour_id)
    line_items, total_amount_cents = _build_checkout_line_items(
        prices_by_id, quantities_by_pricing
    )
    kennel_info = _get_required_document(
        db, f"accounts/{account}/data/bookingManager", "Booking manager settings"
    )
    fee_amount = _calculate_platform_fee(total_amount_cents, kennel_info)
    return {
        "line_items": line_items,
        "total_amount_cents": total_amount_cents,
        "fee_amount": fee_amount,
    }


def _booking_label(booking: dict, customers: list[dict]) -> str:
    name = str(booking.get("name") or "").strip()
    if name:
        return name
    for customer in customers:
        customer_name = str(customer.get("name") or "").strip()
        if customer_name:
            return customer_name
        for value in (customer.get("customerOtherInfo") or {}).values():
            other_value = str(value or "").strip()
            if other_value:
                return other_value
    return "Booking"


def _reserve_booking_transaction(
    db,
    account: str,
    tour_id: str,
    booking: dict,
    customers: list[dict],
    now: datetime,
) -> dict:
    booking_id = booking.get("id")
    customer_group_id = booking.get("customerGroupId")
    if not booking_id or not customer_group_id:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Booking id and customerGroupId are required",
        )
    if not customers:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "At least one customer is required",
        )

    transaction = db.transaction()

    @firestore.transactional
    def reserve(transaction):
        bm_ref = _booking_manager_ref(db, account)
        customer_group_ref = bm_ref.collection("customerGroups").document(
            customer_group_id
        )
        customer_group_snapshot = _get_document_snapshot(
            transaction, customer_group_ref
        )
        if not customer_group_snapshot.exists:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.NOT_FOUND, "Customer group not found"
            )
        customer_group = customer_group_snapshot.to_dict() or {}
        if customer_group.get("tourTypeId") != tour_id:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "Customer group does not belong to the requested tour",
            )

        requested_capacity = len(customers)
        max_capacity = int(_unwrap_int64_wrappers(customer_group.get("maxCapacity", 0)))
        reserved_capacity = _count_reserved_customers_for_group(
            db, account, customer_group_id, now, transaction
        )
        if (
            max_capacity > 0
            and reserved_capacity + requested_capacity > max_capacity
        ):
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "This group is now full",
            )

        expires_at = now + timedelta(minutes=30)
        booking_ref = bm_ref.collection("bookings").document(booking_id)
        booking_data = {
            **booking,
            "id": booking_id,
            "customerGroupId": customer_group_id,
            "name": _booking_label(booking, customers),
            "paymentStatus": "waiting",
            "createdAt": now,
            "expiresAt": expires_at,
        }
        transaction.set(booking_ref, booking_data)
        for customer in customers:
            customer_id = customer.get("id")
            pricing_id = customer.get("pricingId")
            if not customer_id or not pricing_id:
                raise https_fn.HttpsError(
                    https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                    "Customer id and pricingId are required",
                )
            customer_ref = bm_ref.collection("customers").document(customer_id)
            transaction.set(customer_ref, {**customer, "bookingId": booking_id})
        return {
            "bookingId": booking_id,
            "customerGroupId": customer_group_id,
            "expiresAt": expires_at,
        }

    return reserve(transaction)


def _assert_account_member(req: https_fn.CallableRequest[dict], account: str) -> None:
    if req.auth is None:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            "Authentication is required",
        )
    uid = req.auth.uid
    user_doc = firestore.client().document(f"users/{uid}").get()
    user_data = user_doc.to_dict()
    if user_data is None or user_data.get("account") != account:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "User does not belong to this account",
        )


@https_fn.on_call()
def add_booking(req: https_fn.CallableRequest[dict]) -> dict:
    raise https_fn.HttpsError(
        https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        "Legacy add_booking is disabled. Use create_booking_checkout_session.",
    )


@https_fn.on_call()
def stripe_create_account(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data or {}
        account_id = data.get("account")
        if not account_id:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "Missing account",
            )
        _assert_account_member(req, account_id)
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
        firestore.client().document(
            f"accounts/{account_id}/integrations/stripe"
        ).set({"accountId": account.id})
        return {"account": account.id}
    except https_fn.HttpsError:
        raise
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def stripe_create_account_link(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        account = req.data.get("account")
        if account is None:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "Missing account",
            )
        _assert_account_member(req, account)
        stripe_data = get_stripe_data(account)
        connected_account_id = stripe_data.get("accountId")
        if not connected_account_id:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Stripe integration is missing accountId",
            )
        account_link = stripe.AccountLink.create(
            account=connected_account_id,
            return_url=f"https://mush-on.web.app/stripe_connection?kennel={account}&result=success",
            refresh_url=f"https://mush-on.web.app/stripe_connection?kennel={account}&result=failed",
            type="account_onboarding",
        )
        return {"url": account_link.url}
    except https_fn.HttpsError:
        raise
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def change_stripe_integration_activation(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        account = data["account"]
        is_active = data["isActive"]
        if account is None or is_active is None:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "account or isActive is null",
            )
        _assert_account_member(req, account)
        db = firestore.client()
        ref = db.document(f"accounts/{account}/integrations/stripe")
        ref.update({"isActive": is_active})
        return {}
    except https_fn.HttpsError:
        raise
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def get_stripe_integration_data(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        account = data["account"]
        if account is None:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "account is null",
            )
        _assert_account_member(req, account)
        return get_stripe_data(account)
    except https_fn.HttpsError:
        raise
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def get_public_stripe_status(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data or {}
    account = data.get("account")
    if not account:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Missing account",
        )
    stripe_doc = (
        firestore.client().document(f"accounts/{account}/integrations/stripe").get()
    )
    stripe_data = stripe_doc.to_dict() or {}
    return {"isActive": bool(stripe_data.get("isActive"))}


@https_fn.on_call()
def get_public_booking_counts(req: https_fn.CallableRequest[dict]) -> dict:
    """Return aggregate booked passenger counts for public availability UI."""
    data = req.data or {}
    account = data.get("account")
    customer_group_ids = data.get("customerGroupIds") or []
    if not account or not isinstance(customer_group_ids, list):
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Missing account or customerGroupIds",
        )

    customer_group_ids = [
        str(cg_id) for cg_id in customer_group_ids if str(cg_id).strip()
    ]
    if not customer_group_ids:
        return {"counts": {}}

    db = firestore.client()
    bm_ref = _booking_manager_ref(db, account)
    counts = {cg_id: 0 for cg_id in customer_group_ids}
    now = datetime.now(timezone.utc)

    for cg_ids in _chunks(customer_group_ids):
        booking_docs = (
            bm_ref.collection("bookings")
            .where("customerGroupId", "in", cg_ids)
            .stream()
        )
        for booking_doc in booking_docs:
            booking = booking_doc.to_dict() or {}
            if not _booking_counts_for_capacity(booking, now):
                continue
            booking_id = booking.get("id") or booking_doc.id
            customer_docs = (
                bm_ref.collection("customers")
                .where("bookingId", "==", booking_id)
                .stream()
            )
            customer_group_id = booking.get("customerGroupId")
            if customer_group_id in counts:
                counts[customer_group_id] += sum(1 for _ in customer_docs)

    return {"counts": counts}


@https_fn.on_call()
def get_booking_success_data(req: https_fn.CallableRequest[dict]) -> dict:
    """Return only the data needed to render one customer booking success page."""
    data = req.data or {}
    account = data.get("account")
    booking_id = data.get("bookingId")
    if not account or not booking_id:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Missing account or bookingId",
        )

    db = firestore.client()
    checkout_docs = (
        db.collection("checkoutSessions")
        .where("bookingId", "==", booking_id)
        .limit(1)
        .stream()
    )
    checkout_doc = next(checkout_docs, None)
    if (
        checkout_doc is not None
        and (checkout_doc.to_dict() or {}).get("account") != account
    ):
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Checkout session does not belong to this account",
        )

    bm_ref = _booking_manager_ref(db, account)
    booking_doc = bm_ref.collection("bookings").document(booking_id).get()
    if not booking_doc.exists:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.NOT_FOUND, "Booking not found"
        )

    booking = booking_doc.to_dict() or {}
    customer_docs = (
        bm_ref.collection("customers").where("bookingId", "==", booking_id).stream()
    )
    customers = [doc.to_dict() or {} for doc in customer_docs]

    customer_group_id = booking.get("customerGroupId")
    cg_doc = bm_ref.collection("customerGroups").document(customer_group_id).get()
    if not cg_doc.exists:
        cg_docs = (
            bm_ref.collection("customerGroups")
            .where("id", "==", customer_group_id)
            .limit(1)
            .stream()
        )
        cg_doc = next(cg_docs, None)
    if cg_doc is None or not cg_doc.exists:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.NOT_FOUND, "Customer group not found"
        )

    customer_group = cg_doc.to_dict() or {}
    tour_type_id = customer_group.get("tourTypeId")
    prices = []
    if tour_type_id:
        price_docs = (
            bm_ref.collection("tours")
            .document(tour_type_id)
            .collection("prices")
            .where("isArchived", "==", False)
            .stream()
        )
        prices = [doc.to_dict() or {} for doc in price_docs]

    return _callable_safe_firestore_data(
        {
            "booking": booking,
            "customers": customers,
            "customerGroup": customer_group,
            "pricings": prices,
        }
    )


@https_fn.on_call()
def create_checkout_session(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data or {}
        account = data.get("account")
        booking_id = data.get("bookingId")
        tour_id = data.get("tourId")
        customer_group_id = data.get("customerGroupId")

        if not account or not booking_id or not tour_id or not customer_group_id:
            return {"error": "account, bookingId, tourId or customerGroupId is null"}

        stripe_data = get_stripe_data(account)
        stripe_account_id = stripe_data.get("accountId")
        if not stripe_data.get("isActive") or not stripe_account_id:
            return {"error": "Stripe integration is not active"}

        checkout_payload = _build_server_checkout_payload(
            firestore.client(), account, booking_id, tour_id, customer_group_id
        )

        session = stripe.checkout.Session.create(
            line_items=checkout_payload["line_items"],
            client_reference_id=booking_id,
            payment_intent_data={
                "application_fee_amount": checkout_payload["fee_amount"]
            },
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
            checkout_payload["total_amount_cents"],
            checkout_payload["fee_amount"],
        )

        return {"url": session.url}
    except Exception as e:
        return {"error": str(e)}


@https_fn.on_call()
def create_booking_checkout_session(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data or {}
        account = data.get("account")
        tour_id = data.get("tourId")
        booking = _unwrap_int64_wrappers(data.get("booking") or {})
        customers = _unwrap_int64_wrappers(data.get("customers") or [])

        if not account or not tour_id or not isinstance(customers, list):
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "Missing account, tourId, booking or customers",
            )

        stripe_data = get_stripe_data(account)
        stripe_account_id = stripe_data.get("accountId")
        if not stripe_data.get("isActive") or not stripe_account_id:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Stripe integration is not active",
            )

        db = firestore.client()
        now = datetime.now(timezone.utc)
        reservation = _reserve_booking_transaction(
            db=db,
            account=account,
            tour_id=tour_id,
            booking=booking,
            customers=customers,
            now=now,
        )
        booking_id = reservation["bookingId"]
        customer_group_id = reservation["customerGroupId"]

        checkout_payload = _build_server_checkout_payload(
            db, account, booking_id, tour_id, customer_group_id
        )

        session = stripe.checkout.Session.create(
            line_items=checkout_payload["line_items"],
            client_reference_id=booking_id,
            payment_intent_data={
                "application_fee_amount": checkout_payload["fee_amount"]
            },
            mode="payment",
            success_url=f"https://mush-on.web.app/booking_success?bookingId={booking_id}&account={account}",
            stripe_account=stripe_account_id,
        )
        checkout_session_id = session.id
        if checkout_session_id is None:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.INTERNAL,
                f"Checkout session is None. Session: {session}",
            )

        add_checkout_session.add_checkout_session_to_db(
            checkout_session_id,
            account,
            stripe_account_id,
            booking_id,
            checkout_payload["total_amount_cents"],
            checkout_payload["fee_amount"],
        )
        db.document(
            f"{_booking_manager_collection_path(account, 'bookings')}/{booking_id}"
        ).update({"checkoutSessionId": checkout_session_id})

        return {
            "url": session.url,
            "bookingId": booking_id,
            "checkoutSessionId": checkout_session_id,
        }
    except https_fn.HttpsError:
        raise
    except Exception as e:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INTERNAL, str(e))


@https_fn.on_call()
def create_stripe_tax_rate(req: https_fn.CallableRequest[dict]) -> dict:
    try:
        data = req.data
        account = data["account"]
        _assert_account_member(req, account)
        stripe_data = get_stripe_data(account)
        stripe_account_id = stripe_data.get("accountId")
        if not stripe_account_id:
            raise https_fn.HttpsError(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Stripe integration is missing accountId",
            )
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
    except https_fn.HttpsError:
        raise
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
    account = data.get("account")
    db = firestore.client()
    ref = db.collection("checkoutSessions").where("bookingId", "==", booking_id)
    docs = ref.stream()
    first_doc = next(docs, None)
    if first_doc is None:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.NOT_FOUND, "No checkout session found"
        )
    data = first_doc.to_dict()
    if account is not None and data.get("account") != account:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Checkout session does not belong to this account",
        )
    return get_payment_receipt_url(
        data["stripeId"], data["checkoutSessionId"], os.getenv("STRIPE_KEY")
    )


@https_fn.on_call()
def refund_payment(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data or {}
    account = data.get("account")
    booking_id = data.get("bookingId")
    if not account or not booking_id:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Missing account or bookingId",
        )
    _assert_account_member(req, account)

    db = firestore.client()
    checkout_docs = (
        db.collection("checkoutSessions")
        .where("bookingId", "==", booking_id)
        .where("account", "==", account)
        .limit(1)
        .stream()
    )
    checkout_doc = next(checkout_docs, None)
    if checkout_doc is None:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "No checkout session found for this booking",
        )
    checkout_data = checkout_doc.to_dict() or {}
    existing_refund_id = checkout_data.get("refundId")
    if existing_refund_id:
        return {
            "refundId": existing_refund_id,
            "refundStatus": checkout_data.get("refundStatus"),
        }

    booking_ref = db.document(
        f"accounts/{account}/data/bookingManager/bookings/{booking_id}"
    )
    booking_data = booking_ref.get().to_dict() or {}
    if booking_data.get("paymentStatus") == "refunded":
        return {
            "refundId": existing_refund_id,
            "refundStatus": checkout_data.get("refundStatus"),
            "alreadyRefunded": True,
        }

    payment_intent = checkout_data.get("paymentIntentId")
    stripe_account = checkout_data.get("stripeId")
    if not payment_intent or not stripe_account:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Checkout session is missing payment data",
        )

    refund = stripe.Refund.create(
        payment_intent=payment_intent,
        stripe_account=stripe_account,
        refund_application_fee=True,
        idempotency_key=f"refund:{account}:{booking_id}",
    )
    booking_ref.update({"paymentStatus": "refunded"})
    checkout_doc.reference.update(
        {
            "refundId": refund.id,
            "refundStatus": getattr(refund, "status", None),
            "refundedAt": datetime.now(timezone.utc),
            "refundedBy": req.auth.uid,
        }
    )
    return {"refundId": refund.id, "refundStatus": getattr(refund, "status", None)}


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


@https_fn.on_call()
def rebuild_teamgroup_teams_snapshot(req: https_fn.CallableRequest[dict]) -> dict:
    data = req.data or {}
    teamgroup_path = data.get("teamgroupPath")

    if not teamgroup_path:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Missing required field: teamgroupPath",
        )

    try:
        return rebuild_teamgroup_snapshot(teamgroup_path)
    except ValueError as exc:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT, str(exc)
        )
    except Exception as exc:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INTERNAL, str(exc))


# Run once a day at midnight to send booking reminder emails.
# Manually trigger at https://console.cloud.google.com/cloudscheduler
@scheduler_fn.on_schedule(schedule="every day 00:00", region="europe-west1")
def send_daily_booking_reminders(event: scheduler_fn.ScheduledEvent) -> None:
    """Send reminder emails to customers for upcoming bookings based on per-account reminder rules."""
    send_booking_reminders()
