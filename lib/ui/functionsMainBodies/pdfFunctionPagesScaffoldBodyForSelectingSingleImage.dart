import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/widgets/functionsMainWidgets/directPop.dart';
import 'package:files_tools/widgets/functionsMainWidgets/onWillPopDialog.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getCacheFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:files_tools/widgets/functionsMainWidgets/permissionDialogBox.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_theme/app_theme.dart';
import '../../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:files_tools/widgets/functionsMainWidgets/functionsButtons.dart';

class PDFFunctionBodyForSelectingSingleImage extends StatefulWidget {
  const PDFFunctionBodyForSelectingSingleImage(
      {Key? key,
      this.notifyBodyPoppingSplitPDFFunctionScaffold,
      this.onNotifyAppbarFileStatus,
      this.mapOfFunctionDetails})
      : super(key: key);

  final bool? notifyBodyPoppingSplitPDFFunctionScaffold;
  final ValueChanged<bool>? onNotifyAppbarFileStatus;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _PDFFunctionBodyForSelectingSingleImageState createState() =>
      _PDFFunctionBodyForSelectingSingleImageState();
}

class _PDFFunctionBodyForSelectingSingleImageState
    extends State<PDFFunctionBodyForSelectingSingleImage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String? loadedPercent;
  int? lengthOfDigits;
  bool firstRun = true;
  List<Widget>? dialogActionButtonsListForPermanentlyDeniedPermission;
  List<Widget>? dialogActionButtonsListForDeniedPermission;
  String? dialogTextForPermanentlyDeniedPermission;
  String? dialogTextForDeniedPermission;

  @override
  void initState() {
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
            debugPrint(prefs.getBool('storagePermissionPermanentlyDeniedBoolValue').toString());
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
  bool isFileLoaded = false;
  bool isFilePickingInitiated = false;
  late File file;
  late File? compressedFile;
  late String filePath;
  late String? compressedFilesPath;
  late String fileName;
  late int fileByte;
  int filesSize = 0;
  XFile? image;
  bool shouldRenderingImagesLoopBeDisabled = false;

  List<pdfRenderer.PdfPageImage?> pdfPagesImages = [];

  var myChildSize = Size.zero;
  bool storagePermissionPermanentlyDenied = false;

  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  int _count = 0;

  List<Widget> widgetListForDialogActionOfButtonForSelectedMultipleImages = [];

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
                                                        false //if this condition true then that means storage Permission is not Permanently Denied
                                                    ? () async {
                                                        if (isFilePicked ==
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
                                                            // final ImagePicker?
                                                            //     result =
                                                            //     ImagePicker();

                                                            final FilePickerResult?
                                                                result =
                                                                await FilePicker
                                                                    .platform
                                                                    .pickFiles(
                                                              type: FileType
                                                                  .custom,
                                                              allowMultiple:
                                                                  false,
                                                              allowCompression:
                                                                  true,
                                                              allowedExtensions: [
                                                                'jpg',
                                                                'jpeg',
                                                                'png',
                                                                //'webp'
                                                              ],
                                                            );

                                                            // if (result !=
                                                            //     null) {
                                                            //   // Pick single image
                                                            //   image = await result
                                                            //       .pickImage(
                                                            //           source: ImageSource
                                                            //               .gallery);

                                                            // if (image != null) {
                                                            //
                                                            //   filesSize = 0;
                                                            //
                                                            //   XFile xFile =
                                                            //       image!;
                                                            //   file = File(
                                                            //       xFile.path);

                                                            if (result !=
                                                                null) {
                                                              PlatformFile
                                                                  platformFile =
                                                                  result.files
                                                                      .first;

                                                              file = File(
                                                                  platformFile
                                                                      .path!);

                                                              String
                                                                  extensionOfFileName =
                                                                  extensionOfString(
                                                                          fileName:
                                                                              platformFile.name)
                                                                      .toLowerCase();
                                                              String
                                                                  fileNameWithoutExtension =
                                                                  stringWithoutExtension(
                                                                      fileName:
                                                                          platformFile
                                                                              .name,
                                                                      extensionOfString:
                                                                          extensionOfFileName);

                                                              Future<File>
                                                                  testCompressAndGetFile(
                                                                      File file,
                                                                      String
                                                                          targetPath) async {
                                                                File? imageCompressResult;
                                                                if (extensionOfFileName ==
                                                                    '.png') {
                                                                  imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                      file.absolute
                                                                          .path,
                                                                      targetPath,
                                                                      quality:
                                                                          88,
                                                                      rotate: 0,
                                                                      format: CompressFormat
                                                                          .png);
                                                                } else if (extensionOfFileName ==
                                                                        '.jpg' ||
                                                                    extensionOfFileName ==
                                                                        '.jpeg') {
                                                                  imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                      file.absolute
                                                                          .path,
                                                                      targetPath,
                                                                      quality:
                                                                          88,
                                                                      rotate: 0,
                                                                      format: CompressFormat
                                                                          .jpeg);
                                                                } else if (extensionOfFileName ==
                                                                    '.webp') {
                                                                  imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                      file.absolute
                                                                          .path,
                                                                      targetPath,
                                                                      quality:
                                                                          88,
                                                                      rotate: 0,
                                                                      format: CompressFormat
                                                                          .webp);
                                                                } else if (extensionOfFileName ==
                                                                        '.heic' ||
                                                                    extensionOfFileName ==
                                                                        '.heif') {
                                                                  imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                      file.absolute
                                                                          .path,
                                                                      targetPath,
                                                                      quality:
                                                                          88,
                                                                      rotate: 0,
                                                                      format: CompressFormat
                                                                          .heic);
                                                                }

                                                                debugPrint(file
                                                                    .lengthSync().toString());
                                                                debugPrint(imageCompressResult!
                                                                    .lengthSync().toString());

                                                                return imageCompressResult;
                                                              }

                                                              String
                                                                  targetPath =
                                                                  await getCacheFilePathFromFileName(fileNameWithoutExtension + ' ' + 'compressed' + extensionOfFileName);
                                                              debugPrint(targetPath);
                                                              if (extensionOfFileName == '.png' ||
                                                                  extensionOfFileName ==
                                                                      '.jpg' ||
                                                                  extensionOfFileName ==
                                                                      '.jpeg' ||
                                                                  extensionOfFileName ==
                                                                      '.heic' ||
                                                                  extensionOfFileName ==
                                                                      '.heif' ||
                                                                  extensionOfFileName ==
                                                                      '.webp') {
                                                                compressedFile =
                                                                    await testCompressAndGetFile(
                                                                        file,
                                                                        targetPath);
                                                                compressedFilesPath =
                                                                    targetPath;
                                                              }
                                                              filePath =
                                                                  platformFile
                                                                      .path!;
                                                              debugPrint(
                                                                  "xFile.path : ${platformFile.path}");

                                                              fileByte = file
                                                                  .lengthSync();
                                                              fileName =
                                                                  platformFile
                                                                      .name;
                                                              filesSize =
                                                                  fileByte;

                                                              setState(() {
                                                                isFilePicked =
                                                                    true;
                                                                widget
                                                                    .onNotifyAppbarFileStatus
                                                                    ?.call(
                                                                        true);
                                                              });

                                                              shouldRenderingImagesLoopBeDisabled =
                                                                  false;

                                                              isFileLoaded =
                                                                  true;

                                                              isFilePickingInitiated =
                                                                  false; //as the file should be picked and loaded in the app cache & images are compressed at this point
                                                            } else {
                                                              setState(() {
                                                                debugPrint(
                                                                    'User canceled the picker');
                                                                isFilePickingInitiated =
                                                                    false;
                                                                isFilePicked =
                                                                    false;
                                                                widget
                                                                    .onNotifyAppbarFileStatus
                                                                    ?.call(
                                                                        false);
                                                              });
                                                              // User canceled the picker
                                                            }
                                                            // } else {
                                                            //   //result was null
                                                            //   setState(() {
                                                            //     print(
                                                            //         'ImagePicker() result was null');
                                                            //     isFilePickingInitiated =
                                                            //         false;
                                                            //     isFilePicked =
                                                            //         false;
                                                            //     widget
                                                            //         .onNotifyAppbarFileStatus
                                                            //         ?.call(
                                                            //             false);
                                                            //   });
                                                            // }
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
                                                          OpenFile.open(
                                                              filePath);
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
                                                                      myChildSize.toString());
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
                                                                        'assets/images/tools_icons/image_tools_icon.svg',
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    height: 35,
                                                                    color: widget.mapOfFunctionDetails![
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
                                                                  const Text(
                                                                    "Image",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
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
                                                                        formatBytes(filesSize, 2),
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
                                                                              isFileLoaded ==
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
                                                                        isFileLoaded =
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
                                                                              isFileLoaded ==
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
                                                                isFileLoaded ==
                                                                    false //this condition means that the loading bar will only show when shouldRenderingImagesLoopBeDisabled & isFileLoaded is false. shouldRenderingImagesLoopBeDisabled false means that we have not disabled loading images and isFileLoaded false means file has not loaded until now.
                                                            ? Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius: const BorderRadius.only(
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
                                                              'Select Image',
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
                                      fileLoadingStatus: isFileLoaded,
                                      onTapAction: () =>
                                          widget.mapOfFunctionDetails![
                                                      'Sublist Functions']
                                                  [index]['Action'](
                                              file,
                                              compressedFile ?? file,
                                              filePath,
                                              compressedFilesPath ?? filePath,
                                              fileName,
                                              fileByte,
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
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
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

//todo: stop picking of svg files and limit to png and jpg as some operations like image to pdf can't be performed on svgs
