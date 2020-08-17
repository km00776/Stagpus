import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String eventType;
  String eventDate;
  String eventImage;
  String eventName;
  String eventVenue;
  String eventOffer;
  String eventDJ;
  String eventLocation;
  String eventId;
  String eventCreator;

  Event(
      {this.eventType,
      this.eventOffer,
      this.eventCreator,
      this.eventName,
      this.eventLocation,
      this.eventId});

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
        eventType: doc['eventType'],
        eventCreator: doc['eventCreator'],
        eventName: doc['eventName'],
        eventLocation: doc['evenLocation'],
        eventOffer: doc['eventOffer'],
        eventId: doc['eventId']);
  }

  Event.fromMap(Map<String, dynamic> map) {
    this.eventType = map['eventType'];
    this.eventDate = map['eventDate'];
    this.eventName = map['eventName'];
    this.eventVenue = map['eventVenue'];
    this.eventOffer = map['eventOffer'];
    this.eventDJ = map['eventDJ'];
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['eventType'] = this.eventType;
    map['eventDate'] = this.eventDate;
    map['eventName'] = this.eventName;
    map['eventVenue'] = this.eventVenue;
    map['eventOffer'] = this.eventOffer;
    map['eventDJ'] = this.eventDJ;

    return map;
  }
}

// note to my myself populate the data from firebase
