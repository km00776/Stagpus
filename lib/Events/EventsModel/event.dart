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
}
  

var events = [
  Event(eventType: "RnB Night", eventDJ: "DJ Khalid",eventDate:'20 July at : 2:00PM - 4:00PM',eventImage: 'https://futaa.com/images/crops/desktops/20200131B19GNSS0704.JPG', eventLocation: "Rubix", eventName: "Rnb Night With Karhti", eventVenue:  "Rubix", eventOffer: "50%"),
  Event(eventType: "RnB Night", eventDJ: "DJ Khalid",eventDate:'20 July at : 2:00PM - 4:00PM',eventImage: 'https://futaa.com/images/crops/desktops/20200131B19GNSS0704.JPG', eventLocation: "Rubix", eventName: "Rnb Night With Karhti", eventVenue:  "Rubix", eventOffer: "50%"),
  Event(eventType: "RnB Night", eventDJ: "DJ Khalid",eventDate:'20 July at : 2:00PM - 4:00PM',eventImage: 'https://futaa.com/images/crops/desktops/20200131B19GNSS0704.JPG', eventLocation: "Rubix", eventName: "Rnb Night With Karhti", eventVenue:  "Rubix", eventOffer: "50"),
];

// note to my myself populate the data from firebase
