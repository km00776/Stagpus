import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsController/Interested_events.dart';
import 'package:stagpus/Events/EventsController/upcoming_events_controller.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/progress.dart';
import 'colors.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class EventsHomePage extends StatefulWidget {
  final User currentUser;

  const EventsHomePage({Key key, this.currentUser}) : super(key: key);

  _EventsHomePageState createState() => _EventsHomePageState();
}



class _EventsHomePageState extends State<EventsHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                _backBgCover(),
                _greetings(),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _notificationCard(),
                   _nextAppointmentText(),
                   StreamBuilder(
                   stream: eventCollectionRef.document("users").collection("AllEvents").snapshots(),
                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                     if(snapshot.data == null) {
                       return circularProgress();
                     }
                    List<Event> events = snapshot.data.documents.map((doc) => Event.fromDocument(doc)).toList();
                    return Container(
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) => UpcomingEventsCard(
                          event: events[index]
                        ),
                      
                      ),
                    ); 
                   }
                   ),
                   InterestedEventCard()
                
               
                
                    

                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getEvents() async {
    
  }

  

  Container _backBgCover() {
    return Container(
      height: 260.0,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned _greetings() {
    return Positioned(
        left: 20,
        bottom: 90,
        child: Column(
          children: <Widget>[
            Text('Hi' + currentUser.displayName,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'How are you feeling today ?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }



  // note this is the text
  Widget _areaSpecialistsText() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Specialist In Your Area',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: midColor,
            ),
          ),
        ],
      ),
    );
  }

  Container _notificationCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        // gradient: redGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          LineAwesomeIcons.calendar_check_o,
          color: Colors.white,
          size: 32,
        ),
        title: Text(
          "Event Booked!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: OutlineButton(
          onPressed: () {},
          color: Colors.transparent,
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            'Review & Add Notes',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

 

  Widget _nextAppointmentText() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Your Next Appointment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: midColor,
            ),
          ),
        ],
      ),
    );
  }
}
