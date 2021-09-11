import 'package:amigo_secretov2/pages/participantesnew.dart';
import 'package:amigo_secretov2/pages/sorteioPageDep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'oAmigo.dart';

class GruposDep extends StatefulWidget {
  String currentUser;
  GruposDep(this.currentUser);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GruposDep(currentUser);
  }
}

class _GruposDep extends State {
  CollectionReference grupos = FirebaseFirestore.instance.collection('grupos');

  final String _currentUser;

  _GruposDep(this._currentUser);

  //_Grupos(_currentUser);
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = grupos.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos'),
      ),
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
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) =>
                        _buildListTitle(context, snapshot.data.docs[index]),
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
    Map<dynamic, dynamic> _participantes = document.get('participantes');
    String groupName = document['nome'].toString();

    if (_participantes.containsKey(_currentUser))
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
          title: Container(
              child: Text(
            groupName,
            style: TextStyle(fontSize: 18),
          )),
          onTap: () {
            grupos.doc(document.id).get().then((DocumentSnapshot snapshot) {
              Map<dynamic, dynamic> participantes =
                  snapshot.get('participantes');
              //List part = participantes.keys;
              //print(grupos.document(document.documentID).documentID.toString());
              String docId = grupos.doc(document.id).id.toString();
              //print(user);
              if (participantes[_currentUser] != '') {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OAmigo(_currentUser, participantes[_currentUser]);
                }));
              } else
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SorteioDep(
                      groupName, participantes, docId.toString(), _currentUser);
                }));
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
