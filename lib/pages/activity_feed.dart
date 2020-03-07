import 'package:stagpus/pages/post_screen.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/progress.dart';

import 'package:stagpus/pages/home.dart';

class ActivityFeed extends StatefulWidget {
 
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
   getActivityFeed() async {
   QuerySnapshot snapshot =  await activityFeedRef.document(currentUser.uid).collection('feedItems').orderBy('timestamp', descending: true).limit(50).getDocuments();
   List<ActivityFeedItem> feedItems = [];
   snapshot.documents.forEach((doc) {
     print('Activity Feed item: ${doc.data}');
    feedItems.add(ActivityFeedItem.fromDocument(doc));
  });
    return feedItems;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: header(context, titleText: "Activity Feed"),
      body: Container(
          child: FutureBuilder(
            future: getActivityFeed(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return circularProgress();
              }
              return ListView(
                children: snapshot.data,
                );
              }
            )
      )
    );
  }
}

Widget mediaPreview;
String activityitemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });
  
  

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['uid'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  configureMediaPreview(context) {
    if(type == "like" || type == " comment ") {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                )
              )
            )
          )
        )
      );
    } else {
      mediaPreview =  Text('');
    }

    if (type == 'like') {
      activityitemText = "  liked your post";
    }
    else if (type == "follow") {
      activityitemText = " is following you";
    }
    else if (type == "comment") {
      activityitemText = "replied: $commentData";
    }
    else {
      activityitemText = "Error: Unknown type '$type'";
    }
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(profileId: profileId,
    ),
    ),
    );
  }

  showPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(postId: postId, userId: userId,)));
  }
  

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
      color: Colors.white54,
      child: ListTile(
        title: GestureDetector(
          onTap: () => showProfile(context, profileId: userId),
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                text: username,
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '$activityitemText',
                ),
                
              ]
            )
          ),
        ),
         leading: CircleAvatar(
              backgroundColor: Colors.redAccent,
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
 
      ),
      ), 
    );
  }
}
