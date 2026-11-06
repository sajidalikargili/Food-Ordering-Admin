import json
from datetime import datetime

import firebase_admin
from firebase_admin import credentials, firestore

# Connect to Firebase
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# Read the JSON file
with open("reviews.json", "r", encoding="utf-8") as file:
    data = json.load(file)

# Upload reviews to Firestore
batch = db.batch()

for index, review in enumerate(data["reviews"], start=1):
    # Convert ISO date string to a Python datetime.
    # Firestore stores datetime values as Timestamp.
    review["createdAt"] = datetime.fromisoformat(
        review["createdAt"].replace("Z", "+00:00")
    )

    # Stable document IDs prevent duplicate documents on reruns.
    doc_ref = db.collection("reviews").document(
        f"review_{index:03d}"
    )

    batch.set(doc_ref, review)

batch.commit()

print(f"Successfully uploaded {len(data['reviews'])} reviews!")
