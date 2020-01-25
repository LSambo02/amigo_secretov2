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
    final currentUser = await _auth.currentUser();
    return currentUser.displayName.toString();
  }

  @override
  Future<String> getUser() async {
    await _auth.currentUser().catchError((err) {
      return null;
    });
  }

  @override
  Future<String> getUserPicURL() async {
    final currentUser = await _auth.currentUser();
    return currentUser.photoUrl;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
