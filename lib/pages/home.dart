import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/pages/create_account.dart';
import 'package:timeago/timeago.dart';
import 'package:stagpus/pages/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/models/user.dart';


final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState(); // creates an immutable state. 
}

class _HomeState extends State<Home> {
  String _email = null;
  String _password = null;
  PageController pageController;
  bool userAuth = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildAuthScreen() {
      return Text('Authenticated');
}


@override
void initState() {
  super.initState();
}
Future<void> Login() async {
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);      
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
                       this.Login();
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
