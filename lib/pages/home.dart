import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/pages/create_account.dart';
import 'package:timeago/timeago.dart';
import 'package:stagpus/pages/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/models/user.dart';


final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState(); // creates an immutable state. 
}

class _HomeState extends State<Home> {
  String _email = null;
  String _password = null;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildAuthScreen() {
      return Text('Authenticated');
}

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
        "displayName" : user.displayName,
        "bio" : "",
        "timestamp" : timestamp

      });
      
      doc = await usersRef.document(user.uid).get();
    }

    currentUser = User.fromDocument(doc);

}


@override
void initState() {
  super.initState();
  Login();

 
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
                      //  Login();
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
      return userAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  
  
}
