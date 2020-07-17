import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Chat/ChatView/ChatBackground.dart';
import 'package:stagpus/Chat/ChatView/SearchScreen.dart';
import 'package:stagpus/Events/EventsView/MainView.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketBackground.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/timeline.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';
import 'Chat/ChatView/ChatScreen.dart';
import 'Clubs/ViewClubs/ClubBackground.dart';
import 'models/user.dart';

void main() {
  /**  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print("Timestamps enabled in snapshots\n");
  }, onError: (_) {
    print("Error enabling timestamps\n");
  }); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StagPus',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        home: EventsPage());
  }
}
