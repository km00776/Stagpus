import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Screens/comments.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/create_account.dart';
import 'package:stagpus/pages/home.dart';

import 'package:stagpus/widgets/progress.dart';

import 'package:stagpus/widgets/custom_image.dart';


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username : doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes']
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((value) {
      if (value == true) {
        count += 1;
      }
    });
    return count;
  }



  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      location: this.location,
      description: this.description,
      mediaUrl: this.mediaUrl,
      likes : this.likes,
      likeCount: getLikeCount(this.likes),
  );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.uid;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  bool showHeart = false;
  int likeCount;
  Map likes;
  bool isLiked;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });


  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(backgroundColor: Colors.blue),
          title: GestureDetector(
            onTap: () => print("showing"),
            child: Text(
              user.displayName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )
            )
          ),
          subtitle: Text(location),
          trailing: isPostOwner ? IconButton(
            onPressed: () => handleDeletePost(context),
            icon: Icon(Icons.more_vert),
          ) : Text(''),
        );
      }
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Remove this post"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                deletePost();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )
              ),
               SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',
              )
              ),
          ],
        );
      }
    );
  }

  deletePost() async {
    postsRef.document(ownerId).collection('userPosts').document(postId).get().then((doc) {
      if(doc.exists) {
        doc.reference.delete();
      }
    });
    //storageRef.child("post_$postId.jpg").delete();
    QuerySnapshot activityFeedSnapshot = await activityFeedRef.document(ownerId).collection("feedItems").where("postId", isEqualTo: postId).getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if(doc.exists) {
        doc.reference.delete();
      }
     });
     QuerySnapshot commentsSnapshot  = await commentsRef.document(postId).collection('comments').getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if(doc.exists) {
          doc.reference.delete();
      }
     });
  }

  addLikeToActivityFeed() {
    activityFeedRef.document(ownerId).collection("feedItems").document(postId).setData({
      "type" : "like",
      "username" : currentUser.displayName,
      "userId" : currentUser.uid,
      "userProfileImg" : currentUser.photoUrl,
      "postId" : postId,
      "mediaUrl" : mediaUrl,
      "timestamp" : timestamp,
    });
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner) {
    activityFeedRef.document(ownerId).collection("feedItems").document(postId).get().then((doc) {
      if(doc.exists) {
        doc.reference.delete();
      }
    });
    }
  }

   
  handleLikePost() {
      bool _isLiked = likes[currentUserId] == true;
      if(_isLiked) {
        postsRef.document(ownerId).collection('userPosts').document(postId).updateData({'likes.$currentUserId' : false});
        removeLikeFromActivityFeed();
        setState(() {
          likeCount -= 1;
          isLiked = false;
          likes[currentUserId] = false;
        });
      }
      else if (!_isLiked) {
        postsRef.document(ownerId).collection('userPosts').document(postId).updateData({'likes.$currentUserId' : true});
        addLikeToActivityFeed();
        setState(() {
          likeCount += 1;
          isLiked = true;
          likes[currentUserId] = true;
          addLikeToActivityFeed();
        });
        Timer(Duration(microseconds: 500), () {
          setState(() {
            showHeart = false;
          });
        });
      }
  }
  

  buildPostImage() {
    return GestureDetector(
      onTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cachedNetworkImage(mediaUrl),
          showHeart
          ? Animator(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0.8, end: 1.4), 
            curve: Curves.elasticOut,
            cycles: 0,
            builder: (anim) => Transform.scale(
              scale: anim.value,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 80.0,
                color: Colors.pink,
              ),
            ) ,
           )
            : Text(""),
        ],
      )
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top:40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
            GestureDetector(
              onTap: () => showComments(context, postId: postId, ownerId: ownerId, mediaUrl: mediaUrl),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              )
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
              )
            )
          ]
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left:20.0),
              child: Text(
                "$username",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
              ),
              ),
              Expanded(child: Text(description))
          ],
        )
      ],
    );
  }

  showComments(BuildContext context, {String postId, String ownerId, String mediaUrl}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments( 
        postId: postId, // id of the post as each post is stored with a unique id
        postOwnerId: ownerId, // owner of the person who commmented
        postMediaUrl: mediaUrl, //get the url of the picture

      );
  }));
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter()
      ],
    );
  }
}
