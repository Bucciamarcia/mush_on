# Stripe Configuration Readiness Report

This report lists the main Stripe connection and payment configuration gaps to address before accepting real payments.

## 1. Add a Disconnect or Disable Payments Control

The settings page currently shows the Stripe connection flow only when no Stripe integration document exists. Once connected, there is no visible way to disable or disconnect Stripe from settings. A safe first step is a "Disable payments" action that sets `isActive` to `false` while keeping historical payment data intact.

## 2. Verify Stripe Account Readiness Before Activation

The onboarding success page currently activates the integration after Stripe redirects back with a success result. Before enabling real checkout, the backend should confirm the connected Stripe account is actually ready for payments, including required capabilities, onboarding requirements, charges, and transfers.

## 3. Show Clear Connection Status in Settings

Settings should show the current Stripe state, such as connected, active, disabled, onboarding incomplete, or restricted. Right now, any existing Stripe integration document is treated as enough to show payment page settings, which can hide incomplete or broken connection states.

## 4. Add Explicit Test and Live Mode Handling

The backend currently uses a single `STRIPE_KEY` environment variable. There is no stored or visible distinction between test and live mode. Before live payments, the app should clearly identify which mode is active and avoid mixing test-created Stripe objects with live checkout.

## 5. Validate Webhook Configuration for Live Payments

Payment completion depends on the Stripe webhook secret and API key being configured correctly. Live payments require a live webhook endpoint and live webhook signing secret that match the deployed Stripe key. The system should make this operational dependency explicit and easier to verify.

## 6. Replace Hardcoded Production URLs

Stripe onboarding and checkout success URLs are currently hardcoded to the production web app domain. This works for production but makes staging, local testing, and environment separation fragile. These URLs should come from environment-specific configuration.

## 7. Review Connected Account Country Handling

Stripe connected accounts are currently created with `country="fi"`. If Mush On will support businesses outside Finland, account country should be configurable or derived from verified business settings.

## 8. Recreate or Migrate Stripe Tax Rates for Live Mode

Stripe object IDs are mode-specific. Tax rates created in test mode will not work with live payments. Before switching to live mode, the app needs a way to recreate or migrate tax rate IDs for live Stripe.
