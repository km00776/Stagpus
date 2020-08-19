import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Posting/PostingModel/post.dart';
import 'package:stagpus/Posting/PostingView/post_screen.dart';
import 'package:stagpus/widgets/custom_image.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  showPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(postId: post.postId, userId: post.ownerId,)));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: Container(
                       width: 200,
                       height: 200,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         image: DecorationImage(
                           image: NetworkImage(post.mediaUrl
                           ),
                           fit: BoxFit.fill
                           ),
                       ),
                      )
        
      
    );
    
  }
}
