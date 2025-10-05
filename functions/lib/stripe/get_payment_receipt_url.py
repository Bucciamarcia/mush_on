import stripe


def get_payment_receipt_url(
    stripe_id: str, checkout_session_id: str, stripe_api_key: str
) -> str:
    stripe.api_key = stripe_api_key
    checkout_session = stripe.checkout.Session.retrieve(
        checkout_session_id, stripe_account=stripe_id
    )
    payment_intent = stripe.PaymentIntent.retrieve(
        checkout_session.payment_intent, stripe_account=stripe_id
    )
    charge_id = payment_intent.latest_charge
    charge = stripe.Charge.retrieve(charge_id, stripe_account=stripe_id)
    return charge.receipt_url or ""
