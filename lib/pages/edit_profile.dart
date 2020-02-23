import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _validBio = true;


  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

Column buildBioField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Text(
          "Bio",
          style: TextStyle(color: Colors.grey),
        ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update bio",
            errorText: _validBio ? null : "Bio too long",
          ),
        ),
    ],
  );
}

updateProfile() {
  setState(() {
    bioController.text.trim().length > 100
    ? _validBio = false : _validBio = true;
  });
  if(_validBio) {
    usersRef.document(widget.currentUserId).updateData(
      {
        "bio" : bioController.text,
      }
    );
    SnackBar snackBar = SnackBar(content: Text("Profile Updated!"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
        style: TextStyle(
          color: Colors.black,
        ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size:30.0,
              color: Colors.green

            )
          )
        ],        
      ),
      body: isLoading ? circularProgress() :
        ListView(
          children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Column(children: <Widget>[
                    buildBioField(),
                  ],)
                  ),
                  RaisedButton(onPressed: () => print('pudate profile data'),
                  child: Text(
                    "Update Profile",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: FlatButton.icon(
                      onPressed: logout,
                       icon: Icon(Icons.cancel, color: Colors.red), 
                       label: Text(
                         "Logout",
                         style: TextStyle(color: Colors.red, fontSize: 20.0),
                       ),
                    ),
                  ),
              ],
              ),
            ),
          ],
        ),
    );       
  }
  }
