import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compress_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/decrypt_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/encrypt_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/extract_all_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/fixed_range_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/modify_image_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_to_images_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/compress_image.dart';
import 'package:files_tools/ui/functionsActionsScaffold/custom_range_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/images_to_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/merge_pdf_pages_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_pages_modification_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/pdf_pages_selection_scaffold.dart';
import 'package:files_tools/ui/functionsActionsScaffold/watermark_pdf.dart';
import 'package:files_tools/ui/functionsMainScaffold/pdf_function_pages_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_image_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_pdf_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/result_zip_scaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdf_scaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/main_page_scaffold.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ads/ad_state.dart';
import 'navigation/page_routes_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void initialization(BuildContext context) async {
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  After this function completes, the
  // splash screen will be removed.
  WidgetsFlutterBinding.ensureInitialized();
}

Future<void> main() async {
  FlutterNativeSplash.removeAfter(initialization);
  // runApp will run, but not be shown until initialization completes:
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(Provider.value(
    value: adState,
    builder: (context, child) => MyApp(savedThemeMode: savedThemeMode),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);
  final AdaptiveThemeMode? savedThemeMode;
  final AdaptiveThemeMode firstRunAfterInstallThemeMode =
      AdaptiveThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.android,
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
        //iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(
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
      initial: savedThemeMode ?? firstRunAfterInstallThemeMode,
      builder: (theme, darkTheme) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          //Locale('hi', ''), // Hindi, no country code
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        darkTheme: darkTheme,
        theme: theme,
        themeMode: ThemeMode.system,
        home: Home(
          savedThemeMode: savedThemeMode ?? firstRunAfterInstallThemeMode,
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
          PageRoutes.modifyImageScaffold: (context) => ModifyImageScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as ModifyImageScaffoldArguments?),
          PageRoutes.resultImageScaffold: (context) => ResultImageScaffold(
              arguments: ModalRoute.of(context)!.settings.arguments
                  as ResultImageScaffoldArguments?),
          PageRoutes.compressImagesScaffold: (context) =>
              CompressImagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as CompressImagesScaffoldArguments?),
          PageRoutes.watermarkPDFPagesScaffold: (context) =>
              WatermarkPDFPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as WatermarkPDFPagesScaffoldArguments?),
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
    debugPrint(brightness.name);
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
      debugPrint(brightness.name);
      // > should print Brightness.light / Brightness.dark when you switch
      themeCalc();
      setState(() {
        darkModeOn = (theme == 'Dark') ||
            (brightness == Brightness.dark && theme == 'System');
      });
    });
    WidgetsBinding.instance!.addObserver(this); //most important
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    debugPrint(brightness.name);
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
    debugPrint(
        '$darkModeOn, $theme, ${AdaptiveTheme.of(context).mode.isLight}');
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
