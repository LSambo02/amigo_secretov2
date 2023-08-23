import 'package:amigo_secretov2/widgets/showAlertDialogDoubleOption.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  String nomeGrupo;
  List participantes;
  String docID;
  Admin(this.nomeGrupo, this.participantes, this.docID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Admin(nomeGrupo, participantes, docID);
  }
}

class _Admin extends State<Admin> {
  String nomeGrupo;
  List _participantes;
  String _docID;

  _Admin(this.nomeGrupo, this._participantes, this._docID);

  CollectionReference grupos = FirebaseFirestore.instance.collection('grupos');
  User currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, String> empty = new Map();

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> _participantesMap = {};

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
//        title: Text(nomeGrupo),actions: <Widget>[],
          ),
      body: Column(
        children: <Widget>[
          Container(
            child:
                /*grupos.document('icon') != null
                ? Image.network(
                    ,
                    height: 70,
                    width: 55,
                    fit: BoxFit.fill,
                  )
                :*/
                Image.asset('icon/icon.png',
                    fit: BoxFit.fill, height: 70, width: 55),
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.blueGrey)),
          ),
          new Expanded(
            child: ListView.separated(
                itemCount: _participantes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_participantes[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return new Divider(
                    height: 2.0,
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 50.0),
                margin: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                    child: Text('Apagar grupo'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      return ShowAlertDialogDoubleOption().showAlertDialog(
                        context: context,
                        title: 'Deseja mesmo apagar o grupo?',
                        content: 'Esta acção é irreversível!',
                        action1: () {
                          // print('delete');
                          grupos.doc('/$_docID').delete().then((onValue) {
                            Navigator.pushReplacementNamed(context, '/pages');
                            _getCurrentUser().then((onValue) {
                              print(onValue);
                            });
                          });
                        },
                      );
                      //grupos.document('grupos/$_docID').delete();
                      // print(_docID);

                      /*FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        participantes[snapshot.data.toString()] = '';
                        print(snapshot.data.toString());

                      },
                      future: _getCurrentUser(),
                    );*/
                    }),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 50.0),
                child: ElevatedButton(
                    child: Text('Reiniciar grupo'),
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      // _getCurrentUser().then((onValue) {
                      //   print(onValue);
                      _participantesMap = {for (var v in _participantes) v: ''};

                      //empty[admin] = '';
                      //print('El admin: ' + empty.toString());
                      grupos
                          .doc(widget.docID)
                          .update({'participantes': _participantesMap});
                      // });
                      /*FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        participantes[snapshot.data.toString()] = '';
                        print(snapshot.data.toString());

                      },
                      future: _getCurrentUser(),
                    );*/
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _getCurrentUser() async {
    currentUser = await _auth.currentUser;
    //print('Hello ' + currentUser.displayName.toString());
    String username = currentUser.displayName.toString();
    return username;
  }
}
