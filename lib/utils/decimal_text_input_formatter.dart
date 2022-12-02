import 'dart:math' as math;

import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains('.') &&
        (value.substring(value.indexOf('.') + 1).length > decimalRange)) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == '.') {
      truncated = '0.';

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (value.contains('.')) {
      String tempValue = value.substring(value.indexOf('.') + 1);
      if (tempValue.contains('.')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      if (value.indexOf('.') == 0) {
        truncated = '0$truncated';
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
    }
    if (value.contains(' ') ||
        value.contains('-') ||
        value.contains(',') ||
        double.tryParse(value) == null) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
