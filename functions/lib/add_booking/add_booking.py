from firebase_functions import https_fn
from firebase_admin import firestore


def add_booking_main(booking, customers, account):
    db = firestore.client()
    batch = db.batch()
    booking_ref = db.document(
        f"accounts/{account}/data/bookingManager/bookings/{booking['id']}"
    )
    batch.set(booking_ref, booking)
    for customer in customers:
        c_ref = db.document(
            f"accounts/{account}/data/bookingManager/customers/{customer['id']}"
        )
        batch.set(c_ref, customer)
    try:
        batch.commit()
    except Exception as e:
        raise https_fn.HttpsError(https_fn.FunctionsErrorCode.INTERNAL, str(e))
