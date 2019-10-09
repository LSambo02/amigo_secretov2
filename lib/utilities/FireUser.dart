import 'package:firebase_auth/firebase_auth.dart';

abstract class FireUser {
  Future<String> getCurrentUser();
}

class CurrentUser implements FireUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> getCurrentUser() async {
    final currentUser = await _auth.currentUser();
    return currentUser.displayName.toString();
  }
}
