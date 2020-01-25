import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  String text, route;
  SecondaryButton(this.text, this.route);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SecondaryButton(text, route);
  }
}

class _SecondaryButton extends State<SecondaryButton> {
  String _text, _route;
  _SecondaryButton(this._text, this._route);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: new Text(_text,
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: () {
        setState(() {
          Navigator.pushReplacementNamed(context, _route);
        });
      },
    );
  }
}
