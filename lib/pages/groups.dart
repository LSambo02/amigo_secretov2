import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amigo_secretov2/pages/create_group.dart';
import 'package:amigo_secretov2/pages/participantesnew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'oAmigo.dart';
import 'sorteioPage.dart';
import 'login.dart';
import '../widgets/LogOutButon.dart';

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

  //_Grupos(_currentUser);
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = grupos.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos'),
        actions: <Widget>[LogOutButton()],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: snapshots,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                return new Expanded(
                    child: ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListTitle(context, snapshot.data.documents[index]),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ));
              })
        ],
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
    Map<dynamic, dynamic> _participantes = document.data['participantes'];
    String group_name = document['nome'].toString();

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
          document['nome'].toString(),
        )),
        onTap: () {
          grupos
              .document(document.documentID)
              .get()
              .then((DocumentSnapshot snapshot) {
            Map<dynamic, dynamic> participantes =
                snapshot.data['participantes'];
            print(participantes.length);
            String docId =
                grupos.document(document.documentID).documentID.toString();
            _getCurrentUser().then((user) {
              print(user);
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
        });
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser();
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }

  logout() {
    _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }
}
