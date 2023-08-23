import 'package:flutter/material.dart';

import './groups.dart';
import './perfil.dart';

class Pages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Pages();
  }
}

class _Pages extends State {
  int _selectedItem = 0;
  final _paginas = [Grupos(), Perfil()];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: _paginas[_selectedItem],
        backgroundColor: Colors.blueGrey,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (var index) {
            setState(() {
              _selectedItem = index;
            });
          },
          currentIndex: _selectedItem,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Grupos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            )
          ],
        ));
  }
}
