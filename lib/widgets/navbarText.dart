import 'package:flutter/material.dart';

import '../pages/login.dart';

class NavBarText extends StatefulWidget {
  String text;

  NavBarText(this.text);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NavBarText(text);
  }
}

class _NavBarText extends State<NavBarText> {
  String _text;
  _NavBarText(this._text);
  Login login = new Login();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      _text,
      style: TextStyle(
          fontWeight: FontWeight.w900, color: Colors.black87, fontSize: 17),
    );
  }
}
