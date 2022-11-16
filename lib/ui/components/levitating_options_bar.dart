import 'package:flutter/material.dart';

class LevitatingOptionsBar extends StatelessWidget {
  const LevitatingOptionsBar({Key? key, required this.optionsList})
      : super(key: key);

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
