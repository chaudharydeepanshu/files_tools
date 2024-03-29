import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

/// Define custom colors. The 'guide' color values are from
/// https://material.io/design/color/the-color-system.html#color-theme-creation

/// Guide primary color.
const Color guidePrimary = Color(0xFF6200EE);

/// Guide primary variant color.
const Color guidePrimaryVariant = Color(0xFF3700B3);

/// Guide secondary color.
const Color guideSecondary = Color(0xFF03DAC6);

/// Guide secondary variant color.
const Color guideSecondaryVariant = Color(0xFF018786);

/// Guide error color.
const Color guideError = Color(0xFFB00020);

/// Guide dark error color.
const Color guideErrorDark = Color(0xFFCF6679);

/// Blue blues color.
const Color blueBlues = Color(0xFF174378);

/// Make a custom ColorSwatch to name map from the above custom colors.
final Map<ColorSwatch<Object>, String> colorsNameMap =
    <ColorSwatch<Object>, String>{
  ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
  ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
  ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
  ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
  ColorTools.createPrimarySwatch(guideError): 'Guide Error',
  ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
  ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
};

/// Dialog for color picking in app.
Future<bool> colorPickerDialog({
  required final BuildContext context,
  required final Color dialogPickerColor,
  required final ValueChanged<Color> onColorChanged,
}) async {
  AppLocale appLocale = AppLocale.of(context);
  String heading = appLocale.colorPicker_Heading;
  String subheading = appLocale.colorPicker_Subheading;
  String wheelSubheading = appLocale.colorPicker_WheelSubheading;

  return ColorPicker(
    // Use the dialogPickerColor as start color.
    color: dialogPickerColor,
    // Update the dialogPickerColor using the callback.
    onColorChanged: (final Color color) => onColorChanged.call(color),
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    wheelDiameter: 155,
    heading: Text(
      heading,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    subheading: Text(
      subheading,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    wheelSubheading: Text(
      wheelSubheading,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    showMaterialName: true,
    showColorName: true,
    showColorCode: true,
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
    ),
    materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: true,
      ColorPickerType.accent: true,
      ColorPickerType.bw: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
    customColorSwatchesAndNames: colorsNameMap,
  ).showPickerDialog(
    context,
    constraints:
        const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
  );
}
