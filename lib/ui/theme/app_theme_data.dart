import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'custom_color.g.dart';

class AppThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData(ColorScheme? dynamic) =>
      themeData(dynamic, lightColorScheme, _lightFocusColor, lightCustomColors);
  static ThemeData darkThemeData(ColorScheme? dynamic) =>
      themeData(dynamic, darkColorScheme, _darkFocusColor, darkCustomColors);

  static ThemeData themeData(ColorScheme? dynamic, ColorScheme colorScheme,
      Color focusColor, CustomColors customColors) {
    if (dynamic != null) {
      colorScheme = dynamic.harmonized();
      customColors = customColors.harmonized(colorScheme);
    }

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      extensions: [customColors],
      fontFamily: "LexendDeca",
      focusColor: focusColor,
    );
  }
}
