# Remaining Payment and Booking Fixes

This document tracks the critical payment and booking issues that still remain after locking down direct public access to private booking data and moving refund lookup logic server-side.

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
