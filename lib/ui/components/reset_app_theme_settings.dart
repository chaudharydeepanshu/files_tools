import 'package:files_tools/state/preferences.dart';
import 'package:files_tools/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for showing reset button to reset app theme settings.
class ResetAppThemeSettings extends StatelessWidget {
  /// Defining [ResetAppThemeSettings] constructor.
  const ResetAppThemeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            sharedPreferencesInstance.remove(Preferences.themeModePerfKey);
            sharedPreferencesInstance
                .remove(Preferences.userThemeSeedColorValuePerfKey);
            sharedPreferencesInstance
                .remove(Preferences.dynamicThemeStatusPerfKey);
            // sharedPreferencesInstance
            //     .remove(Preferences.onBoardingStatusPerfKey);
            ref.read(appThemeStateProvider).updateTheme();
          },
          child: const Text('Reset Theme'),
        );
      },
    );
  }
}
