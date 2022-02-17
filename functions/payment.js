const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firestore = admin.firestore();
const settings = { timestampInSnapshots: true };
firestore.settings(settings)
const stripe = require('stripe')('sk_test_51HsUZTL7n0XSuhvJ2jGHE7AHNKUWrEwZJS1SeJ5ZCeFAIDzAPgEkO7k3E6sTZqwQKPC6lE5HmE8SJ2XdrbaJYaLm00RZopqRN1');
exports.createPaymentIntent = functions.https.onCall((data, context) => {
    return stripe.paymentIntents.create({
    amount: data.amount,
    currency: data.currency,
    payment_method_types: ['card'],
  });
});