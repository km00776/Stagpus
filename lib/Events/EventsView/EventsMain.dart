import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsController/Interested_events.dart';
import 'package:stagpus/Events/EventsController/upcoming_events_controller.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/Marketplace/ViewMarket/product_card.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/progress.dart';
import 'colors.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class EventsHomePage extends StatefulWidget {
  final User currentUser;
  EventsHomePage({this.currentUser});

  _EventsHomePageState createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  List<Event> eventList;

  @override
  void initState() {
    super.initState();
  }

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
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _notificationCard(),
                      interestedEvents(),
                      InterestedEventCard(),
                      upcomingEvents(),
                      StreamBuilder(
                          stream: eventCollectionRef
                              .document("users")
                              .collection("allEvents")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data == null) {
                              return circularProgress();
                            }
                            List<Event> events = snapshot.data.documents
                                .map((doc) => Event.fromDocument(doc))
                                .toList();
                            return Container(
                                child: SizedBox(
                                    height: 300.0,
                                    child: new ListView.builder(
                                        itemCount: events.length,
                                        itemBuilder: (context, index) =>
                                            new UpcomingEventsCard(
                                                event: events[index]))));
                          })
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWork() {
    return Expanded(
        child: SizedBox(
      height: 200.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        margin: EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1.0,
                blurRadius: 6.0,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFFD9D9D9),
                  backgroundImage: NetworkImage(USER_IMAGE),
                  radius: 36.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Event\n',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'widget.event.eventLocation,',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'widget.event.eventDate,',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: 'widget.event.eventOffer,',
                            style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: purpleGradient,
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight:
                                  36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Interested',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
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
  Widget upcomingEvents() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Events In Your Area',
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

  Widget interestedEvents() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Your Next Event',
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
