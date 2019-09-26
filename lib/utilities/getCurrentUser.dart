import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  FirebaseUser currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Future<FirebaseUser> get _getCurrentUser async {
    currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    return currentUser;
  }

}
