import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/ui/topLevelPagesScaffold/mainPageScaffold.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/permissionDialogBox.dart';
import 'package:files_tools/widgets/resultPageWidgets/ResultPageButtons.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'dart:io';
import 'dart:async';
import 'package:files_tools/basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_theme/fitness_app_theme.dart';
import '../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:path/path.dart' as PathLibrary;
import 'package:store_redirect/store_redirect.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ResultZipScaffold extends StatefulWidget {
  static const String routeName = '/resultZipScaffold';
  const ResultZipScaffold({Key? key, this.arguments}) : super(key: key);

  final ResultZipScaffoldArguments? arguments;

  @override
  _ResultZipScaffoldState createState() => _ResultZipScaffoldState();
}

class _ResultZipScaffoldState extends State<ResultZipScaffold> {
  late String tempZipPath;
  late String userZipPath;
  File? file;

  bool viewZipBannerStatus = false;

  Future<String?> saveFileInUserDescribedLocation() async {
    final params = SaveFileDialogParams(
        sourceFilePath: tempZipPath, mimeTypesFilter: ["application/zip"]);
    //data: Uint8List.fromList(bytes), fileName: 'Test.pdf');
    final filePath = await FlutterFileDialog.saveFile(params: params);
    print(filePath);
    return filePath;
  }

  Future<void> extractZipInUserDescribedLocation() async {
    String? result = await FilePicker.platform
        .getDirectoryPath(); //changes are made according to this https://github.com/miguelpruivo/flutter_file_picker/pull/763 to make it work. also read https://github.com/miguelpruivo/flutter_file_picker/issues/745
    print('result: $result');

    if (result != null && result != '/') {
      final zipFile = File("${widget.arguments!.rangesPdfsZipFilePath}");
      final destinationDir = Directory("$result");
      try {
        ZipFile.extractToDirectory(
            zipFile: zipFile, destinationDir: destinationDir);
      } catch (e) {
        print(e);
      }
    }
  }

  TextEditingController _controller = TextEditingController();
  late String extensionOfFileName;
  late String fileNameWithoutExtension;
  late String newFileName;

  List<Widget>? dialogActionButtonsListForDeniedPermission;
  String? dialogTextForDeniedPermission;

  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? androidInfo;
  Future<AndroidDeviceInfo?> androidDeviceInfo() async {
    androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
  }

  @override
  void initState() {
    File file = File("${widget.arguments!.rangesPdfsZipFilePath}");
    String fileName = PathLibrary.basename(file.path);
    print("filename : $fileName");

    if (Platform.isAndroid) {
      androidDeviceInfo();
    }

    dialogActionButtonsListForDeniedPermission = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Not now'),
      ),
      OutlinedButton(
        onPressed: () async {
          Navigator.pop(context);
          await Permission.manageExternalStorage.request().then((value) {
            if (value == PermissionStatus.granted) {
              print('Permission granted');
            } else if (value == PermissionStatus.denied) {
              print(
                  'Denied. Show a dialog with a reason and again ask for the permission.');
            } else if (value == PermissionStatus.permanentlyDenied) {
              print('Take the user to the settings page.');
            }
            return null;
          });
        },
        child: const Text('Continue'),
      ),
    ];
    dialogTextForDeniedPermission =
        'In order to extract the zip to your desired location, Files Tools App requires access to manage all files permission. To allow this permission tap "Continue" and enable "Allow access to manage all files".';

    extensionOfFileName = extensionOfString(fileName: fileName);
    fileNameWithoutExtension = stringWithoutExtension(
        fileName: fileName, extensionOfString: extensionOfFileName);

    _controller.text = fileNameWithoutExtension;
    tempZipPath = widget.arguments!.rangesPdfsZipFilePath;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> deleteFile() async {
    try {
      final file = File(tempZipPath);

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
                            'assets/images/tools_icons/zip_tools_icon.svg',
                            fit: BoxFit.fitHeight,
                            height: 100,
                            alignment: Alignment.center,
                            semanticsLabel: 'A red up arrow'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Your files are ready',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Color(0xFFF2C614),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          // 'Test',
                          'File Size : ${formatBytes(File('$tempZipPath').lengthSync(), 2)}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFF2C614),
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
                            var file = File(tempZipPath);

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

                            tempZipPath =
                                changeFileNameOnlySync(file, newFileName);

                            file = File(tempZipPath);
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
                        buttonTitle: 'View Zip',
                        onTapAction: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final _result = await OpenFile.open(tempZipPath);
                          print(_result.message);

                          setState(() {
                            _openResult =
                                "type=${_result.type}  message=${_result.message}";
                          });
                          if (_result.type == ResultType.noAppToOpen) {
                            print(_openResult);
                            setState(() {
                              viewZipBannerStatus = true;
                            });
                          }
                        },
                        buttonIcon: Icons.preview,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      ResultPageButtons(
                        buttonTitle: 'Save Zip',
                        onTapAction: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await saveFileInUserDescribedLocation();
                        },
                        buttonIcon: Icons.save,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      ResultPageButtons(
                        buttonTitle: 'Extract Zip',
                        onTapAction: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          print(androidInfo!.version.sdkInt);
                          if (androidInfo!.version.sdkInt! >= 30 &&
                              Platform.isAndroid) {
                            if (await Permission
                                .manageExternalStorage.isGranted) {
                              print('Permission granted');
                              extractZipInUserDescribedLocation();
                            } else if (await Permission
                                .manageExternalStorage.isDenied) {
                              print(
                                  'Denied. Show a dialog with a reason and again ask for the permission.');
                              permissionDialogBox(
                                  context: context,
                                  text: dialogTextForDeniedPermission,
                                  actionButtonsList:
                                      dialogActionButtonsListForDeniedPermission);
                            } else if (await Permission
                                .manageExternalStorage.isPermanentlyDenied) {
                              print('Take the user to the settings page.');
                            }
                          } else if (Platform.isAndroid) {
                            extractZipInUserDescribedLocation();
                          }
                        },
                        buttonIcon: Icons.folder_open_outlined,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                      ResultPageButtons(
                        buttonTitle: 'Share Zip',
                        onTapAction: () async {
                          Share.shareFiles([tempZipPath]);
                        },
                        buttonIcon: Icons.share,
                        mapOfSubFunctionDetails:
                            widget.arguments!.mapOfSubFunctionDetails,
                      ),
                    ],
                  ),
                ),
              ),
              viewZipBannerStatus
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
                                'Hello, no app was found on your device to view the zip file.\n\nClick "INSTALL" to install "WinRAR"(recommended) app which can open zip files.'),
                            leading: Icon(Icons.info_outline_rounded),
                            backgroundColor: Color(0xffDBF0F3),
                            actions: <Widget>[
                              TextButton(
                                child: Text('INSTALL'),
                                onPressed: () {
                                  setState(() {
                                    viewZipBannerStatus = false;
                                  });
                                  StoreRedirect.redirect(
                                      androidAppId: "com.rarlab.rar");
                                },
                              ),
                              TextButton(
                                child: Text('DISMISS'),
                                onPressed: () {
                                  setState(() {
                                    viewZipBannerStatus = false;
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

class ResultZipScaffoldArguments {
  String rangesPdfsZipFilePath;
  PlatformFile? pdfFile;
  List<String> rangesPdfsFilePaths;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  ResultZipScaffoldArguments({
    required this.rangesPdfsZipFilePath,
    this.pdfFile,
    required this.rangesPdfsFilePaths,
    required this.mapOfSubFunctionDetails,
  });
}
