import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagpus/Chat/ChatView/ChatBackground.dart';
import 'package:stagpus/Chat/ChatView/SearchScreen.dart';
import 'package:stagpus/Events/EventsView/Listings.dart';
import 'package:stagpus/Societies/SocietyView/society_main.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/timeline.dart';
import 'package:stagpus/widgets/eventCard.dart';
import 'Chat/ChatView/ChatScreen.dart';
import 'Events/EventsView/EventsMain.dart';
import 'Events/EventsView/single_event_widget.dart';
import 'Marketplace/ViewMarket/products_screen.dart';
import 'Provider/user_provider.dart';
import 'Societies/SocietyView/society_description.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StagPus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        home: SocietyDescription());
  }
}
