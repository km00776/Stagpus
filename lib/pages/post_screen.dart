import 'package:flutter/material.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/post.dart';
import 'package:stagpus/widgets/progress.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.document(userId).collection('userPosts').document(postId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                  )
              ],
            )
    )
  );
  }
    );
}
}
