import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';

class Event {
  String eventType;
  String eventDate;
  String eventImage;
  String eventName;
  String eventVenue;
  String eventOffer;
  String eventDJ;
  String eventLocation;

  Event(
      {this.eventType,
      this.eventDate,
      this.eventImage,
      this.eventOffer,
      this.eventName,
      this.eventVenue,
      this.eventDJ,
      this.eventLocation});


  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
      eventType: doc['eventType'],
      eventDate: doc['eventDate'],
      eventName: doc['EventName'],
      eventVenue: doc['eventVenue'],
      eventOffer: doc['eventOffer'],
      eventDJ : doc['eventDJ'],
      eventLocation: doc['eventLocation']
    );
  }

  Event.fromMap(Map<String, dynamic> map) {
    this.eventType = map['eventType'];
    this.eventDate = map['eventDate'];
    this.eventName = map['eventName'];
    this.eventVenue = map['eventVenue'];
    this.eventOffer = map['eventOffer'];
    this.eventDJ = map['eventDJ'];
    this.eventLocation = map['eventDJ'];
  }

  Map toMap() {
    var map = Map<String, dynamic> ();
    map['eventType'] = this.eventType;
    map['eventDate'] = this.eventDate;
    map['eventName'] = this.eventName;
    map['eventVenue'] = this.eventVenue;
    map['eventOffer'] = this.eventOffer;
    map['eventDJ'] = this.eventDJ;
    map['eventLocation'] = this.eventLocation;

    return map;
  }
}





  


// note to my myself populate the data from firebase
