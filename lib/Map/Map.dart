import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SurreyMap extends StatefulWidget {
  @override
  State<SurreyMap> createState() => SurreyMapState();
}

class SurreyMapState extends State<SurreyMap> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
        initialCameraPosition: CameraPosition(
        target: LatLng(51.215485, -0.631027),
        zoom: 12,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      Container(alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: Text("StagPus Maps")
      )
      ],),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

_getLocationPermission() {
  Location location = new Location();
  try {
    location.requestPermission();
  } on Exception catch(_) {
    print('This was problem allowing location');
  }
}


@override
void initState() {
  super.initState();;
   _getLocationPermission();
}
}