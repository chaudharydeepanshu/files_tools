import 'package:files_tools/state/providers.dart';
import 'package:files_tools/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

import 'package:files_tools/constants.dart';
import 'package:files_tools/ui/components/link_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return DrawerHeader(
                    decoration: const BoxDecoration(
                        // color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/app_icon.png',
                          ),
                        ),
                        Text(ref.read(packageInfoCalcProvider).appName,
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    const ThemeModeSwitcher(),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          route.settingsPage,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('About'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          route.aboutPage,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinkButton(
                              urlLabel: "Privacy Policy",
                              urlIcon: Icons.privacy_tip,
                              url: privacyPolicyUrl),
                          const Text(
                            ' - ',
                          ),
                          LinkButton(
                              urlLabel: "Terms and Conditions",
                              urlIcon: Icons.gavel,
                              url: termsAndConditionsUrl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
