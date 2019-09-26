import 'package:flutter/material.dart';
import '../pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NomeText extends StatefulWidget {

  String hint;
  IconData _icon;
  NomeText(String this.hint, this._icon);


  @override
  State<StatefulWidget> createState() {

    return _NomeText(hint,_icon);
  }
}
class _NomeText extends State<NomeText>{
  String  _hint;
  IconData _icon;
  _NomeText( String this._hint,this._icon);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      // TODO: campo para email
      child: TextField(
        //controller: tFcontroller1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: _hint,
            icon: Icon(
              _icon,
              color: Colors.blueGrey,
            )),
      ),
    );
  }

}


