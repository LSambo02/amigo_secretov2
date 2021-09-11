import 'package:firebase_auth/firebase_auth.dart';

abstract class FireUser {
  Future<String> getCurrentUser();
  Future<String> getUser();
  Future<String> getUserPicURL();
}

class CurrentUser implements FireUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    return currentUser.displayName.toString();
  }

  @override
  Future<String> getUser() async {
    _auth.currentUser;
  }

  @override
  Future<String> getUserPicURL() async {
    final currentUser =  _auth.currentUser;
    return currentUser.photoURL;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
