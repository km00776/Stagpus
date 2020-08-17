import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Events/EventsView/colors.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class UpcomingEventsCard extends StatefulWidget {
  final Event event;

  const UpcomingEventsCard({Key key, this.event}) : super(key: key);

  UpcomingEventsCardState createState() => UpcomingEventsCardState();
}

class UpcomingEventsCardState extends State<UpcomingEventsCard> {
  TextSpan evenTypeText;
  TextSpan eventNameText;
  TextSpan eventOfferText;
  String eventId = Uuid().v4();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen

    return Container(
      
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
                          eventOfferText = TextSpan(
                            text: widget.event.eventOffer + "\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          evenTypeText = new TextSpan(
                            text: widget.event.eventType + "\n",
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                          eventNameText = TextSpan(
                            text: widget.event.eventName,
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
                          child: FlatButton(
                            child: Text(
                              'Interested',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                            onPressed: () => handleInterestButton(),
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
    );
  }

  addToInterestedEvent(
      {String eventLocation, String eventType, String eventName, String eventLongtitude, String eventLatitude, String eventOffer, String description}) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();
    currentUser = User.fromDocument(doc);
    eventCollectionRef
        .document(currentUser.uid)
        .collection("interestedEvents")
        .document(eventId)
        .setData({
      "eventCreator": currentUser.displayName,
      "eventName": eventName,
      "eventLongtitude" : eventLongtitude,
      "eventLatitude" : eventLatitude, 
      "eventOffer": eventOffer,
      "eventType": eventType,
      "eventDescription": description,
      "eventId": eventId
    });
    eventCollectionRef
        .document('users')
        .collection("allEvents")
        .document(widget.event.eventId)
        .delete();
  }

  handleInterestButton() {
    addToInterestedEvent(
        eventOffer: eventOfferText.toPlainText(),
        eventType: evenTypeText.toPlainText(),
        eventName: eventNameText.toPlainText());
  }
}

// note this is the text
