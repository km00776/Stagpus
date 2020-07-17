import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class User {
  String uid;
  String username;
  String email;
  String photoUrl;
  String displayName;
  String bio;
  GeoFirePoint myLocation;

  User({
    this.uid,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.myLocation,
  });

  // maps have a key and value pair the value being the data retrieved from firebase, as a json and then saved into a local variable
  Map toMap(User user) {
    var data = Map<String, dynamic>();
    user.uid = data['uid'];
    user.email = data['email'];
    user.photoUrl = data['photoUrl'];
    user.displayName = data['displayName'];
    user.bio = data['bio'];
    user.myLocation = data['location'];

    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.bio = mapData['bio'];
    this.myLocation = mapData['location'];
  }

// factory keyword used here because it doesn't always create a new instance of its class.
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        uid: doc['uid'],
        email: doc['email'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        myLocation: doc['location']);
  }
}
