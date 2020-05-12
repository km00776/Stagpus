import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';



  class UserMap extends StatefulWidget {
    State createState() => UserMapState(); 
  }

  class UserMapState extends State<UserMap> {
    
















  @override
  Widget build(BuildContext context) {
      return Stack(children:[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(24.142, -110.321),
            zoom: 15
          ),
          // onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid, 
          compassEnabled: true,
         // trackCameraPosition: true,

        )
      ]);
  }
    
  }

