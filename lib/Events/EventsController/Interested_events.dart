import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Events/EventsView/colors.dart';
import 'package:stagpus/Map/MapView/MapMain.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';

class InterestedEventCard extends StatefulWidget {
  final User currentUser;
  final Event event;

  const InterestedEventCard({Key key, this.currentUser, this.event})
      : super(key: key);
  _InterestedEventCardState createState() => _InterestedEventCardState();
}

class _InterestedEventCardState extends State<InterestedEventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      margin: EdgeInsets.only(bottom: 20.0),
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
                  text: widget.event.eventOffer,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.event.eventName + '\n',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: widget.event.eventType,
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
              _iconInformation(),
              _iconCancel(),
              _iconEventLocation()
            ],
          )
        ],
      ),
    );
  }

  Column _iconInformation() {
    return Column(children: <Widget>[
      IconButton(
          icon: Icon(LineAwesomeIcons.info_circle),
          padding: EdgeInsets.all(20),
          hoverColor: Colors.green,
          iconSize: 28,
          onPressed: () {},
          color: Colors.black),
      SizedBox(
        height: 8.0,
      ),
      Text(
        "Details",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      )
    ]);
  }

  Column _iconCancel() {
    return Column(children: <Widget>[
      IconButton(
          icon: Icon(LineAwesomeIcons.times_circle),
          padding: EdgeInsets.all(20),
          hoverColor: Colors.green,
          iconSize: 28,
          onPressed: () {
            eventCollectionRef
                .document(currentUser.uid)
                .collection("interestedEvents")
                .document(widget.event.eventId)
                .delete();
            addBackToAllEvents();
          },
          color: Colors.black),
      SizedBox(
        height: 8.0,
      ),
      Text(
        "Cancel",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      )
    ]);
  }

  Column _iconEventLocation() {
    return Column(children: <Widget>[
      IconButton(
          icon: Icon(LineAwesomeIcons.compass),
          padding: EdgeInsets.all(20),
          hoverColor: Colors.green,
          iconSize: 28,
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => SurreyMap(event: widget.event)));
          },
          color: Colors.black),
      SizedBox(
        height: 8.0,
      ),
      Text(
        "Directions",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      )
    ]);
  }

  addBackToAllEvents(
      {String eventLongtitude,
      String eventLatitude,
      String eventName,
      String eventOffer}) {
    eventCollectionRef
        .document('users')
        .collection('allEvents')
        .document(widget.event.eventId)
        .setData({
      "eventName": widget.event.eventName,
      "eventType": widget.event.eventType,
      "eventLocation": widget.event.eventLocation,
      "eventOffer": widget.event.eventOffer,
      "eventId": widget.event.eventId
    });
  }
}
