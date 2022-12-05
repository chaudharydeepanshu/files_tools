import 'package:dynamic_color/dynamic_color.dart';
import 'package:files_tools/ui/theme/color_schemes.g.dart';
import 'package:files_tools/ui/theme/custom_color.g.dart';
import 'package:flutter/material.dart';

/// For creating app ThemeData by providing any color schemes.
class AppThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  /// For creating app light ThemeData by providing any light color scheme.
  static ThemeData lightThemeData(ColorScheme? customLightColorScheme) =>
      themeData(
        customLightColorScheme,
        defaultLightColorScheme,
        _lightFocusColor,
        lightCustomColors,
      );

  /// For creating app dark ThemeData by providing any dark color scheme.
  static ThemeData darkThemeData(ColorScheme? customDarkColorScheme) =>
      themeData(
        customDarkColorScheme,
        defaultDarkColorScheme,
        _darkFocusColor,
        darkCustomColors,
      );

  /// For creating ThemeData properties of [lightThemeData] and [darkThemeData].
  static ThemeData themeData(
    ColorScheme? customColorScheme,
    ColorScheme colorScheme,
    Color focusColor,
    CustomColors customColors,
  ) {
    if (customColorScheme != null) {
      colorScheme = customColorScheme.harmonized();
      customColors = customColors.harmonized(colorScheme);
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        customColors,
      ],
      fontFamily: 'LexendDeca',
      focusColor: focusColor,
    );
  }
}
