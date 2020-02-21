import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:stagpus/widgets/progress.dart';

import 'create_account.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});

  
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {

  
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

  buildProfileButton() {
    return Text("profile button");
  }
doesUserExist() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DocumentSnapshot doc = await usersRef.document(user.uid).get();
  if(!doc.exists){
     final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
     usersRef.document(user.uid).setData({
       "id" :user.uid,
       "username" : username,
       "photoUrl" : user.photoUrl,
       "email" : user.email,
       "displayName" : username,
       "bio" : "",
       "timestamp" : timestamp
     });
  }
    currentUser = User.fromDocument(doc);
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
                           buildCountColumn("posts", 0),
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
                   currentUser.email, 
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
                  "Text" // should be currentName.username
                ),
              ),
          ],
          ),
        );
      }
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      )
    );
  }    
}