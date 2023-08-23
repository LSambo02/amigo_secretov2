import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SorteioDep extends StatefulWidget {
  Map<dynamic, dynamic> participantes;
  String docId, groupName, userName;

  SorteioDep(this.groupName, Map<dynamic, dynamic> this.participantes,
      String this.docId, this.userName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SorteioDep(groupName, participantes, docId, userName);
  }
}

class _SorteioDep extends State<SorteioDep> {
  Map<dynamic, dynamic> participantes;
  String docId, _groupName, userName;
  BehaviorSubject<int> selected = BehaviorSubject<int>();

  _SorteioDep(this._groupName, Map<dynamic, dynamic> this.participantes,
      String this.docId, this.userName);

  CollectionReference grupos = FirebaseFirestore.instance.collection('grupos');
  String currentUser;

  final CollectionReference utilizadores =
      FirebaseFirestore.instance.collection("Utilizador");

  Random rndm = new Random();
  List amigos = [];
  String _amigo = '';

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  startTimer(user) async {
    var _duration = new Duration(seconds: 6);
    return new Timer(_duration, () {
      setState(() {
        _amigo = user;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    amigos = getFriend();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List codes = new List.generate(
    //     amigos.length, (_) => rndm.nextInt(amigos.length + 30));
    // codes.shuffle();
    String title = 'Erro de conexão';
    String content = 'Não foi possível concluir a operação';

    List items = participantes.keys.toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Gira a Roleta"),
          /* actions: <Widget>[
            AdminButton(_groupName, participantes.keys.toList(), docId)
          ],*/
        ),
        body: SingleChildScrollView(
          child: Center(
            heightFactor: 0.8,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected.add(
                          Fortune.randomInt(0, amigos.length),
                        );
                        Stream stream = selected.stream;
                        stream.listen((value) {
                          print('Value from controller: ${amigos[value]}');
                          String key = amigos[value];
                          _amigo == ''
                              ? setState(
                                  () {
                                    // _fireUser.getCurrentUser().then((user) {
                                    if (key != userName) {
                                      participantes.update(
                                          userName, (value) => key);
                                      //print(participantes);
                                      grupos.doc(docId).update(
                                          {'participantes': participantes});
                                      startTimer(participantes[userName]);
                                      // Navigator.pushReplacement(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //   return OAmigo(
                                      //       userName, participantes[userName]);
                                      // }));
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
                                    // });
                                  },
                                )
                              : null;
                        });
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: FortuneWheel(
                            animateFirst: false,
                            duration: Duration(seconds: 7),
                            selected: selected.stream,
                            items: [
                              for (var it in amigos)
                                FortuneItem(
                                    child: Text(
                                  it,
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.black),
                                )),
                            ],
                          ),
                        ),
                        _amigo != ""
                            ? RichText(
                                text: TextSpan(
                                    style:
                                        TextStyle(color: Colors.blueGrey[700]),
                                    text: 'O seu Amigo é:\n',
                                    children: [
                                      TextSpan(
                                          text: _amigo,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700))
                                    ]),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        // _chaves.remove(_chaves[i]);
      }
    }
    //print(chave);
    //print(_res);

    return _res;
  }
}
