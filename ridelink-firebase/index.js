/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// HTTP version of the cleanup
exports.cleanUpTempRides = functions.https.onRequest(async (req, res) => {
  try {
    const now = Date.now();
    const cutoff = now - 30 * 60 * 1000; // 30 minutes ago

    const snapshot = await admin.firestore()
      .collection("trips")
      .where("createdAt", "<=", cutoff)
      .get();

    const deletes = [];
    snapshot.forEach((doc) => {
      deletes.push(doc.ref.delete());
    });

    await Promise.all(deletes);

    console.log(`Deleted ${deletes.length} temp rides`);
    res.status(200).send(`Deleted ${deletes.length} temp rides`);
  } catch (error) {
    console.error(error);
    res.status(500).send("Cleanup failed: " + error.message);
  }
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
