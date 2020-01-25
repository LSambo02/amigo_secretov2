import 'dart:io';
import 'dart:math';

import 'package:amigo_secretov2/pages/oAmigo.dart';
import 'package:amigo_secretov2/utilities/FireUser.dart';
import 'package:amigo_secretov2/widgets/adminButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sorteio extends StatefulWidget {
  Map<dynamic, dynamic> participantes;
  String docId, groupName, admin;

  Sorteio(this.groupName, Map<dynamic, dynamic> this.participantes,
      String this.docId, this.admin);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Sorteio(groupName, participantes, docId, admin);
  }
}

class _Sorteio extends State<Sorteio> {
  Map<dynamic, dynamic> participantes;
  String docId, _groupName, _admin;

  _Sorteio(this._groupName, Map<dynamic, dynamic> this.participantes,
      String this.docId, this._admin);

  CollectionReference grupos = Firestore.instance.collection('grupos');
  FirebaseUser currentUser;
  final FireUser _fireUser = new CurrentUser();

  final CollectionReference utilizadores =
      Firestore.instance.collection("Utilizador");

  Random rndm = new Random();
  List amigos = [];

  @override
  Widget build(BuildContext context) {
    amigos = getFriend();
    List codes = new List.generate(
        amigos.length, (_) => rndm.nextInt(amigos.length + 30));
    codes.shuffle();
    String title = 'Erro de conexão';
    String content = 'Não foi possível concluir a operação';
    //print(docId);

    return Scaffold(
        appBar: AppBar(
          title: Text("Particpantes"),
          actions: <Widget>[
            AdminButton(_groupName, participantes.keys.toList(), docId)
          ],
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
                child: ListView.separated(
              itemCount: amigos.length,
              itemBuilder: (context, index) {
                String key = amigos[index];
                //String value = participantes.values.elementAt(index);
                //print(key);
                return FlatButton(
                  onPressed: () {
                    setState(
                      () {
                        _fireUser.getCurrentUser().then((user) {
                          if (key != user) {
                            participantes.update(user, (value) => key);
                            //print(participantes);
                            grupos
                                .document(docId)
                                .updateData({'participantes': participantes});
                            Navigator.pushReplacement(context,
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
                  child: Row(
                    children: <Widget>[
                      Text('AS' + codes[index].toString()),
                    ],
                  ),
                  padding: EdgeInsets.all(20.0),
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
            ))
          ],
        ));
  }

  List getFriend() {
    List _chaves = participantes.keys.toList(),
        _amigos = participantes.values.toList();
    List _res = [];
    /*print(_chaves.length);
    print(_amigos.length);
    print(_chaves);
    print(_amigos);*/

    for (int i = 0; i < _chaves.length; i++) {
      if (!_amigos.contains(_chaves[i])) {
        _res.add(_chaves[i]);
        //print(_chaves[i]);
        //_chaves.remove(_chaves[i]);
      }
    }
    //print(chave);
    //print(_res);

    return _res;
  }
}
