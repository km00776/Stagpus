// page only available by the superuser
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stagpus/Events/EventsView/EventsMain.dart';
import 'package:stagpus/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:image/image.dart' as Im;
import 'package:stagpus/pages/home.dart';

class EventForm extends StatefulWidget {
  final User currentUser;

  const EventForm({Key key, this.currentUser});

  @override
  _EventFormState createState() => new _EventFormState(currentUser);
}

class _EventFormState extends State<EventForm>
    with AutomaticKeepAliveClientMixin {
  User currentUser;
  _EventFormState(this.currentUser);

  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventVenueController = new TextEditingController();
  TextEditingController eventOfferController = new TextEditingController();
  TextEditingController eventDJController = new TextEditingController();
  TextEditingController eventLocationController = new TextEditingController();
  TextEditingController eventTypeController = new TextEditingController();
  TextEditingController eventDateController = new TextEditingController();
  String eventId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildEventForm();
  }

  createEventInFirestore(
      {String eventName,
      String eventCreator,
      String eventVenue,
      String eventOffer,
      String eventDJ,
      String location,
      String eventType,
      String eventDescription}) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();
    currentUser = User.fromDocument(doc);
    eventCollectionRef
        .document("users")
        .collection("AllEvents")
        .document(eventId)
        .setData({
      "eventCreator": currentUser.displayName,
      "eventName": eventName,
      "eventVenue": eventVenue,
      "eventOffer": eventOffer,
      "eventDJ": eventDJ,
      "eventLocation": location,
      "eventType": eventType,
      "eventDescription": eventDescription
    });
  }

  handleSubmit() async {
    createEventInFirestore(
        eventName: eventNameController.text,
        eventVenue: eventVenueController.text,
        eventOffer: eventOfferController.text,
        eventDJ: eventDJController.text,
        location: eventLocationController.text,
        eventType: eventTypeController.text);

    Navigator.push(context, MaterialPageRoute(builder: (context) => EventsHomePage(currentUser: currentUser)));
  }

  Scaffold buildEventForm() {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ListTile(
            leading:
                Icon(Icons.verified_user, size: 35.0, color: Colors.blueGrey),
            title:
                Container(width: 250.0, child: Text(currentUser.displayName))),
        Divider(),
        ListTile(
          leading: Icon(Icons.pageview, size: 35.0, color: Colors.purpleAccent),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                hintText: "Event name:",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.local_offer, color: Colors.redAccent),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventOfferController,
                    decoration: InputDecoration(
                        hintText: "Event Offer:", border: InputBorder.none)))),
        Divider(),
        ListTile(
            leading: Icon(Icons.account_balance, color: Colors.brown),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventVenueController,
                    decoration: InputDecoration(
                        hintText: "Event Venue:", border: InputBorder.none)))),
        Divider(),
        ListTile(
            leading: Icon(Icons.disc_full, color: Colors.orange),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventDJController,
                    decoration: InputDecoration(
                        hintText: "Event DJ:", border: InputBorder.none)))),
        Divider(),
        ListTile(
            leading: Icon(Icons.location_on, color: Colors.blue),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventLocationController,
                    decoration: InputDecoration(
                        hintText: "Event Location:",
                        border: InputBorder.none)))),
        Divider(),
        ListTile(
            leading: Icon(Icons.category, color: Colors.greenAccent),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventTypeController,
                    decoration: InputDecoration(
                        hintText: "Event Type:", border: InputBorder.none)))),
        Divider(),
        Padding(
          padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                "Add Event",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              color: Colors.blueAccent,
              onPressed: () => handleSubmit()),
        ),
      ],
    ));
  }

  bool get wantKeepAlive => true;
}
