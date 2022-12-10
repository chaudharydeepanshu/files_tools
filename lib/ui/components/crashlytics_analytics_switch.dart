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
    return SwitchListTile(
      title: const Text('Crashlytics'),
      subtitle: const Text(
        'Share crash-reports for bugs fixing.',
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
    return SwitchListTile(
      title: const Text('Analytics'),
      subtitle: const Text(
        'Share app usage for app improvement',
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
