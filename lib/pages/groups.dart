import 'package:amigo_secretov2/pages/participantesnew.dart';
import 'package:amigo_secretov2/widgets/showAlertDialog.dart';
import 'package:amigo_secretov2/widgets/showAlertDialogDoubleOption.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/FireUser.dart';
import '../widgets/LogOutButon.dart';
import 'addParticipantes.dart';
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

  final FireUser _currentUser = new CurrentUser();

  var admin;

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
                    return Container(
                        margin: EdgeInsets.all(160.0),
                        child:
                            const Center(child: CircularProgressIndicator()));
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
    String _title = 'Erro de conexão';
    String _content = 'Não foi possível concluir a operação';

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return listTile(document, context, snapshot);
          case ConnectionState.none:
            return ShowAlertDialog().showAlertDialog(context, _title, _content);
            break;
          case ConnectionState.waiting:
            return Container();
            break;
          case ConnectionState.active:
            return ShowAlertDialog().showAlertDialog(context, _title, _content);
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
    String docId = grupos.document(document.documentID).documentID.toString();
    Map<String, String> empty = new Map();
    String admin = document['admnistrador'].toString();
    var empty2;

    if (_participantes.containsKey(snapshot.data))
      return ListTile(
          leading: document['icon'] != null
              ? CircleAvatar(
                  radius: 25,
                  foregroundColor: Colors.blueGrey,
                  child: ClipOval(
                    child: SizedBox(
                      height: 70,
                      width: 55,
                      child: Image.network(
                        document['icon'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 10,
                  child: ClipOval(
                    child: SizedBox(
                      height: 70,
                      width: 55,
                      child: Image.asset(
                        'icon/icon.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
          trailing: admin == snapshot.data
              ? PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: (result) {
                    setState(() {
                      if (result == 1) {
                        _participantes.forEach((k, v) => empty[k] = '');
                        //empty[admin] = '';
                        //print('El admin: ' + empty.toString());
                        grupos
                            .document(docId)
                            .updateData({'participantes': empty});
                      } else if (result == 2) {
                        return ShowAlertDialogDoubleOption().showAlertDialog(
                            context,
                            'Deseja mesmo apagar o grupo?',
                            'Esta acção é irreversível!',
                            deleteGroup(docId),
                            () {});
                      } else if (result == 3) {
                        /*if (showAlertDialogDB.showAlertDialog(
                                context,
                                'Deseja retirar todos os amigos secretos?',
                                'Adicionar novos Participantes implica todos ficarem sem amigos') ==
                           true) {*/
                        _participantes.forEach((k, v) => empty[k] = '');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddParticipantes(empty, docId);
                        }));
                        //print('ok');
                        // Navigator.of(context).pop();
                        //}
                      }
                      //print('El admin: ' + admin);
                      // grupos.document(docId).updateData({'participantes': empty2});
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(child: Text('Reiniciar Grupo'), value: 1),
                        PopupMenuItem(
                          child: Text('Apagar Grupo'),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text('Adicionar Participantes'),
                          value: 3,
                        )
                      ])
              : Container(
                  height: 0,
                  width: 0,
                ),
          title: Container(
              child: Text(
            groupName,
            style: TextStyle(fontSize: 18),
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

              _currentUser.getCurrentUser().then((user) {
                //print(user);
                if (participantes[user] != '') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OAmigo(user, participantes[user]);
                  }));
                } else
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Sorteio(
                        groupName, participantes, docId.toString(), admin);
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

  deleteGroup(docID) {
    grupos.document(docID).delete();
  }

  getGroups(DocumentSnapshot document, Map<dynamic, dynamic> _participantes,
      AsyncSnapshot snapshot) {
    List<dynamic> group = new List();
    for (String integrante in _participantes.keys.toList()) {}
  }
}
