import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/ui/components/crashlytics_analytics_switch.dart';
import 'package:files_tools/ui/components/dynamic_theme_switch_tile.dart';
import 'package:files_tools/ui/components/reset_app_theme_settings.dart';
import 'package:files_tools/ui/components/theme_chooser_widget.dart';
import 'package:files_tools/ui/components/theme_mode_switcher.dart';
import 'package:flutter/material.dart';

/// It is the settings screen widget.
class SettingsPage extends StatelessWidget {
  /// Defining [SettingsPage] constructor.
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String settings = appLocale.settings_ScreenTitle;
    String theming = appLocale.settings_Theming_Title;
    String usageAndDiagnostics = appLocale.settings_UsageAndDiagnostics_Title;
    String usageAndDiagnosticsNote =
        appLocale.settings_UsageAndDiagnostics_About;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  theming,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const ResetAppThemeSettings(),
              ],
            ),
          ),
          const ThemeChooserWidget(),
          const DynamicThemeSwitchTile(),
          const ThemeModeSwitcher(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  usageAndDiagnostics,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const CrashlyticsSwitchTile(),
          const AnalyticsSwitchTile(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              usageAndDiagnosticsNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}
