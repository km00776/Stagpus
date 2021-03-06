import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/header.dart';
import 'package:uuid/uuid.dart';


class CreateAccount extends StatefulWidget {

  
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  bool isUploading = false;
  File file;
  String photoId = Uuid().v4();
     
  

  

  

 

  submit()  {
   final form =  _formKey.currentState;

   if(form.validate()) {
   form.save();
   SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
   _scaffoldKey.currentState.showSnackBar(snackbar);
   Timer(Duration(seconds: 2), () {
         Navigator.pop(context, username);
   });
   }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: "Set up up your profile"),
      body: ListView(children: <Widget>[
        Container(child: Column(children: <Widget>[
         
          Padding(padding: EdgeInsets.only(top: 25.0),
          child: Center( 
            child: Text("Create a username", 
            style:  TextStyle(fontSize: 25.0),),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Form(
                key: _formKey,
                child:TextFormField(
                  validator: (value) {
                      if(value.trim().length < 5 || value.isEmpty) {
                        return "Username must be longer than 5";
                      }
                      else if(value.trim().length > 12) {
                        return "Username must be shorter 12";
                      }
                  },
                  onSaved: (value) => username = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "Must be at least 3 characters",
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: submit,
            child: Container(
              height: 50.0,
              width: 350.0,
              decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(7.0)
            ),
            child: Text(
                "Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold
              ),
            )
            )
          )
        ],),)
      ],)



      );

  }

}
