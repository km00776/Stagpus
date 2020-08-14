import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Events/EventsView/colors.dart';
import 'package:stagpus/models/user.dart';

class InterestedEventCard extends StatefulWidget {
  final User currentUser;
  final Event event;

  const InterestedEventCard({Key key, this.currentUser, this.event}) : super(key: key);

  _InterestedEventCardState createState() => _InterestedEventCardState();
  
    
  }
  
  class _InterestedEventCardState extends State<InterestedEventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
                backgroundImage: NetworkImage(USER_IMAGE),
                radius: 36.0,
              ),
              RichText(
                text: TextSpan(
                  text: 'Dr Dan MlayahFX',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\nSunday,May 5th at 8:00 PM',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(
                      text: '\n570 Kyemmer Stores \nNairobi Kenya C -54 Drive',
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            color: Colors.grey[200],
            height: 3,
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _iconBuilder(LineAwesomeIcons.info_circle, 'Details'),
              _iconBuilder(LineAwesomeIcons.times_circle, 'Cancel'),
              _iconBuilder(LineAwesomeIcons.calendar_times_o, 'Calender'),
              _iconBuilder(LineAwesomeIcons.compass, 'Directions'),
            ],
          )
        ],
      ),
    );
  }


  Column _iconBuilder(icon, title) {
    return Column(children: <Widget>[
      IconButton(
          icon: Icon(icon),
          padding: EdgeInsets.all(20),
          hoverColor: Colors.green,
          iconSize: 28,
          onPressed: () {},
          color: Colors.black),
      SizedBox(
        height: 8.0,
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      )
    ]);
  }
}