import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/Register.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/create_account.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/upload.dart';
import 'package:timeago/timeago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/pages/timeline.dart';
import 'dart:io';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');

User currentUser;
class Home extends StatefulWidget {
   
  
  @override 
  _HomeState createState() => new _HomeState(); // creates an immutable state. 
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging _Messaging = FirebaseMessaging();
  String _email = null;
  String _password = null;
  PageController pageController;
  int pageIndex = 0;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username;



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
       "id" :user.uid,
       "username" : username,
       "photoUrl" : user.photoUrl,
       "email" : user.email,
       "displayName" : username,
       "bio" : "",
       "timestamp" : timestamp
     });

     await followersRef.document(user.uid).collection('userFollowers').document(user.uid).setData({});
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
    
    Widget Drawer(Text text) {
      return Scaffold(
      drawer: Drawer(
          Text('Hello World'),
        ),
      );
    }

    Scaffold dashBoard() {
      return Scaffold(
        key: _scaffoldKey,
        body: PageView(
          children: <Widget>[
            Timeline(currentUser: currentUser,),
            ActivityFeed(),
            Upload(currentUser: currentUser),
            Search(),
            Profile(profileId: currentUser?.uid),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu),),
            BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35.0,),),
            BottomNavigationBarItem(icon: Icon(Icons.search),),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
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

  Future<void> Register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
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
