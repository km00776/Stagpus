const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.onCreateFollower = functions.firestore.document("/followers/{userId}/userFollowers/{followerId}").onCreate( async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followedUserPostRef = admin.firestore().collection('posts').doc(userId).collection('userPosts');
    const timelinePostsRef = admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts');

    const querySnapshot = await followedUserPostRef.get();

    querySnapshot.forEach(doc =>{
        if(doc.exists) {
           const postId =  doc.id;
           const postData = doc.data();
           timelinePostsRef.doc(postId).set(postData); x
        }
    })
});

exports.

exports.onDeleteFollower = functions.firestore.document("/followers/{userId}/userFollowers/{followerId}").onDelete(async (snapshot, context) => {
    console.log("Follower Deleted", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const timelinePostsRef = admin.firestore().collection("timeline").doc(followerId).collection("timelinePosts").where("ownerId", "==", userId);
    const querySnapshot = await timelinePostsRef.get();
    querySnapshot.forEach(doc => {
        if(doc.exists) {
            doc.ref.delete();
        }
    });
});

exports.onCreatePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}').onCreate(async (snapshot, context) => {
    const postCreated = snapshot.data();
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');
    const querySnapshot = await userFollowersRef.get();
    querySnapshot.forEach(doc => {
       const followerId =  doc.id;
        admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).set()
    });
});

exports.onUpdatePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}').onUpdate(async (change, context) =>
{
    const postUpdated = change.after.data();
    const UserId = context.params.userId;
    const postId = context.params.postId;

    const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');

    const querySnapshot = await userFollowersRef.get();

    querySnapshot.forEach(doc => {
        const followerId =  doc.id;
         admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).get().then(doc => {
             if(doc.exists) {
                 doc.ref.update(postUpdated);
             }
         });
     });
});

exports.onDeletePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}').onDelete(async (snapshot,context) => {
    const querySnapshot = await userFollowersRef.get();

    querySnapshot.forEach(doc => {
        const followerId =  doc.id;
         admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).get().then(doc => {
             if(doc.exists) {
                 doc.ref.delete();
             }
         });
     });
});

exports.onCreateActivityFeedItem = functions.firestore.document('/feed/{userId}/feedItems/{activityFeedItem}').onCreate( async (snapshot, context) => {
    console.log('Activity Feed Item Created', snapshot.data());

    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();

    doc.data().androidNotificationToken;
    
    if(androidNotificationToken) {

    } else {
        console.log("No token for user, cannot send notification");
    }

    function sendNotification(androidNotificationToken, activityFeedItem) {
            let body;

        switch(activityFeedItem.type) {
            case "comment":
                body = `${activityFeedItem.username} replied: $ {activityFeedItem.commentData}`;
                break;
            case "like":
                body = `${activityFeedItem.username} started following you`;
                break;
            default:
                break;
        }

        const message = {
            notification: {body},
            token: androidNotificationToken,
            data: {recipient: doc.data().id}
        };

        admin.messaging().send(message).then(response => {
            console.log("Successfully sent message", response);
        })
        .catch(error => {
            console.log("Error sending message", error)
        })
}
})

