import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/timeline.dart';

import 'Clubs/ViewClubs/ClubBackground.dart';



void main() {
 /**  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print("Timestamps enabled in snapshots\n");
  }, onError: (_) {
    print("Error enabling timestamps\n");
  }); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StagPus',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
