import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/models/user.dart';
import 'home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/post_tile.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:stagpus/widgets/post.dart';
import 'create_account.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final String profileId;
  final User currentUser;
  List<Post> posts = [];
  Profile({Key key, @required this.profileId, @required this.currentUser}): super(key: key);

  @override
  _ProfileState createState() => new  _ProfileState(profileId, currentUser);
}
class _ProfileState extends State<Profile> {
  String postOrientation = "grid";
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts =[];
  String profileId; 
  User currentUser;



  _ProfileState(this.profileId, this.currentUser);

 

getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef.document(profileId).collection('userPosts').orderBy('timestamp', descending: true).getDocuments(); //issue retrieving data osmetimes?
    setState(() {
     isLoading = false;
     posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
     postCount = snapshot.documents.length;
     
    });

  }
 @override
  void initState() {
    super.initState();
    getProfilePosts();
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )
            ),
          alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(5.0)
            )
          )
        )
      );
  }

  
      doesUserExist() async {
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        DocumentSnapshot doc = await usersRef.document(user.uid).get();
        if(!doc.exists){
           final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
           usersRef.document(user.uid).setData({
             "id" :user.uid,
             "username" : username,
             "photoUrl" : currentUser.photoUrl,
             "email" : user.email,
             "displayName" : username,
             "bio" : "",
             "timestamp" : timestamp
           });
        }
        setState(() {
              currentUser = User.fromDocument(doc);
        });        
      }
      
buildProfileButton() {
       return buildButton(text: "Edit Profile", function: editProfile);
    
  }
      
  buildProfileHeader()   {
          return FutureBuilder(
          future: doesUserExist(),
           builder: (context, snapshot) {
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
                                 buildCountColumn("followers", 0),
                                 buildCountColumn("following", 0),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                         currentUser?.email, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                       currentUser.displayName,// currentUser.displayName, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        currentUser.bio, // should be currentName.username
                      ),
                    ),
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

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid' ? Theme.of(context).primaryColor : Colors.grey),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list' ? Theme.of(context).primaryColor : Colors.grey),
      ],
    );

  }

    @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: header(context, titleText: "Profile"),
            body: ListView(
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
          );
        } 
}