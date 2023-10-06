exports.incrementPrice = functions.firestore
  .document('items/{itemId}')
  .onUpdate((change, context) => {
    // Get the ID of the user who triggered this function
    const userId = context.auth.uid;

    // Get current time
    const currentTime = admin.firestore.Timestamp.now();

    // Update the item in Firestore.
    return change.after.ref.update({
      'lastIncrementedBy': userId,
      'lastIncrementedAt': currentTime,
      'lastIn': currentTime,
      // Add any other fields that should be updated here...
    });
});

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Firestore document reference
const countdownRef = admin.firestore().collection('countdown').doc('timer');

// Cloud Function
exports.startCountdown = functions.pubsub.schedule('every 1 hour').onRun(async (context) => {
  try {
    // Get the current countdown value from Firestore
    const docSnapshot = await countdownRef.get();
    let currentValue = docSnapshot.data().value;

    // Decrement the countdown value by 1 if it's greater than 0
    if (currentValue > 0) {
      currentValue--;
      await countdownRef.update({ value: currentValue });
      console.log(`Countdown decremented. Current value: ${currentValue}`);
    } else {
      console.log("Countdown already reached zero.");
    }
    
  } catch (error) {
    console.error("Error updating countdown:", error);
  }
});