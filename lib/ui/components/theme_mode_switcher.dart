import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for changing app theme mode to light, dart and system.
class ThemeModeSwitcher extends StatelessWidget {
  /// Defining ThemeModeSwitcher constructor.
  const ThemeModeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ThemeMode themeMode = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.themeMode),
        );
        String buttonText = themeMode == ThemeMode.light
            ? 'Light'
            : themeMode == ThemeMode.dark
                ? 'Dark'
                : 'System';
        IconData iconData = themeMode == ThemeMode.light
            ? Icons.light_mode
            : themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.android;
        return ListTile(
          leading: Icon(iconData),
          title: const Text('Theme Mode'),
          subtitle: Text(buttonText),
          onTap: () {
            ref.read(appThemeStateProvider).updateThemeMode();
          },
        );
      },
    );
  }
}
