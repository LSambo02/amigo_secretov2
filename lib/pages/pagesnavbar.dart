import 'package:flutter/material.dart';
import './groups.dart';
import './perfil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pages extends StatefulWidget {
  FirebaseUser currentUser;

  Pages(this.currentUser);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Pages(currentUser);
  }
}

class _Pages extends State {
  FirebaseUser _currentUser;

  int _selectedItem = 0;
   final _paginas = [Grupos(), Perfil()];

  _Pages(this._currentUser);


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        body: _paginas[_selectedItem],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (var index) {
            setState(() {
              _selectedItem = index;
            });
          },
          currentIndex: _selectedItem,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Grupos')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Perfil')),
          ],
        ));
  }



}
