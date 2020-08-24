import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  
@override



Widget build(BuildContext context) {
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
              Text('Any data that is deemed to be sensitive will be processed in accordance with the  ‘Data Protection Act 2018.’ In a scenario in which the Privacy Policy will have any changes, it will be our responsibility to inform you of the changes and the user will be asked to accept the new changes', 
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 20,
                color: Colors.black,
              )
              ),
              Text('To protect your information:,',

              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 20,
                color: Colors.black,
              )
              ),
               Text('Encrypted password using a verified third-party database ‘firebase’ who have a brilliant reputation for handling sensitive data such as passwords. ',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
              Text('Data at no moment will be exposed, as firebase’s networking through a safe HTTPS connection, so data cannot be altered by a third party.',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
              Divider(),
               Text('Your data, we do:',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
              Text('Do not share with third-parties.',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
              Text('Leak for financial gain',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
               Text('Not expose to any individual, besides yourself',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
              Text('Your data, we might:',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
               Text('Send email verification emails:',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
               Text('Change password requests:',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),
               Text('Recommend you to other users & allow other users to find you:',
              style: TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.black,
              )
              ),

             
            ],
            ),
    ),
   
    );
  }

  
}
                

       
   
