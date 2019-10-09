import 'dart:io';

import 'package:amigo_secretov2/pages/participantesnew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/FireUser.dart';
import '../widgets/LogOutButon.dart';
import 'oAmigo.dart';
import 'sorteioPage.dart';

class Grupos extends StatefulWidget {
  FirebaseUser currentUser;

  //Grupos(currentUser);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Grupos();
  }
}

class _Grupos extends State {
  CollectionReference grupos = Firestore.instance.collection('grupos');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser currentUser;
  final FireUser _currentUser = new CurrentUser();

  //_Grupos(_currentUser);
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = grupos.snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('Grupos'), actions: <Widget>[LogOutButton()]),
      body: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: snapshots,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  return new Expanded(
                      child: ListView.separated(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _buildListTitle(
                        context, snapshot.data.documents[index]),
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.1,
                      );
                    },
                  ));
                })
          ],
        ),
        padding: EdgeInsets.only(top: 9, left: 9),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ParticipantesNew();
            }));
          });
        },
        child: Icon(Icons.group),
        tooltip: 'Criar novo grupo',
      ),
    );
  }

  Widget _buildListTitle(BuildContext context, DocumentSnapshot document) {
    //Map<dynamic, dynamic> _participantes = document.data['participantes'];
    //print(_participantes.keys);
    String title = 'Erro de conexão';
    String content = 'Não foi possível concluir a operação';

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return listTile(document, context, snapshot);
          case ConnectionState.none:
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(content),
                  )
                : AlertDialog(
                    title: Text(title),
                    content: Text(content),
                  );
            break;
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(content),
                  )
                : AlertDialog(
                    title: Text(title),
                    content: Text(content),
                  );
            break;
        }
      },
      future: _currentUser.getCurrentUser(),
    );
  }

  Widget listTile(DocumentSnapshot document, BuildContext context,
      AsyncSnapshot<String> snapshot) {
    //print(snapshot.data);
    Map<dynamic, dynamic> _participantes = document.data['participantes'];
    String groupName = document['nome'].toString();

    if (_participantes.containsKey(snapshot.data))
      return ListTile(
          leading: document['icon'] != null
              ? ClipOval(
                  child: Image.network(
                    document['icon'],
                    height: 70,
                    width: 55,
                    fit: BoxFit.fill,
                  ),
                )
              : ClipOval(
                  child: Image.asset('icon/icon.png',
                      fit: BoxFit.fill, height: 70, width: 55),
                ),
          title: Container(
              child: Text(
            groupName,
          )),
          onTap: () {
            grupos
                .document(document.documentID)
                .get()
                .then((DocumentSnapshot snapshot) {
              Map<dynamic, dynamic> participantes =
                  snapshot.data['participantes'];
              //List part = participantes.keys;
              //print(grupos.document(document.documentID).documentID.toString());
              String docId =
                  grupos.document(document.documentID).documentID.toString();
              _currentUser.getCurrentUser().then((user) {
                //print(user);
                if (participantes[user] != '') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OAmigo(user, participantes[user]);
                  }));
                } else
                  //print(participantes[user]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Sorteio(participantes, docId);
                  }));
              });
            });
          },
          contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0));
    else
      return Divider(
        color: Colors.transparent,
        height: 0.0,
      );
  }

  getGroups(DocumentSnapshot document, Map<dynamic, dynamic> _participantes,
      AsyncSnapshot snapshot) {
    List<dynamic> group = new List();
    for (String integrante in _participantes.keys.toList()) {}
  }
}
