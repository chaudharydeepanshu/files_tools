import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dailog_box_for_leaving_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? previousTheme;
  String? themeButtonText;

  buttonTextCalc() async {
    if (AdaptiveTheme.of(context).mode.isLight) {
      setState(() {
        themeButtonText = AppLocalizations.of(context)!.lightMode;
      });
    } else if (AdaptiveTheme.of(context).mode.isDark) {
      setState(() {
        themeButtonText = AppLocalizations.of(context)!.darkMode;
      });
    } else if (AdaptiveTheme.of(context).mode.isSystem) {
      setState(() {
        themeButtonText = AppLocalizations.of(context)!.systemMode;
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

  List<Widget>? dialogActionButtonsListForLeavingApp;
  String? dialogTextForForLeavingApp;

  @override
  void initState() {
    packageInfoCalc();

    dialogActionButtonsListForLeavingApp = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
      OutlinedButton(
        onPressed: () async {
          Navigator.pop(context);
          launch('https://pureinfoapps.com/files-tools/privacy-policy');
        },
        child: const Text('Yes'),
      ),
    ];
    dialogTextForForLeavingApp =
        'You are leaving the app to open the privacy policy url. So, please confirm that do you want to leave the app?';

    super.initState();
  }

  @override
  void didChangeDependencies() {
    buttonTextCalc(); // calling here as buttonTextCalc need context for localization of app
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(themeButtonText);
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
                  decoration: const BoxDecoration(
                      //color: Colors.white,
                      ),
                  child: FittedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              'assets/images/logos/files_tools_app_logo.svg',
                              fit: BoxFit.fitHeight,
                              height: 100,
                              alignment: Alignment.center,
                              semanticsLabel: 'App Logo'),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Files Tools',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                      '${AppLocalizations.of(context)!.themeMode} - $themeButtonText'),
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      leavingAppDialogBox(
                          actionButtonsList:
                              dialogActionButtonsListForLeavingApp,
                          text: dialogTextForForLeavingApp,
                          context: context);
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
