# Remaining Payment and Booking Fixes

This document tracks the critical payment and booking issues that still remain after locking down direct public access to private booking data and moving refund lookup logic server-side.

## 4. Harden Success Page Payment-State Handling

**Executive description:**  
The success page still presents a booking confirmation as soon as booking data loads. Payment confirmation and receipt availability are handled separately.

**Why it matters:**  
Stripe may redirect before the webhook has processed. A customer can briefly see a confirmed state while the booking is still `waiting`, or a manually opened success URL can show stronger confirmation than the payment state warrants.

**Recommendation:**  
Return `paymentStatus` and checkout-session processing state from the success-data callable. Render distinct states: “payment processing”, “booking confirmed”, “payment failed/expired”, and “refunded”. Only show the strongest confirmation and receipt CTA after `paymentStatus == paid`.

## 5. Make Webhook Email Delivery Durable and Idempotent

**Executive description:**  
The payment webhook updates booking/payment state and then sends the confirmation email. If email sending fails after state is committed, the webhook can be considered already processed and the email may never be retried.

**Why it matters:**  
Customers may pay successfully but never receive confirmation email or receipt details. Staff may not notice until support is contacted.

**Recommendation:**  
Separate payment processing from email delivery. Store an email task document with status such as `pending`, `sent`, `failed`, `retryCount`, and `lastError`. A scheduled worker or queue-triggered function should send the email idempotently and retry failures without reprocessing the Stripe payment.

## 6. Add Idempotency and Audit Fields to Refunds

**Executive description:**  
Refunds now run server-side, but the refund function should still protect against duplicate refund attempts and preserve an audit trail.

**Why it matters:**  
Staff can accidentally retry a refund, network failures can cause ambiguous UI states, and financial actions need traceability.

**Recommendation:**  
Before calling Stripe, check whether the booking is already `refunded` or whether the checkout session already has a `refundId`. Store `refundId`, `refundedAt`, `refundedBy`, and any Stripe refund status on the checkout session or booking. Return the existing refund result if a refund was already completed.

## 7. Validate Stripe Account Activation Server-Side

**Executive description:**  
The public booking page checks whether Stripe is active, but checkout creation should also enforce this on the backend.

**Why it matters:**  
Client-side gates are UX safeguards, not security controls. A direct callable request could bypass the page-level active check.

**Recommendation:**  
In `create_checkout_session`, fetch the Stripe integration document and reject the request unless `isActive == true`, the connected account id exists, and the account matches the requested kennel.

## 8. Add Tests Around Payment Security Boundaries

**Executive description:**  
The new database-lockdown and refund tests cover the first round of fixes, but the payment flow still lacks tests for the highest-risk areas.

**Why it matters:**  
Most remaining issues are contract and state-machine bugs. They are easy to reintroduce unless tested at the backend boundary.

**Recommendation:**  
Add backend tests for server-side pricing calculation, capacity race prevention, pending booking expiry, webhook idempotency, refund idempotency, and success-page payment states. Add Flutter tests that assert the client sends only non-authoritative booking selections, not prices, totals, fees, payment intents, or Stripe account ids.
