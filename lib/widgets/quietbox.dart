import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stagpus/Chat/ChatView/SearchScreen.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Container(
                color: Color.fromARGB(24, 30, 40, 60),
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("All the contacts will be shown here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                      SizedBox(height: 25),
                      Text(
                          "Search for your friends and family to start calling or chatting with them.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          )),
                      SizedBox(height: 25),
                      FlatButton(
                        color: Colors.lightBlue,
                        child: Text("Start Searching!"),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen())),
                      ),
                    ]))));
  }
}
