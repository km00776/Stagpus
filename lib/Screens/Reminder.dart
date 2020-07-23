 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget remind(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomPadding: false,
       body: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [Colors.blueAccent, Colors.cyan])
         ), 
          alignment:Alignment.topCenter,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: <Widget> [
              Text('Please click the verification email sent!', 
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 65,
                color: Colors.black,
              )
              ),
              RaisedButton(
                color: Color.alphaBlend(Colors.cyan, Colors.cyanAccent),
                onPressed: () {
                    Navigator.pop(context);
                },
                child: Text('Back')
                )
            ],
            ),
    ),
   
    );
  }

  Widget privacy(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomPadding: false,
       body: Container(
         decoration: 
          BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [Colors.blueAccent, Colors.cyan])
         ),
          alignment:Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
          )
         ),
                 

       
    );
  }
