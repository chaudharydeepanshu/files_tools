import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/topLevelPagesBodies/home.dart';
import 'package:files_tools/ui/topLevelPagesBodies/tools.dart';
import '../../basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import '../../widgets/reusableUIWidgets/ReusableTopAppBar.dart';

class MainPagesScaffold extends StatefulWidget {
  static const String routeName = '/mainPagesScaffold';
  const MainPagesScaffold({Key? key, this.arguments}) : super(key: key);

  final MainPagesScaffoldArguments? arguments;

  @override
  _MainPagesScaffoldState createState() => _MainPagesScaffoldState();
}

class _MainPagesScaffoldState extends State<MainPagesScaffold>
//   with WidgetsBindingObserver
{
  // static const platform =
  //     const MethodChannel('tinyappsteam.flutter.dev/open_file');
  //
  // String openFileUrl;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getOpenFileUrl();
  //   // Listen to lifecycle events.
  //   WidgetsBinding.instance.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     getOpenFileUrl();
  //   }
  // }
  //
  // void getOpenFileUrl() async {
  //   dynamic url = await platform.invokeMethod("getOpenFileUrl");
  //   print("getOpenFileUrl");
  //   if (url != null && url != openFileUrl) {
  //     setState(() {
  //       openFileUrl = url;
  //     });
  //     // String str = await FlutterAbsolutePath.getAbsolutePath(
  //     //     'content://com.android.externalstorage.documents/document/primary%3ADownload%2FSchedule_Term%20End%20Examinations_Winter%20Semester%202020-21.pdf');
  //     // print(str);
  //     // Navigator.pushNamed(
  //     //   context,
  //     //   PageRoutes.pdfScaffold,
  //     //   arguments: PDFScaffoldArguments(
  //     //     pdfPath: str,
  //     //   ),
  //     // );
  //   }
  // }

  late int? currentIndex;

  @override
  void initState() {
    super.initState();
    //deleteCacheDir();
    deleteAppDir();
    if (widget.arguments == null) {
      currentIndex = 0;
    } else {
      currentIndex = widget.arguments!.bodyIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Audio file: " + (openFileUrl != null ? openFileUrl : "Nothing!"));
    var appBarIconRightText = AdaptiveThemeMode.system.isSystem == true
        ? 'System'
        : AdaptiveThemeMode.light.isLight == true
            ? 'Light'
            : 'Dark';
    print(appBarIconRightText);
    return Scaffold(
      appBar: currentIndex == 0
          ? ReusableSilverAppBar(
              title: 'Tools',
              // appBarIconLeft: Icons.light,
              // appBarIconLeftAction: () {
              //   Scaffold.of(context).openDrawer();
              // },
            )
          : currentIndex == 1
              ? ReusableSilverAppBar(
                  title: 'Recent Docs',
                )
              : null,

      body: currentIndex == 0
          ? HomeBody()
          : currentIndex == 1
              ? Recent()
              : null,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          //padding: EdgeInsets.zero,
          children: [
            // const DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            //   child: Text('Files Tools'),
            // ),
            ListTile(
              title: const Text('Theme Mode - System'),
              onTap: () {
                // Update the state of the app
                AdaptiveTheme.of(context).setSystem();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Theme Mode - Light'),
              onTap: () {
                // Update the state of the app
                AdaptiveTheme.of(context).setLight();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Theme Mode - Dark'),
              onTap: () {
                // Update the state of the app
                AdaptiveTheme.of(context).setDark();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: ReusableBottomAppBar(
      //   onCurrentIndex: (value) => setState(() {
      //     currentIndex = value;
      //   }),
      // ),
    );
  }
}

class MainPagesScaffoldArguments {
  int? bodyIndex;

  MainPagesScaffoldArguments({
    this.bodyIndex,
  });
}

//todo: intent filters added make the app non installable on any devices and could only run in debug mode
