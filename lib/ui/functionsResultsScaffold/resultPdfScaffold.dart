import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfScaffold.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:files_tools/widgets/resultPageWidgets/viewFileBanner.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/widgets/resultPageWidgets/ResultPageButtons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
    debugPrint(filePath);
    return filePath;
  }

  final TextEditingController _controller = TextEditingController();
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
      debugPrint(e.toString());
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

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: GestureDetector(
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
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
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            // 'Test',
                            'File Size : ${formatBytes(File(tempPdfPath).lengthSync(), 2)}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _controller,
                          maxLength: 100,
                          onChanged: (String value) {
                            newFileName =
                                _controller.text + extensionOfFileName;
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
                              debugPrint(e.toString());
                            }
                            // creatingAndSavingFileTemporarily(newFileName)
                            //     .whenComplete(() {
                            //   setState(() {});
                            // });
                          },
                          decoration: InputDecoration(
                            hintText: "File Name",
                            suffixText: extensionOfFileName,
                            icon: const Icon(Icons.drive_file_rename_outline),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        ResultPageButtons(
                          buttonTitle: 'View Document',
                          onTapAction: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final _result = await OpenFile.open(tempPdfPath);
                            debugPrint(_result.message);

                            setState(() {
                              _openResult =
                                  "type=${_result.type}  message=${_result.message}";
                            });
                            if (_result.type == ResultType.noAppToOpen) {
                              debugPrint(_openResult);
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
                        Provider.of<AdState>(context).bannerAdUnitId != null
                            ? SizedBox(
                                height: bannerAdSize.height.toDouble(),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MeasureSize(
                      onChange: (Size size) {
                        setState(() {
                          bannerAdSize = size;
                        });
                      },
                      child: const BannerAD(),
                    ),
                  ],
                ),
                viewPDFBannerStatus
                    ? NoFileOpenerAvailableNotifierBanner(
                        onViewZipBannerStatus: (bool value) {
                          setState(() {
                            viewPDFBannerStatus = value;
                          });
                        },
                        redirectAndroidAppId:
                            'com.google.android.apps.nbu.files',
                        bannerText:
                            'Hello, no app was found on your device to view the pdf file.\n\nClick "INSTALL" to install "Files"(recommended) app which can open pdf files.',
                      )
                    : Container(),
              ],
            ),
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
