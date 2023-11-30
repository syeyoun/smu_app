const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Firestore document reference
const itemsRef = admin.firestore().collection("QR").doc("B5WxFun8tLdhe5tYdJ5w");

// Cloud Function
exports.updateRandomValue = functions.region("asia-northeast3").pubsub.schedule("10 22 * * 7").onRun(async (context) => {
  try {
    // Generate a random alphabet between a and z
    const randomAlphabet = String.fromCharCode(97 + Math.floor(Math.random() * 26));

    // Update the 'qrnum' field in Firestore
    await itemsRef.update({"qrnum": randomAlphabet});

    console.log("'qrnum' updated. Current value: " + randomAlphabet);
  } catch (error) {
    console.error("Error updating 'qrnum':", error);
  }
});
