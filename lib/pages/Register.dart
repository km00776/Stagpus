import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Services/RegisterUser.dart';

import 'home.dart';


final primaryColor = const Color(0xFF75A2EA);

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

  
}

class _SignUpScreenState extends State<SignUpScreen> {
    final formKey = GlobalKey<FormState> ();
    String _email;
    String _password;
    String _confirmPassword; 
    PageController pageController;
    int pageIndex = 0; 

  

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
      


  @override
  Widget build(BuildContext context) {
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
 
  void submit() async {
    final form = formKey.currentState;
    form.save();
    try{
      AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
       Home a1 = new Home();
       Navigator.push(context, MaterialPageRoute(builder: (context) => a1.createState().dashBoard()));
      }
    catch(e) {
      print(e);
    }
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