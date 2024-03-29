import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/state/app_theme_state.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/ui/components/color_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for changing app theme color scheme.
class ThemeChooserWidget extends StatelessWidget {
  /// Defining [ThemeChooserWidget] constructor.
  const ThemeChooserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String chooseThemeColorListTileTitle =
        appLocale.settings_Theming_ChooseThemeColor_ListTileTitle;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        Color userColorSchemeSeedColor = ref.watch(
          appThemeStateProvider
              .select((AppThemeState value) => value.userColorSchemeSeedColor),
        );
        return ListTile(
          title: Text(chooseThemeColorListTileTitle),
          subtitle: Text(
            '${ColorTools.materialNameAndCode(userColorSchemeSeedColor)} '
            'aka '
            '${ColorTools.nameThatColor(userColorSchemeSeedColor)}',
          ),
          leading: const Icon(Icons.palette),
          trailing: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: 22,
            color: userColorSchemeSeedColor,
          ),
          onTap: () async {
            // Store current color before we open the dialog.
            final Color colorBeforeDialog = userColorSchemeSeedColor;
            // Wait for the picker to close, if dialog was dismissed,
            // then restore the color we had before it was opened.
            bool dialogStatus = await colorPickerDialog(
              context: context,
              dialogPickerColor: userColorSchemeSeedColor,
              onColorChanged: (Color value) {
                ref.read(appThemeStateProvider).updateUserTheme(value);
              },
            );

            if (!dialogStatus) {
              ref
                  .read(appThemeStateProvider)
                  .updateUserTheme(colorBeforeDialog);
            }
          },
        );
      },
    );
  }
}
