import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stagpus/Chat/ChatModel/Message.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';
import 'package:universal_html/js_util.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _userCollection = _firestore.collection("users");
  final CollectionReference _messageCollection =
      _firestore.collection("messages");

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await _firestore.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message, User sender, User receiver) async {
    var map = message.toMap();

    // Adding messages to the firebase with the collection name 'messages'
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    //to retrieve the messages from the database (reverse of collection)
    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<User> getUserDetailsById(uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.document(uid).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}