import 'package:files_tools/ads_state/ad_state.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:open_file/open_file.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/widgets/resultPageWidgets/ResultPageButtons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'dart:io';
import 'dart:async';
import 'package:files_tools/basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import '../../app_theme/app_theme.dart';
import '../../basicFunctionalityFunctions/getSizeFromBytes.dart';

class ResultPDFScaffold extends StatefulWidget {
  static const String routeName = '/resultPDFScaffold';
  const ResultPDFScaffold({Key? key, this.arguments}) : super(key: key);

  final ResultPDFScaffoldArguments? arguments;

  @override
  _ResultPDFScaffoldState createState() => _ResultPDFScaffoldState();
}

class _ResultPDFScaffoldState extends State<ResultPDFScaffold> {
  late String tempPdfPath;
  late String userPdfPath;
  File? file;

  bool viewPDFBannerStatus = false;

  Future<String?> saveFileInUserDescribedLocation() async {
    final params = SaveFileDialogParams(
        sourceFilePath: tempPdfPath, mimeTypesFilter: ["application/pdf"]);
    //data: Uint8List.fromList(bytes), fileName: 'Test.pdf');
    final filePath = await FlutterFileDialog.saveFile(params: params);
    print(filePath);
    return filePath;
  }

  TextEditingController _controller = TextEditingController();
  late String extensionOfFileName;
  late String fileNameWithoutExtension;
  late String newFileName;
  @override
  void initState() {
    extensionOfFileName =
        extensionOfString(fileName: widget.arguments!.pdfFileName);
    fileNameWithoutExtension = stringWithoutExtension(
        fileName: widget.arguments!.pdfFileName,
        extensionOfString: extensionOfFileName);
    _controller.text = fileNameWithoutExtension;
    tempPdfPath = widget.arguments!.pdfFilePath;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> deleteFile() async {
    try {
      final file = File(tempPdfPath);

      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  IconData appBarIconLeft = Icons.arrow_back;
  String appBarIconLeftToolTip = 'Back';
  Future<void> appBarIconLeftAction() async {
    deleteFile();
    //deleteCacheDir();
    deleteAppDir();

    return Navigator.of(context).pop();
  }

  IconData appBarIconRight = Icons.home_repair_service;
  String appBarIconRightToolTip = 'Done';
  Future appBarIconRightAction() {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      PageRoutes.mainPagesScaffold,
      (route) => false,
      arguments: MainPagesScaffoldArguments(
        bodyIndex: 0,
      ),
    );
    //   Navigator.pushNamed(
    //   context,
    //   PageRoutes.mainPagesScaffold,
    //   arguments: MainPagesScaffoldArguments(
    //     bodyIndex: 0,
    //   ),
    // );
  }

  var _openResult = 'Unknown';

  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
          listener: adState.adListener,
          adUnitId: adState.bannerAdUnitId,
          request: AdRequest(),
          size: AdSize.banner,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          deleteFile();
          //deleteCacheDir();
          deleteAppDir();
          return true;
        },
        child: Scaffold(
          appBar: ReusableSilverAppBar(
            title: 'Result',
            titleColor: Colors.black,
            leftButtonColor: Colors.red,
            appBarIconLeft: appBarIconLeft,
            appBarIconLeftToolTip: appBarIconLeftToolTip,
            appBarIconLeftAction: appBarIconLeftAction,
            rightButtonColor: Colors.blue,
            appBarIconRight: appBarIconRight,
            appBarIconRightToolTip: appBarIconRightToolTip,
            appBarIconRightAction: appBarIconRightAction,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                            'assets/images/tools_icons/pdf_tools_icon.svg',
                            fit: BoxFit.fitHeight,
                            height: 100,
                            alignment: Alignment.center,
                            semanticsLabel: 'PDF File Icon'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Your PDF is ready',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          // 'Test',
                          'File Size : ${formatBytes(File('$tempPdfPath').lengthSync(), 2)}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _controller,
                        maxLength: 100,
                        onChanged: (String value) {
                          newFileName = _controller.text + extensionOfFileName;
                          try {
                            var file = File(tempPdfPath);

                            String changeFileNameOnlySync(
                                File file, String newFileName) {
                              var path = file.path;
                              var lastSeparator =
                                  path.lastIndexOf(Platform.pathSeparator);
                              var newPath =
                                  path.substring(0, lastSeparator + 1) +
                                      newFileName;

                              file.renameSync(newPath);
                              return newPath;
                            }

                            tempPdfPath =
                                changeFileNameOnlySync(file, newFileName);

                            file = File(tempPdfPath);
                          } catch (e) {
                            print(e);
                          }
                          // creatingAndSavingFileTemporarily(newFileName)
                          //     .whenComplete(() {
                          //   setState(() {});
                          // });
                        },
                        decoration: InputDecoration(
                          hintText: "File Name",
                          suffixText: extensionOfFileName,
                          icon: Icon(Icons.drive_file_rename_outline,
                              color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ResultPageButtons(
                        buttonTitle: 'View Document',
                        onTapAction: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final _result = await OpenFile.open(tempPdfPath);
                          print(_result.message);

                          setState(() {
                            _openResult =
                                "type=${_result.type}  message=${_result.message}";
                          });
                          if (_result.type == ResultType.noAppToOpen) {
                            print(_openResult);
                            //Using default app pdf viewer instead of suggesting downloading others
                            Navigator.pushNamed(
                              context,
                              PageRoutes.pdfScaffold,
                              arguments: PDFScaffoldArguments(
                                pdfPath: tempPdfPath,
                              ),
                            );
                            // setState(() {
                            //   viewPDFBannerStatus = true;
                            // });
                          }
                        },
                        buttonIcon: Icons.preview,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      ResultPageButtons(
                        buttonTitle: 'Save Document',
                        onTapAction: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await saveFileInUserDescribedLocation();
                        },
                        buttonIcon: Icons.save,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      ResultPageButtons(
                        buttonTitle: 'Share Document',
                        onTapAction: () async {
                          Share.shareFiles([tempPdfPath]);
                        },
                        buttonIcon: Icons.share,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      SizedBox(
                        height: AdSize.banner.height.toDouble(),
                      ),
                    ],
                  ),
                ),
              ),
              banner == null
                  ? SizedBox(
                      height: AdSize.banner.height.toDouble(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: AdSize.banner.height.toDouble(),
                          child: AdWidget(
                            ad: banner!,
                          ),
                        ),
                      ],
                    ),
              viewPDFBannerStatus
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                //top: BorderSide(color: Colors.grey, width: 1.5),
                                ),
                          ),
                          child: MaterialBanner(
                            padding: EdgeInsets.all(5),
                            content: Text(
                              'Hello, no app was found on your device to view the pdf file.\n\nClick "INSTALL" to install "Files"(recommended) app which can open pdf files.',
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Icon(Icons.info_outline_rounded),
                            backgroundColor: Color(0xffDBF0F3),
                            actions: <Widget>[
                              OutlinedButton(
                                child: Text('INSTALL'),
                                onPressed: () {
                                  setState(() {
                                    viewPDFBannerStatus = false;
                                  });
                                  StoreRedirect.redirect(
                                      androidAppId:
                                          "com.google.android.apps.nbu.files");
                                },
                              ),
                              OutlinedButton(
                                child: Text('DISMISS'),
                                onPressed: () {
                                  setState(() {
                                    viewPDFBannerStatus = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPDFScaffoldArguments {
  String pdfFilePath;
  String pdfFileName;
  PdfDocument document;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  ResultPDFScaffoldArguments({
    required this.pdfFilePath,
    required this.pdfFileName,
    required this.document,
    required this.mapOfSubFunctionDetails,
  });
}
