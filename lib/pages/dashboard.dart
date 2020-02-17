
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/timeline.dart';
import 'package:stagpus/pages/upload.dart';

import 'create_account.dart';
import 'home.dart';


final postsRef = Firestore.instance.collection('posts');
final usersRef = Firestore.instance.collection('users');

  User currentUser;
class dashboard extends StatefulWidget {







  @override
  _dashboardState createState() => _dashboardState();
}


class _dashboardState extends State<dashboard> {
  String _email = null;
  String _password = null;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageController pageController = null;
  int pageIndex = 0;


createUserInFirestore() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
   DocumentSnapshot doc = await usersRef.document(user.uid).get();

  if(!doc.exists) {
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount(),));

     usersRef.document(user.uid).setData({
        "uid" : user.uid,
        "username" : username,
        "photoUrl" : user.photoUrl,
        "email" : user.email,
        "displayName" : username,
        "bio" : "",
        "timestamp" : timestamp

      });
      
      doc = await usersRef.document(user.uid).get();
    }
    User currentUser = User.fromDocument(doc);
}


Future<void> Login() async {
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      createUserInFirestore();
      Navigator.push(context, MaterialPageRoute(builder:(context) =>dashboard()));
      }catch(e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        return dashBoard();
    }

  @override
    void initState(){
        super.initState();
        Login();
        pageController = PageController();
        

    }

    void onPageChanged(int pageIndex) {
      setState(() {
        this.pageIndex = pageIndex;
      });
    }
     void onTap(int pageIndex) {
          pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
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
                       Login();
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

    Scaffold dashBoard() {
      return Scaffold(
        body: PageView(
          children: <Widget>[
            Timeline(),
            ActivityFeed(),
            Upload(currentUser: currentUser),
            Search(),
            Profile(),
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
            BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35.0,),),
            BottomNavigationBarItem(icon: Icon(Icons.search),),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
          ],
          ),
      );
    }

    
}