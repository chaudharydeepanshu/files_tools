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
        padding: const EdgeInsets.all(16),
        children: [
          Text("App Theming", style: Theme.of(context).textTheme.titleMedium),
          const ThemeWidget(),
          const DynamicThemeCheckboxTile(),
        ],
      ),
    );
  }
}
