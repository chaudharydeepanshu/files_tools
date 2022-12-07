import 'dart:math' as math;

import 'package:flutter/services.dart';

/// Text input formatter to help restrict TextField text input to a decimal
/// input of certain decimal range.
class DecimalTextInputFormatter extends TextInputFormatter {
  /// Defining [DecimalTextInputFormatter] constructor.
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  /// Takes decimal range.
  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Holds the new value text caret value.
    TextSelection newSelection = newValue.selection;
    // Holds the new value text.
    String truncated = newValue.text;

    if (truncated.contains('.') &&
        (truncated.substring(truncated.indexOf('.') + 1).length >
            decimalRange)) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (truncated == '.') {
      truncated = '0.';

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (truncated.contains('.')) {
      String tempValue = truncated.substring(truncated.indexOf('.') + 1);
      if (tempValue.contains('.')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      if (oldValue.text.length < truncated.length &&
          truncated.indexOf('.') == 0) {
        truncated = '0$truncated';
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
    }
    if (truncated.contains(' ') || truncated.contains(',')) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}
