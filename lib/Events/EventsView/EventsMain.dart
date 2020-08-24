import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsController/Interested_events.dart';
import 'package:stagpus/Events/EventsController/upcoming_events_controller.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Events/EventsView/add_events.dart';
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

 AppBar buildAppBar() {
    return AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Surrey Events"),
        backgroundColor: marketColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.plus_one),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventForm(currentUser: currentUser)));
            },
            color: Colors.amber[300],
          )
        ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: mainBgColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                bgCover(),
                greet(),
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
                      StreamBuilder(
                          stream: eventCollectionRef
                              .document(currentUser.uid)
                              .collection("interestedEvents")
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
                                            new InterestedEventCard(
                                                event: events[index]))));
                          }),
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
                                    height: 200.0,
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

  Container bgCover() {
    return Container(
      height: 260.0,
      decoration: BoxDecoration(
        color: marketColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned greet() {
    return Positioned(
        left: 20,
        bottom: 90,
        child: Column(
          children: <Widget>[
            Text('Hello fellow ' + currentUser.displayName,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Broken down for your ease',
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
        color: marketColor,
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
          "Choose from several upcoming Events!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
