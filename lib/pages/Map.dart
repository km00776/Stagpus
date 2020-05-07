import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}



class _RegisterScreenState extends State<RegisterScreen> {
   String email = null; 
   String password = null;
   String confirmPassword = null;

  @override
  Widget build(BuildContext context) {
     return  Scaffold(
       body: Container(
         color: Colors.black,
         child: Stack(
           children: <Widget>[
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
       Padding(
         padding: EdgeInsets.only(top: 64.0),
         child:  Column (
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget> [
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
       ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:Column(children :<Widget> [
           Padding(
            padding: const EdgeInsets.all(20.0),
             child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Email'),
                        )))
              ],
            ),
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
                          decoration: InputDecoration(hintText: 'Password'),
                        )))
              ],
            ),
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
                          decoration: InputDecoration(hintText: 'Confirm Password'),
                        )))
              ],
            ),
          ),

          ]
          ),
        ),

           ]
         )
       ),
         );
  }
}