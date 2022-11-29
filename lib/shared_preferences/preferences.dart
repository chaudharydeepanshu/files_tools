import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String themeModePerfKey = "themeMode";
String onBoardingStatusPerfKey = "isUserOnBoarded";
String userThemeSeedColorValuePerfKey = "userThemeSeedColorValue";
String dynamicThemeStatusPerfKey = "dynamicThemeStatus";

class Preferences extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  init(SharedPreferences sharedPreferencesInstance) async {
    _sharedPreferences = sharedPreferencesInstance;
  }

  persistThemeMode(ThemeMode mode) =>
      sharedPreferences.setString(themeModePerfKey, mode.toString());

  ThemeMode get themeMode => ThemeMode.values.firstWhere(
        (element) =>
            element.toString() == sharedPreferences.getString(themeModePerfKey),
        orElse: () => ThemeMode.light,
      );

  persistOnBoardingStatus(bool isUserOnBoarded) =>
      sharedPreferences.setBool(onBoardingStatusPerfKey, isUserOnBoarded);

  bool get isUserOnBoarded =>
      sharedPreferences.getBool(onBoardingStatusPerfKey) ?? false;

  persistUserThemeSeedColorValue(int userThemeSeedColorValue) =>
      sharedPreferences.setInt(
          userThemeSeedColorValuePerfKey, userThemeSeedColorValue);

  int get userThemeSeedColorValue =>
      sharedPreferences.getInt(userThemeSeedColorValuePerfKey) ??
      const Color(0xFFA93054).value;

  persistDynamicThemeStatus(bool dynamicThemeStatus) =>
      sharedPreferences.setBool(dynamicThemeStatusPerfKey, dynamicThemeStatus);

  bool get dynamicThemeStatus =>
      sharedPreferences.getBool(dynamicThemeStatusPerfKey) ?? true;
}
