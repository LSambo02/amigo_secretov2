import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference utilizadores =
      Firestore.instance.collection('utilizadores');

  //_Perfil(_currentUser);
  @override
  Widget build(BuildContext context) {
    Map<String, String> grupos = new Map();
    grupos['grupo1'] = 'drena group';
    grupos['grupo2'] = 'family gathering';
    grupos['grupo3'] = 'gift and party';
    grupos['grupo4'] = 'lets take shots and party, and sure some gifts';
    List gruposName = grupos.keys.toList();
    List gruposDesc = grupos.values.toList();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: <Widget>[LogOutButton()],
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    'icon/icon.png',
                    fit: BoxFit.fill,
                    height: 150,
                    width: 150,
                  ),
                ),
                FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                              fontFamily: 'KhalidPersonal',
                              color: Colors.black,
                              fontSize: 40),
                        );
                      case ConnectionState.none:
                        // TODO: Handle this case.
                        break;
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                        break;
                      case ConnectionState.active:
                        // TODO: Handle this case.
                        break;
                    }
                  },
                  future: _getCurrentUser(),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0))),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: grupos.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.asset(
                  'icon/icon.png',
                  fit: BoxFit.fill,
                  height: 50,
                  width: 50,
                ),
                title: Text(gruposName[index]),
                subtitle: Text(gruposDesc[index]),
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _getCurrentUser() async {
    _currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    String username = _currentUser.displayName.toString();
    return username;
  }
}
