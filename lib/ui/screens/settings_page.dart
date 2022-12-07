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
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
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
                  'App Theming',
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
                  'Usage & diagnostics',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Please read!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'User reports are the only way to keep track of new bugs '
                    'for a free and small app like Files Tools that '
                    'lacks resources.\n\n'
                    'The information collected is secure, does not contain '
                    'any sensitive user information, and is only used for '
                    'app development purposes.\n\n'
                    'Still, if you don\'t want to share, we understand.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
