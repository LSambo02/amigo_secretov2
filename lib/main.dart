import 'package:amigo_secretov2/pages/create_account.dart';
import 'package:amigo_secretov2/pages/groups.dart';
import 'package:amigo_secretov2/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(Page());

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amigo Secreto',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => CriarUser(),
        '/grupos': (context) => Grupos()
      },
    );
  }
}
