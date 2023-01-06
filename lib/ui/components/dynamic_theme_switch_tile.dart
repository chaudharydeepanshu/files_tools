import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [SwitchListTile] for switching between non dynamic and dynamic themes.
class DynamicThemeSwitchTile extends StatelessWidget {
  /// Defining [DynamicThemeSwitchTile] constructor.
  const DynamicThemeSwitchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String dynamicThemeListTileTitle =
        appLocale.settings_Theming_DynamicTheme_ListTileTitle;
    String dynamicThemeListTileSubtitle =
        appLocale.settings_Theming_DynamicTheme_ListTileSubtitle;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool isDynamicThemeEnabled = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.isDynamicThemeEnabled),
        );
        ColorScheme? lightDynamicColorScheme = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.lightDynamicColorScheme),
        );

        return lightDynamicColorScheme != null
            ? SwitchListTile(
                title: Text(dynamicThemeListTileTitle),
                subtitle: Text(dynamicThemeListTileSubtitle),
                secondary: const Icon(Icons.wallpaper),
                value: isDynamicThemeEnabled,
                onChanged: (bool? value) {
                  ref.read(appThemeStateProvider).updateDynamicThemeStatus();
                },
              )
            : const SizedBox();
      },
    );
  }
}
