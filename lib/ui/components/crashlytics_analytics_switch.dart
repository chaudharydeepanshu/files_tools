import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/main.dart';
import 'package:files_tools/state/preferences.dart';
import 'package:flutter/material.dart';

/// [SwitchListTile] for enabling or disabling crashlytics data collection.
class CrashlyticsSwitchTile extends StatefulWidget {
  /// Defining [CrashlyticsSwitchTile] constructor.
  const CrashlyticsSwitchTile({Key? key}) : super(key: key);

  @override
  State<CrashlyticsSwitchTile> createState() => _CrashlyticsSwitchTileState();
}

class _CrashlyticsSwitchTileState extends State<CrashlyticsSwitchTile> {
  bool isCrashlyticsEnabled =
      crashlyticsInstance.isCrashlyticsCollectionEnabled;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String crashlyticsListTileTitle =
        appLocale.settings_UsageAndDiagnostics_Crashlytics_ListTileTitle;
    String crashlyticsListTileSubtitle =
        appLocale.settings_UsageAndDiagnostics_Crashlytics_ListTileSubtitle;

    return SwitchListTile(
      title: Text(crashlyticsListTileTitle),
      subtitle: Text(
        crashlyticsListTileSubtitle,
      ),
      secondary: const Icon(Icons.bug_report),
      value: isCrashlyticsEnabled,
      onChanged: (bool? value) async {
        await Preferences.persistCrashlyticsCollectionStatus(
          !isCrashlyticsEnabled,
        );
        setState(() {
          isCrashlyticsEnabled =
              crashlyticsInstance.isCrashlyticsCollectionEnabled;
        });
      },
    );
  }
}

/// [SwitchListTile] for enabling or disabling analytics data collection.
class AnalyticsSwitchTile extends StatefulWidget {
  /// Defining [AnalyticsSwitchTile] constructor.
  const AnalyticsSwitchTile({Key? key}) : super(key: key);

  @override
  State<AnalyticsSwitchTile> createState() => _AnalyticsSwitchTileState();
}

class _AnalyticsSwitchTileState extends State<AnalyticsSwitchTile> {
  bool isAnalyticsEnabled = Preferences.analyticsCollectionStatus;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String analyticsListTileTitle =
        appLocale.settings_UsageAndDiagnostics_Analytics_ListTileTitle;
    String analyticsListTileSubtitle =
        appLocale.settings_UsageAndDiagnostics_Analytics_ListTileSubtitle;

    return SwitchListTile(
      title: Text(analyticsListTileTitle),
      subtitle: Text(
        analyticsListTileSubtitle,
      ),
      secondary: const Icon(Icons.analytics),
      value: isAnalyticsEnabled,
      onChanged: (bool? value) async {
        await Preferences.persistAnalyticsCollectionStatus(!isAnalyticsEnabled);
        setState(() {
          isAnalyticsEnabled = Preferences.analyticsCollectionStatus;
        });
      },
    );
  }
}
