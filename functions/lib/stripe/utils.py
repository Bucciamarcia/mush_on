from firebase_admin import firestore


def get_stripe_data(account: str) -> dict:
    try:
        db = firestore.client()
        ref = db.document(f"accounts/{account}/integrations/stripe")
        snapshot = ref.get()
        stripe_data = snapshot.to_dict()
        if stripe_data is None:
            return {"error": "stripe data is null"}
        return stripe_data
    except Exception as e:
        raise Exception(f"Couldn't get stripe data: {str(e)}")
