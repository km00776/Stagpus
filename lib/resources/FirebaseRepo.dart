import 'package:firebase_auth/firebase_auth.dart';
import 'package:stagpus/Chat/ChatModel/Message.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';

class FirebaseRepository {
  FirebaseMethods _method = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _method.getCurrentUser();

  Future<List<User>> fetchAllUsers(FirebaseUser user) =>
      _method.fetchAllUsers(user);

  Future<void> addMessageToDb(Message message, User sender, User receiver) =>
      _method.addMessageToDb(message, sender, receiver);

  Future<List<Product>> fetchAllProducts(Product product) =>
      _method.fetchAllProducts();
}
// returns the respective methods from firebasemethods 