import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/single_event_widget.dart';


// test view notice how singleevent is created do something similar
class Listings extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  List<Event> eventsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              eventSlider()
        ]));
  }

  getEvents() async {
    QuerySnapshot snapshot = await eventCollectionRef.document("users").collection("AllEvents").getDocuments();
    List<Event> events = snapshot.documents.map((doc) => Event.fromDocument(doc)).toList();
    setState(() {
      this.eventsList = events;
    });
  }

  Widget eventSlider() {
    return Expanded(
        child: ListView.builder(
            itemCount: eventsList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var event = eventsList[index];
              return SingleEvent(
                  eventType: event.eventType,
                  eventName: event.eventName,
                  eventVenue: event.eventVenue,
                  eventOffer: event.eventOffer,
                  eventDJ: event.eventDJ,
                  eventLocation: event.eventLocation
                  );
            }));
  }
}
