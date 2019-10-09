import 'dart:io';
import 'dart:math';

import 'package:amigo_secretov2/pages/oAmigo.dart';
import 'package:amigo_secretov2/utilities/FireUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final FireUser _fireUser = new CurrentUser();

  final CollectionReference utilizadores =
      Firestore.instance.collection("Utilizador");

  Random rndm = new Random();

  @override
  Widget build(BuildContext context) {
    List codes = new List.generate(
        participantes.length, (_) => rndm.nextInt(participantes.length + 30));
    codes.shuffle();
    String title = 'Erro de conexão';
    String content = 'Não foi possível concluir a operação';

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
                      String key = participantes.keys.elementAt(index);
                      //print(key);
                      return RaisedButton(
                        onPressed: () {
                          setState(
                            () {
                              _fireUser.getCurrentUser().then((user) {
                                if (key != user) {
                                  participantes.update(user, (value) => key);
                                  //print(participantes);
                                  grupos.document(docId).updateData(
                                      {'participantes': participantes});
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return OAmigo(user, participantes[user]);
                                  }));
                                } else {
                                  Platform.isIOS
                                      ? CupertinoAlertDialog(
                                          title: Text(title),
                                          content: Text(content),
                                        )
                                      : AlertDialog(
                                          title: Text(title),
                                          content: Text(content),
                                        );
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              new Text('AS' + codes[index].toString())
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
}
