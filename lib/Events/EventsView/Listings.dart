import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/widgets/single_event_widget.dart';

class Listings extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
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

  Widget eventSlider() {
    return Expanded(
        child: ListView.builder(
            itemCount: events.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var event = events[index];
              return SingleEvent(
                  eventDate: event.eventDate,
                  eventType: event.eventType,
                  eventImage: event.eventImage,
                  eventName: event.eventName,
                  eventVenue: event.eventVenue,
                  eventOffer: event.eventOffer,
                  eventDJ: event.eventDJ,
                  eventLocation: event.eventLocation
                  );
            }));
  }
}
