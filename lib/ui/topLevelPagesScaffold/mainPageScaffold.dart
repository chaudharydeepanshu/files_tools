import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:files_tools/widgets/reusableUIWidgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/topLevelPagesBodies/home.dart';
import 'package:files_tools/ui/topLevelPagesBodies/tools.dart';
import '../../basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import '../../widgets/reusableUIWidgets/ReusableTopAppBar.dart';

class MainPagesScaffold extends StatefulWidget {
  static const String routeName = '/mainPagesScaffold';
  const MainPagesScaffold(
      {Key? key,
      this.arguments,
      this.savedThemeMode,
      required this.onSavedThemeMode})
      : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;
  final ValueChanged<AdaptiveThemeMode> onSavedThemeMode;
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

  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line
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
      key: _scaffoldKey,
      appBar: currentIndex == 0
          ? ReusableSilverAppBar(
              title: 'Tools',
              appBarIconLeft: Icons.menu,
              appBarIconLeftToolTip: 'Open navigation menu',
              appBarIconLeftAction: () {
                _scaffoldKey.currentState!.openDrawer();
              },
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
      drawer: CustomDrawer(
        savedThemeMode: widget.savedThemeMode,
        onSavedThemeMode: (AdaptiveThemeMode value) {
          widget.onSavedThemeMode.call(value);
        },
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
