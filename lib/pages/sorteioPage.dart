import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amigo_secretov2/pages/groups.dart';
import 'package:amigo_secretov2/pages/create_account.dart';
import 'package:amigo_secretov2/pages/login.dart';

//void main() => runApp(AmigoSecreto(""));

class Sorteio extends StatefulWidget {
  Map<dynamic, dynamic> participantes;
  String docId;

  Sorteio(Map<dynamic, dynamic> this.participantes, String this.docId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Sorteio(participantes, docId);
  }
}

class _Sorteio extends State<Sorteio> {
  Map<dynamic, dynamic> participantes;
  String docId;

  _Sorteio(Map<dynamic, dynamic> this.participantes, String this.docId);

  CollectionReference grupos = Firestore.instance.collection('grupos');
  FirebaseUser currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference utilizadores =
      Firestore.instance.collection("Utilizador");

  //List lista() {}

  @override
  Widget build(BuildContext context) {
    //TODO: Passar categoria como parâmetro
    //Stream<QuerySnapshot> snapshots =utilizadores.where('categoria', isEqualTo: categoria).snapshots();
    //print(categoria);

    // Stream<QuerySnapshot> snapshots =
    // utilizadores.snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text("Particpantes"),
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
                child: ListView.builder(
                    itemCount: participantes.length,
                    itemBuilder: (context, index) {
                      String aux = (index+22).toString();
                      String key = participantes.keys.elementAt(index);
                      //print(key);
                      return RaisedButton(
                        onPressed: () {
                          setState(
                            () {
                              _getCurrentUser().then((user) {

                                  if (key != user) {
                                    aux =key;
                                    participantes.update(user, (value)=>key);
                                    print(participantes);
                                    grupos.document(docId).updateData(
                                        {'participantes': participantes});


                                  }

                              });
                            },
                          );
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              new Text((aux).toString())
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(20.0),
                        color: Colors.white,
                      );
                    }))
          ],
        ));
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }
}
