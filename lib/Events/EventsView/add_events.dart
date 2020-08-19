// page only available by the superuser

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Events/EventsView/EventsMain.dart';
import 'package:stagpus/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:image/image.dart' as Im;
import 'package:stagpus/pages/home.dart';

class EventForm extends StatefulWidget {
  final User currentUser;
  final Event event;

  EventForm({Key key, this.currentUser, this.event});

  @override
  _EventFormState createState() => new _EventFormState(currentUser);
}

class _EventFormState extends State<EventForm>
    with AutomaticKeepAliveClientMixin {
  String eventLocationId = Uuid().v4();
  User currentUser;
  _EventFormState(this.currentUser);

  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventVenueController = new TextEditingController();
  TextEditingController eventOfferController = new TextEditingController();
  TextEditingController eventDJController = new TextEditingController();
  TextEditingController eventLocationController = new TextEditingController();
  TextEditingController eventTypeController = new TextEditingController();
  TextEditingController eventDateController = new TextEditingController();
  TextEditingController eventLocationLatitudeController =
      new TextEditingController();
  TextEditingController eventLocationLongtitudeController =
      new TextEditingController();

  String eventId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildEventForm();
  }

  createEventInFirestore(
      {String eventName,
      String eventCreator,
      String eventOffer,
      String eventType,
      String eventLongtitude,
      String eventLatitude,
      String eventLocation,
      String eventDescription}) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();
    currentUser = User.fromDocument(doc);
    await eventCollectionRef
        .document("users")
        .collection("allEvents")
        .document(eventId)
        .setData({
      "eventCreator": currentUser.displayName,
      "eventName": eventName,
      "eventLocation":
          GeoPoint(double.parse(eventLatitude), double.parse(eventLongtitude)),
      "eventOffer": eventOffer,
      "eventType": eventType,
      "eventDescription": eventDescription,
      "eventId": eventId
    });

    eventLocationCollectionRef
        .document(eventId)
        .collection("location")
        .document(eventLocationId)
        .setData({
      "eventId": eventId,
      "eventLocation":
          GeoPoint(double.parse(eventLatitude), double.parse(eventLongtitude)),
      "eventDescription": eventDescription,
      "eventName": eventName,
      "eventOffer": eventOffer
    });
  }

  handleSubmit() async {
    await createEventInFirestore(
        eventName: eventNameController.text,
        eventOffer: eventOfferController.text,
        eventType: eventTypeController.text,
        eventLongtitude: eventLocationLongtitudeController.text,
        eventLatitude: eventLocationLatitudeController.text);
    eventNameController.clear();
    eventOfferController.clear();
    eventTypeController.clear();
    setState(() {
      eventId = Uuid().v4();
      eventLocationId = Uuid().v4();
    });
  }

  Scaffold buildEventForm() {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Text(
            "Dear SuperUser, enter longtitude and latitude so we can add event to maps"),
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
            leading: Icon(Icons.category, color: Colors.greenAccent),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventTypeController,
                    decoration: InputDecoration(
                        hintText: "Event Type:", border: InputBorder.none)))),
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
            leading: Icon(Icons.location_on, color: Colors.red),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventLocationLongtitudeController,
                    decoration: InputDecoration(
                        hintText: "Event Lontitude:",
                        border: InputBorder.none)))),
        Divider(),
        ListTile(
            leading: Icon(Icons.location_on, color: Colors.green),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventLocationLatitudeController,
                    decoration: InputDecoration(
                        hintText: "Event Latitude:",
                        border: InputBorder.none)))),
        Divider(),
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
