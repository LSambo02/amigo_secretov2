import 'package:amigo_secretov2/pages/addChild.dart';
import 'package:amigo_secretov2/utilities/FireUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/LogOutButon.dart';
import 'groups_dependentes.dart';

class Perfil extends StatefulWidget {
  User currentUser;

  //Perfil(currentUser);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Perfil();
  }
}

class _Perfil extends State {
  CollectionReference utilizadores =
      FirebaseFirestore.instance.collection('utilizadores');

  final FireUser _currentUser = new CurrentUser();

  //_Perfil(_currentUser);
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = utilizadores.snapshots();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: <Widget>[
          LogOutButton(),
        ],
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());

                    return snapshot.data != null
                        ? CircleAvatar(
                            radius: 80,
                            foregroundColor: Colors.blueGrey,
                            child: ClipOval(
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: Image.network(
                                  snapshot.data,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 80,
                            foregroundColor: Colors.blueGrey,
                            child: ClipOval(
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: Image.asset(
                                  'icon/icon.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                  },
                  future: _currentUser.getUserPicURL(),
                ),
                FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                          fontFamily: 'KhalidPersonal',
                          color: Colors.black,
                          fontSize: 40),
                    );
                  },
                  future: _currentUser.getCurrentUser(),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15),
            margin: EdgeInsets.only(bottom: 15.0),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0))),
          ),
          StreamBuilder(
              stream: snapshots,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) {
                  return Center(child: Text('ERRO AO CARREGAR DEPENDENTES'));
                }

                // print(snapshot.data.docs);
                return Expanded(
                  child: Column(children: <Widget>[
                    Expanded(
                      child: snapshot.data.docs.length > 0
                          ? ListView.separated(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) => _buildListTitle(
                                context,
                                snapshot.data.docs[index],
                              ),
                              separatorBuilder: (context, index) => Divider(
                                height: 0.0,
                              ),
                            )
                          : Container(
                              child: Text(
                                'Sem Dependentes',
                                style: TextStyle(fontSize: 30),
                              ),
                              margin: EdgeInsets.all(50.0),
                            ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) =>
                              _setFlat(context, snapshot.data.docs[index])
                          /**/
                          ),
                    )
                  ]),
                );
              }),
        ],
      ),
    );
  }

  Widget _setFlat(BuildContext context, DocumentSnapshot document) {
    //Map<dynamic, dynamic> _participantes = document.data['participantes'];
    //print(_participantes.keys);
    String _title = 'Erro de conexão';
    String _content = 'Não foi possível concluir a operação';
    String docID;
    List childs;
    // print(document['username']);

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (document['username'].toString() == snapshot.data.toString()) {
          docID = utilizadores.doc(document.id).id.toString();
          childs = document.get('childs');
          //print(childs);
        }
        return document['username'].toString() == snapshot.data.toString()
            ? TextButton.icon(
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Addchild(docID, childs);
                    }));
                  });
                },
                icon: Icon(Icons.add),
                label: Text('Adicionar dependente'))
            : Divider(color: Colors.transparent, height: 0.0);
      },
      future: _currentUser.getCurrentUser(),
    );
  }

  Widget _buildListTitle(BuildContext context, DocumentSnapshot document) {
    //Map<dynamic, dynamic> _participantes = document.data['participantes'];
    //print(_participantes.keys);
    String _title = 'Erro de conexão';
    String _content = 'Não foi possível concluir a operação';
    // print(document.get('dependencia'));
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('ERRO AO CARREGAR DEPENDENTES'),
          );
        }

        try {
          return document.get('dependencia').toString() ==
                  snapshot.data.toString()
              ? ListTile(
                  leading: document.get('profile_picture') != null
                      ? CircleAvatar(
                          radius: 40,
                          foregroundColor: Colors.blueGrey,
                          child: ClipOval(
                            child: SizedBox(
                              height: 70,
                              width: 55,
                              child: Image.network(
                                document.get('profile_picture'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : ClipOval(
                          child: Image.asset('icon/icon.png',
                              fit: BoxFit.fill, height: 70, width: 55),
                        ),
                  title: Container(
                      child: Text(
                    document.get('username'),
                  )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GruposDep(document.get('username').toString());
                    }));
                  },
                  contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0))
              : Divider(
                  height: 0.0,
                );
        } catch (e) {
          return Divider(
            height: 0.0,
          );
        }

        return Divider(
          height: 0.0,
        );
      },
      future: CurrentUser().getCurrentUser(),
    );
  }
}
