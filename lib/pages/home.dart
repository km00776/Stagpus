import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/activity_feed.dart'; 
import 'package:stagpus/pages/create_account.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/upload.dart';
import 'package:timeago/timeago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/pages/timeline.dart';
import 'dart:io';

import 'Clubs.dart';
import 'Map.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');
Color primaryColor = new Color(0xFF300093);
User currentUser;
class Home extends StatefulWidget {
  @override 
  _HomeState createState() => new _HomeState(); // creates an immutable state. 
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState> ();
  FirebaseMessaging _Messaging = FirebaseMessaging();
  String _email;
  String _password;
  String _confirmPassword; 
  PageController pageController;
  int pageIndex = 0;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username;
  GeoFirePoint location;


  
onPageChanged(int pageIndex) {
      setState(() {
        this.pageIndex = pageIndex;
      });
    }
 onTap(int pageIndex) {
          pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
          );
    }
  
  doesUserExist() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DocumentSnapshot doc = await usersRef.document(user.uid).get();

  if(!doc.exists){
    final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
     usersRef.document(user.uid).setData({
       "uid" : user.uid,
       "username" : username,
       "photoUrl" : user.photoUrl,
       "email" : user.email,
       "displayName" : username,
       "bio" : "",
       "timestamp" : timestamp,
       "location" : location,
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
      pageController.dispose();
      super.dispose();
    }

    Notifications() async {
        final FirebaseUser user =  await FirebaseAuth.instance.currentUser();
        if(Platform.isIOS) getiOSPermission();

        _Messaging.getToken().then((token) {
          print("Firebase Messaging Token: $token\n");
          usersRef.document(user.uid).updateData({"androidNotificationToken" : token});
        });

        _Messaging.configure(
      //    onLaunch: (Map<String, dynamic> message) async {
        //  },
        //  onResume: (Map<String, dynamic> message) async {},
          onMessage: (Map<String, dynamic> message) async {
            print("on message: $message\n");
            final String recipientId = message['data']['recipient'];
            final String body = message['notification']['body'];
            if(recipientId == user.uid) {
              print("Notification!");
              SnackBar snackbar = SnackBar(content: Text(
                body,
                overflow: TextOverflow.ellipsis,
              ));
              _scaffoldKey.currentState.showSnackBar(snackbar);
            }
              print("Notification NOT shown");
          },
        );
    }
    
    getiOSPermission() {
      _Messaging.requestNotificationPermissions(IosNotificationSettings(alert: true, badge: true, sound: true));
      _Messaging.onIosSettingsRegistered.listen((settings) {
        print("Settings registered: $settings");
      });
    }
    Scaffold dashBoard() {
      return Scaffold(
        key: _scaffoldKey,
        body: PageView(
          children: <Widget>[
            Timeline(currentUser: currentUser),
            ActivityFeed(),
            Upload(currentUser: currentUser),
            SurreyMap(),
            Search(),
            Club(),
            Profile(profileId: currentUser?.uid),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: onTap,
          backgroundColor: Colors.blueAccent,
          items: <Widget> [
           Icon(Icons.whatshot, size: 35.0,),
           Icon(Icons.notifications_active, size: 35.0),
           Icon(Icons.photo_camera, size: 35.0,),
           Icon(Icons.map, size: 35.0,),
           Icon(Icons.search, size: 35.0),
           Icon(Icons.extension, size: 35.0),
          Icon(Icons.account_circle, size: 35.0),
          ],
          ),
      );
     
    }

@override
void initState() {
  super.initState();
  pageController = PageController();
  Login();
}

void submit() async {
    final form = formKey.currentState;
    form.save();
    try{
      verifyUser();
       
      }
    catch(e) {
      print(e);
    }
  }


List<Widget> buildButtons() {
    String _submitButtonText = "Submit";
    return [Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
      ),
    )];
  }
      


  
  Widget registerScreen(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
    body: Container(
      color: primaryColor,
      height: _height,
      width: _width,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: _height * 0.05),
            BackButtonWidget(),
            SizedBox(height: _height * 0.05),
            Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: buildInput() + buildButtons(),
              )
            )
          )
          ],
        ),

      )

    ),
    );
  }


  List<Widget> buildInput() {
    List<Widget> textFields = [];

   textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 20,));
    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Password"),
        onSaved: (value) => _password = value,
      )
    );
     textFields.add(SizedBox(height: 20,));
     textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Confirm Password"),
        onSaved: (value) => _confirmPassword = value,
      )
      );
    
    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
  return InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0)),
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
          );
        }




void Register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => registerScreen(context)));
}

 verifyUser() async {
  AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
  FirebaseUser user = result.user;
  user.sendEmailVerification();
    if(!user.isEmailVerified) {
        return buildUnAuthScreen;
    }
    else if (user.isEmailVerified) {
        return dashBoard;
    }
      
  
  }


Future<void> Login() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
      AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);  
      await doesUserExist();
      Navigator.push(context, MaterialPageRoute(builder: (context) => dashBoard()));
      }catch(e) {
        print(e.message);
      }
    }
  }



  
 Scaffold buildUnAuthScreen() {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.teal, Colors.purple])
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            Text('StagPus', 
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white
              ),
            ),
            Form(
              key:_formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty) {
                        return "Field can't be left empty";
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (input){
                      if(input.isEmpty) {                      
                        return "Password can't be left empty";
                      }
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Color.alphaBlend(Colors.blue, Colors.blueGrey),
                        onPressed: () {
                        Login();                          
                    },
                    child: Text('Sign in'),
                  ),
                  SizedBox(width: 290, height: 90),
                  RaisedButton(
                    color: Color.alphaBlend(Colors.blue, Colors.blueGrey),
                    onPressed: () {
                      this.Register();
                    },

                    child: Text('Register'),
                  )
                     ],
                    ),
                ]
              ),
            ),
        ],
    ),
    ),
  );  
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
         child:  Column (
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget> [
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
           backgroundImage: NetworkImage("https://pbs.twimg.com/media/BslJsptIAAEvxtu?format=jpg&name=small"),
         ),
        ),
        SizedBox(height:20),
           ],
         ), 
       );
       
  }
}
