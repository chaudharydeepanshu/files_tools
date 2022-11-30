import 'package:files_tools/shared_preferences/preferences.dart';
import 'package:files_tools/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetAppThemeSettings extends StatelessWidget {
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
            sharedPreferencesInstance.remove(themeModePerfKey);
            sharedPreferencesInstance.remove(userThemeSeedColorValuePerfKey);
            sharedPreferencesInstance.remove(dynamicThemeStatusPerfKey);
            // sharedPreferencesInstance.remove(onBoardingStatusPerfKey);
            ref.read(appThemeStateProvider).updateTheme();
          },
          child: const Text('Reset'),
        );
      },
    );
  }
}
