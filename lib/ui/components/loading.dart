import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.loadingText}) : super(key: key);

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(loadingText, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
