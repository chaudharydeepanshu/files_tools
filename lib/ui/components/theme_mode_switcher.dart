import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for changing app theme mode to light, dart and system.
class ThemeModeSwitcher extends StatelessWidget {
  /// Defining [ThemeModeSwitcher] constructor.
  const ThemeModeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String themeModeListTileTitle =
        appLocale.settings_Theming_ThemeMode_ListTileTitle;
    String themeModeLightListTileSubtitle =
        appLocale.settings_Theming_ThemeMode_Light_ListTileSubtitle;
    String themeModeDarkListTileSubtitle =
        appLocale.settings_Theming_ThemeMode_Dark_ListTileSubtitle;
    String themeModeSystemListTileSubtitle =
        appLocale.settings_Theming_ThemeMode_System_ListTileSubtitle;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ThemeMode themeMode = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.themeMode),
        );
        String buttonText = themeMode == ThemeMode.light
            ? themeModeLightListTileSubtitle
            : themeMode == ThemeMode.dark
                ? themeModeDarkListTileSubtitle
                : themeModeSystemListTileSubtitle;
        IconData iconData = themeMode == ThemeMode.light
            ? Icons.light_mode
            : themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.android;
        return ListTile(
          leading: Icon(iconData),
          title: Text(themeModeListTileTitle),
          subtitle: Text(buttonText),
          onTap: () {
            ref.read(appThemeStateProvider).updateThemeMode();
          },
        );
      },
    );
  }
}
