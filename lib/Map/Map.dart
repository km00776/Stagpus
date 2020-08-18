import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SurreyMap extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        this.currentLocation = currloc;
        mapToggle = true;
        populateClients();
      });
    });
    
  }

  populateClients() {
      clients  = [];
      Firestore.instance.collection('markers').getDocuments();
  }

  initMarker(client) {
    

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
            Container(
                height: 526,
                width: double.infinity,
                child: mapToggle
                    ? GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(target: LatLng(this.currentLocation.latitude, this.currentLocation.longitude),
                      zoom:10.0,
                      ),
                    )
                    : Center(
                        child: Text('Loading... Please wait...',
                            style: TextStyle(fontSize: 20.0)))),
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

 

_getLocationPermission() {
  Location location = new Location();
  try {
    location.requestPermission();
  } on Exception catch(_) {
    print('This was problem allowing location');
  }
}

}
