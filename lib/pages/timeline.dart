import 'package:flutter/material.dart';
import 'package:stagpus/Posting/PostingModel/post.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Timeline extends StatefulWidget {
  final User currentUser;
  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  List<Post> posts;
  List<String> followingList = [];
  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }
 
  getTimeline() async {
     QuerySnapshot snapshot = await timelineRef.document(widget.currentUser.uid).collection('timelinePosts').orderBy('timestamp', descending: true).getDocuments();
     List<Post> posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
     setState(() {
       this.posts = posts;
     });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef.document(currentUser.uid).collection('userFollowing').getDocuments();
    setState(()  {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildTimeLine() {
    if (posts == null) {
      return circularProgress();
    }
    else if(posts.isEmpty) {
      return buildUsersToFollow();
    }
    else {
      return ListView(children: posts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream: usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user =  User.fromDocument(doc);
          final bool isAuthUser = currentUser.uid == user.uid;
          final bool isFollowingUser = followingList.contains(user.uid);

          if(isAuthUser) {
            return;
          }
          else if(isFollowingUser) {
            return;
          }
          else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueAccent, Colors.cyan])
      ),          child: Column(children: <Widget>[
        Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_add,
                    color: Colors.black54,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(child:
                  Text(
                    "Users you may be interested in following",
                     style: TextStyle(color: Colors.black54, fontSize: 30.0)
                  ),
                  )
                ],
            ),
            ),
          
            Column(children: userResults,),
          ],
          ),
        );
      },
    );
  }
          




  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeLine(),
      )
    );
  }
}
