import 'package:files_tools/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("App Theming",
                    style: Theme.of(context).textTheme.bodyMedium),
                const ResetAppThemeSettings(),
              ],
            ),
          ),
          const ThemeChooserWidget(),
          const DynamicThemeSwitchTile(),
          const ThemeModeSwitcher(),
        ],
      ),
    );
  }
}
