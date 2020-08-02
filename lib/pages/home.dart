import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:stagpus/Chat/ChatModel/Message.dart';
import 'package:stagpus/Chat/ChatView/ChatBackground.dart';
import 'package:stagpus/Chat/ChatView/ChatScreen.dart';
import 'package:stagpus/Chat/ChatView/SearchScreen.dart';
import 'package:stagpus/Events/EventsView/EventsMain.dart';
import 'package:stagpus/Map/Map.dart';
import 'package:stagpus/Marketplace/ViewMarket/products_screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/sell_screen_form.dart';

import 'package:stagpus/Screens/Reminder.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/create_account.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/upload.dart';
import 'package:timeago/timeago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/pages/timeline.dart';
import 'package:email_validator/email_validator.dart';
import 'package:location/location.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');

const blueg = LinearGradient(
  colors: <Color>[Colors.cyan, Colors.cyanAccent],
  stops: [0.0, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState(); // creates an immutable state.
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  bool _agreePrivacy = false;
  PageController page = PageController();
  int pageIndex = 0;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username;
  GeoFirePoint location;
  var email = "@surrey.ac.uk";

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    page.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  doesUserExist() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      usersRef.document(user.uid).setData({
        "uid": user.uid,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": username,
        "bio": "",
        "timestamp": timestamp,
        "location": location,
      });
      await followersRef
          .document(user.uid)
          .collection('userFollowers')
          .document(user.uid)
          .setData({});

      doc = await usersRef.document(user.uid).get();
    }
    currentUser = User.fromDocument(doc);
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  Scaffold dashBoard() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageView(
        children: <Widget>[
          Timeline(currentUser: currentUser),
          ActivityFeed(),
          SellScreen(currentUser: currentUser),
          SurreyMap(),
          Search(),
          MessageScreen(currentUser: currentUser),
          EventsHomePage(),
          ProductScreen(currentUser: currentUser),
          Profile(profileId: currentUser?.uid),
        ],
        controller: page,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: onTap,
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(
            Icons.whatshot,
            size: 35.0,
          ),
          Icon(Icons.notifications_active, size: 35.0),
          Icon(
            Icons.photo_camera,
            size: 35.0,
          ),
          Icon(
            Icons.map,
            size: 35.0,
          ),
          Icon(Icons.search, size: 35.0),
          Icon(Icons.message, size: 35.0),
          Icon(Icons.extension, size: 35.0),
          Icon(Icons.shopping_basket, size: 35.0),
          Icon(Icons.account_circle, size: 35.0),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    page = PageController();
    login();
  }

  void _setAgreed(bool newValue) {
    setState(() {
      _agreePrivacy = newValue;
    });
  }

  verifyUserDetails() async {
    FirebaseUser user;
    registerKey.currentState.save();
    if (registerKey.currentState.validate()) {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      user = result.user;
      user.sendEmailVerification();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => remind(context)));
    }
  }

  Widget registerScreen(BuildContext context) {
    String results;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Colors.cyan])),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'SurreyConnect',
              style: TextStyle(
                  fontFamily: "Signatra", fontSize: 55.0, color: Colors.black),
            ),
            Form(
              key: registerKey,
              child: Column(children: <Widget>[
                TextFormField(
                  onSaved: (input) => _email = input.trim(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 25.0),
                    labelText: 'Email:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  validator: (input) {
                    if (!(input.contains(email))) {
                      return "Please enter a valid surrey email address";
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (passwordInput) {
                    if (passwordInput.isEmpty) {
                      return "Cannot leave Password Empty";
                    } else if (passwordInput.length < 5) {
                      return "Please enter a password which has more than 5 characters";
                    }
                    results = passwordInput.toString();
                  },
                  onSaved: (passwordInput) => _password = passwordInput,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 25.0),
                      labelText: 'Password:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (confirmPasswordInput) {
                    if (confirmPasswordInput != results) {
                      return "Passwords do not match";
                    }
                  },
                  onSaved: (confirmPasswordInput) =>
                      _confirmPassword = confirmPasswordInput,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 25.0),
                      labelText: 'Confirm Password:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  obscureText: true,
                ),
                SizedBox(width: 300, height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 20, height: 35),
                    Expanded(
                      child: RaisedButton(
                        color: Color.alphaBlend(Colors.cyan, Colors.cyanAccent),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(width: 80, height: 35),
                    Expanded(
                      child: RaisedButton(
                        color: Color.alphaBlend(Colors.cyan, Colors.cyanAccent),
                        onPressed: () {
                          verifyUserDetails();
                        },
                        child: Text('Register'),
                      ),
                    ),
                    SizedBox(height: 10, width: 20),
                  ],
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
                SizedBox(height: 10, width: 10),
                Checkbox(
                  value: _agreePrivacy,
                  onChanged: _setAgreed,
                ),
                GestureDetector(
                  onTap: () => _setAgreed(!_agreePrivacy),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(text: "By clicking register, you agree to our "),
                    TextSpan(
                        text: 'Terms of Services \n',
                        style: TextStyle(color: Colors.yellowAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Terms of Services');
                          }),
                    TextSpan(text: 'and you have read our '),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Colors.yellowAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Privacy Policy');
                          })
                  ])),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildInput() {
    List<Widget> textFields = [];

    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value.trim(),
      ),
    );
    textFields.add(SizedBox(
      height: 20,
    ));
    textFields.add(TextFormField(
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpInputDecoration("Password"),
      onSaved: (value) => _password = value,
    ));
    textFields.add(SizedBox(
      height: 20,
    ));
    textFields.add(TextFormField(
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpInputDecoration("Confirm Password"),
      onSaved: (value) => _confirmPassword = value,
    ));
    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  void register() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => registerScreen(context)));
  }

  Future<void> login() async {
    FirebaseUser user;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      user = result.user;
    }
    if (user.isEmailVerified) {
      await doesUserExist();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => dashBoard()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => remind(context)));
    }
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Colors.cyan])),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'SurreyConnect',
              style: TextStyle(
                  fontFamily: "Signatra", fontSize: 55.0, color: Colors.black),
            ),
            Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (!(input.contains(email))) {
                      return "Please enter a valid surrey email address";
                    }
                  },
                  onSaved: (input) => _email = input.trim(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 25.0),
                    labelText: 'Email:',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Password can't be left empty";
                    }
                  },
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 25.0),
                      labelText: 'Password:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.alphaBlend(Colors.cyan, Colors.cyanAccent),
                      onPressed: () {
                        login();
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(width: 150, height: 90),
                    RaisedButton(
                      color: Color.alphaBlend(Colors.cyan, Colors.cyanAccent),
                      onPressed: () {
                        register();
                      },
                      child: Text('Register'),
                    )
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAuth ? dashBoard() : buildUnAuthScreen();
  }
}

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.blueGrey,
                ],
              ),
            ),
          ),
          Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white60, width: 2.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://pbs.twimg.com/media/BslJsptIAAEvxtu?format=jpg&name=small"),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
