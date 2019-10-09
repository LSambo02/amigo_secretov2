import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login.dart';

class LogOutButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LogOutButton();
  }
}

class _LogOutButton extends State<LogOutButton> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Login login = new Login();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Opacity(
      opacity: 0.8,
      child: FlatButton(
        onPressed: () {
          _auth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Login();
          }));
        },
        child: Text(
          'LogOut',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
