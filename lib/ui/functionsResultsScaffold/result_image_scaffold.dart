import 'dart:typed_data';
// import 'package:extended_image/extended_image.dart';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/size_calculator.dart';
import 'package:files_tools/widgets/annotated_region.dart';
import 'package:files_tools/widgets/resultPageWidgets/saving_dialog.dart';
import 'package:files_tools/widgets/resultPageWidgets/view_file_banner.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:files_tools/basicFunctionalityFunctions/file_name_manager.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/main_page_scaffold.dart';
import 'package:files_tools/widgets/resultPageWidgets/result_page_buttons.dart';
import 'package:files_tools/widgets/reusableUIWidgets/reusable_top_appbar.dart';
import 'dart:io';
import 'dart:async';
import 'package:files_tools/basicFunctionalityFunctions/manage_app_directory_and_cache.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_theme/app_theme.dart';
import '../../basicFunctionalityFunctions/get_size_from_bytes.dart';

class ResultImageScaffold extends StatefulWidget {
  static const String routeName = '/resultImageScaffold';
  const ResultImageScaffold({Key? key, this.arguments}) : super(key: key);

  final ResultImageScaffoldArguments? arguments;

  @override
  _ResultImageScaffoldState createState() => _ResultImageScaffoldState();
}

class _ResultImageScaffoldState extends State<ResultImageScaffold> {
  late String tempImagePath;

  File? file;

  List<String>? mimeTypes = ['image/jpg', 'image/jpeg', 'image/png'];
  bool viewPDFBannerStatus = false;

  Future<String?> saveFileInUserDescribedLocation() async {
    final params = SaveFileDialogParams(
        sourceFilePath: tempImagePath, mimeTypesFilter: mimeTypes);
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
    if (extensionOfFileName == '.jpg' || extensionOfFileName == '.jpeg') {
      mimeTypes = ['image/jpg'];
    } else if (extensionOfFileName == '.png') {
      mimeTypes = ['image/png'];
    }
    fileNameWithoutExtension = stringWithoutExtension(
        fileName: widget.arguments!.pdfFileName,
        extensionOfString: extensionOfFileName);
    _controller.text = fileNameWithoutExtension;
    tempImagePath = widget.arguments!.filePath;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> deleteFile() async {
    try {
      final file = File(tempImagePath);

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
                              'assets/images/tools_icons/image_tools_icon.svg',
                              fit: BoxFit.fitHeight,
                              height: 100,
                              alignment: Alignment.center,
                              semanticsLabel: 'Image File Icon'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                          child: Text(
                            'Your Image is ready',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            // 'Test',
                            'File Size : ${formatBytes(File(tempImagePath).lengthSync(), 2)}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.blue,
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
                              var file = File(tempImagePath);

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

                              tempImagePath =
                                  changeFileNameOnlySync(file, newFileName);

                              file = File(tempImagePath);
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
                          buttonTitle: 'View Image',
                          onTapAction: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final _result = await OpenFile.open(tempImagePath);
                            debugPrint(_result.message);

                            setState(() {
                              _openResult =
                                  "type=${_result.type}  message=${_result.message}";
                            });
                            if (_result.type == ResultType.noAppToOpen) {
                              debugPrint(_openResult);
                              //Using default app pdf viewer instead of suggesting downloading others
                              // Navigator.pushNamed(
                              //   context,
                              //   PageRoutes.pdfScaffold,
                              //   arguments: PDFScaffoldArguments(
                              //     pdfPath: tempPdfPath,
                              //   ),
                              // );
                              setState(() {
                                viewPDFBannerStatus = true;
                              });
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
                          buttonTitle: 'Save To Gallery',
                          onTapAction: () async {
                            savingDialog(context); //shows the saving dialog
                            await GallerySaver.saveImage(
                                    widget.arguments!.filePath,
                                    albumName: 'Files Tools')
                                .then((saved) {
                              debugPrint("saved");
                            });
                            Navigator.pop(context); //closes the saving dialog
                            final filesSavedNotifierSnackBar = SnackBar(
                              content: const Text(
                                  'Files successfully saved in gallery.'),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(filesSavedNotifierSnackBar);
                          },
                          buttonIcon: Icons.folder_open_outlined,
                          mapOfSubFunctionDetails:
                              widget.arguments!.mapOfSubFunctionDetails,
                        ),
                        ResultPageButtons(
                          buttonTitle: 'Share Image',
                          onTapAction: () async {
                            Share.shareFiles([tempImagePath]);
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

class ResultImageScaffoldArguments {
  Uint8List? fileData;
  String filePath;
  String pdfFileName;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  ResultImageScaffoldArguments({
    this.fileData,
    required this.filePath,
    required this.pdfFileName,
    required this.mapOfSubFunctionDetails,
  });
}