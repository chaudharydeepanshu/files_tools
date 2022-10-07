import 'package:flutter/services.dart';
import 'dart:math' as math;

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    int oldValueLength = oldValue.text.length;
    int newValueLength = newValue.text.length;

    // Blocks comma at start.
    if ((oldValue.text.isEmpty || oldValue.text == "") &&
        newValue.text[newValueLength - 1] == ",") {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }
    // Allows numbers at start.
    else if (oldValue.text.isEmpty || oldValue.text == "") {
      truncated = newValue.text;
      newSelection = newValue.selection;
    } else {
      // Blocks comma after comma.
      if (oldValue.text[oldValueLength - 1] == "," &&
          newValue.text[newValueLength - 1] == ",") {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
