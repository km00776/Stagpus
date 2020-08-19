import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  String eventType;
  String eventDate;
  String eventImage;
  String eventName;
  String eventVenue;
  String eventOffer;
  String eventDJ;
  String eventLocation;
  GeoPoint eventCoordinates;
  String eventId;
  String eventCreator;
  String thumbNail;

  Event(
      {this.eventType,
      this.eventOffer,
      this.eventCreator,
      this.eventName,
      this.eventLocation,
      this.eventCoordinates,
      this.eventId,
      this.thumbNail});

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
        eventType: doc['eventType'],
        eventCreator: doc['eventCreator'],
        eventName: doc['eventName'],
        eventLocation: doc['eventLocation'],
        eventCoordinates: doc['eventCoordinates'],
        eventOffer: doc['eventOffer'],
        eventId: doc['eventId'],
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipPGoxAP7eK6C44vSIx4SdhXdp78qiZz2qKp8-o1=w90-h90-n-k-no');
  }

  Event.fromMap(Map<String, dynamic> data) {
    eventType = data['eventType'];
    eventCreator = data['eventCreator'];
    eventName = data['eventName'];
    eventLocation = data['eventLocation'];
    eventCoordinates = data['eventCoordinates'];
    eventOffer = data['eventOffer'];
    eventId = data['eventId'];
  }
}

// note to my myself populate the data from firebase
