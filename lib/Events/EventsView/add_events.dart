// page only available by the superuser
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  TextEditingController eventType = new TextEditingController();
  TextEditingController eventDate = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildEventForm();
  }

  createEventInFirestore(
      {String eventName,
      String eventVenue,
      String eventOffer,
      String eventDJ,
      String loction}) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  }

  handleSubmit() async {
    createEventInFirestore();
  }

  Scaffold buildEventForm() {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
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
        ListTile(
            leading: Icon(Icons.category, color: Colors.greenAccent),
            title: Container(
                width: 250.0,
                child: TextField(
                    controller: eventType,
                    decoration: InputDecoration(
                        hintText: "Event Type:",
                        border: InputBorder.none))))
      ],
    ));
  }

  bool get wantKeepAlive => true;
}
