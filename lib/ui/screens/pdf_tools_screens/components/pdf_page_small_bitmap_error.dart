import 'package:flutter/material.dart';

class ErrorPageSmallBitmap extends StatelessWidget {
  const ErrorPageSmallBitmap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      ],
    );
  }
}