import 'package:flutter/material.dart';

Future<bool> onWillPopForSelectedFile(BuildContext context) async {
  bool dialogAction;
  dialogAction = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Going back would cancel the selected file.'),
              Text('Do you still want to go back?'),
            ],
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
              print('Pressed Yes');
            },
          ),
          OutlinedButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
              print('Pressed No');
            },
          ),
        ],
      );
    },
  ).then((value) {
    if (value == null || value == false) {
      value = false;
    } else if (value == true) {
      value = true;
    }
    return value;
  });

  return dialogAction;
}