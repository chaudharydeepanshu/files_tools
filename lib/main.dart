import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/CompressPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/DecryptPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/EncryptPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/ExtractAllPDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/FixedRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/PDFToImagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/customRangePDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/imagesToPDFScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/mergePDFPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/pdfPagesModificationScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsActionsScaffold/pdfPagesSelectionScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsMainScaffold/pdfFunctionPagesScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/widgets/pdfFunctionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'ad_state.dart';
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
  final AdaptiveThemeMode? savedThemeMode;
  final ValueChanged<AdaptiveThemeMode>? onSavedThemeMode;

  const MyApp({Key? key, this.savedThemeMode, this.onSavedThemeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        //statusBarColor: Colors.white, //Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.grey,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: AdaptiveTheme(
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
          home: MainPagesScaffold(
            savedThemeMode: savedThemeMode,
            onSavedThemeMode: (AdaptiveThemeMode value) {
              onSavedThemeMode!.call(value);
            },
          ),
          routes: {
            PageRoutes.mainPagesScaffold: (context) => MainPagesScaffold(
                  arguments: ModalRoute.of(context)!.settings.arguments
                      as MainPagesScaffoldArguments?,
                  onSavedThemeMode: (AdaptiveThemeMode value) {
                    onSavedThemeMode!.call(value);
                  },
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
            PageRoutes.mergePDFPagesScaffold: (context) =>
                MergePDFPagesScaffold(
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
      ),
    );
  }
}
