import 'package:flutter/material.dart';

/// Widget for showing info through a popup about a something anywhere.
class MoreInfoButton extends StatelessWidget {
  /// Defining [MoreInfoButton] constructor.
  const MoreInfoButton({Key? key, required this.infoText}) : super(key: key);

  /// Information text.
  final String infoText;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: infoText,
      triggerMode: TooltipTriggerMode.tap,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: null,
        child: const Icon(Icons.info),
      ),
    );
  }
}
