import 'package:flutter/material.dart';

import '../pages/admin.dart';

class AdminButton extends StatefulWidget {
  String nomeGrupo;
  List participantes;
  String docID;
  AdminButton(this.nomeGrupo, this.participantes, this.docID);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminButton(nomeGrupo, participantes, docID);
  }
}

class _AdminButton extends State<AdminButton> {
  String _nomeGrupo;
  List _participantes;
  String _docID;

  _AdminButton(this._nomeGrupo, this._participantes, this._docID);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Opacity(
      opacity: 0.8,
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Admin(_nomeGrupo, _participantes, _docID);
          }));
        },
        child: Text(
          'Detalhes',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
