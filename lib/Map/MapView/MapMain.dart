import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stagpus/Events/EventsModel/event.dart';
import 'package:stagpus/Map/MapModel/map.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/progress.dart';

class SurreyMap extends StatefulWidget {
  String eventId;

  SurreyMap({Key key, this.eventId}) : super(key: key);

  @override
  State<SurreyMap> createState() => SurreyMapState();
}

class SurreyMapState extends State<SurreyMap> {
  var clients = [];
  GoogleMapController mapController;
  String searchAddress;
  bool mapToggle = false;
  var currentLocation;
  Position pos;
  List<Marker> allMarkers = [];
  PageController _pageController;
  int prevPage;
  List<Map> places = [];

  @override
  void initState() {
    super.initState();
    getPlaces();

    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        this.currentLocation = currloc;
        mapToggle = true;
        // populateClients();
      });
    });


    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  getPlaces() async {
    QuerySnapshot snapshot = await eventCollectionRef
        .document(u)
        .collection('location')
        .getDocuments();
    List<Map> places = snapshot.documents.map((doc) => Map.fromDocument(doc)).toList();
     places.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.eventName),
          draggable: false,
          infoWindow: InfoWindow(
              title: element.eventName, snippet: element.description),
          position: element.eventLocationCoords 
      ));
    });
  }

  _eventPlaceList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(places[index].thumbNail),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  places[index].eventName,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  places[index].description,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    places[index].description,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surrey Maps"),
      ),
      body: Column(children: <Widget>[
        Stack(
          children: <Widget>[
           StreamBuilder(
             stream: eventLocationCollectionRef.document("test123").collection("location").snapshots(),
             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if(snapshot.data == null) {
                 return circularProgress();
               }
               List<Map> places = snapshot.data.documents.map((doc) => Map.fromDocument(doc)).toList();
              } ),
             
            Container(
              height: 526,
              width: double.infinity,
              child: mapToggle
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(this.currentLocation.latitude,
                            this.currentLocation.longitude),
                        zoom: 10.0,
                      ),
                      markers: Set.from(places),
                      onMapCreated: onMapCreated,
                    )
                  : Center(
                      child: Text('Loading... Please wait...',
                          style: TextStyle(fontSize: 20.0))),
            ),
            Positioned(
                bottom: 20.0,
                child: Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: places.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _eventPlaceList(index);
                        }))),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Event Address',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: searchAndNavigate,
                            iconSize: 30.0)),
                    onChanged: (val) {
                      setState(() {
                        searchAddress = val;
                      });
                    },
                  )),
            ),
          ],
        ),
      ]),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((addressResult) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(addressResult[0].position.latitude,
              addressResult[0].position.longitude),
          zoom: 10.0)));
    });
  }

  moveCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: places[_pageController.page.toInt()].eventLocationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  _getLocationPermission() {
    Location location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('This was problem allowing location');
    }
  }
}
