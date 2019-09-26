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
     Map<String,String>grupos = new Map();
     grupos['grupo1'] = 'drena group';
     grupos['grupo2'] = 'family gathering';
     grupos['grupo3'] = 'gift and party';
     grupos['grupo4'] = 'lets take shots and party, and sure some gifts';
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: <Widget>[LogOutButton()],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 80.0,
                  child: Image.asset('icon/icon.png'),
                ),
                Text(
                  'nickname',
                  style: TextStyle(
                      fontFamily: 'KhalidPersonal', color: Colors.black),
                )
              ],
            ),
            heightFactor: 10.0,
            widthFactor: 40.0,
          ),
          ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              title: Text(grupos.keys.toString()),
              subtitle: Text(grupos.values.toString()),

            ),
          )
        ],
      ),
      backgroundColor: Colors.blueGrey,
    );
  }
}
