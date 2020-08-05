import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Posting/PostingModel/post.dart';
import 'package:stagpus/Posting/PostingView/post_tile.dart';
import 'package:stagpus/Screens/edit_profile.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId; // currentUser.uid;

  Profile({this.profileId});
    
  @override
  _ProfileState createState() => new  _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserUid = currentUser?.uid; 
  bool isFollowing = false;
  String postOrientation = "grid";
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts =[];


  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef.document(widget.profileId).collection('userPosts').orderBy('timestamp', descending: true).getDocuments(); //issue retrieving data osmetimes?
    setState(() {
     isLoading = false;
     posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
     postCount = snapshot.documents.length;
     
    });

  }


checkIfFollowing() async {
   DocumentSnapshot doc = await followersRef.document(widget.profileId).
   collection('userFollowers').
   document(currentUserUid).get();
    setState(() {
      isFollowing = doc.exists;
    });
  }


getFollowers() async {
   QuerySnapshot snapshot =  await followersRef.document(widget.profileId).collection('userFollowers').getDocuments();
   setState(() {
     followerCount = snapshot.documents.length;
   });
  }

getFollowing() async{
   QuerySnapshot snapshot =  await followingRef.document(widget.profileId).collection('userFollowing').getDocuments();
   setState(() {
     followingCount = snapshot.documents.length; 
   });
  }

Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Text(
            label, 
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Container buildButton({String text, Function function}) {
      return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
          onPressed: function,
          child: Container(
            width:250.0,
            height: 27.0,
            child: Text(
              text,
              style: TextStyle(
                color: isFollowing ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              )
            ),
          alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFollowing ? Colors.white: Colors.blue,
              border: Border.all(
                color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(5.0)
            )
          )
        )
      );
  }


    handleUnfollowUsers() {
        setState(() {
          isFollowing = false;
        });
        followersRef.document(widget.profileId).collection('userFollowers').document(currentUser.uid).get().then((doc) {
            if(doc.exists) {
              doc.reference.delete();
            }
        });
        followingRef.document(currentUser.uid).collection('userFollowing').document(widget.profileId).get().then((doc) {
        if(doc.exists) {
          doc.reference.delete();
        }
        });
        activityFeedRef.document(widget.profileId).collection('feedItems').document(currentUser.uid).get().then((doc) {
          if(doc.exists) {
          doc.reference.delete();
        }
        });
     } 

     handleFollowUser() {
        setState(() {
          isFollowing = true;
        });
        followersRef.document(widget.profileId).collection('userFollowers').document(currentUserUid).setData({});
        followingRef.document(currentUser.uid).collection('userFollowing').document(widget.profileId).setData({});
        activityFeedRef.document(widget.profileId).collection('feedItems').document(currentUserUid).setData({
          "type" : "follow",
          "ownerId" : widget.profileId,
          "username" : currentUser.displayName,
          "userId" : currentUser.uid,
          "userProfileImg" : currentUser.photoUrl,
          "timestamp" : timestamp, 
          });
     }

buildProfileButton() {
       bool isProfileOwner = currentUser?.uid == widget.profileId;
       if(isProfileOwner) {
         return buildButton(text: "Edit Profile", function: editProfile);
       }
       
       else if(isFollowing) {
         return buildButton(
           text: "Unfollow", 
           function: handleUnfollowUsers);
       }
       else if(!isFollowing) {
         return buildButton(
           text: "Follow",
           function: handleFollowUser
         );
       }
       else {
         return Text('button');
       }
    
  }
      
  buildProfileHeader()   {
          return FutureBuilder(
          future: usersRef.document(widget.profileId).get(),
           builder: (context, snapshot) {
             if(!snapshot.hasData) {
               return circularProgress();
             }
             User user = User.fromDocument(snapshot.data);
             return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                         radius: 40.0,
                         backgroundColor: Colors.grey, 
                         ),
                         Expanded(
                           flex: 1,
                           child: Column(
                             children: <Widget>[
                             Row(
                               mainAxisSize: MainAxisSize.max,
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                buildCountColumn("posts", postCount),
                                buildCountColumn("followers", followerCount),
                                buildCountColumn("following", followingCount),
                               ],
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 buildProfileButton(),
                                
                                 
                               ],
                             ),
                           ],
                           )
                         )
                      ],
                    ),
                  Row(
                  children: <Widget> [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                         user.email, 
                        
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          ),
                      ),
                    
                    
                    ),
                    
                  
                  ]
                  ),
                  Row(
                    children: <Widget> [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                      user.displayName,// currentUser.displayName, 
                    
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),  
                    ]
                  ),
                  Row(
                    children: <Widget> [
                     Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        user.bio, // should be currentName.username
                      ),
                    ),
                    SizedBox(width: 230.0),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 2.0),
                      child: ChatButton()

                    )

                  ],)

                
                ],
                ),
              );
            }
          );
        }
       
       buildProfilePosts() {
          if(isLoading) {
            return circularProgress();
          }
          else if(postOrientation == "grid") {
          List<GridTile> gridTiles = [];
          posts.forEach((post) { 
            gridTiles.add(GridTile(child:  PostTile(post)));
          });
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: gridTiles,
            );
       }
       else if(postOrientation == "list") {
         return Column(
           children: posts
         );
         
         
       }
       }

         
      
   editProfile() {
       Navigator.push(context, MaterialPageRoute(
          builder: (context) => EditProfile(currentUserId : currentUser?.uid),
          )
        );
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  setColorOrientation() {
    if(postOrientation == 'grid') {
      Theme.of(context).primaryColor == Colors.white;
    }
    else if (postOrientation != 'grid') {
      Theme.of(context).primaryColor == Colors.black;
    }
    if(postOrientation == 'list') {
      Theme.of(context).primaryColor == Colors.white;
    }
    else if (postOrientation != 'list') {
      Theme.of(context).primaryColor == Colors.black;
    }
  
    }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: setColorOrientation(),
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: setColorOrientation(),
        ),
      ],
    );
  }
 
    @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: header(context,  titleText: "Profile", icon: Icon(Icons.message)),
            body: Container(
              decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueAccent, Colors.cyan])
      ),
              child: ListView( 
              children: <Widget>[
              buildProfileHeader(),
              Divider(),
             buildTogglePostOrientation(),
              Divider(
                height: 0.0,
              ),
              buildProfilePosts(),
              ],
            )
            )
          );
        } 
}

class ChatButton extends StatelessWidget {
  final String text;
  final Icon icon;

  const ChatButton({Key key, this.text, this.icon}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Expanded(child:FlatButton(
      color: Colors.white,
      child: Row(
        children: <Widget> [
          Icon(Icons.filter_drama, size: 2.0,),
          Text("Message"),
          
      ]
      ),
      onPressed: () => {


      }
         
    )
    );  
  }


  
}