const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.paymentCallback = functions.https.onRequest(async (request, response) => {
  try {
    const callbackData = request.body?.Body?.stkCallback;

    if (!callbackData) {
      throw new Error('Invalid request body structure or missing stkCallback.');
    }

    console.log("Received payload: ", callbackData);

    const responseCode = callbackData.ResultCode;
    const mCheckoutRequestID = callbackData.CheckoutRequestID;

    if (responseCode === 0) {
      // Transaction was successful
      const details = callbackData.CallbackMetadata.Item;

      let mReceipt, mPhonePaidForm, mAmountPaid;

      details.forEach(entry => {
        switch (entry.Name) {
          case "MpesaReceiptNumber":
            mReceipt = entry.Value;
            break;
          case "PhoneNumber":
            mPhonePaidForm = entry.Value;
            break;
          case "Amount":
            mAmountPaid = parseFloat(entry.Value);
            break;
          default:
            break;
        }
      });

      const mEntryDetails = {
        "receipt": mReceipt,
        "phone": mPhonePaidForm,
        "amount": mAmountPaid,
        "timestamp": admin.firestore.FieldValue.serverTimestamp(),
         "status": "Approved"
      };

      // Update or store the payment details in Firestore
      const donationDocRef = admin.firestore().doc(`donations/${mCheckoutRequestID}`);
      await donationDocRef.set(mEntryDetails, { merge: true });

      console.log(`Payment details stored for CheckoutRequestID: ${mCheckoutRequestID}`);
    } else {
      // Transaction failed
      console.log("Failed transaction.");
    }

    response.json({ 'result': `Payment for ${mCheckoutRequestID} response received.` });
  } catch (error) {
    console.error("Error processing payment callback:", error);
    response.status(500).send("Internal Server Error");
  }
});
exports.getTransactionStatus = functions.https.onRequest(async (request, response) => {
  try {
    const checkoutRequestID = request.query.checkoutRequestID;

    if (!checkoutRequestID) {
      throw new Error('Missing checkoutRequestID parameter.');
    }

    const snapshot = await admin.firestore().collection('donations').doc(checkoutRequestID).get();
    const status = snapshot.exists ? snapshot.data().status || 'Pending' : 'Pending';

    response.json({ 'status': status });
  } catch (error) {
    console.error("Error fetching transaction status:", error);
    response.status(500).send("Internal Server Error");
  }
});

// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();

// exports.paymentCallback = functions.https.onRequest(async (request, response) => {
//   try {
//     const callbackData = request.body.Body.stkCallback;

//     console.log("Received payload: ", callbackData);

//     const responseCode = callbackData.ResultCode;
//     const checkoutRequestID = callbackData.CheckoutRequestID;

//     if (responseCode == 0) {
//       const details = callbackData.CallbackMetadata.Item;

//       let receipt, phonePaidFrom, amountPaid;

//       details.forEach(entry => {
//         switch (entry.Name) {
//           case "MpesaReceiptNumber":
//             receipt = entry.Value;
//             break;
//           case "PhoneNumber":
//             phonePaidFrom = entry.Value;
//             break;
//           case "Amount":
//             amountPaid = parseFloat(entry.Value);
//             break;
//           default:
//             break;
//         }
//       });

//       const entryDetails = {
//         "receipt": receipt,
//         "phone": phonePaidFrom,
//         "amount": amountPaid
//       };

//       // Find document matching CheckoutRequestID in donations collection
//       const querySnapshot = await admin.firestore().collection('donations')
//         .where('checkoutRequestID', '==', checkoutRequestID)
//         .get();

//       if (!querySnapshot.empty) {
//         // Update existing donation document
//         const donationDoc = querySnapshot.docs[0];
//         const userId = donationDoc.ref.path.split('/')[1];

//         const userDoc = await admin.firestore().collection('Users').doc(userId).get();
//         const userName = userDoc.exists ? userDoc.data().FullName : 'Unknown User';

//         await donationDoc.ref.update({
//           FullName: userName,
//           amount: amountPaid,
//           phoneNumber: phonePaidFrom,
//           status: "Approved",
//           timestamp: admin.firestore.FieldValue.serverTimestamp()
//         });

//         console.log("Updated donation document:", donationDoc.ref.path);
//       } else {
//         // Create a new document if no matching donation is found
//         console.log("No document found matching the CheckoutRequestID:", checkoutRequestID);
//         await admin.firestore().collection('donations').doc().set({
//           amount: amountPaid,
//           phoneNumber: phonePaidFrom,
//           status: "Approved",
//           timestamp: admin.firestore.FieldValue.serverTimestamp()
//         });
//       }
//     } else {
//       console.log("Failed transaction.");
//     //  await admin.firestore().collection('donations').doc(checkoutRequestID).set({
//     //     status: "Failed",
//     //     timestamp: admin.firestore.FieldValue.serverTimestamp()
//     //   }, { merge: true });
//     // }
//     }

//     response.json({ result: `Payment for ${checkoutRequestID} response received.` });
//   } catch (error) {
//     console.error("Error processing payment callback:", error);
//     response.status(500).send("Internal Server Error");
//   }
// });











