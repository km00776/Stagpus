import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stagpus/Societies/SocietyModel/Society.dart';
import 'package:stagpus/Societies/SocietyView/society_main.dart';

class SocietyDescription extends StatefulWidget {
  final Society society;

  SocietyDescription({this.society});

  @override
  _SocietyDescriptionState createState() => _SocietyDescriptionState();
  
  
    
  }
  
  class _SocietyDescriptionState extends State<SocietyDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget> [
                 Container(
                   padding: EdgeInsets.only(
                     left: 30.0,
                     right: 30.0,
                     top: 60.0,
                   ),
                   height: 520.0,
                   color: Color(0xFF035AA6),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget> [
                       GestureDetector(
                         onTap: () => Navigator.pop(context),
                         child: Icon(
                           Icons.arrow_back,
                           size: 30.0,
                           color: Colors.white,
                         )
                       ),
                     ]
                   ),
                 ),
                 SizedBox(height: 20.0),
                 Text(
                   //currently null
                   "boxing",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 30.0,
                     fontWeight: FontWeight.bold
                   )
                 ),
                 SizedBox(height: 40.0),
                 Text(
                   'FROM',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 15.0,
                   )
                 ),
                 SizedBox(height: 5.0),
                 Text(
                   '20.00',
                 style: TextStyle(
                   color: Colors.white, 
                   fontSize: 25.0,
                   fontWeight: FontWeight.bold,
                 )
              ),
              Positioned(
                right: 20.0,
                bottom: 30.0,
               
              ),
                ],
              ),
              Container(
                height: 400.0,
                transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.0, 
                        right: 30.0,
                        top: 40.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'All to know...',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 10.0),
                            Text(
                                "Gang",
                              style: TextStyle(
                                color: Colors.black87,
                              )
                            )
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 40.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Text('Details',
                            style: TextStyle(
                              fontSize:24.0,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            
                          ]
                          )
                      )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
    
  }