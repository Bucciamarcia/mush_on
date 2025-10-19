from typing import Any
from firebase_admin import firestore
from google.cloud.firestore import DocumentSnapshot
from google.cloud.firestore_v1.query_results import QueryResultsList


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

    def read_doc(self, path: str) -> dict[str, Any]:
        """
        Returns the dict of a single document.
        """
        doc = self.db.document(path)
        snapshot = doc.get()
        data = snapshot.to_dict()
        if data is None:
            raise Exception("Document is empty or does not exist")
        return data

    def get_collection(self, path) -> QueryResultsList[DocumentSnapshot]:
        collection = self.db.collection(path)
        return collection.get()
