import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App SharedPreferences Instance.
late final SharedPreferences sharedPreferencesInstance;

/// App SharedPreferences state class.
class Preferences {
  /// Theme mode SharedPref key.
  static String themeModePerfKey = 'themeMode';

  /// OnBoarding status SharedPref key.
  static String onBoardingStatusPerfKey = 'isUserOnBoarded';

  /// User theme seed color SharedPref key.
  static String userThemeSeedColorValuePerfKey = 'userThemeSeedColorValue';

  /// Dynamic theme SharedPref key.
  static String dynamicThemeStatusPerfKey = 'dynamicThemeStatus';

  /// SharedPreferences Instance initializer.
  static Future<void> initSharedPreferences() async {
    sharedPreferencesInstance = await SharedPreferences.getInstance();
  }

  /// For persisting theme mode status in SharedPreferences.
  static Future<bool> persistThemeMode(ThemeMode mode) =>
      sharedPreferencesInstance.setString(themeModePerfKey, mode.toString());

  /// For getting theme mode status persisted in SharedPreferences.
  static ThemeMode get themeMode => ThemeMode.values.firstWhere(
        (ThemeMode element) =>
            element.toString() ==
            sharedPreferencesInstance.getString(themeModePerfKey),
        orElse: () => ThemeMode.light,
      );

  /// For persisting on boarding status in SharedPreferences.
  static Future<bool> persistOnBoardingStatus(bool isUserOnBoarded) =>
      sharedPreferencesInstance.setBool(
        onBoardingStatusPerfKey,
        isUserOnBoarded,
      );

  /// For getting on boarding status persisted in SharedPreferences.
  static bool get isUserOnBoarded =>
      sharedPreferencesInstance.getBool(onBoardingStatusPerfKey) ?? false;

  /// For persisting user theme seed color in SharedPreferences.
  static Future<bool> persistUserThemeSeedColorValue(
    int userThemeSeedColorValue,
  ) =>
      sharedPreferencesInstance.setInt(
        userThemeSeedColorValuePerfKey,
        userThemeSeedColorValue,
      );

  /// For getting on boarding status persisted in SharedPreferences.
  static int get userThemeSeedColorValue =>
      sharedPreferencesInstance.getInt(userThemeSeedColorValuePerfKey) ??
      const Color(0xFFA93054).value;

  /// For persisting dynamic theme status in SharedPreferences.
  static Future<bool> persistDynamicThemeStatus(bool dynamicThemeStatus) =>
      sharedPreferencesInstance.setBool(
        dynamicThemeStatusPerfKey,
        dynamicThemeStatus,
      );

  /// For getting dynamic theme status in SharedPreferences.
  static bool get dynamicThemeStatus =>
      sharedPreferencesInstance.getBool(dynamicThemeStatusPerfKey) ?? true;
}
