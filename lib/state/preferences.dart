import 'package:files_tools/main.dart';
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

  /// Dynamic theme enable status SharedPref key.
  static String dynamicThemeStatusPerfKey = 'dynamicThemeStatus';

  /// Crashlytics Collection enable status SharedPref key.
  static String crashlyticsCollectionStatusPerfKey =
      'crashlyticsCollectionStatus';

  /// Analytics Collection enable status SharedPref key.
  static String analyticsCollectionStatusPerfKey = 'analyticsCollectionStatus';

  /// SharedPreferences Instance initializer.
  static Future<void> initSharedPreferences() async {
    sharedPreferencesInstance = await SharedPreferences.getInstance();
  }

  /// For persisting theme mode status in SharedPreferences.
  static Future<bool> persistThemeMode(final ThemeMode mode) =>
      sharedPreferencesInstance.setString(themeModePerfKey, mode.toString());

  /// For getting theme mode status persisted from SharedPreferences.
  static ThemeMode get themeMode => ThemeMode.values.firstWhere(
        (final ThemeMode element) =>
            element.toString() ==
            sharedPreferencesInstance.getString(themeModePerfKey),
        orElse: () => ThemeMode.light,
      );

  /// For persisting on boarding status in SharedPreferences.
  static Future<bool> persistOnBoardingStatus(final bool isUserOnBoarded) =>
      sharedPreferencesInstance.setBool(
        onBoardingStatusPerfKey,
        isUserOnBoarded,
      );

  /// For getting on boarding status persisted from SharedPreferences.
  static bool get isUserOnBoarded =>
      sharedPreferencesInstance.getBool(onBoardingStatusPerfKey) ?? false;

  /// For persisting user theme seed color in SharedPreferences.
  static Future<bool> persistUserThemeSeedColorValue(
    final int userThemeSeedColorValue,
  ) =>
      sharedPreferencesInstance.setInt(
        userThemeSeedColorValuePerfKey,
        userThemeSeedColorValue,
      );

  /// For getting on boarding status persisted from SharedPreferences.
  static int get userThemeSeedColorValue =>
      sharedPreferencesInstance.getInt(userThemeSeedColorValuePerfKey) ??
      const Color(0xFFA93054).value;

  /// For persisting dynamic theme status in SharedPreferences.
  static Future<bool> persistDynamicThemeStatus(
    final bool dynamicThemeStatus,
  ) =>
      sharedPreferencesInstance.setBool(
        dynamicThemeStatusPerfKey,
        dynamicThemeStatus,
      );

  /// For getting dynamic theme status from SharedPreferences.
  static bool get dynamicThemeStatus =>
      sharedPreferencesInstance.getBool(dynamicThemeStatusPerfKey) ?? true;

  /// For persisting crashlytics collection status in SharedPreferences.
  static Future<bool> persistCrashlyticsCollectionStatus(
    final bool crashlyticsCollectionStatus,
  ) async {
    await crashlyticsInstance.setCrashlyticsCollectionEnabled(
      crashlyticsCollectionStatus,
    );
    return sharedPreferencesInstance.setBool(
      crashlyticsCollectionStatusPerfKey,
      crashlyticsCollectionStatus,
    );
  }

  /// For getting crashlytics collection status from SharedPreferences.
  static bool get crashlyticsCollectionStatus =>
      sharedPreferencesInstance.getBool(crashlyticsCollectionStatusPerfKey) ??
      true;

  /// For persisting analytics collection status in SharedPreferences.
  static Future<bool> persistAnalyticsCollectionStatus(
    final bool analyticsCollectionStatus,
  ) async {
    await analyticsInstance.setAnalyticsCollectionEnabled(
      analyticsCollectionStatus,
    );
    return sharedPreferencesInstance.setBool(
      analyticsCollectionStatusPerfKey,
      analyticsCollectionStatus,
    );
  }

  /// For getting analytics collection status from SharedPreferences.
  static bool get analyticsCollectionStatus =>
      sharedPreferencesInstance.getBool(analyticsCollectionStatusPerfKey) ??
      true;
}
