import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  String text;
  var validateAndSubmit;
  PrimaryButton(this.text, this.validateAndSubmit());
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrimaryButton(text, validateAndSubmit);
  }
}

class _PrimaryButton extends State<PrimaryButton> {
  String _text;
  var _validateAndSubmit;
  _PrimaryButton(this._text, this._validateAndSubmit());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              backgroundColor: Colors.blueGrey,
            ),
            child: new Text(_text,
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
