# Payment platform overhaul — implementation guide

This document plus the accompanying failing tests are the complete spec for the
"reseller / partner payments + financial dashboard" milestone. Implement until
**every test listed in the last section is green**. Nothing here is optional
unless explicitly marked *(later)*.

The guiding principle, repeated because it drives every decision:

> **The only revenue is the 3.5% application fee on payments that flow through
> Stripe Connect.** Every path that ends in "paid" must go through the Stripe
> checkout flow so the fee is captured. Off‑platform settlement is *possible*
> (the kennel may take a bank transfer) but it must be a deliberate, tracked,
> less‑convenient action — never the default.

---

## 0. Vocabulary

| Term | Meaning |
|------|---------|
| **Partner** | A B2B reseller who books on behalf of their own customers. Identified by a `&partner=<code>` URL param on the booking page. |
| **Deferred payment** | A confirmed booking whose balance is paid later, through a Stripe pay‑link. Seat is reserved immediately. |
| **Pay link** | A public URL that, when opened, lazily mints a fresh Stripe Checkout Session for an existing booking and redirects to it. Never expires (the session is created on click). |
| **Off‑platform payment** | The kennel marks a booking paid manually (cash/bank transfer). No Stripe, no commission. Tracked as `paidOffPlatform` so stats stay honest. |

---

## 1. Data model changes

### 1.1 New `PaymentStatus` value (Dart + Python)

Add `paidOffPlatform` to `PaymentStatus` in
`lib/customer_management/models.dart` with `@JsonValue("paidOffPlatform")`.

Semantics:
- It **occupies a seat** (counts toward capacity).
- It is **"active"** (shown in the customer group, like `paid`/`deferredPayment`).
- It earns **zero commission**.

Update `BookingsExtension.active` to include it. Add a helper:

```dart
extension PaymentStatusX on PaymentStatus {
  /// True when the booking holds a seat in its customer group.
  bool get occupiesSeat =>
      this == PaymentStatus.paid ||
      this == PaymentStatus.deferredPayment ||
      this == PaymentStatus.paidOffPlatform;

  /// True when money actually moved through Stripe (so it can be refunded
  /// and earned us a commission).
  bool get isOnPlatformPaid => this == PaymentStatus.paid;
}
```

### 1.2 `Booking` gains fields

In `lib/customer_management/models.dart`, add to `Booking`:

```dart
/// The id of the partner (reseller) this booking belongs to, if any.
String? partner,

/// The total price of the booking in cents, AFTER any partner discount.
/// Stored at creation for deferred / off‑platform bookings so the financial
/// dashboard and the payment email have an amount without re‑hitting Stripe.
/// For on‑platform paid bookings the authoritative value is on the
/// CheckoutSession, but we mirror it here for convenience.
int? totalCents,
```

Mirror these in the Python `Booking` pydantic model in
`functions/lib/add_booking/add_checkout_session.py` (add `partner: str | None`
and `totalCents: int | None`).

### 1.3 New `Partner` model (Dart)

Create `lib/customer_management/partners/models.dart`:

```dart
@freezed
sealed class Partner with _$Partner {
  const factory Partner({
    required String id,                 // ALSO stored as a field in the doc
    @Default("") String name,           // internal display name
    @Default("") String code,           // the value used in &partner=<code>
    String? email,                      // ALWAYS the recipient of payment emails
    double? discountRate,               // fraction 0..1 (e.g. 0.1 == 10% off). null == no discount
    @Default(false) bool allowDeferred, // may this partner defer payment?
    @Default(0) int deferredDays,       // balance due this many days BEFORE the tour date
    @Default(false) bool archived,      // never delete partners — archive for stats/recovery
  }) = _Partner;

  factory Partner.fromJson(Map<String, dynamic> json) => _$PartnerFromJson(json);
}

extension PartnersExtension on List<Partner> {
  /// Non-archived partners only.
  List<Partner> get active => where((p) => !p.archived).toList();

  /// First partner with this id, or null.
  Partner? fromId(String id) =>
      where((p) => p.id == id).firstOrNull;

  /// First NON-ARCHIVED partner whose code matches (case-insensitive), or null.
  Partner? fromCode(String code) => active
      .where((p) => p.code.toLowerCase() == code.trim().toLowerCase())
      .firstOrNull;
}
```

Firestore location (subcollection of the booking manager doc, mirroring
`bookings`, `customers`, `customerGroups`):

```
accounts/{account}/data/bookingManager/partners/{partnerId}
```

### 1.4 Pure partner logic (Dart)

Create `lib/customer_management/partners/logic.dart`:

```dart
/// Whether the partner may choose deferred payment at checkout.
bool canDeferPayment(Partner? partner) =>
    partner != null && partner.allowDeferred;

/// Apply a partner discount to a price. Rounds to the nearest cent.
/// Returns the original price when there is no partner / no discount.
int discountedPriceCents(int priceCents, Partner? partner) {
  final rate = partner?.discountRate;
  if (rate == null || rate <= 0) return priceCents;
  return (priceCents * (1 - rate)).round();
}

/// The date the deferred balance is due: the tour date minus the partner's
/// `deferredDays`. (NOTE: it is measured from the tour date, NOT from now.)
DateTime paymentDueDate(DateTime tourDate, Partner partner) =>
    tourDate.subtract(Duration(days: partner.deferredDays));
```

> ⚠️ **Important correction baked into the tests:** `deferredDays` is "days
> before the tour", so `dueDate = tourDate - deferredDays`. Do **not** compute it
> from `now`.

---

## 2. Partner management UI (musher only)

Add a "Partners" management section reachable by admins (`musher` user level).
Admins can **add**, **edit**, and **archive** partners. They can **never
delete** — archiving preserves history and allows recovery.

Keep the screen split into a thin presentational widget so it is testable
without Firebase/Riverpod:

```dart
// lib/customer_management/partners/partners_management_view.dart
class PartnersManagementView extends StatelessWidget {
  final List<Partner> partners;          // pass already-fetched partners
  final void Function() onAdd;
  final void Function(Partner) onEdit;
  final void Function(Partner) onArchive;
  // Renders only PartnersExtension.active by default, with a toggle to reveal
  // archived ones. Each active row has an "Edit" and an "Archive" action.
  // There must be NO delete action anywhere.
}
```

Persistence goes through `PartnersRepository` (§3). Gate writes in Firestore
security rules to the `musher` level as well — client-side gating is not enough.

---

## 3. Repositories (Dart)

### 3.1 `PartnersRepository`

Create `lib/customer_management/partners/repository.dart`:

```dart
class PartnersRepository {
  final String account;
  final FirebaseFirestore db;
  PartnersRepository({required this.account, FirebaseFirestore? db})
      : db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => db
      .collection('accounts').doc(account)
      .collection('data').doc('bookingManager')
      .collection('partners');

  /// Upsert. The doc id MUST equal partner.id, and `id` MUST also be written
  /// as a field (so Dart code never relies on doc.id alone).
  Future<void> savePartner(Partner partner) =>
      _col.doc(partner.id).set(partner.toJson());

  /// Archive — never delete.
  Future<void> archivePartner(String partnerId) =>
      _col.doc(partnerId).update({'archived': true});

  Future<List<Partner>> fetchPartners() async {
    final snap = await _col.get();
    return snap.docs.map((d) => Partner.fromJson(d.data())).toList();
  }
}
```

### 3.2 `AlertEditorsRepository` additions

In `lib/customer_management/alert_editors/repository.dart` add three callables
(mirror the existing `refundBooking` style — payload is `{account, bookingId}`):

```dart
Future<void> cancelBooking(Booking booking);              // -> "cancel_booking"
Future<void> markBookingPaidOffPlatform(Booking booking); // -> "mark_booking_paid_off_platform"
Future<void> sendDeferredPaymentEmail(Booking booking);   // -> "send_deferred_payment_email"
```

### 3.3 Booking-action decision (Dart, pure)

Create `lib/customer_management/alert_editors/logic.dart`:

```dart
enum BookingAction { refund, cancel, none }

/// Decides which destructive action the editor should offer.
/// - paid (on-platform)            -> refund (Stripe, claws back commission)
/// - deferredPayment / waiting /
///   unknown / paidOffPlatform      -> cancel (no Stripe; just free the seat)
/// - refunded                       -> none (already terminal)
BookingAction bookingActionFor(Booking booking) {
  switch (booking.paymentStatus) {
    case PaymentStatus.paid:
      return BookingAction.refund;
    case PaymentStatus.refunded:
      return BookingAction.none;
    case PaymentStatus.deferredPayment:
    case PaymentStatus.waiting:
    case PaymentStatus.unknown:
    case PaymentStatus.paidOffPlatform:
      return BookingAction.cancel;
  }
}
```

Wire `alert_editors/booking.dart` to show **Refund** when
`bookingActionFor(...) == refund`, **Cancel booking** when `== cancel`, and
nothing when `== none`. Add, next to each deferred booking in
`customer_group_viewer.dart`, a **"Send payment email"** button
(→ `sendDeferredPaymentEmail`) and a **"Mark paid (off‑platform)"** button
(→ `markBookingPaidOffPlatform`).

### 3.4 `BookingPageRepository` (customer-facing)

In `lib/customer_facing/booking_page/repository.dart`:

1. `getStripePaymentUrl` gains an optional `Partner? partner`. When non-null,
   add `"partner": partner.id` to the callable payload. (The discount itself is
   applied **server-side** — never trust the client for the amount.)
2. Add a new method for the deferred path:

```dart
/// Creates a confirmed-but-unpaid booking and triggers the partner email.
/// Returns the bookingId. Calls "create_deferred_booking" with
/// {account, tourId, booking, customers, partner: partner.id}.
Future<String> createDeferredBooking({
  required Booking booking,
  required List<Customer> customers,
  required Partner partner,
});
```

The checkout page must, when `canDeferPayment(partner)` is true, present the
choice **"Pay now"** (existing flow) vs **"Pay later"** (`createDeferredBooking`).
A partner with `allowDeferred` may still choose to pay now.

---

## 4. Cloud functions (Python, `functions/main.py`)

Reuse the existing helpers — do **not** duplicate price logic. The keystone is
that **one** server-side calculator feeds every path.

### 4.1 Shared price calculator gains partner discount

`_build_server_checkout_payload(...)` gets a new optional `partner: dict | None`
parameter. When a partner with a positive `discountRate` is supplied, discount
**each line item's `unit_amount`** (round to nearest cent) before building line
items, so the total, the per-line amounts, and the application fee are all
computed on the discounted total. (The existing fee calc `_calculate_platform_fee`
truncates to int, so e.g. a discounted total of 9000 → fee `int(9000 * 0.035 *
1.255)` == 395; the test asserts this.) Add helpers:

```python
def _get_partner(db, account, partner_id) -> dict | None: ...
def _partner_discount_rate(partner: dict | None) -> float:
    # 0.0 when partner is None, archived, or has no positive discountRate
```

### 4.2 `create_booking_checkout_session` (modify)

- Read optional `partner` (a partnerId) from `req.data`.
- Load the partner, pass it into `_build_server_checkout_payload`.
- Persist `partner` (the id) on **both** the booking doc and the CheckoutSession
  doc, and store the discounted `totalCents` on the booking.
- Everything else (capacity transaction, tax rates, fee) is unchanged.

### 4.3 `create_deferred_booking` (new `@https_fn.on_call`)

Customer-facing (no auth) — validated by the partner, like the public checkout.
Payload: `{account, tourId, booking, customers, partner}`.

1. Load partner; reject (`FAILED_PRECONDITION`) if missing/archived or
   `allowDeferred` is false.
2. Reserve the seat **inside the existing reservation transaction**
   (`_reserve_booking_transaction`) but write `paymentStatus: "deferredPayment"`
   (and **no** `expiresAt` — deferred holds the seat permanently). Raise
   `"This group is now full"` on contention, exactly like checkout.
3. Compute the discounted total via the shared calculator; store `partner` and
   `totalCents` on the booking.
4. Send the partner confirmation email (§4.6) to **`partner.email`**.
5. Return `{"bookingId": booking_id}`.

### 4.4 `_create_deferred_checkout_session` (new helper) + `pay_deferred_booking` (new `@https_fn.on_request`, public)

This is the lazily-minted pay link.

`_create_deferred_checkout_session(db, account, booking_id) -> dict`:
- Reject if the booking is already `paid`/`refunded`.
- Rebuild the checkout payload from the stored booking + its partner (so the
  discount is re-applied) via `_build_server_checkout_payload`.
- Create the Stripe Checkout Session, write the CheckoutSession doc (same as the
  normal flow), store `checkoutSessionId` on the booking.
- Return `{"url": session.url, "checkoutSessionId": session.id}`.

`pay_deferred_booking(req)` is a thin public `on_request` wrapper: read
`account` and `bookingId` from the query string, call the helper, and redirect
(HTTP 303) to the returned `url`. (The unit tests target the helper, not the
redirect plumbing.)

When the customer pays, the **existing webhook**
(`stirpe_webhook_checkout_session_succeeded` → `payment_processed`) flips the
booking `deferredPayment → paid` and captures the commission. No new webhook.

### 4.5 `send_deferred_payment_email` (new `@https_fn.on_call`)

Used by the booking editor and the "resend" button. Payload `{account, bookingId}`.
Assert account membership.

- Load booking, its partner, its customers.
- Build the pay link: `f"{PAY_BASE_URL}?account={account}&bookingId={booking_id}"`
  where `PAY_BASE_URL` points at the `pay_deferred_booking` route.
- Send the payment email (§4.6) to **`partner.email`** — never to the booking's
  own email. (Per product decision: trip reminders go to the booking email set
  in the cart; **payment** emails always go to the partner.)

### 4.6 Payment email + the template-id placeholder ⚑

Both `create_deferred_booking` and `send_deferred_payment_email` send the **same**
payment email. Factor the body into a shared helper so both callers reuse it:

```python
def send_deferred_payment_email_for_booking(*, db, account, booking_id): ...
```

`send_deferred_payment_email` (the `on_call`) is a thin wrapper that asserts
account membership and calls this helper; `create_deferred_booking` calls it
directly after reserving the seat. Implement it next to the others (mirror
`_send_reminder_email` in `functions/lib/booking_reminders.py` — it is a
ZeptoMail template send).

**Wire up everything now: the numbers, names, URLs, and the custom fields.**
Reuse `build_booking_other_info_html` / `build_customers_other_info_html` so the
booking and customer custom fields render in the email, exactly like the reminder.

Leave the template id as a placeholder:

```python
# functions/lib/deferred_payment_email.py
DEFERRED_PAYMENT_TEMPLATE_KEY = "REPLACE_ME_DEFERRED_PAYMENT_TEMPLATE_KEY"  # ⚑ see payment_overhaul.md
```

`merge_info` passed to ZeptoMail (these are the **custom parameters the template
must define** — building the HTML template itself is out of scope; this code only
plugs in the values):

| merge_info key | value |
|----------------|-------|
| `partner_name` | partner display name |
| `kennel_name` | kennel name |
| `booking_name` | booking label |
| `tour_date` | formatted tour date/time in the kennel timezone |
| `amount` | formatted `booking.totalCents` (e.g. `"€150.00"`) |
| `pay_url` | the pay link (`PAY_BASE_URL?account=…&bookingId=…`) |
| `due_date` | formatted `paymentDueDate` (tour date − `deferredDays`) |
| `cancellation_policy` | kennel cancellation policy |
| `kennel_url` | kennel public url |
| `kennel_header_picture_url` | banner image url |
| `booking_other_info` | `build_booking_other_info_html(...)` |
| `customers_other_info` | `build_customers_other_info_html(...)` |

**HOW TO FINISH THE TEMPLATE (do this once the code is merged):**
1. In ZeptoMail, create a Template whose merge tags exactly match the keys
   above (e.g. `{{pay_url}}`, `{{amount}}`, `{{booking_other_info}}` rendered as
   raw HTML, etc.).
2. Copy its **template key** from ZeptoMail.
3. Replace `DEFERRED_PAYMENT_TEMPLATE_KEY`'s placeholder string with that key
   (or, preferably, read it from an env var `ZEPTOMAIL_DEFERRED_PAYMENT_TEMPLATE`
   and set that in the Functions config, matching how other secrets are stored).
4. Send one test deferred booking to yourself and confirm every field renders.

### 4.7 `cancel_booking` (new `@https_fn.on_call`, musher)

Payload `{account, bookingId}`. Assert account membership.
- If the booking is `paid` → reject (`FAILED_PRECONDITION`, "Use refund for paid
  bookings"). Paid bookings must go through `refund_payment`.
- Otherwise delete the booking doc **and its customer docs**, freeing the seat.

### 4.8 `mark_booking_paid_off_platform` (new `@https_fn.on_call`, musher)

Payload `{account, bookingId}`. Assert account membership. Set the booking
`paymentStatus` to `"paidOffPlatform"`. (No Stripe, no commission.)

### 4.9 Capacity counts `paidOffPlatform`

In `_booking_counts_for_capacity`, add `"paidOffPlatform"` to the always-counts
set (alongside `paid` and `deferredPayment`).

### 4.10 Two parallel reminder systems

- **Trip reminders** — keep `functions/lib/booking_reminders.py` as is, but add
  `"paidOffPlatform"` to the eligible `paymentStatus` filter so off-platform
  bookings still get trip reminders. Recipient stays the **booking email**.
- **Payment-due reminders** — NEW, separate, in
  `functions/lib/deferred_payment_reminders.py`, on its own scheduler. Only for
  bookings with `paymentStatus == "deferredPayment"`. Recipient is always the
  **partner email**. Fire it the day before the balance is due. Pure date helpers
  (so they are unit-testable):

```python
def _deferred_payment_due_date(tour_date: date, deferred_days: int) -> date:
    return tour_date - timedelta(days=deferred_days)

def _should_send_deferred_reminder(due_date: date, today: date) -> bool:
    # send exactly one day before the balance is due
    return today == due_date - timedelta(days=1)
```

Skip any booking already `paid`/`paidOffPlatform`/`refunded`.

---

## 5. Financial dashboard (revenue only; costs are *later*)

A pure aggregation function over a small record type keeps it testable and
decoupled from Firestore. Build the records by reading the `checkoutSessions`
collection (for `total`/`commission`) joined with bookings (for status, partner,
tour type, date). Reuse the existing date-filter widget from `lib/stats` /
teams history.

Create `lib/stats/financial/logic.dart`:

```dart
class FinancialRecord {
  final DateTime date;          // payment/booking date
  final PaymentStatus status;
  final int totalCents;         // discounted total
  final int commissionCents;    // 0 unless on-platform paid
  final String? partner;        // partnerId or null
  final String? tourTypeId;
  const FinancialRecord({...});
}

class FinancialSummary {
  final int grossRevenueCents;        // sum total where status in {paid, paidOffPlatform}
  final int commissionCents;          // sum commission where status == paid
  final int netRevenueCents;          // gross - commission
  final int outstandingDeferredCents; // sum total where status == deferredPayment
  final int refundedCents;            // sum total where status == refunded
  final int paidBookingsCount;        // count where status in {paid, paidOffPlatform}
  final Map<String, int> revenueByPartner;   // partnerId(or "direct") -> gross
  final Map<String, int> revenueByTourType;  // tourTypeId -> gross
  const FinancialSummary({...});
}

/// Aggregates records, optionally filtered to [range] (inclusive of start,
/// exclusive of end — match the existing stats widgets).
FinancialSummary computeFinancialSummary(
  List<FinancialRecord> records, {
  DateTimeRange? range,
});
```

Semantics encoded by the tests:
- "Revenue" = `paid` + `paidOffPlatform` totals.
- Commission only accrues on `paid` (on-platform).
- `deferredPayment` is **outstanding** (AR), not revenue.
- `refunded` is excluded from revenue and reported separately.
- `revenueByPartner` keys direct (no partner) bookings under `"direct"`.

---

## 6. Build order

1. Shared price calculator gains partner discount (§4.1) — unblocks everything.
2. Models: `Partner`, `Booking.partner`/`totalCents`, `paidOffPlatform` (§1).
3. `create_booking_checkout_session` discount + persistence (§4.2).
4. Deferred booking + pay link + payment email (§4.3–4.6).
5. Cancel / mark-off-platform / capacity (§4.7–4.9).
6. Reminders split (§4.10).
7. Partner repo + management UI (§2, §3.1).
8. Booking-editor partner selector + action wiring (§3.2–3.3).
9. Financial dashboard (§5).

Items 1–6 are the reseller MVP; 7–9 round it out for launch.

---

## 7. The failing tests (definition of done)

### Python — `functions/test_payment_overhaul.py`
- partner discount reduces line items, total, application fee, and stored `totalCents`
- `partner` id persisted on booking + checkout session
- `create_deferred_booking` writes a `deferredPayment` booking with partner + total, sends the partner email, rejects non-deferred partners, rejects a full group
- `_create_deferred_checkout_session` re-applies the discount and mints a session; rejects already-paid bookings
- `send_deferred_payment_email` sends to the **partner** email with the pay link + amount + custom fields, using the placeholder template key
- `cancel_booking` deletes deferred booking + customers; rejects paid bookings
- `mark_booking_paid_off_platform` sets the status
- capacity counts `paidOffPlatform`
- deferred payment-due date + "send the day before" helpers

### Dart
- `test/customer_management/partners/partner_logic_test.dart` — model json round-trip (incl. `id` field), `PartnersExtension` (active/fromId/fromCode), `canDeferPayment`, `discountedPriceCents`, `paymentDueDate`
- `test/customer_management/partners/partner_repository_test.dart` — save (id as field + doc id), archive (never delete), fetch
- `test/customer_management/booking_payment_action_test.dart` — `bookingActionFor`, `paidOffPlatform` is active + occupies a seat
- `test/customer_facing/booking_page/deferred_repository_test.dart` — `getStripePaymentUrl` forwards `partner`; `createDeferredBooking` calls `create_deferred_booking` with the right payload
- `test/stats/financial_dashboard_test.dart` — `computeFinancialSummary` revenue/commission/outstanding/refund/group-by + date filtering
- `test/settings/partners_management_widget_test.dart` — view lists active partners, exposes Edit + Archive, and exposes **no** delete action

> These tests reference symbols that do not exist yet, so until they are
> implemented the suites will not even compile — that is the intended red state.
> Implement the spec above until `flutter test` and
> `python -m unittest functions/test_payment_overhaul.py` are both green.
</content>
</invoke>
