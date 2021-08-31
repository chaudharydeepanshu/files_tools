import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/widgets/functionsMainWidgets/directPop.dart';
import 'package:files_tools/widgets/functionsMainWidgets/onWillPopDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getCacheFilePathFromFileName.dart';
import 'package:files_tools/basicFunctionalityFunctions/lifecycleEventHandler.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as pdfRenderer;
import 'package:files_tools/widgets/functionsMainWidgets/dialogActionBodyOfButtonForSelectedMultipleImages.dart';
import 'package:files_tools/widgets/functionsMainWidgets/permissionDialogBox.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_theme/app_theme.dart';
import '../../../basicFunctionalityFunctions/getSizeFromBytes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:files_tools/widgets/functionsMainWidgets/functionsButtons.dart';

class PDFFunctionBodyForSelectingSingleMultipleImages extends StatefulWidget {
  const PDFFunctionBodyForSelectingSingleMultipleImages(
      {Key? key,
      this.notifyBodyPoppingSplitPDFFunctionScaffold,
      this.onNotifyAppbarFileStatus,
      this.mapOfFunctionDetails})
      : super(key: key);

  final bool? notifyBodyPoppingSplitPDFFunctionScaffold;
  final ValueChanged<bool>? onNotifyAppbarFileStatus;
  final Map<String, dynamic>? mapOfFunctionDetails;

  @override
  _PDFFunctionBodyForSelectingSingleMultipleImagesState createState() =>
      _PDFFunctionBodyForSelectingSingleMultipleImagesState();
}

class _PDFFunctionBodyForSelectingSingleMultipleImagesState
    extends State<PDFFunctionBodyForSelectingSingleMultipleImages>
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
  bool isFileLoaded = false;
  bool isFilePickingInitiated = false;
  late List<File> files = [];
  late List<File> compressedFiles = [];
  late List<String> filePaths = [];
  late List<String> compressedFilesPaths = [];
  late List<String> fileNames = [];
  late List<int> fileBytes = [];
  int filesSize = 0;
  List<XFile>? images;
  bool shouldRenderingImagesLoopBeDisabled = false;

  List<pdfRenderer.PdfPageImage?> pdfPagesImages = [];

  var myChildSize = Size.zero;
  bool storagePermissionPermanentlyDenied = false;

  double defaultButtonElevation = 3;
  double onTapDownButtonElevation = 0;
  double buttonElevation = 3;

  int _count = 0;

  List<Widget> widgetListForDialogActionOfButtonForSelectedMultipleImages = [];

  Future<void> multipleFilesSelectedActionDialog() async {
    await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        widgetListForDialogActionOfButtonForSelectedMultipleImages =
            List<Widget>.generate(filePaths.length, (int index) {
          String fileName = 'Image ${index + 1}';
          String filePath = filePaths[index];
          int fileByte = fileBytes[index];
          return DialogActionBodyOfButtonForSelectedMultipleImages(
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
                const Text('Selected Images'),
                const Text('Click to view'),
              ],
            ),
          ),
          children: widgetListForDialogActionOfButtonForSelectedMultipleImages,
        );
      },
    );
  }

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
                ? () => onWillPop(context)
                : () => directPop(),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return false;
              },
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
                                            onTap: isFilePickingInitiated ==
                                                    false
                                                ? storagePermissionPermanentlyDenied ==
                                                        false
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
                                                            setState(() {
                                                              isFilePickingInitiated =
                                                                  true;
                                                            });

                                                            print(
                                                                'Permission granted');
                                                            if (Platform
                                                                    .isAndroid ||
                                                                Platform
                                                                    .isIOS) {
                                                              final ImagePicker?
                                                                  result =
                                                                  ImagePicker();

                                                              if (result !=
                                                                  null) {
                                                                // Pick multiple images
                                                                images =
                                                                    await result
                                                                        .pickMultiImage();
                                                                if (images !=
                                                                    null) {
                                                                  fileBytes =
                                                                      [];
                                                                  filePaths =
                                                                      [];
                                                                  fileNames =
                                                                      [];
                                                                  compressedFilesPaths =
                                                                      [];
                                                                  files = [];
                                                                  compressedFiles =
                                                                      [];
                                                                  filesSize = 0;
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          images!
                                                                              .length;
                                                                      i++) {
                                                                    XFile
                                                                        xFile =
                                                                        images![
                                                                            i];
                                                                    File file =
                                                                        File(xFile
                                                                            .path);
                                                                    files.add(
                                                                        file);

                                                                    String
                                                                        extensionOfFileName =
                                                                        extensionOfString(fileName: xFile.name)
                                                                            .toLowerCase();
                                                                    String fileNameWithoutExtension = stringWithoutExtension(
                                                                        fileName:
                                                                            xFile
                                                                                .name,
                                                                        extensionOfString:
                                                                            extensionOfFileName);

                                                                    Future<File> compressAndGetFile(
                                                                        File
                                                                            file,
                                                                        String
                                                                            targetPath) async {
                                                                      var imageCompressResult;
                                                                      if (extensionOfFileName ==
                                                                          '.png') {
                                                                        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                            file
                                                                                .absolute.path,
                                                                            targetPath,
                                                                            quality:
                                                                                88,
                                                                            rotate:
                                                                                0,
                                                                            format:
                                                                                CompressFormat.png);
                                                                      } else if (extensionOfFileName ==
                                                                              '.jpg' ||
                                                                          extensionOfFileName ==
                                                                              '.jpeg') {
                                                                        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                            file
                                                                                .absolute.path,
                                                                            targetPath,
                                                                            quality:
                                                                                88,
                                                                            rotate:
                                                                                0,
                                                                            format:
                                                                                CompressFormat.jpeg);
                                                                      } else if (extensionOfFileName ==
                                                                          '.webp') {
                                                                        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                            file
                                                                                .absolute.path,
                                                                            targetPath,
                                                                            quality:
                                                                                88,
                                                                            rotate:
                                                                                0,
                                                                            format:
                                                                                CompressFormat.webp);
                                                                      } else if (extensionOfFileName ==
                                                                              '.heic' ||
                                                                          extensionOfFileName ==
                                                                              '.heif') {
                                                                        imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                            file
                                                                                .absolute.path,
                                                                            targetPath,
                                                                            quality:
                                                                                88,
                                                                            rotate:
                                                                                0,
                                                                            format:
                                                                                CompressFormat.heic);
                                                                      }

                                                                      print(file
                                                                          .lengthSync());
                                                                      print(imageCompressResult!
                                                                          .lengthSync());

                                                                      return imageCompressResult;
                                                                    }

                                                                    String
                                                                        targetPath =
                                                                        "${await getCacheFilePathFromFileName(fileNameWithoutExtension + ' ' + 'compressed' + ' ' + i.toString() + extensionOfFileName)}";
                                                                    print(
                                                                        "targetPath $targetPath");
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
                                                                      compressedFiles.add(await compressAndGetFile(
                                                                          file,
                                                                          targetPath));
                                                                      compressedFilesPaths
                                                                          .add(
                                                                              targetPath);
                                                                    }
                                                                    filePaths.add(
                                                                        xFile
                                                                            .path);
                                                                    print(
                                                                        "xFile.path : ${xFile.path}");

                                                                    fileBytes
                                                                        .add(file
                                                                            .lengthSync());
                                                                    fileNames.add(
                                                                        xFile
                                                                            .name);
                                                                    filesSize =
                                                                        filesSize +
                                                                            fileBytes[i];
                                                                  }

                                                                  print(
                                                                      "fileNames $fileNames");

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
                                                                    print(
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
                                                              } else {
                                                                //result was null
                                                                setState(() {
                                                                  print(
                                                                      'ImagePicker() result was null');
                                                                  isFilePickingInitiated =
                                                                      false;
                                                                  isFilePicked =
                                                                      false;
                                                                  widget
                                                                      .onNotifyAppbarFileStatus
                                                                      ?.call(
                                                                          false);
                                                                });
                                                              }
                                                            } else if (Platform
                                                                .isWindows) {
                                                              final FilePickerResult?
                                                                  result =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                type: FileType
                                                                    .custom,
                                                                allowMultiple:
                                                                    true,
                                                                allowedExtensions: [
                                                                  'jpg',
                                                                  'jpeg',
                                                                  'png',
                                                                  'webp'
                                                                ],
                                                              );

                                                              if (result !=
                                                                  null) {
                                                                // Pick multiple images
                                                                fileBytes = [];
                                                                filePaths = [];
                                                                fileNames = [];
                                                                compressedFilesPaths =
                                                                    [];
                                                                files = [];
                                                                compressedFiles =
                                                                    [];
                                                                filesSize = 0;
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

                                                                for (int i = 0;
                                                                    i <
                                                                        files
                                                                            .length;
                                                                    i++) {
                                                                  String
                                                                      extensionOfFileName =
                                                                      extensionOfString(
                                                                              fileName: fileNames[i])
                                                                          .toLowerCase();
                                                                  String fileNameWithoutExtension = stringWithoutExtension(
                                                                      fileName:
                                                                          fileNames[
                                                                              i],
                                                                      extensionOfString:
                                                                          extensionOfFileName);

                                                                  Future<File>
                                                                      compressAndGetFile(
                                                                          File
                                                                              file,
                                                                          String
                                                                              targetPath) async {
                                                                    var imageCompressResult;
                                                                    if (extensionOfFileName ==
                                                                        '.png') {
                                                                      ImageFile
                                                                          input =
                                                                          ImageFile(
                                                                        rawBytes:
                                                                            file.readAsBytesSync(),
                                                                        filePath:
                                                                            file.path,
                                                                      ); // set the input image file
                                                                      Configuration
                                                                          config =
                                                                          Configuration(
                                                                        outputType:
                                                                            ImageOutputType.png,
                                                                        // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
                                                                        useJpgPngNativeCompressor:
                                                                            false,
                                                                        // set quality between 0-100
                                                                        quality:
                                                                            88,
                                                                      );

                                                                      final param = ImageFileConfiguration(
                                                                          input:
                                                                              input,
                                                                          config:
                                                                              config);
                                                                      final output =
                                                                          await compressor
                                                                              .compress(param);

                                                                      final bytes =
                                                                          output
                                                                              .rawBytes;
                                                                      imageCompressResult =
                                                                          File(
                                                                              targetPath);
                                                                      await imageCompressResult.writeAsBytes(bytes
                                                                          .buffer
                                                                          .asUint8List(
                                                                              bytes.offsetInBytes,
                                                                              bytes.lengthInBytes));
                                                                    } else if (extensionOfFileName ==
                                                                            '.jpg' ||
                                                                        extensionOfFileName ==
                                                                            '.jpeg') {
                                                                      ImageFile
                                                                          input =
                                                                          ImageFile(
                                                                        rawBytes:
                                                                            file.readAsBytesSync(),
                                                                        filePath:
                                                                            file.path,
                                                                      ); // set the input image file
                                                                      Configuration
                                                                          config =
                                                                          Configuration(
                                                                        outputType:
                                                                            ImageOutputType.jpg,
                                                                        // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
                                                                        useJpgPngNativeCompressor:
                                                                            false,
                                                                        // set quality between 0-100
                                                                        quality:
                                                                            88,
                                                                      );

                                                                      final param = ImageFileConfiguration(
                                                                          input:
                                                                              input,
                                                                          config:
                                                                              config);
                                                                      final output =
                                                                          await compressor
                                                                              .compress(param);

                                                                      final bytes =
                                                                          output
                                                                              .rawBytes;
                                                                      imageCompressResult =
                                                                          File(
                                                                              targetPath);
                                                                      await imageCompressResult.writeAsBytes(bytes
                                                                          .buffer
                                                                          .asUint8List(
                                                                              bytes.offsetInBytes,
                                                                              bytes.lengthInBytes));
                                                                    } else if (extensionOfFileName ==
                                                                        '.webp') {
                                                                      ImageFile
                                                                          input =
                                                                          ImageFile(
                                                                        rawBytes:
                                                                            file.readAsBytesSync(),
                                                                        filePath:
                                                                            file.path,
                                                                      ); // set the input image file
                                                                      Configuration
                                                                          config =
                                                                          Configuration(
                                                                        outputType:
                                                                            ImageOutputType.webpThenPng,
                                                                        // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
                                                                        useJpgPngNativeCompressor:
                                                                            false,
                                                                        // set quality between 0-100
                                                                        quality:
                                                                            88,
                                                                      );

                                                                      final param = ImageFileConfiguration(
                                                                          input:
                                                                              input,
                                                                          config:
                                                                              config);
                                                                      final output =
                                                                          await compressor
                                                                              .compress(param);

                                                                      final bytes =
                                                                          output
                                                                              .rawBytes;
                                                                      imageCompressResult =
                                                                          File(
                                                                              targetPath);
                                                                      await imageCompressResult.writeAsBytes(bytes
                                                                          .buffer
                                                                          .asUint8List(
                                                                              bytes.offsetInBytes,
                                                                              bytes.lengthInBytes));
                                                                    }
                                                                    // else if (extensionOfFileName ==
                                                                    //         '.heic' ||
                                                                    //     extensionOfFileName ==
                                                                    //         '.heif') {
                                                                    //   imageCompressResult = await FlutterImageCompress.compressAndGetFile(
                                                                    //       file.absolute
                                                                    //           .path,
                                                                    //       targetPath,
                                                                    //       quality:
                                                                    //           88,
                                                                    //       rotate:
                                                                    //           0,
                                                                    //       format:
                                                                    //           CompressFormat.heic);
                                                                    // }

                                                                    // print(file
                                                                    //     .lengthSync());
                                                                    // print(imageCompressResult!
                                                                    //     .lengthSync());

                                                                    return imageCompressResult;
                                                                  }

                                                                  String
                                                                      targetPath =
                                                                      "${await getCacheFilePathFromFileName(fileNameWithoutExtension + ' ' + 'compressed' + ' ' + i.toString() + extensionOfFileName)}";
                                                                  print(
                                                                      "targetPath $targetPath");
                                                                  if (extensionOfFileName ==
                                                                          '.png' ||
                                                                      extensionOfFileName ==
                                                                          '.jpg' ||
                                                                      extensionOfFileName ==
                                                                          '.jpeg' ||
                                                                      // extensionOfFileName ==
                                                                      //     '.heic' ||
                                                                      // extensionOfFileName ==
                                                                      //     '.heif' ||
                                                                      extensionOfFileName ==
                                                                          '.webp') {
                                                                    compressedFiles.add(await compressAndGetFile(
                                                                        files[
                                                                            i],
                                                                        targetPath));
                                                                    compressedFilesPaths
                                                                        .add(
                                                                            targetPath);
                                                                  }
                                                                }

                                                                print(
                                                                    "fileNames $fileNames");

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
                                                                //result was null
                                                                setState(() {
                                                                  print(
                                                                      'ImagePicker() result was null');
                                                                  isFilePickingInitiated =
                                                                      false;
                                                                  isFilePicked =
                                                                      false;
                                                                  widget
                                                                      .onNotifyAppbarFileStatus
                                                                      ?.call(
                                                                          false);
                                                                });
                                                              }
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
                                                                context:
                                                                    context);
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
                                                                context:
                                                                    context);
                                                          }
                                                        } else if (isFilePicked ==
                                                            true) {
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
                                              decoration: BoxDecoration(
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
                                                                  print(
                                                                      myChildSize);
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
                                                                            'Select File Icon Color'] ??
                                                                        null,
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
                                                                    "${files.length.toString() + ' ' + 'Images Selected'}",
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
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${formatBytes(filesSize, 2)}',
                                                                        style: TextStyle(
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
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                  false &&
                                                                              isFileLoaded ==
                                                                                  false
                                                                          ? Radius.circular(
                                                                              0)
                                                                          : Radius.circular(
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
                                                                        if (Platform.isAndroid ||
                                                                            Platform.isIOS) {
                                                                          FilePicker
                                                                              .platform
                                                                              .clearTemporaryFiles();
                                                                        }
                                                                        // This is the trick to reset whole page! Required to reset step-2 button warnings
                                                                        ++_count; //the count would change the key of this widget forcing it to reset
                                                                      });
                                                                    },
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight: shouldRenderingImagesLoopBeDisabled ==
                                                                                  false &&
                                                                              isFileLoaded ==
                                                                                  false
                                                                          ? Radius.circular(
                                                                              0)
                                                                          : Radius.circular(
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
                                                                        Container(
                                                                      width: 50,
                                                                      height: myChildSize
                                                                          .height,
                                                                      child:
                                                                          Icon(
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
                                                                    borderRadius: BorderRadius.only(
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
                                                                            TextOverflow.clip,
                                                                        softWrap:
                                                                            false,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            TextStyle(
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
                                                          children: [
                                                            Text(
                                                              'Select Images',
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
                                                          children: [
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
                                                      [index]
                                                  ['Action'](
                                              files,
                                              compressedFiles.length ==
                                                      files.length
                                                  ? compressedFiles
                                                  : files,
                                              filePaths,
                                              compressedFilesPaths.length ==
                                                      filePaths.length
                                                  ? compressedFilesPaths
                                                  : filePaths,
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 30,
                          width: 70,
                          child: Center(
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
              child: BannerAD(),
            ),
          ],
        ),
      ],
    );
  }
}

//todo check filetype and show a snack bar for wrong filetype
