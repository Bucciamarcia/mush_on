# Payment overhaul — smoke test

Manual smoke test for the "reseller / partner payments + financial dashboard"
milestone. Run through this after deploying functions + rules and building the
app, to confirm the happy paths and the important guardrails work end to end.

> The **only** revenue is the 3.5% application fee on payments that flow through
> Stripe Connect. The core thing this test proves: every "paid" path either
> goes through Stripe (and captures the fee) or is a deliberate, tracked
> off-platform action that earns no commission.

---

## 0. Preconditions / setup

- [x] Functions deployed: `cd functions && firebase deploy --only functions`
- [x] Firestore rules deployed: `firebase deploy --only firestore:rules`
- [x] App built and running against the same Firebase project.
- [x] A kennel **account** with an **active Stripe Connect** integration
      (test mode is fine) and at least one tour type with a price.
- [x] Two users on the account: one **musher** (admin) and one **handler**
      (non-admin) — used for the permission checks.
- [x] Env / config set on the functions:
  - `ZEPTOMAIL_AUTHORIZATION`
  - `PAY_BASE_URL` → the deployed `pay_deferred_booking` URL
    (e.g. `https://<region>-<project>.cloudfunctions.net/pay_deferred_booking`
    or your hosting rewrite, e.g. `https://mush-on.web.app/pay`).
  - `ZEPTOMAIL_DEFERRED_PAYMENT_TEMPLATE` *(optional)* — until set, emails use
    the placeholder template key `REPLACE_ME_DEFERRED_PAYMENT_TEMPLATE_KEY` and
    ZeptoMail will reject the send. See "Known placeholder" at the bottom.

### Automated tests (run first — cheap and fast)

```bash
# Dart
flutter test

# Python (from functions/)
cd functions && python -m unittest test_payment_overhaul test_main \
  test_stripe_accounts_overhaul test_booking_email_html
```

All should pass before doing any manual testing.

---

## 1. Partner management (musher only)

Reach it from **Manage Bookings → "Manage partners"** (top right), or navigate to
`/client_management/partners`.

1. [x] **Create a partner** with: a display name, a `code` (e.g. `acme`), an
       **email**, a **discount %** (e.g. `10`), toggle **Allow deferred payment**
       ON, and **deferred days** = `7`. Save.
2. [x] The partner appears in the active list.
3. [x] **Edit** it (pencil) — values round-trip correctly; change the name; save.
4. [x] **Archive** it (archive icon) → it disappears from the default list.
5. [x] Toggle **"Show archived"** ON → the archived partner reappears, and it has
       **no archive action** (already archived).
6. [x] **There is no Delete affordance anywhere** (no delete button, no "Delete"
       text/tooltip). Archiving is the only way to remove.
7. [x] Un-archive path: there's intentionally no client un-archive button; if you
       need it back, flip `archived` in Firestore. (Recovery is preserved.)

Leave **one active partner** (`code=acme`, 10% discount, deferred allowed,
deferredDays=7) seeded for the rest of the test.

### Permission guardrail
8. [ ] Sign in as the **handler** user. You should **not** be able to reach /use
       partner management (screen is gated to `musher`).
9. [ ] (Optional, rules) Attempt a direct Firestore write to
       `accounts/{account}/data/bookingManager/partners/{id}` as a non-musher /
       signed-out client → **denied**. Public **read** of that path is allowed
       (needed by the booking page).

---

## 2. Partner discount + on-platform checkout (Pay now)

Open the public booking page **with the partner code**:

```
/booking?kennel=<account>&tourId=<tourId>&partner=acme
```

1. [x] Pick a date/time, add a passenger, fill required fields.
2. [x] The primary button reads **"Pay now"** (and a secondary **"Pay later
       (invoice)"** is visible because this partner allows deferral — see §3).
3. [x] Tap **Pay now** → redirected into Stripe Checkout. Confirm the **amount is
       discounted** (10% off the list price).
4. [x] Complete the test payment (Stripe test card `4242 4242 4242 4242`).
5. [x] You land on the booking success page showing **"Booking confirmed!"**.

### Verify the data (Firestore / Stripe)
6. [x] `…/bookingManager/bookings/{bookingId}`: `paymentStatus == "paid"`,
       `partner == "<partnerId>"`, `totalCents` == the **discounted** total,
       `checkoutSessionId` set.
7. [x] `checkoutSessions/{sessionId}`: `total` == discounted total,
       `commission` == `int(total * 0.035 * (1 + vatRate))`, `partner` set.
8. [x] In Stripe, the **application fee** equals that commission and was charged
       on the **discounted** amount (the fee is computed on the discounted total,
       not the list price).

### No-partner regression
9. [x] Open `/booking?kennel=<account>&tourId=<tourId>` (no `partner`). Button
       reads **"Pay now"**, **no "Pay later"** option, price is **undiscounted**,
       and checkout succeeds as before. Booking has no `partner`.

---

## 3. Deferred booking (Pay later) + pay link + partner email

On the partner booking page (`…&partner=acme`):

1. [x] Fill the cart, then tap **"Pay later (invoice)"**.
2. [x] You get a **"Booking confirmed"** dialog (seat reserved, no Stripe yet).
3. [x] Firestore `…/bookings/{bookingId}`:
       `paymentStatus == "deferredPayment"`, `partner` set,
       `totalCents` == discounted total, and **no `expiresAt`** (deferred holds
       the seat permanently).
4. [x] The **partner email** (not the cart email) receives the payment email with
       a **pay link**, the **amount**, the **due date** (tour date − 7 days), and
       the booking/customer custom fields rendered.
       *(Requires a real ZeptoMail template — see placeholder note.)*

### The pay link (lazy Stripe session)
5. [x] Open the pay link
       (`<PAY_BASE_URL>?account=<account>&bookingId=<bookingId>`).
6. [x] It **303-redirects** into a freshly minted Stripe Checkout Session with the
       **discount re-applied** (same discounted amount as §2).
7. [x] Pay with the test card. The **existing webhook** flips the booking
       `deferredPayment → paid` and captures the commission (verify `paid`
       status + `checkoutSessions` doc + Stripe application fee).
8. [x] Re-open the pay link **after** payment → rejected (already paid); it does
       not create a second session.

### Resend from the editor
9. [x] Create another deferred booking. In **Manage Bookings**, open the customer
       group; the deferred booking card shows **"Send payment email"** and
       **"Mark paid (off-platform)"** buttons.
10. [x] Tap **"Send payment email"** → success snackbar; the **partner** receives
        the email again (same pay link).

---

## 4. Off-platform payment (cash / bank transfer)

1. [x] On a **deferred** booking card, tap **"Mark paid (off-platform)"**.
2. [x] Success snackbar; the booking status chip becomes
       **"Paid (off-platform)"**.
3. [x] Firestore: `paymentStatus == "paidOffPlatform"`. **No** Stripe session,
       **no** `checkoutSessions` doc, **no** commission.
4. [x] The booking still **occupies a seat** (counts toward capacity) and shows
       in the active list.

---

## 5. Capacity (paidOffPlatform & deferred fill seats)

1. [x] Pick a customer group and note `maxCapacity`.
2. [x] Fill remaining seats using a mix of **deferred** and **paid off-platform**
       bookings until full.
3. [x] Attempt one more booking (Pay now **or** Pay later) on the same group →
       rejected with **"This group is now full"**, and **no** Stripe session is
       created for the rejected attempt.
4. [x] Confirm the public availability count reflects the deferred + off-platform
       seats as taken.

---

## 6. Destructive actions in the booking editor

Open a booking in the editor (as **musher**) and confirm the offered action
matches its status:

| Booking status            | Expected action button         |
|---------------------------|--------------------------------|
| `paid` (on-platform)      | **Refund booking** (Stripe)    |
| `deferredPayment`         | **Cancel booking**             |
| `paidOffPlatform`         | **Cancel booking**             |
| `waiting` / `unknown`     | **Cancel booking**             |
| `refunded`                | *(no destructive action)*      |

1. [x] **Refund** a `paid` booking → Stripe refund issued, commission clawed
       back, seat freed.
2. [x] **Cancel** a `deferredPayment` booking → the booking **and its customer
       docs are deleted**, seat freed. No Stripe call.
3. [x] Confirm a **`paid`** booking offers **only Refund** (never plain Cancel) 
       `cancel_booking` must reject paid bookings server-side
       (`failed-precondition`, "Use refund for paid bookings").
4. [x] A **handler** (non-musher) does not see these destructive actions.

---

## 7. Reminders

Two **independent** reminder systems:

1. [x] **Trip reminders** (`send_daily_booking_reminders`): a `paidOffPlatform`
       booking now also receives the trip reminder, sent to the **booking email**
       (cart email) — same as `paid`/`deferredPayment`.
2. [x] **Payment-due reminders** (`send_daily_deferred_payment_reminders`): only
       for `deferredPayment` bookings, sent to the **partner email**, fired the
       **day before** the balance is due (tour date − deferredDays − 1).
       - Quick check: a deferred booking whose due date is *tomorrow* triggers a
         reminder today; one due *today* or *in 2 days* does not.
       - Skips bookings already `paid` / `paidOffPlatform` / `refunded`.

You can trigger schedulers manually from Cloud Scheduler to test without waiting.

---

## 8. Financial dashboard (revenue aggregation)

Open it from the menu under **Data → Financial** (musher only; the entry is
hidden for handlers), or navigate to `/financial`. It calls the
`get_financial_records` function (which reads the server-only `checkoutSessions`
for commission) and renders the summary via `computeFinancialSummary`.

- [ ] A **handler** does not see the **Financial** menu entry, and opening
      `/financial` directly shows "You don't have access to this page."
- [ ] As a **musher**, the page loads with the metric cards + two breakdowns.
- [ ] The **Date range** button filters the figures (start inclusive, picked end
      day inclusive in the UI); **Clear** returns to "All time".

Numbers to verify against the seeded data:

- [ ] **Gross revenue** = sum of `paid` + `paidOffPlatform` totals.
- [ ] **Commission** accrues **only** on `paid` (on-platform).
- [ ] **Net revenue** = gross − commission.
- [ ] **Outstanding (AR)** = sum of `deferredPayment` totals (not counted as
      revenue).
- [ ] **Refunded** reported separately, excluded from revenue.
- [ ] **Revenue by partner** buckets no-partner bookings under `"direct"`.
- [ ] **Revenue by tour type** sums correctly.
- [ ] Date range filter is **start-inclusive, end-exclusive**.

---

## Known placeholder ⚑

`functions/lib/deferred_payment_email.py` ships with
`DEFERRED_PAYMENT_TEMPLATE_KEY = "REPLACE_ME_DEFERRED_PAYMENT_TEMPLATE_KEY"`.
Until you create the ZeptoMail template and either replace this constant or set
`ZEPTOMAIL_DEFERRED_PAYMENT_TEMPLATE`, the **email send in §3/§7 will fail**
(everything else — seat reservation, totals, pay link, status changes — still
works). The template must define the merge tags listed in `payment_overhaul.md`
§4.6 (`pay_url`, `amount`, `due_date`, `booking_other_info`, etc.).

---

## Pass criteria

- [ ] Every "paid" outcome either captured a Stripe application fee **or** was an
      explicit off-platform mark with zero commission.
- [ ] Partner discounts applied consistently to line items, total, fee, and
      stored `totalCents`.
- [ ] Deferred seats reserved without expiry; pay link re-applies the discount.
- [ ] Capacity counts `paid` + `deferredPayment` + `paidOffPlatform`.
- [ ] Partners can be created/edited/archived but **never deleted**, by mushers
      only.
- [ ] No regressions to the existing no-partner checkout flow.
