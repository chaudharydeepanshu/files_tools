import 'package:files_tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Widget for showing an loading animation using [RiveAnimation].
class LoadingIndicator extends StatelessWidget {
  /// Defining [LoadingIndicator] constructor.
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 100,
      child: RiveAnimation.asset(
        loadingAnimationAssetName,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Widget for showing loading state.
class Loading extends StatelessWidget {
  /// Defining [Loading] constructor.
  const Loading({Key? key, required this.loadingText}) : super(key: key);

  /// Loading description text.
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const LoadingIndicator(),
          Text(loadingText, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
