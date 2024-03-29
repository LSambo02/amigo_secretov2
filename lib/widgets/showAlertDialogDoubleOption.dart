import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowAlertDialogDoubleOption {
  //bool isYes;
  showAlertDialog(
      {@required BuildContext context,
      @required title,
      @required content,
      action1(),
      action2()}) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        action1();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        action2();
        Navigator.of(context).pop(false);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [okButton, cancelButton],
    );
    CupertinoAlertDialog c_alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [okButton, cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return kIsWeb
            ? alert
            : !Platform.isIOS
                ? alert
                : c_alert;
      },
    );
    // return isYes;
  }
}
