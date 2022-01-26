import 'package:flutter/material.dart';

Future<bool> onWillPopForSelectedFile(BuildContext context) async {
  bool dialogAction;
  dialogAction = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Going back would cancel the selected file.'),
              Text('Do you still want to go back?'),
            ],
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
              debugPrint('Pressed Yes');
            },
          ),
          OutlinedButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
              debugPrint('Pressed No');
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
