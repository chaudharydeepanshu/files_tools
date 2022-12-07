import 'package:files_tools/state/preferences.dart';
import 'package:files_tools/ui/theme/app_theme_data.dart';
import 'package:flutter/material.dart';

/// App theme state class.
class AppThemeState extends ChangeNotifier {
  late Color _userColorSchemeSeedColor;

  /// User color scheme seed color.
  Color get userColorSchemeSeedColor => _userColorSchemeSeedColor;

  late ColorScheme? _lightDynamicColorScheme;

  /// Dynamic theme light mode color scheme.
  ColorScheme? get lightDynamicColorScheme => _lightDynamicColorScheme;

  late ColorScheme? _darkDynamicColorScheme;

  /// Dynamic theme dark mode color scheme.
  ColorScheme? get darkDynamicColorScheme => _darkDynamicColorScheme;

  late ColorScheme _userLightColorScheme;

  /// User theme light mode color scheme.
  ColorScheme get userLightColorScheme => _userLightColorScheme;

  late ColorScheme _userDarkColorScheme;

  /// User theme dark mode color scheme.
  ColorScheme get userDarkColorScheme => _userDarkColorScheme;

  late ColorScheme? _appLightColorScheme;

  /// App current theme light mode color scheme.
  ColorScheme? get appLightColorScheme => _appLightColorScheme;

  late ColorScheme? _appDarkColorScheme;

  /// App current theme dark mode color scheme.
  ColorScheme? get appDarkColorScheme => _appDarkColorScheme;

  late ThemeData _appLightThemeData;

  /// App current light mode theme data.
  ThemeData get appLightThemeData => _appLightThemeData;

  late ThemeData _appDarkThemeData;

  /// App current dark mode theme data.
  ThemeData get appDarkThemeData => _appDarkThemeData;

  late ThemeMode _themeMode;

  /// App current theme mode mode.
  ThemeMode get themeMode => _themeMode;

  late bool _isDynamicThemeEnabled;

  /// App dynamic theme enabled status.
  bool get isDynamicThemeEnabled => _isDynamicThemeEnabled;

  /// Initializes AppThemeState class members.
  void initTheme({
    final ColorScheme? lightDynamic,
    final ColorScheme? darkDynamic,
  }) {
    // Setting dynamic light / dark theme color scheme received to initializer.
    _lightDynamicColorScheme = lightDynamic;
    _darkDynamicColorScheme = darkDynamic;

    // Getting dynamic theme on / off status from SharedPreferences.
    _isDynamicThemeEnabled = Preferences.dynamicThemeStatus;

    // Getting user theme seed color value from SharedPreferences.
    int seedColorValue = Preferences.userThemeSeedColorValue;
    _userColorSchemeSeedColor = Color(seedColorValue);

    // Getting theme mode from SharedPreferences.
    _themeMode = Preferences.themeMode;

    // Generating user theme light mode color scheme from seed color.
    _userLightColorScheme = ColorScheme.fromSeed(
      seedColor: _userColorSchemeSeedColor,
    );

    // Generating user theme dark mode color scheme from seed color.
    _userDarkColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _userColorSchemeSeedColor,
    );

    if ((_lightDynamicColorScheme != null || _darkDynamicColorScheme != null) &&
        _isDynamicThemeEnabled == true) {
      // If dynamic color scheme is not null and dynamic theme is enabled then
      // generating app theme data based on dynamic color scheme.
      _appLightColorScheme = _lightDynamicColorScheme;
      _appDarkColorScheme = _darkDynamicColorScheme;
    } else {
      // If dynamic color scheme is null or dynamic theme is disabled then
      // generating app theme data based on user color scheme.
      _appLightColorScheme = _userLightColorScheme;
      _appDarkColorScheme = _userDarkColorScheme;
    }

    // Generating app light theme data from app light color scheme.
    _appLightThemeData = AppThemeData.lightThemeData(_appLightColorScheme);

    // Generating app light theme data from app dark color scheme.
    _appDarkThemeData = AppThemeData.darkThemeData(_appDarkColorScheme);
  }

  /// Updates theme data of app theme.
  void updateTheme() {
    // Re-initializes AppThemeState class members to update their values.
    initTheme(
      lightDynamic: _lightDynamicColorScheme,
      darkDynamic: _darkDynamicColorScheme,
    );

    if ((_lightDynamicColorScheme != null || _darkDynamicColorScheme != null) &&
        isDynamicThemeEnabled == true) {
      // If dynamic color scheme is not null and dynamic theme is enabled then
      // generating app theme data based on dynamic color scheme.
      _appLightThemeData =
          AppThemeData.lightThemeData(_lightDynamicColorScheme);
      _appDarkThemeData = AppThemeData.darkThemeData(_darkDynamicColorScheme);
    } else {
      // If dynamic color scheme is null or dynamic theme is disabled then
      // generating app theme data based on user color scheme.
      _appLightThemeData = AppThemeData.lightThemeData(_userLightColorScheme);
      _appDarkThemeData = AppThemeData.darkThemeData(_userDarkColorScheme);
    }

    // Notifying AppThemeState listeners.
    notifyListeners();
  }

  /// Updates dynamic theme on / off status.
  void updateDynamicThemeStatus() {
    // If dynamic theme enabled then disable or vice-versa.
    _isDynamicThemeEnabled = !_isDynamicThemeEnabled;

    // Persisting dynamic theme new status in SharedPreferences.
    Preferences.persistDynamicThemeStatus(_isDynamicThemeEnabled);

    // Updating app theme data after disabling dynamic theme.
    updateTheme();

    // Notifying AppThemeState listeners.
    notifyListeners();
  }

  /// Updates user theme color scheme.
  void updateUserTheme(final Color newUserThemeColor) {
    // Persisting user theme new seed color value in SharedPreferences.
    Preferences.persistUserThemeSeedColorValue(newUserThemeColor.value);

    // Generating color scheme from new seed color for light mode.
    _userLightColorScheme = ColorScheme.fromSeed(
      seedColor: newUserThemeColor,
    );

    // Generating color scheme from new seed color for dark mode.
    _userDarkColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: newUserThemeColor,
    );

    // Updating app theme data after generating new user theme color scheme.
    updateTheme();

    // Notifying AppThemeState listeners.
    notifyListeners();
  }

  /// Updates theme mode.
  void updateThemeMode() {
    if (themeMode == ThemeMode.dark) {
      // If theme mode is dark then setting to system/auto.
      _themeMode = ThemeMode.system;
    } else if (themeMode == ThemeMode.light) {
      // If theme mode is light then setting to dark.
      _themeMode = ThemeMode.dark;
    } else {
      // For other theme modes setting to light.
      _themeMode = ThemeMode.light;
    }

    // Persisting theme mode new status in SharedPreferences.
    Preferences.persistThemeMode(_themeMode);

    // Notifying AppThemeState listeners.
    notifyListeners();
  }
}
