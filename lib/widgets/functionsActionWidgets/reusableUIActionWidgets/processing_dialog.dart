import 'package:files_tools/widgets/functionsMainWidgets/direct_pop.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/app_theme/app_theme.dart';
import 'dart:io';

// Widget progressFakeDialogBox = SafeArea(
//   child: Scaffold(
//     backgroundColor: Colors.black54,
//     body: Center(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4.0),
//           color: Colors.white,
//         ),
//         height: 200,
//         width: 200,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // CircularProgressIndicator(),
//             // SizedBox(
//             //   height: 20,
//             // ),
//             Text(
//               'Processing Data\n\nPlease Wait...',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: AppTheme.fontName,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 18,
//                 letterSpacing: 0.0,
//                 color: AppTheme.darkText,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// );

Future<void> processingDialog(
    BuildContext context, ValueChanged<bool>? onProcessingDialogVisible) async {
  await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          onProcessingDialogVisible?.call(false);
          return directPop();
        },
        child: SimpleDialog(
          // title: Center(
          //   child: const Text('Processing'),
          // ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Platform.isWindows ? const CircularProgressIndicator() : Container(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
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
                Platform.isWindows
                    ? OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      );
    },
  );
}
