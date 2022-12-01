import 'package:flutter/services.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    int oldValueLength = oldValue.text.length;
    int newValueLength = newValue.text.length;

    // Allows deleting text always.
    if (oldValueLength > newValueLength) {
      truncated = newValue.text;
      newSelection = newValue.selection;
    }
    // Blocks comma and dash at start.
    else if ((oldValue.text.isEmpty || oldValue.text == '') &&
        (newValue.text[newValueLength - 1] == ',' ||
            newValue.text[newValueLength - 1] == '-')) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }
    // Allows numbers at start.
    else if (oldValue.text.isEmpty || oldValue.text == '') {
      truncated = newValue.text;
      newSelection = newValue.selection;
    } else {
      // Blocks comma and dash after comma.
      if (newValue.text[newValueLength - 2] == ',' &&
          (newValue.text[newValueLength - 1] == ',' ||
              newValue.text[newValueLength - 1] == '-')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      // Blocks comma and dash after dash.
      else if (newValue.text[newValueLength - 2] == '-' &&
          (newValue.text[newValueLength - 1] == ',' ||
              newValue.text[newValueLength - 1] == '-')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      // Blocks dash after number dash number. Ex: 48-58- <- this last dash is blocked
      else if (oldValue.text.lastIndexOf('-') != -1) {
        if (!(oldValue.text
                .substring(oldValue.text.lastIndexOf('-'))
                .contains(',')) &&
            newValue.text[newValueLength - 1] == '-') {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        }
      }
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
