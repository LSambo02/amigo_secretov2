import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddParticipantes extends StatefulWidget {
  Map<String, String> participantes = new Map();
  String docID;

  AddParticipantes(this.participantes, this.docID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddParticipantes(this.participantes, this.docID);
  }
}

class _AddParticipantes extends State {
  CollectionReference grupos = FirebaseFirestore.instance.collection('grupos');

  Map<String, String> participantes = new Map();
  String _docID;
  _AddParticipantes(this.participantes, this._docID);

  CollectionReference utilizadores =
      FirebaseFirestore.instance.collection('utilizadores');

  int _pressed = 0;
  IconData _outline = Icons.label_outline;
  IconData _label = Icons.label;

  User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _pressed = participantes.length;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> snapshots = utilizadores.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicione participantes'),
        actions: <Widget>[
          Center(
              child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text(_pressed.toString() + ' participantes'))),
        ],
      ),
      body: Column(children: <Widget>[
        StreamBuilder(
            stream: snapshots,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Occorreu um erro');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text("SEM DADOS"),
                );
              }
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) => _buildListTitle(
                          context, snapshot.data.docs[index], index)));
            }),
        Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: ElevatedButton(
                        child: Text('Confirmar'),
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () {
                          _getCurrentUser().then((onValue) {
                            print(onValue);
                            grupos
                                .doc(_docID)
                                .update({'participantes': participantes});
                          });
                          /*FutureBuilder(
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              participantes[snapshot.data.toString()] = '';
                              print(snapshot.data.toString());

                            },
                            future: _getCurrentUser(),
                          );*/
                        }),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildListTitle(
      BuildContext context, DocumentSnapshot document, int index) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return document['username'].toString() != snapshot.data.toString()
            ? ListTile(
                leading: document['profile_picture'] != null
                    ? CircleAvatar(
                        radius: 25,
                        foregroundColor: Colors.blueGrey,
                        child: ClipOval(
                          child: SizedBox(
                            height: 70,
                            width: 55,
                            child: Image.network(
                              document['profile_picture'].toString(),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                        'icon/icon.png',
                        height: 70,
                        width: 55,
                        fit: BoxFit.fill,
                      )),
                trailing:
                    participantes.containsKey(document['username'].toString())
                        ? Icon(_label)
                        : Icon(_outline),
                title: Container(
                    child: Row(
                  children: <Widget>[
                    Text(document['username'].toString()),
                  ],
                )),
                subtitle: Container(
                    child: Row(
                  children: <Widget>[
                    Text(document['nome'].toString() +
                        ' ' +
                        document['apelido'].toString())
                  ],
                )),
                onTap: () {
                  if (!participantes
                      .containsKey(document['username'].toString())) {
                    participantes[document['username'].toString()] = '';
                    _action(index);
                    //_pressed = true;
                  } else {
                    participantes.remove(document['username'].toString());
                    _action(index);
                  }
                })
            : Divider(color: Colors.transparent, height: 0.0);
      },
      future: _getCurrentUser(),
    );
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser;
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }

  _action(int index) {
    //print(participantes.length);
    setState(() {
      _pressed = participantes.length;
    });
  }
}
