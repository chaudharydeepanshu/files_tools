import 'package:flutter/material.dart';

/// Shows a levitating bottom app bar.
///
/// We use it in the app inside a stack with a align widget having alignment
/// set to bottom center. To show options like rotate, flip, process, etc.
class LevitatingOptionsBar extends StatelessWidget {
  /// Defining [FileTile] constructor.
  const LevitatingOptionsBar({Key? key, required this.optionsList})
      : super(key: key);

  /// List of widgets of options.
  final List<Widget> optionsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 30, right: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 70,
            child: Row(
              children: optionsList,
            ),
          ),
        ),
      ),
    );
  }
}
