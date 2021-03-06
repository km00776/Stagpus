import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Posting/PostingModel/post.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

// A collection called comment will be created when a post has comments

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  Comments({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });
  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}
class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .document(postId)
            .collection('comments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }
   
  addComment() async  {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();
    currentUser = User.fromDocument(doc);
    Post p1 = new Post(postId: postId, username: postOwnerId,);
    commentsRef.document(p1.postId).collection("comments").add({
      "username": currentUser.displayName,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.uid,
    });
    bool isNotPostOwner = postOwnerId != currentUser.uid;
    if(isNotPostOwner) {
    activityFeedRef.document(postOwnerId).collection("feedItems").add({
      "type" : "comment",
      "commentData" : commentController.text,
      "username" : currentUser.displayName,
      "userId" : currentUser.uid,
      "userProfileImg" : currentUser.photoUrl,
      "postId" : postId,
      "mediaUrl" : postMediaUrl,
      "timestamp" : timestamp,
    });
    }
    commentController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}
class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;
  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundColor: Colors.black12,
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}