const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Firestore collection reference
const itemsRef = admin.firestore().collection("chair");

// Cloud Function
exports.updateAllFields = functions.region("asia-northeast3").pubsub.schedule("* 0 * * *").onRun(async (context) => {
  try {
    // Get all documents in 'chair' collection
    const snapshot = await itemsRef.get();

    // Update all fields in all documents to 'a'
    snapshot.forEach(async (doc) => {
      const data = doc.data();
      for (const key in data) {
        if (Object.prototype.hasOwnProperty.call(data, key)) {
          data[key] = "a";
        }
      }
      await itemsRef.doc(doc.id).set(data);
    });

    console.log("All fields in 'chair' collection updated to 'a'");
  } catch (error) {
    console.error("Error updating fields:", error);
  }
});
