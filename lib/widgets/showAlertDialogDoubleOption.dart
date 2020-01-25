import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAlertDialogDoubleOption {
  //bool isYes;
  showAlertDialog(
      BuildContext context, _title, _content, _action1(), _action2()) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        _action1();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        _action2();
        Navigator.of(context).pop(false);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: [okButton, cancelButton],
    );
    CupertinoAlertDialog c_alert = CupertinoAlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: [okButton, cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isAndroid ? alert : c_alert;
      },
    );
    // return isYes;
  }
}
