import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blueAccent,
      body: ListView(
        children: <Widget>[
        
          BackButtonWidget(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Username'),
                        )))
              ],
            ),
          ),
  
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Password'),
                        )))
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.mail), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Confirm Password'),
                        )))
              ],
            ),
          ),
         SizedBox(height: 40,),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: <Widget>[
               Radio(value: null, groupValue: null, onChanged: null),
               RichText(text: TextSpan(
                 text: 'I have accepted the ',
                 style: TextStyle(color: Colors.black),
                 children: [
                   TextSpan(text: 'Terms & Condition',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold))
                 ]
               ))
             ],
           ),
         ),
         SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Home');
                    },
                    color: Colors.lightBlueAccent,
                    child: Text(
          'SIGN UP',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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