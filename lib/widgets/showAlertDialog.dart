import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowAlertDialog {
  Widget showAlertDialog(BuildContext context, _title, _content) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: [
        okButton,
      ],
    );
    CupertinoAlertDialog c_alert = CupertinoAlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return kIsWeb
            ? alert
            : Platform.isIOS
                ? alert
                : c_alert;
      },
    );
  }
}
