import firebase_admin
from firebase_admin import credentials, db
from config import FIREBASE_CRED_PATH, FIREBASE_DB_URL, DB_STATUS_PATH


class FirebaseClient:
    def __init__(self):
        cred = credentials.Certificate(FIREBASE_CRED_PATH)
        firebase_admin.initialize_app(cred, {
            "databaseURL": FIREBASE_DB_URL
        })
        self.ref = db.reference(DB_STATUS_PATH)

    def update_status(self, status: str):
        """
        Firebase Realtime DB에 on/off 상태 저장
        경로: room/status
        """
        self.ref.set(status)
        print(f"[Firebase] room/status = {status}")
