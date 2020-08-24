import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stagpus/Chat/ChatModel/Message.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/products_screen.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';
import 'package:universal_html/js_util.dart';
import 'package:uuid/uuid.dart';
class FirebaseMethods {
  String productId = Uuid().v4();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _userCollection = _firestore.collection("users");
  final CollectionReference _messageCollection =
      _firestore.collection("messages");
  final CollectionReference _productCollectionRef = _firestore.collection("products");
      final productCollectionRef = Firestore.instance.collection("products");

  // This was intended to be used as the main firebase method screen.

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
    } //products --> users --> userProducts
    return userList;
  }
  

  Future<List<Product>> fetchAllProducts() async {
    List<Product> productList = List<Product>();
    QuerySnapshot querySnapshot = await productCollectionRef.document("users").collection("userProducts").getDocuments();
    for(var i = 0; i < querySnapshot.documents.length; i++) {
      productList.add(Product.fromMap(querySnapshot.documents[i].data));
    }
    return productList;
  }





  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
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

  addProductToFirestore({String id, String price, String mediaUrl, String location, String description, String productName}) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();
    currentUser = User.fromDocument(doc);
    _productCollectionRef
        .document(currentUser.uid)
        .collection("userProducts")
        .document(productId).setData({
          "productId": productId,
          "sellerId": currentUser.uid,
          "username": currentUser.displayName,
          "mediaUrl": mediaUrl,
          "description": description,
          "location": location,
          "timestamp": timestamp,
          "name": productName
        });
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<User> getUserDetailsById(uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(uid).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
