import 'package:firebase_auth/firebase_auth.dart';

String _email;
String _password;


class Register {

 verifyUser() async {
  AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
  FirebaseUser user = result.user;
  user.sendEmailVerification();

}
}