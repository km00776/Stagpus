import 'package:flutter/material.dart';

// by the looks of it we dont need this 
class EventCard extends StatelessWidget {
  final String eventName;
  final String eventImage;
  final String eventType;

  const EventCard({Key key, this.eventName, this.eventImage, this.eventType}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          // When clicked the event should be added to a list of events that the user is interested in 
        }
      )
      
      
      );
  }
  
}