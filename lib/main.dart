import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:files_tools/ui/functionsActionsScaffold/CompressPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/DecryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/EncryptPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/ExtractAllPDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/FixedRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/PDFToImagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/customRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/imagesToPDFScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/mergePDFPagesScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesModificationScaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdfPagesSelectionScaffold.dart';
import 'package:files_tools/ui/functionsMainScaffold/pdfFunctionPagesScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ads/ad_state.dart';
import 'navigation/page_routes_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  // await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(Provider.value(
    value: adState,
    builder: (context, child) => MyApp(savedThemeMode: savedThemeMode),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
        //iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white10,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      dark: ThemeData.dark().copyWith(
        // iconTheme: IconThemeData(color: Colors.black),
        // scaffoldBackgroundColor: Color(0xFF121212),
        // canvasColor: Color(0xFF121212),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(Colors.lightBlueAccent),
        ),
        // appBarTheme: AppBarTheme(
        //   iconTheme: IconThemeData(
        //     color: Colors.white,
        //   ),
        // ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        darkTheme: darkTheme,
        theme: theme,
        themeMode: ThemeMode.system,
        home: Home(
          savedThemeMode: savedThemeMode,
        ),
        routes: {
          PageRoutes.mainPagesScaffold: (context) => MainPagesScaffold(
                arguments: ModalRoute.of(context)!.settings.arguments
                    as MainPagesScaffoldArguments?,
              ),
          PageRoutes.pdfFunctionsPageScaffold: (context) =>
              PDFFunctionsPageScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as PDFFunctionsPageScaffoldArguments?),
          PageRoutes.pdfScaffold: (context) => PDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as PDFScaffoldArguments?),
          PageRoutes.pdfPagesSelectionScaffold: (context) =>
              PDFPagesSelectionScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as PDFPagesSelectionScaffoldArguments?),
          PageRoutes.resultPDFScaffold: (context) => ResultPDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as ResultPDFScaffoldArguments?),
          PageRoutes.pdfPagesModificationScaffold: (context) =>
              PDFPagesModificationScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as PDFPagesModificationScaffoldArguments?),
          PageRoutes.reorderPDFPagesScaffold: (context) =>
              ReorderPDFPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as ReorderPDFPagesScaffoldArguments?),
          PageRoutes.customRangePDFPagesScaffold: (context) =>
              CustomRangePDFPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as CustomRangePDFPagesScaffoldArguments?),
          PageRoutes.fixedRangePDFPagesScaffold: (context) =>
              FixedRangePDFPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as FixedRangePDFPagesScaffoldArguments?),
          PageRoutes.extractAllPDFPagesScaffold: (context) =>
              ExtractAllPDFPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as ExtractAllPDFPagesScaffoldArguments?),
          PageRoutes.resultZipScaffold: (context) => ResultZipScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as ResultZipScaffoldArguments?),
          PageRoutes.mergePDFPagesScaffold: (context) => MergePDFPagesScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as MergePDFPagesScaffoldArguments?),
          PageRoutes.compressPDFScaffold: (context) => CompressPDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as CompressPDFScaffoldArguments?),
          PageRoutes.encryptPDFScaffold: (context) => EncryptPDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as EncryptPDFScaffoldArguments?),
          PageRoutes.decryptPDFScaffold: (context) => DecryptPDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as DecryptPDFScaffoldArguments?),
          PageRoutes.imagesToPDFScaffold: (context) => ImagesToPDFScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as ImagesToPDFScaffoldArguments?),
          PageRoutes.pdfToImagesScaffold: (context) => PDFToImagesScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as PDFToImagesScaffoldArguments?),
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool? darkModeOn;
  String? theme;

  themeCalc() async {
    if (AdaptiveTheme.of(context).mode.isLight) {
      setState(() {
        theme = 'Light';
      });
    } else if (AdaptiveTheme.of(context).mode.isDark) {
      setState(() {
        theme = 'Dark';
      });
    } else if (AdaptiveTheme.of(context).mode.isSystem) {
      setState(() {
        theme = 'System';
      });
    }
  }

  @override
  void didChangePlatformBrightness() {
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    themeCalc();
    setState(() {
      darkModeOn = (theme == 'Dark') ||
          (brightness == Brightness.dark && theme == 'System');
    });
    super.didChangePlatformBrightness();
  }

  @override
  void initState() {
    AdaptiveTheme.of(context).modeChangeNotifier.addListener(() {
      WidgetsBinding.instance!.addObserver(this); //most important
      var brightness = WidgetsBinding.instance!.window.platformBrightness;
      print(brightness);
      // > should print Brightness.light / Brightness.dark when you switch
      themeCalc();
      setState(() {
        darkModeOn = (theme == 'Dark') ||
            (brightness == Brightness.dark && theme == 'System');
      });
    });
    WidgetsBinding.instance!.addObserver(this); //most important
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    themeCalc();
    setState(() {
      darkModeOn = (theme == 'Dark') ||
          (brightness == Brightness.dark && theme == 'System');
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('$darkModeOn, $theme, ${AdaptiveTheme.of(context).mode.isLight}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // statusBarColor:
        //     darkModeOn! ? Colors.black : Colors.white, //Colors.transparent,
        // statusBarIconBrightness:
        //     darkModeOn! ? Brightness.light : Brightness.dark,
        // statusBarBrightness: !kIsWeb && Platform.isAndroid && darkModeOn!
        //     ? Brightness.dark
        //     : Brightness.light,
        systemNavigationBarColor: darkModeOn! ? Colors.black : Colors.white,
        // systemNavigationBarDividerColor:
        //     darkModeOn! ? Colors.white10 : Colors.grey,
        systemNavigationBarIconBrightness:
            darkModeOn! ? Brightness.light : Brightness.dark,
      ),
      child: MainPagesScaffold(
        savedThemeMode: widget.savedThemeMode,
      ),
    );
  }
}
