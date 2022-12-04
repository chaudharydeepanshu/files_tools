import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'package:files_tools/ui/theme/color_schemes.g.dart';
import 'package:files_tools/ui/theme/custom_color.g.dart';

class AppThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData(ColorScheme? customLightColorScheme) =>
      themeData(customLightColorScheme, defaultLightColorScheme,
          _lightFocusColor, lightCustomColors,);
  static ThemeData darkThemeData(ColorScheme? customDarkColorScheme) =>
      themeData(customDarkColorScheme, defaultDarkColorScheme, _darkFocusColor,
          darkCustomColors,);

  static ThemeData themeData(ColorScheme? customColorScheme,
      ColorScheme colorScheme, Color focusColor, CustomColors customColors,) {
    if (customColorScheme != null) {
      colorScheme = customColorScheme.harmonized();
      customColors = customColors.harmonized(colorScheme);
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [customColors],
      fontFamily: 'LexendDeca',
      focusColor: focusColor,
    );
  }
}
