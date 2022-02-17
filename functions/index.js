// const functions = require('firebase-functions');
// const admin = require('firebase-admin');

// admin.initializeApp();


// exports.myFunction = functions.firestore
//    .document('chatfornotification/{message}')
//    .onCreate((snapshot, context) => {
//       return admin.messaging().sendToTopic(
//          'chatfornotification', {
//          notification: {
//             title: snapshot.data().name,
//             body: snapshot.data().text,
           
//          }
//       })
//  // clickAction: 'FLUTTER_NOTIFICATION_CLICK',

//    });


const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();




exports.onCreateActivityFeedItem = functions.firestore
.document('/feed/{userId}/feedItems/{activityFeedItem}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();

//check that has notifiation token
    const androidNotificationToken = doc.data().androidNotificationToken;
    const createActivityFeedItem = snapshot.data();

    if(androidNotificationToken)
    {
        sendNotification(androidNotificationToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }
//until here

    function sendNotification(androidNotificationToken, activityFeedItem)
    {
        let body;

        switch (activityFeedItem.type)
        {
            case "comment":
                body = `${activityFeedItem.commentpeoplename} comments: ${activityFeedItem.text}`;
                break;

            case "sendingrequest":
                body = `${activityFeedItem.FromName} sending a request for your uploaded task`;
                break;

            case "acceptrequest":
                body = `${activityFeedItem.FromName} accpeted your request for task`;
                break;

            case "rejectrequest":
                  body = `${activityFeedItem.FromName} rejected your request for task`;
                  break;

            case "completetask":
                    body = `${activityFeedItem.FromName} has complete the task`;
                    break;
            
            case "sendchat":
            body = `${activityFeedItem.FromName} send chat: ${activityFeedItem.text}`;
            break;

            case "sendimage":
            body = `${activityFeedItem.FromName} has send a photo`;
            break;

            case "paymentsendbycustomer":
            body = `${activityFeedItem.FromName} has complete the payment.  Please check`;
            break;
            
            case "canceltaskbysp":
            body = `${activityFeedItem.FromName} has cancel the task.  Please check`;
            break;
            
            case "canceltaskbycustomer":
            body = `${activityFeedItem.FromName} has cancel the task.  Please check`;
            break;

            default:
            break;
        }

        const message =
        {
            notification: { body },
            token: androidNotificationToken,
            data: { recipient: userId },
        };

        admin.messaging().send(message)
        .then(response =>
        {   
           return console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
           return console.log("Error sending message", error);
        })

    }
});




