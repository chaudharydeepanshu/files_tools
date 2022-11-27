import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  init(SharedPreferences sharedPreferencesInstance) async {
    _sharedPreferences = sharedPreferencesInstance;
  }

  persistThemeMode(ThemeMode mode) =>
      sharedPreferences.setString('themeMode', mode.toString());

  ThemeMode get themeMode => ThemeMode.values.firstWhere(
        (element) =>
            element.toString() == sharedPreferences.getString('themeMode'),
        orElse: () => ThemeMode.light,
      );

  persistOnBoardingStatus(bool isUserOnBoarded) =>
      sharedPreferences.setBool('isUserOnBoarded', isUserOnBoarded);

  bool get isUserOnBoarded =>
      sharedPreferences.getBool('isUserOnBoarded') ?? false;

  persistThemeColorValue(int themeColorValue) =>
      sharedPreferences.setInt('themeColorValue', themeColorValue);

  int get themeColorValue =>
      sharedPreferences.getInt('themeColorValue') ??
      const Color(0xFFA93054).value;

  persistDynamicThemeStatus(bool dynamicThemeStatus) =>
      sharedPreferences.setBool('dynamicThemeStatus', dynamicThemeStatus);

  bool get dynamicThemeStatus =>
      sharedPreferences.getBool('dynamicThemeStatus') ?? true;
}
