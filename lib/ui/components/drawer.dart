import 'package:files_tools/constants.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/package_info_state.dart';
import 'package:files_tools/ui/components/link_button.dart';
import 'package:files_tools/ui/components/theme_mode_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App drawer.
class AppDrawer extends StatelessWidget {
  /// Defining [AppDrawer] constructor.
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: const Border(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Flexible(
                                child: Image.asset(
                                  'assets/app_icon_compressed.png',
                                ),
                              ),
                              Text(
                                packageInfo.appName,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const ThemeModeSwitcher(),
                    const Divider(indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          route.AppRoutes.settingsPage,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('About Us'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          route.AppRoutes.aboutPage,
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
            children: <Widget>[
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: <Widget>[
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: LinkButton(
                              urlLabel: 'Privacy Policy',
                              urlIcon: Icons.privacy_tip,
                              url: privacyPolicyUrl,
                            ),
                          ),
                          const Text(
                            ' - ',
                          ),
                          Flexible(
                            child: LinkButton(
                              urlLabel: 'Terms & Conditions',
                              urlIcon: Icons.gavel,
                              url: termsAndConditionsUrl,
                            ),
                          ),
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
