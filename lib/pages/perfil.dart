import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/LogOutButon.dart';

class Perfil extends StatefulWidget {

  FirebaseUser currentUser;
  //Perfil(currentUser);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Perfil();
  }
}

class _Perfil extends State {

  FirebaseUser _currentUser;

  //_Perfil(_currentUser);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil')
        ,actions: <Widget>[LogOutButton()],
      ),
      body: Center(
        child: ClipOval(child:Text('ok', style: TextStyle(fontSize: 70.0),)),
        ),
      );
  }
}
