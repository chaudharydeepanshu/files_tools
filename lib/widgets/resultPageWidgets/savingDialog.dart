import 'package:files_tools/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> savingDialog(BuildContext context) async {
  await showDialog<bool>(
    barrierDismissible: true,
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
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Saving Data\n\nPlease Wait...',
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
