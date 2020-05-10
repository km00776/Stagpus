import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   String _email = null;
   String _password = null;
   String _confirmpassword = null;

  RegisterUserService() {}
  
    // state of user logged in or not logged in
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser user) => user?.uid,
  );

  Future<String> createUser(String email, String password) async {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }



  
}