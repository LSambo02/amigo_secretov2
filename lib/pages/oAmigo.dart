import 'package:flutter/material.dart';

class OAmigo extends StatelessWidget {
  String eu;
  String amigo;

  OAmigo(String this.eu, String this.amigo);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('O seu amigo ' + eu),
        actions: <Widget>[
          FlatButton(child: Text(''), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Container(
            child: Text(
          amigo,
          style: TextStyle(fontSize: 40.0),
        )),
      ),
    );
  }
}
