from firebase_admin import firestore


class FirestoreUtils:
    def __init__(self):
        self.db = firestore.client()

    def set_doc(self, path: str, data: dict, merge: bool = False) -> None:
        """
        Performs the set operation to the specified document path. Can merge (default false).

        Returns none.
        """
        doc = self.db.document(path)
        doc.set(data, merge=merge)
