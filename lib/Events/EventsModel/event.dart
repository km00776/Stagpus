class EventModel{
  String eventDate;
  String eventType;
  String eventImage;
  String eventName;
  String eventVenue;

 EventModel({
   this.eventDate,
   this.eventType,
   this.eventImage,
   this.eventName,
   this.eventVenue,
 });

}
  var events = [
    EventModel(
     eventDate: '14 Feb at : 8:00PM - 10:00PM',
     eventType: 'Flirt Night',
     eventImage: 'assets/reggae.jpg',
     eventName: 'Reggae SumnFest 2020',
     eventVenue: 'Rubix',
    ),
    EventModel(
     eventDate: '20 May at : 8:00PM - 10:00PM',
     eventType: 'Halloween',
     eventImage: 'assets/reggae.jpg',
     eventName: 'Reggae SumnFest 2020',
     eventVenue: 'Casino',
    ),
    EventModel(
     eventDate: '28 September at : 8:00PM - 10:00PM',
     eventType: 'Reggae',
     eventImage: 'assets/reggae.jpg',
     eventName: 'Reggae SumnFest 2020',
     eventVenue: 'Sports park',
    ),
  ];


