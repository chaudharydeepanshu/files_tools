import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/checkEncryptedDocument.dart';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/permissionDialogBox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../app_theme/fitness_app_theme.dart';
import '../../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import '../../../basicFunctionalityFunctions/manageAppDirectoryAndCache.dart';
import 'package:files_tools/ui/pdfViewerScaffold/pdfscaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/pdfFunctionsButtons.dart';

import '../../ad_state.dart';

class PDFFunctionBody extends StatefulWidget {
  const PDFFunctionBody(
      {Key? key,
      this.notifyBodyPoppingSplitPDFFunctionScaffold,
      this.onNotifyAppbarFileStatus,
      this.mapOfFunctionDetails})
      : super(key: key);

  final bool? notifyBodyPoppingSplitPDFFunctionScaffold;
  final ValueChanged<bool>? onNotifyAppbarFileStatus;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _PDFFunctionBodyState createState() => _PDFFunctionBodyState();
}

class _PDFFunctionBodyState extends State<PDFFunctionBody>
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
        // 'In order to select documents, Demo App requires access to Files and Media permission.\nSince you have denied permission requests previously, we cannot ask again. So now you have to manually allow the permissions by pressing Settings > Permissions > Files and Media and select "Allow access to media only".';
        'In order to select documents, Demo App requires access to photos and media permission.\nTo allow the permission tap Settings > Permissions > Files and Media and select "Allow access to media only".';
    dialogTextForDeniedPermission =
        'In order to select documents, Demo App requires access to photos and media permission. Please allow access to continue further.';

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isFilePicked = false;
  bool isFileLoaded = false;
  bool isFilePickingInitiated = false;
  late PlatformFile file;
  bool shouldRenderingImagesLoopBeDisabled = false;

  List<pdfRenderer.PdfPageImage?> pdfPagesImages = [];

  Future<bool> _onWillPop() async {
    bool dialogAction;
    dialogAction = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Going back would cancel loading the file.'),
                Text('Do you still want to go back?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                shouldRenderingImagesLoopBeDisabled = true;
                deleteCacheDir();
                deleteAppDir();
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ) as bool;

    return dialogAction;
  }

  Future<bool> _directPop() async {
    deleteCacheDir();
    deleteAppDir();
    return true;
  }

  var myChildSize = Size.zero;
  bool storagePermissionPermanentlyDenied = false;

  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  int _count = 0;

  int filesEncryptedCount = 0;

  void nativePDFRendererToImg(String filePath) async {
    try {
      final newDocument = await pdfRenderer.PdfDocument.openFile(filePath);
      final pagesCount = newDocument.pagesCount;
      double indicatorSteps = 1 / pagesCount;
      //pages = [];

      pdfPagesImages = [];
      for (var i = 1;
          i <= pagesCount &&
              shouldRenderingImagesLoopBeDisabled == false &&
              widget.notifyBodyPoppingSplitPDFFunctionScaffold == false;
          i++) {
        //Text('Item $i');
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

        pdfPagesImages.add(pageImage);
        await page.close();
        print(i);
        controller.value += indicatorSteps;

        if (i == pagesCount) {
          isFileLoaded = true;
        }
      }

      controller.value = 0;

      newDocument.close();
    } on PlatformException catch (error) {
      print(error);
    }
  }

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
            onWillPop: isFilePicked == true ? _onWillPop : _directPop,
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
                        // color: Color(0xFFFFAFAFA),
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
                                                            allowMultiple:
                                                                false,
                                                            allowedExtensions: [
                                                              'pdf',
                                                            ],
                                                          );
                                                          if (result != null) {
                                                            file = result
                                                                .files.first;

                                                            bool
                                                                isEncryptedDocument =
                                                                checkEncryptedDocument(
                                                                    file.path!);

                                                            bool
                                                                shouldEncryptedDocumentsAllowed =
                                                                widget.mapOfFunctionDetails![
                                                                    'Encrypted Files Allowed'];

                                                            filesEncryptedCount =
                                                                0;

                                                            if (shouldEncryptedDocumentsAllowed ==
                                                                false) {
                                                              if (isEncryptedDocument ==
                                                                  false) {
                                                                print(
                                                                    file.name);
                                                                print(
                                                                    file.bytes);
                                                                print(
                                                                    file.size);
                                                                print(file
                                                                    .extension);
                                                                print(
                                                                    file.path);
                                                                print(
                                                                    'Document not encrypted & encrypted documents are not allowed');

                                                                setState(() {
                                                                  isFilePickingInitiated =
                                                                      false;
                                                                  isFilePicked =
                                                                      true;
                                                                  widget
                                                                      .onNotifyAppbarFileStatus
                                                                      ?.call(
                                                                          true);
                                                                });

                                                                shouldRenderingImagesLoopBeDisabled =
                                                                    false;

                                                                if (isFileLoadingRequired ==
                                                                    true) {
                                                                  nativePDFRendererToImg(
                                                                      file.path!);
                                                                } else {
                                                                  isFileLoaded =
                                                                      true;
                                                                }

                                                                isFilePickingInitiated =
                                                                    false; //as the file should be picked and loaded in the app cache & here loaded doesn't mean converting to images
                                                              } else {
                                                                print(
                                                                    'Document encrypted & encrypted documents are not allowed');

                                                                filesEncryptedCount++;
                                                                setState(() {
                                                                  isFilePickingInitiated =
                                                                      false;
                                                                });
                                                                final encryptedFileWarningSnackBar =
                                                                    SnackBar(
                                                                  content:
                                                                      const Text(
                                                                          'Encrypted File is not allowed!\nDecrypt it using the decrypt function.'),
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
                                                              } //show snackbar for document encrypted here as not allowed through above condition
                                                            } else {
                                                              //document not encrypted but allowed encrypted
                                                              print(file.name);
                                                              print(file.bytes);
                                                              print(file.size);
                                                              print(file
                                                                  .extension);
                                                              print(file.path);

                                                              setState(() {
                                                                isFilePickingInitiated =
                                                                    false;
                                                                isFilePicked =
                                                                    true;
                                                                widget
                                                                    .onNotifyAppbarFileStatus
                                                                    ?.call(
                                                                        true);
                                                              });

                                                              shouldRenderingImagesLoopBeDisabled =
                                                                  false;

                                                              if (isFileLoadingRequired ==
                                                                  true) {
                                                                if (isEncryptedDocument ==
                                                                    false) {
                                                                  nativePDFRendererToImg(
                                                                      file.path!);
                                                                  print(
                                                                      'Document not encrypted & encrypted documents are allowed');
                                                                } else {
                                                                  print(
                                                                      'Document encrypted & encrypted documents are allowed');
                                                                  filesEncryptedCount++;
                                                                }
                                                              } else {
                                                                isFileLoaded =
                                                                    true;
                                                              }

                                                              isFilePickingInitiated =
                                                                  false; //as the file should be picked and loaded in the app cache & here loaded doesn't mean converting to images
                                                            }
                                                          } else {
                                                            setState(() {
                                                              print(
                                                                  'User canceled the picker');
                                                              isFilePickingInitiated =
                                                                  false;
                                                              isFilePicked =
                                                                  false;
                                                              widget
                                                                  .onNotifyAppbarFileStatus
                                                                  ?.call(false);
                                                            });
                                                            // User canceled the picker
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
                                                        Navigator.pushNamed(
                                                          context,
                                                          PageRoutes
                                                              .pdfScaffold,
                                                          arguments:
                                                              PDFScaffoldArguments(
                                                            pdfPath: file.path,
                                                          ),
                                                        );
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
                                                                  file.name,
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
                                                                      '${formatBytes(file.size, 2)}',
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
                                                                            isFileLoaded ==
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
                                                                      isFileLoaded =
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
                                                                            isFileLoaded ==
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
                                                              isFileLoaded ==
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
                                                            'Select File',
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
                                    fileLoadingStatus: isFileLoaded,
                                    onTapAction: () => widget
                                                    .mapOfFunctionDetails![
                                                'Sublist Functions'][index]
                                            ['Action'](
                                        file,
                                        pdfPagesImages,
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
