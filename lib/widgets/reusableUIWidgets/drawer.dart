import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer(
      {Key? key, this.savedThemeMode, required this.onSavedThemeMode})
      : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;
  final ValueChanged<AdaptiveThemeMode> onSavedThemeMode;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? previousTheme;
  String? themeButtonText;

  buttonTextCalc() async {
    if (AdaptiveTheme.of(context).mode.isLight) {
      setState(() {
        themeButtonText = 'Light';
      });
    } else if (AdaptiveTheme.of(context).mode.isDark) {
      setState(() {
        themeButtonText = 'Dark';
      });
    } else if (AdaptiveTheme.of(context).mode.isSystem) {
      setState(() {
        themeButtonText = 'System';
      });
    }
  }

  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;
  packageInfoCalc() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo!.appName;
      packageName = packageInfo!.packageName;
      version = packageInfo!.version;
      buildNumber = packageInfo!.buildNumber;
    });
  }

  @override
  void initState() {
    buttonTextCalc();
    packageInfoCalc();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/images/logos/files_tools_app_logo.svg',
                            fit: BoxFit.fitHeight,
                            height: 100,
                            alignment: Alignment.center,
                            semanticsLabel: 'A red up arrow'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Files Tools',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Theme Mode - $themeButtonText'),
                  onTap: () {
                    // Update the state of the app
                    AdaptiveTheme.of(context).toggleThemeMode();
                    buttonTextCalc();
                    // Then close the drawer
                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          packageInfo != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("App Version - $version+$buildNumber"),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
