import 'package:flutter/material.dart';
import 'package:files_tools/app_theme/app_theme.dart';

Widget progressFakeDialogBox = SafeArea(
  child: Scaffold(
    backgroundColor: Colors.black54,
    body: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
        ),
        height: 200,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircularProgressIndicator(),
            // SizedBox(
            //   height: 20,
            // ),
            Text(
              'Processing Data\n\nPlease Wait...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 0.0,
                color: AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

Future<void> processingDialog(BuildContext context) async {
  await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        // title: Center(
        //   child: const Text('Processing'),
        // ),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircularProgressIndicator(),
              // SizedBox(
              //   height: 20,
              // ),
              Text(
                'Processing Data\n\nPlease Wait...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  //color: FitnessAppTheme.darkText,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}