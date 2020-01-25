import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  String text, val;
  IconData icon;
  bool obscure;
  NameInput(String this.text, this.icon, this.val, this.obscure);

  @override
  State<StatefulWidget> createState() {
    return _NameInput(text, icon, val, obscure);
  }
}

class _NameInput extends State<NameInput> {
  String _text, _val;
  IconData _icon;
  bool _obscure;
  _NameInput(String this._text, this._icon, this._val, this._obscure);
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        key: _formKey,
        obscureText: _obscure,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: _text,
            icon: Icon(
              _icon,
              color: Colors.blueGrey,
            )),
        validator: (value) => value.isEmpty ? 'Insira um nome válido' : null,
        onSaved: (value) => _val = value.trim(),
      ),
    );
  }
}
