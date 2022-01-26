import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/widgets/functionsMainWidgets/directPop.dart';
import 'package:files_tools/widgets/functionsMainWidgets/onWillPopDialog.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/checkEncryptedDocument.dart';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:files_tools/widgets/functionsMainWidgets/permissionDialogBox.dart';
import 'package:files_tools/widgets/functionsMainWidgets/dialogActionBodyOfButtonForSelectedMultiplePdfs.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_theme/app_theme.dart';
import '../../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:files_tools/widgets/functionsMainWidgets/functionsButtons.dart';

class PDFFunctionBodyForMultipleFiles extends StatefulWidget {
  const PDFFunctionBodyForMultipleFiles(
      {Key? key,
      this.notifyBodyPoppingSplitPDFFunctionScaffold,
      this.onNotifyAppbarFileStatus,
      this.mapOfFunctionDetails})
      : super(key: key);

  final bool? notifyBodyPoppingSplitPDFFunctionScaffold;
  final ValueChanged<bool>? onNotifyAppbarFileStatus;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _PDFFunctionBodyForMultipleFilesState createState() =>
      _PDFFunctionBodyForMultipleFilesState();
}

class _PDFFunctionBodyForMultipleFilesState
    extends State<PDFFunctionBodyForMultipleFiles>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String? loadedPercent;
  int? lengthOfDigits;
  bool firstRun = true;
  List<Widget>? dialogActionButtonsListForPermanentlyDeniedPermission;
  List<Widget>? dialogActionButtonsListForDeniedPermission;
  String? dialogTextForPermanentlyDeniedPermission;
  String? dialogTextForDeniedPermission;

  List<bool> fileSelectionCompatibility = [];
  bool fileSelectionCompatibilityStatus = true;

  bool isFileLoadingRequired = true;

  @override
  void initState() {
    int actionWhoRequireFileLoadingCount = 0;
    for (int i = 0;
        i < widget.mapOfFunctionDetails!['Sublist Functions'].length;
        i++) {
      if (widget.mapOfFunctionDetails!['Sublist Functions'][i]
              ['File Loading Required'] ==
          true) {
        actionWhoRequireFileLoadingCount++;
      }
    }

    if (actionWhoRequireFileLoadingCount == 0) {
      isFileLoadingRequired = false;
    }

    controller = AnimationController(
      value: 0,
      vsync: this,
      // duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {
          loadedPercent = ((controller.value * 100).round()).toString();
          lengthOfDigits = ((controller.value * 100).round()).toString().length;
        });
      });
    //controller.repeat(reverse: false);

    loadedPercent = ((controller.value * 100).round()).toString();
    lengthOfDigits = ((controller.value * 100).round()).toString().length;

    if (firstRun) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        debugPrint('build complete');
        if (await Permission.storage.isGranted == true) {
          setState(() {
            storagePermissionPermanentlyDenied = false;
          });
        } else {
          getBoolValuesSF() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //Return bool
            bool storagePermissionPermanentlyDeniedBoolValue =
                prefs.getBool('storagePermissionPermanentlyDeniedBoolValue') ??
                    false;
            debugPrint(prefs
                .getBool('storagePermissionPermanentlyDeniedBoolValue')
                .toString());
            return storagePermissionPermanentlyDeniedBoolValue;
          }

          bool value = await getBoolValuesSF();
          setState(() {
            storagePermissionPermanentlyDenied = value;
          });
        }
        firstRun = false;
        return;
      });
    }

    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      debugPrint('resumeCallBack');
      if (await Permission.storage.isGranted == true) {
        if (mounted) {
          setState(() {
            storagePermissionPermanentlyDenied = false;
          });
        }
        addBoolToSF() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('storagePermissionPermanentlyDeniedBoolValue', false);
        }

        addBoolToSF();
      }
    }));

    dialogActionButtonsListForPermanentlyDeniedPermission = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Not now'),
      ),
      OutlinedButton(
        onPressed: () async {
          Navigator.pop(context);
          await openAppSettings().then((value) {
            debugPrint('setting could be opened: $value');
            return null;
          });
        },
        child: const Text('Settings'),
      ),
    ];

    dialogActionButtonsListForDeniedPermission = [
      OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Ok'),
      ),
    ];

    dialogTextForPermanentlyDeniedPermission =
        'In order to select documents, Files Tools App requires access to photos and media permission.\nTo allow the permission tap Settings > Permissions > Files and Media and select "Allow access to media only".';
    dialogTextForDeniedPermission =
        'In order to select documents, Files Tools App requires access to photos and media permission. Please allow access to continue further.';

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isFilePicked = false;
  List<bool> listOfFilesLoadedStatus = [];
  bool isFilesLoaded = false;
  bool isFilePickingInitiated = false;
  late List<File> files;
  late List<String> filePaths;
  late List<String> fileNames;
  late List<int> fileBytes;
  int filesSize = 0;
  bool shouldRenderingImagesLoopBeDisabled = false;

  List<pdfRenderer.PdfPageImage?> listPDFPagesImages = [];
  List<List<pdfRenderer.PdfPageImage?>> listOfListPDFPagesImages = [];

  var myChildSize = Size.zero;
  bool storagePermissionPermanentlyDenied = false;

  bool filesLoadingStatusCalc() {
    bool ifEveryTrue = listOfFilesLoadedStatus.every((element) {
      return (element == true);
    });

    if (ifEveryTrue == true && listOfFilesLoadedStatus.length >= 2) {
      return true;
    } else {
      return false;
    }
  }

  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  int _count = 0;

  List<Widget> widgetListForDialogActionOfButtonForSelectedMultipleFiles = [];

  Future<void> multipleFilesSelectedActionDialog() async {
    await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        widgetListForDialogActionOfButtonForSelectedMultipleFiles =
            List<Widget>.generate(filePaths.length, (int index) {
          String fileName = fileNames[index];
          String filePath = filePaths[index];
          int fileByte = fileBytes[index];
          return DialogActionBodyOfButtonForSelectedMultipleFiles(
            fileByte: fileByte,
            filePath: filePath,
            fileName: fileName,
            mapOfFunctionDetails: widget.mapOfFunctionDetails,
          );
        });
        return SimpleDialog(
          title: Center(
            child: Column(
              children: const [
                Text('Selected Files'),
                Text('Click to view'),
              ],
            ),
          ),
          children: widgetListForDialogActionOfButtonForSelectedMultipleFiles,
        );
      },
    );
  }

  Future<List<pdfRenderer.PdfPageImage?>> nativePDFRendererToImg(
      String filePath, int x) async {
    try {
      final newDocument = await pdfRenderer.PdfDocument.openFile(filePath);
      final pagesCount = newDocument.pagesCount;

      double indicatorSteps = 1 / pagesCount;

      listPDFPagesImages = [];
      for (var i = 1;
          i <= pagesCount &&
              shouldRenderingImagesLoopBeDisabled == false &&
              widget.notifyBodyPoppingSplitPDFFunctionScaffold == false;
          i++) {
        pdfRenderer.PdfPage page =
            await newDocument.getPage(i); //always start from 1
        //pages.add(page);

        debugPrint('height: ' +
            page.height.toString() +
            ' width: ' +
            page.width.toString());

        int pageHeight = ((page.height) / 1).round();
        int pageWidth = ((page.width) / 1).round();

        pdfRenderer.PdfPageImage? pageImage = await page.render(
          width: pageWidth,
          height: pageHeight,
          format: pdfRenderer.PdfPageFormat.JPEG,
        );

        listPDFPagesImages.add(pageImage);
        await page.close();
        debugPrint(i.toString());
        controller.value += indicatorSteps;

        if (i == pagesCount) {
          setState(() {
            listOfFilesLoadedStatus.removeAt(x);
            listOfFilesLoadedStatus.insert(x, true);
            isFilesLoaded = filesLoadingStatusCalc();
          });
        } else {
          setState(() {
            listOfFilesLoadedStatus.removeAt(x);
            listOfFilesLoadedStatus.insert(x, false);
            isFilesLoaded = filesLoadingStatusCalc();
          });
        }
      }

      controller.value = 0;

      // listOfListPDFPagesImages
      //     .add(
      //         listPDFPagesImages);

      newDocument.close();
      return listPDFPagesImages;
    } on PlatformException catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  int filesEncryptedCount = 0;

  ScrollController scrollController = ScrollController();

  var bannerAdSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KeyedSubtree(
          // This is the trick to reset whole page! Required to reset step-2 button warnings
          //refer https://stackoverflow.com/a/64183322 for more info
          key: ValueKey<int>(_count),
          child: WillPopScope(
            onWillPop: isFilePicked == true
                ? () => onWillPopForSelectedFile(context)
                : () => directPop(),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: Stack(
                  children: [
                    Container(
                      height: 15,
                      color: widget.mapOfFunctionDetails!['BG Color'],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        decoration: const BoxDecoration(
                          //color: Color(0xFFFFAFAFA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: GestureDetector(
                                        onTapDown:
                                            (TapDownDetails tapDownDetails) {
                                          setState(() {
                                            buttonElevation =
                                                onTapDownButtonElevation;
                                          });
                                        },
                                        onTapUp: (TapUpDetails tapUpDetails) {
                                          setState(() {
                                            buttonElevation =
                                                defaultButtonElevation;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            buttonElevation =
                                                defaultButtonElevation;
                                          });
                                        },
                                        onPanEnd:
                                            (DragEndDetails dragEndDetails) {
                                          setState(() {
                                            buttonElevation =
                                                defaultButtonElevation;
                                          });
                                        },
                                        child: Material(
                                          elevation:
                                              isFilePickingInitiated == false
                                                  ? buttonElevation
                                                  : 0,
                                          color: widget.mapOfFunctionDetails![
                                                  'Select File Button Color'] ??
                                              const Color(0xffE4EAF6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: InkWell(
                                            onTap: isFilePickingInitiated ==
                                                    false
                                                ? storagePermissionPermanentlyDenied ==
                                                        false
                                                    ? () async {
                                                        if (isFilePicked ==
                                                                false &&
                                                            isFilePickingInitiated ==
                                                                false) {
                                                          final status = Platform
                                                                      .isAndroid ||
                                                                  Platform.isIOS
                                                              ? await Permission
                                                                  .storage
                                                                  .request()
                                                              : PermissionStatus
                                                                  .granted;
                                                          if (status ==
                                                              PermissionStatus
                                                                  .granted) {
                                                            isFilePickingInitiated =
                                                                true;

                                                            debugPrint(
                                                                'Permission granted');
                                                            FilePickerResult?
                                                                result =
                                                                await FilePicker
                                                                    .platform
                                                                    .pickFiles(
                                                              type: FileType
                                                                  .custom,
                                                              allowMultiple:
                                                                  true,
                                                              allowedExtensions: [
                                                                'pdf',
                                                              ],
                                                            );

                                                            checkCompatibility() {
                                                              fileSelectionCompatibility =
                                                                  [];
                                                              fileSelectionCompatibilityStatus =
                                                                  false;
                                                              debugPrint(
                                                                  'checking compatibility');
                                                              for (int i = 0;
                                                                  i <
                                                                      result!
                                                                          .names
                                                                          .length;
                                                                  i++) {
                                                                if (extensionOfString(
                                                                        fileName:
                                                                            result.names[i]!) ==
                                                                    '.pdf') {
                                                                  fileSelectionCompatibility
                                                                      .add(
                                                                          true);
                                                                } else {
                                                                  fileSelectionCompatibility
                                                                      .add(
                                                                          false);
                                                                }
                                                              }
                                                              if (kDebugMode) {
                                                                print(
                                                                    fileSelectionCompatibility);
                                                              }

                                                              bool ifEveryTrue =
                                                                  fileSelectionCompatibility
                                                                      .every(
                                                                          (element) {
                                                                return (element ==
                                                                    true);
                                                              });
                                                              if (ifEveryTrue ==
                                                                  true) {
                                                                fileSelectionCompatibilityStatus =
                                                                    true;
                                                              } else {
                                                                fileSelectionCompatibilityStatus =
                                                                    false;
                                                              }
                                                            }

                                                            if (result !=
                                                                    null &&
                                                                !result
                                                                    .isSinglePick) {
                                                              checkCompatibility();
                                                            }
                                                            if (result !=
                                                                    null &&
                                                                !result
                                                                    .isSinglePick &&
                                                                fileSelectionCompatibilityStatus) {
                                                              files = result
                                                                  .paths
                                                                  .map((path) =>
                                                                      File(
                                                                          path!))
                                                                  .toList();

                                                              filePaths = result
                                                                  .paths
                                                                  .map((path) =>
                                                                      path!)
                                                                  .toList();

                                                              fileNames = result
                                                                  .names
                                                                  .map((names) =>
                                                                      names!)
                                                                  .toList();

                                                              fileBytes = result
                                                                  .paths
                                                                  .map((path) =>
                                                                      File(path!)
                                                                          .lengthSync())
                                                                  .toList();

                                                              filesSize = 0;
                                                              for (int y = 0;
                                                                  y <
                                                                      files
                                                                          .length;
                                                                  y++) {
                                                                filesSize =
                                                                    filesSize +
                                                                        fileBytes[
                                                                            y];
                                                              }

                                                              setState(() {
                                                                isFilePicked =
                                                                    true;
                                                                isFilePickingInitiated =
                                                                    false;
                                                                widget
                                                                    .onNotifyAppbarFileStatus
                                                                    ?.call(
                                                                        true);
                                                              });

                                                              shouldRenderingImagesLoopBeDisabled =
                                                                  false;

                                                              listOfListPDFPagesImages =
                                                                  [];
                                                              listOfFilesLoadedStatus =
                                                                  [];
                                                              filesEncryptedCount =
                                                                  0;

                                                              bool
                                                                  shouldEncryptedDocumentsAllowed =
                                                                  widget.mapOfFunctionDetails![
                                                                      'Encrypted Files Allowed'];

                                                              if (shouldEncryptedDocumentsAllowed ==
                                                                  false) {
                                                                for (int x = 0;
                                                                    x < files.length &&
                                                                        shouldRenderingImagesLoopBeDisabled ==
                                                                            false &&
                                                                        filesEncryptedCount ==
                                                                            0;
                                                                    x++) {
                                                                  setState(() {
                                                                    listOfFilesLoadedStatus
                                                                        .insert(
                                                                            x,
                                                                            false);
                                                                  });

                                                                  bool
                                                                      isEncryptedDocument =
                                                                      checkEncryptedDocument(
                                                                          files[x]
                                                                              .path);

                                                                  if (isEncryptedDocument ==
                                                                      true) {
                                                                    filesEncryptedCount++;
                                                                  }

                                                                  if (isFileLoadingRequired ==
                                                                      true) {
                                                                    if (isEncryptedDocument ==
                                                                        false) {
                                                                      listOfListPDFPagesImages.add(await nativePDFRendererToImg(
                                                                          files[x]
                                                                              .path,
                                                                          x));
                                                                      debugPrint(
                                                                          "hello: ${listOfListPDFPagesImages[x].length}");
                                                                    }
                                                                  } else {
                                                                    isFilePickingInitiated =
                                                                        false;
                                                                    isFilesLoaded =
                                                                        true;
                                                                  }
                                                                }
                                                                if (filesEncryptedCount !=
                                                                    0) {
                                                                  debugPrint(
                                                                      'Document encrypted & encrypted documents are not allowed');
                                                                  setState(() {
                                                                    isFilePickingInitiated =
                                                                        false;
                                                                    isFilePicked =
                                                                        false;
                                                                    widget
                                                                        .onNotifyAppbarFileStatus
                                                                        ?.call(
                                                                            false);
                                                                  });
                                                                  final encryptedFileWarningSnackBar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        '${filesEncryptedCount.toString()} file was encrypted & encrypted File are not allowed!\nDecrypt it using the decrypt function.'),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          'Ok',
                                                                      onPressed:
                                                                          () {
                                                                        // Some code to undo the change.
                                                                      },
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          encryptedFileWarningSnackBar);
                                                                } else {
                                                                  debugPrint(
                                                                      'Document not encrypted & encrypted documents are not allowed');
                                                                }
                                                              } else {
                                                                for (int x = 0;
                                                                    x < files.length &&
                                                                        shouldRenderingImagesLoopBeDisabled ==
                                                                            false;
                                                                    x++) {
                                                                  setState(() {
                                                                    listOfFilesLoadedStatus
                                                                        .insert(
                                                                            x,
                                                                            false);
                                                                  });

                                                                  bool
                                                                      isEncryptedDocument =
                                                                      checkEncryptedDocument(
                                                                          files[x]
                                                                              .path);

                                                                  if (isEncryptedDocument ==
                                                                      true) {
                                                                    filesEncryptedCount++;
                                                                  }

                                                                  if (isFileLoadingRequired ==
                                                                      true) {
                                                                    if (isEncryptedDocument ==
                                                                        false) {
                                                                      listOfListPDFPagesImages.add(await nativePDFRendererToImg(
                                                                          files[x]
                                                                              .path,
                                                                          x));
                                                                      debugPrint(
                                                                          'Document not encrypted & encrypted documents are allowed');
                                                                    } else {
                                                                      debugPrint(
                                                                          'Document encrypted & encrypted documents are allowed');
                                                                    }
                                                                  } else {
                                                                    isFilePickingInitiated =
                                                                        false;
                                                                    isFilesLoaded =
                                                                        true;
                                                                  }
                                                                }
                                                              }
                                                            } else {
                                                              setState(() {
                                                                isFilePickingInitiated =
                                                                    false;
                                                                isFilePicked =
                                                                    false;
                                                                widget
                                                                    .onNotifyAppbarFileStatus
                                                                    ?.call(
                                                                        false);
                                                              }); // User canceled the picker or pick 1 file
                                                              if (result !=
                                                                      null &&
                                                                  result
                                                                      .isSinglePick) {
                                                                final fileNumberWarningSnackBar =
                                                                    SnackBar(
                                                                  content:
                                                                      const Text(
                                                                          'Please choose more than one file.'),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label: 'Ok',
                                                                    onPressed:
                                                                        () {
                                                                      // Some code to undo the change.
                                                                    },
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        fileNumberWarningSnackBar);
                                                              } // User picked 1 file
                                                              if (result !=
                                                                      null &&
                                                                  !fileSelectionCompatibilityStatus) {
                                                                final pdfFileTypeWarning =
                                                                    SnackBar(
                                                                  content:
                                                                      const Text(
                                                                          'Non PDF File is not allowed!\nPick only PDF file.'),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label: 'Ok',
                                                                    onPressed:
                                                                        () {
                                                                      // Some code to undo the change.
                                                                    },
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        pdfFileTypeWarning);
                                                              } // User picked wrong file types
                                                            }
                                                          } else if (status ==
                                                              PermissionStatus
                                                                  .denied) {
                                                            debugPrint(
                                                                'Denied. Show a dialog with a reason and again ask for the permission.');
                                                            permissionDialogBox(
                                                                actionButtonsList:
                                                                    dialogActionButtonsListForDeniedPermission,
                                                                text:
                                                                    dialogTextForDeniedPermission,
                                                                context:
                                                                    context);
                                                          } else if (status ==
                                                              PermissionStatus
                                                                  .permanentlyDenied) {
                                                            debugPrint(
                                                                'Take the user to the settings page.');
                                                            setState(() {
                                                              storagePermissionPermanentlyDenied =
                                                                  true;
                                                            });
                                                            addBoolToSF() async {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.setBool(
                                                                  'storagePermissionPermanentlyDeniedBoolValue',
                                                                  true);
                                                            }

                                                            addBoolToSF();
                                                            permissionDialogBox(
                                                                actionButtonsList:
                                                                    dialogActionButtonsListForPermanentlyDeniedPermission,
                                                                text:
                                                                    dialogTextForPermanentlyDeniedPermission,
                                                                context:
                                                                    context);
                                                          }
                                                        } else if (isFilePicked ==
                                                            true) {
                                                          //todo names filesy or filesKit by usabl, shyny apps
                                                          ////todo Add more touch and ui improvement to the result page
                                                          //todo fix sematiclabels in svgpicture asset
                                                          //////todo hard and would lead to confusion //add conditions to disable buttons in functions on the basis of conditions such as 1 page image file in extraction or encrypt function in encrypted file
                                                          //todo Catch exceptions in processing functions.
                                                          ////todo Update dialog when taking too long
                                                          ////todo Update permission dialogbox color and appname text(get dynamically)
                                                          //////todo done in most cases. add color theme from parents color from parents
                                                          ////todo Add indicator notification for marked delete in modify that it will not be visible in real output file
                                                          //todo also setup encrypt add permissions. check if doc encrypted if it is then ask decrypt first and then setup permissions
                                                          //todo allow to set different type of encryption
                                                          //todo set a logo and name
                                                          //todo ready for beta release
                                                          multipleFilesSelectedActionDialog();
                                                        }
                                                      }
                                                    : () async {
                                                        permissionDialogBox(
                                                            actionButtonsList:
                                                                dialogActionButtonsListForPermanentlyDeniedPermission,
                                                            text:
                                                                dialogTextForPermanentlyDeniedPermission,
                                                            context: context);
                                                      }
                                                : null,
                                            customBorder:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                            focusColor: widget
                                                        .mapOfFunctionDetails![
                                                    'Select File Button Effects Color'] ??
                                                Colors.black.withOpacity(0.1),
                                            highlightColor: widget
                                                        .mapOfFunctionDetails![
                                                    'Select File Button Effects Color'] ??
                                                Colors.black.withOpacity(0.1),
                                            splashColor: widget
                                                        .mapOfFunctionDetails![
                                                    'Select File Button Effects Color'] ??
                                                Colors.black.withOpacity(0.1),
                                            hoverColor: widget
                                                        .mapOfFunctionDetails![
                                                    'Select File Button Effects Color'] ??
                                                Colors.black.withOpacity(0.1),
                                            child: Container(
                                              height: isFilePicked == true
                                                  ? null
                                                  : 75,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: isFilePicked == true
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            MeasureSize(
                                                              onChange: (size) {
                                                                setState(() {
                                                                  myChildSize =
                                                                      size;
                                                                  debugPrint(
                                                                      myChildSize
                                                                          .toString());
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        top: 20,
                                                                        bottom:
                                                                            20),
                                                                child: SvgPicture.asset(
                                                                    widget.mapOfFunctionDetails!['Select File Icon Asset'] ??
                                                                        'assets/images/tools_icons/pdf_tools_icon.svg',
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    height: 35,
                                                                    color: widget
                                                                            .mapOfFunctionDetails![
                                                                        'Select File Icon Color'],
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    semanticsLabel:
                                                                        'File Icon'),
                                                                // Image.asset(
                                                                //   'assets/images/pdf_icon.png',
                                                                //   fit: BoxFit.fitHeight,
                                                                //   height: 35,
                                                                // ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    files.length
                                                                            .toString() +
                                                                        ' ' +
                                                                        'files selected',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        formatBytes(
                                                                            filesSize,
                                                                            2),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      myChildSize
                                                                          .height,
                                                                  child:
                                                                      const VerticalDivider(
                                                                    color: Colors
                                                                        .black,
                                                                    // thickness: 1,
                                                                    width: 0,
                                                                    indent: 5,
                                                                    endIndent:
                                                                        5,
                                                                  ),
                                                                ),
                                                                Ink(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          const Radius.circular(
                                                                              10),
                                                                      bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                  false &&
                                                                              isFilesLoaded ==
                                                                                  false
                                                                          ? const Radius.circular(
                                                                              0)
                                                                          : const Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        shouldRenderingImagesLoopBeDisabled =
                                                                            true;
                                                                        isFilesLoaded =
                                                                            false;
                                                                        isFilePicked =
                                                                            false;
                                                                        widget
                                                                            .onNotifyAppbarFileStatus
                                                                            ?.call(false);
                                                                        FilePicker
                                                                            .platform
                                                                            .clearTemporaryFiles();

                                                                        // This is the trick to reset whole page! Required to reset step-2 button warnings
                                                                        ++_count; //the count would change the key of this widget forcing it to reset
                                                                      });
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          const Radius.circular(
                                                                              10),
                                                                      bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                  false &&
                                                                              isFilesLoaded ==
                                                                                  false
                                                                          ? const Radius.circular(
                                                                              0)
                                                                          : const Radius.circular(
                                                                              10),
                                                                    ),
                                                                    focusColor: widget.mapOfFunctionDetails![
                                                                            'Select File Button Effects Color'] ??
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                    highlightColor: widget.mapOfFunctionDetails![
                                                                            'Select File Button Effects Color'] ??
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                    splashColor: widget.mapOfFunctionDetails![
                                                                            'Select File Button Effects Color'] ??
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                    hoverColor: widget.mapOfFunctionDetails![
                                                                            'Select File Button Effects Color'] ??
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 50,
                                                                      height: myChildSize
                                                                          .height,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .close_outlined,
                                                                        size:
                                                                            20,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        shouldRenderingImagesLoopBeDisabled ==
                                                                    false &&
                                                                isFilesLoaded ==
                                                                    false //this condition means that the loading bar will only show when shouldRenderingImagesLoopBeDisabled & isFileLoaded is false. shouldRenderingImagesLoopBeDisabled false means that we have not disabled loading images and isFileLoaded false means file has not loaded until now.
                                                            ? Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius: const BorderRadius
                                                                            .only(
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomRight:
                                                                            Radius.circular(10)),
                                                                    child:
                                                                        LinearProgressIndicator(
                                                                      value: controller
                                                                          .value,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue[100],
                                                                      valueColor: const AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .blue),
                                                                      minHeight:
                                                                          16,
                                                                      semanticsLabel:
                                                                          'Linear progress indicator',
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Loading File: $loadedPercent %',
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                        softWrap:
                                                                            false,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                      ],
                                                    )
                                                  : isFilePickingInitiated ==
                                                          false
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              'Select Multiple Files',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: AppTheme
                                                                    .darkText,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Icon(
                                                              Icons.add,
                                                              size: 30,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              'Please wait ...',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: AppTheme
                                                                    .darkText,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                const Divider(
                                  height: 50,
                                  thickness: 1.5,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        height: 30,
                                        width: 70,
                                        child: const Center(
                                          child: Text(
                                            'Step - 2',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              color: AppTheme.darkText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              controller: scrollController,
                              children: List<Widget>.generate(
                                  widget
                                      .mapOfFunctionDetails![
                                          'Sublist Functions']
                                      .length, (int index) {
                                return Column(
                                  children: [
                                    PDFFunctions(
                                      filePickedStatus: isFilePicked,
                                      fileLoadingStatus: isFilesLoaded,
                                      onTapAction: () => widget
                                                      .mapOfFunctionDetails![
                                                  'Sublist Functions'][index]
                                              ['Action'](
                                          files,
                                          listOfListPDFPagesImages,
                                          filePaths,
                                          fileNames,
                                          fileBytes,
                                          widget.mapOfFunctionDetails![
                                              'Sublist Functions'][index],
                                          context),
                                      subFunctionDetailMap:
                                          widget.mapOfFunctionDetails![
                                              'Sublist Functions'][index],
                                    ),
                                    SizedBox(
                                      height: index ==
                                              widget
                                                      .mapOfFunctionDetails![
                                                          'Sublist Functions']
                                                      .length -
                                                  1
                                          ? bannerAdSize.height.toDouble() + 10
                                          : 20,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 30,
                          width: 70,
                          child: const Center(
                            child: Text(
                              'Step - 1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: AppTheme.darkText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
      ],
    );
  }
}
