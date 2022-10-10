import 'package:flutter/material.dart';

class LoadingPageSmallBitmap extends StatelessWidget {
const LoadingPageSmallBitmap({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      CircularProgressIndicator(),
    ],
  );
}
}
