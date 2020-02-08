import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    final String uid;
    final String username;
    final String email;
    final String photoUrl;
    final String displayName;
    final String bio;


User({
  this.uid,
  this.username,
  this.email,
  this.photoUrl,
  this.displayName,
  this.bio,
});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio']
    );
  }
}
