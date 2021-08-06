import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/directPop.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/onWillPopDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/checkEncryptedDocument.dart';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/permissionDialogBox.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/dialogActionBodyOfButtonForSelectedMultipleFiles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../app_theme/fitness_app_theme.dart';
import '../../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/pdfFunctionsButtons.dart';

import '../../ad_state.dart';

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
        print('build complete');
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
            print(prefs.getBool('storagePermissionPermanentlyDeniedBoolValue'));
            return storagePermissionPermanentlyDeniedBoolValue;
          }

          bool value = await getBoolValuesSF();
          setState(() {
            storagePermissionPermanentlyDenied = value;
          });
        }
        firstRun = false;
        return null;
      });
    }

    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      print('resumeCallBack');
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
            print('setting could be opened: $value');
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
              children: [
                const Text('Selected Files'),
                const Text('Click to view'),
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

        print('height: ' +
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
        print(i);
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
      print(error);
      return [];
    }
  }

  int filesEncryptedCount = 0;

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

  ScrollController scrollController = ScrollController();

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
                ? () => onWillPop(context)
                : () => directPop(),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Stack(
                children: [
                  Container(
                    height: 15,
                    color: widget.mapOfFunctionDetails!['BG Color'] ?? null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      decoration: BoxDecoration(
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
                                            Color(0xffE4EAF6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                          onTap: isFilePickingInitiated == false
                                              ? storagePermissionPermanentlyDenied ==
                                                      false
                                                  ? () async {
                                                      if (isFilePicked ==
                                                              false &&
                                                          isFilePickingInitiated ==
                                                              false) {
                                                        final status =
                                                            await Permission
                                                                .storage
                                                                .request();
                                                        if (status ==
                                                            PermissionStatus
                                                                .granted) {
                                                          isFilePickingInitiated =
                                                              true;

                                                          print(
                                                              'Permission granted');
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.custom,
                                                            allowMultiple: true,
                                                            allowedExtensions: [
                                                              'pdf',
                                                            ],
                                                          );
                                                          if (result != null &&
                                                              !result
                                                                  .isSinglePick) {
                                                            files = result.paths
                                                                .map((path) =>
                                                                    File(path!))
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
                                                                  ?.call(true);
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
                                                                      .insert(x,
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
                                                                    listOfListPDFPagesImages.add(
                                                                        await nativePDFRendererToImg(
                                                                            files[x].path,
                                                                            x));
                                                                    print(
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
                                                                print(
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
                                                                        encryptedFileWarningSnackBar);
                                                              } else {
                                                                print(
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
                                                                      .insert(x,
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
                                                                    listOfListPDFPagesImages.add(
                                                                        await nativePDFRendererToImg(
                                                                            files[x].path,
                                                                            x));
                                                                    print(
                                                                        'Document not encrypted & encrypted documents are allowed');
                                                                  } else {
                                                                    print(
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
                                                                  ?.call(false);
                                                            }); // User canceled the picker or pick 1 file
                                                            if (result !=
                                                                null) {
                                                              final fileNumberWarningSnackBar =
                                                                  SnackBar(
                                                                content: const Text(
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
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      fileNumberWarningSnackBar);
                                                            } // User picked 1 file
                                                          }
                                                        } else if (status ==
                                                            PermissionStatus
                                                                .denied) {
                                                          print(
                                                              'Denied. Show a dialog with a reason and again ask for the permission.');
                                                          permissionDialogBox(
                                                              actionButtonsList:
                                                                  dialogActionButtonsListForDeniedPermission,
                                                              text:
                                                                  dialogTextForDeniedPermission,
                                                              context: context);
                                                        } else if (status ==
                                                            PermissionStatus
                                                                .permanentlyDenied) {
                                                          print(
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
                                                              context: context);
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
                                          customBorder: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
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
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
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
                                                                print(
                                                                    myChildSize);
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      top: 20,
                                                                      bottom:
                                                                          20),
                                                              child: SvgPicture.asset(
                                                                  widget.mapOfFunctionDetails![
                                                                          'Select File Icon Asset'] ??
                                                                      'assets/images/tools_icons/pdf_tools_icon.svg',
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  height: 35,
                                                                  color: widget
                                                                              .mapOfFunctionDetails![
                                                                          'Select File Icon Color'] ??
                                                                      null,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  semanticsLabel:
                                                                      'A red up arrow'),
                                                              // Image.asset(
                                                              //   'assets/images/pdf_icon.png',
                                                              //   fit: BoxFit.fitHeight,
                                                              //   height: 35,
                                                              // ),
                                                            ),
                                                          ),
                                                          SizedBox(
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
                                                                  "${files.length.toString() + ' ' + 'files selected'}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      '${formatBytes(filesSize, 2)}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
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
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                height:
                                                                    myChildSize
                                                                        .height,
                                                                child:
                                                                    VerticalDivider(
                                                                  color: Colors
                                                                      .black,
                                                                  // thickness: 1,
                                                                  width: 0,
                                                                  indent: 5,
                                                                  endIndent: 5,
                                                                ),
                                                              ),
                                                              Ink(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                false &&
                                                                            isFilesLoaded ==
                                                                                false
                                                                        ? Radius
                                                                            .circular(
                                                                                0)
                                                                        : Radius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: InkWell(
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
                                                                          ?.call(
                                                                              false);
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
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                false &&
                                                                            isFilesLoaded ==
                                                                                false
                                                                        ? Radius
                                                                            .circular(
                                                                                0)
                                                                        : Radius.circular(
                                                                            10),
                                                                  ),
                                                                  focusColor: widget
                                                                              .mapOfFunctionDetails![
                                                                          'Select File Button Effects Color'] ??
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                  highlightColor: widget
                                                                              .mapOfFunctionDetails![
                                                                          'Select File Button Effects Color'] ??
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                  splashColor: widget
                                                                              .mapOfFunctionDetails![
                                                                          'Select File Button Effects Color'] ??
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                  hoverColor: widget
                                                                              .mapOfFunctionDetails![
                                                                          'Select File Button Effects Color'] ??
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                  child:
                                                                      Container(
                                                                    width: 50,
                                                                    height: myChildSize
                                                                        .height,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close_outlined,
                                                                      size: 20,
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
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  child:
                                                                      LinearProgressIndicator(
                                                                    value: controller
                                                                        .value,
                                                                    backgroundColor:
                                                                        Colors.blue[
                                                                            100],
                                                                    valueColor: AlwaysStoppedAnimation<
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
                                                                          TextOverflow
                                                                              .clip,
                                                                      softWrap:
                                                                          false,
                                                                      maxLines:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
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
                                                        children: [
                                                          Text(
                                                            'Select Multiple Files',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20,
                                                              letterSpacing:
                                                                  0.0,
                                                              color:
                                                                  FitnessAppTheme
                                                                      .darkText,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Icon(
                                                            Icons.add,
                                                            size: 30,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Please wait ...',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  FitnessAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 20,
                                                              letterSpacing:
                                                                  0.0,
                                                              color:
                                                                  FitnessAppTheme
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
                              Divider(
                                height: 50,
                                thickness: 1.5,
                              ),
                              Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      height: 30,
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          'Step - 2',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.darkText,
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
                                    .mapOfFunctionDetails!['Sublist Functions']
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
                                        ? AdSize.banner.height.toDouble() + 10
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: 30,
                        width: 70,
                        child: Center(
                          child: Text(
                            'Step - 1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.darkText,
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
      ],
    );
  }
}
