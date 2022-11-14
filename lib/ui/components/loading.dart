import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// class Loading extends StatelessWidget {
//   const Loading({Key? key, required this.loadingText}) : super(key: key);
//
//   final String loadingText;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(),
//           const SizedBox(height: 16),
//           Text(loadingText, style: Theme.of(context).textTheme.bodySmall),
//         ],
//       ),
//     );
//   }
// }

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 150,
      height: 100,
      child: RiveAnimation.asset(
        'assets/rive/finger_tapping.riv',
        fit: BoxFit.contain,
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.loadingText}) : super(key: key);

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          Text(loadingText, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
