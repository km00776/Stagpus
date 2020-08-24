import 'dart:async';
import 'dart:collection';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:stagpus/Events/EventsModel/event.dart';

import 'package:stagpus/pages/home.dart';

class SurreyMap extends StatefulWidget {
  @override
  _SurreyMapState createState() => _SurreyMapState();
}

class _SurreyMapState extends State<SurreyMap> {
  bool mapToggle = false;
  bool geraiToggle = false;
  var currentLocation;

  String searchAddress;

  List<Marker> allMarkers = [];

  setMarkers() {
    return allMarkers;
  }

  Widget loadMap() {
    return StreamBuilder(
        stream: eventCollectionRef
            .document('users')
            .collection('allEvents')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading maps");
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            allMarkers.add(new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(
                    snapshot.data.documents[i]['eventCoordinates'].latitude,
                    snapshot.data.documents[i]['eventCoordinates'].longitude),
                builder: (context) => new Container(
                    child: IconButton(
                        icon: Icon(Icons.file_download),
                        color: Colors.deepOrangeAccent,
                        iconSize: 22.0,
                        onPressed: () {
                          print(snapshot.data.documents[i]['eventCreator']);
                        }))));
          }
          return FlutterMap(
            options:
                MapOptions(center: LatLng(51.2362, -0.5704), minZoom: 10.0),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              new MarkerLayerOptions(markers: allMarkers)
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((deviceLocation) {
      setState(() {
        currentLocation = deviceLocation;
        mapToggle = true;
      });
    });
  }

  // Future addMarker() async {
  //   await showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return new SimpleDialog(
  //           title: new Text('Add Marker', style: new TextStyle(fontSize: 17.0)),
  //           children: <Widget>[
  //             new SimpleDialogOption(
  //                 child: new Text('add it',
  //                     style: new TextStyle(color: Colors.blue)),
  //                 onPressed: () {
  //                   addToList();
  //                   Navigator.of(context).pop();
  //                 })
  //           ],
  //         );
  //       });
  // }

  // addToList() async {
  //   final query = "London";
  //   var addresses = await Geocoder.local.findAddressesFromQuery(query);
  //   var first = addresses.first;

  //   setState(() {
  //     allMarkers.add(
  //       new Marker(
  //           width: 45.0,
  //           height: 45.0,
  //           point: new LatLng(
  //               first.coordinates.latitude, first.coordinates.longitude),
  //           builder: (context) => new Container(
  //                   child: IconButton(
  //                 icon: Icon(Icons.ballot_outlined),
  //                 color: Colors.blue,
  //                 iconSize: 45.0,
  //                 onPressed: () {
  //                   print(first.featureName);
  //                 },
  //               ))),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text('Surrey Maps'),
            leading: IconButton(icon: Icon(Icons.add))),
        body: loadMap());
  }
}
