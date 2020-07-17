import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Chat/ChatModel/Contact.dart';
import 'package:stagpus/Chat/ChatModel/Message.dart';
import 'package:stagpus/models/user.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _messageCollection =
      _firestore.collection("messages");
  final CollectionReference _usersCollection = _firestore.collection("users");

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    // Adding messages to the firebase with the collection name 'messages'
    await _firestore
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    //to retrieve the messages from the database (reverse of collection)
    return await _firestore
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) {
    return _firestore.collection("users")
        .document(of)
        .collection("contacts")
        .document(forContact);
  }

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  addToReceiverContacts(
      String senderId, String receiverId, Timestamp currentTime) async {
      DocumentSnapshot receiverSnapshot = await getContactsDocument(of: receiverId, forContact: senderId).get();
  }

  addToSenderContacts(
      String senderId, String receiverId, Timestamp currentTime) async {
      DocumentSnapshot senderSnapshot = await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );
      var receiverMap = receiverContact.toMap(receiverContact);
      await getContactsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    var map = message.toImageMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) {
    return _usersCollection.document(userId).collection("contacts").snapshots();
  }

  Stream<QuerySnapshot> fetchLastMessageBetween({@required String senderId, @required String receiverId,}) 
  {
    return _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
  }
      
}
