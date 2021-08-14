import 'dart:ui';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/currentDateTimeInString.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/bottomNavBarButtonsForFileModifications.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/card_carousel.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/reorder_pages_scaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

class ImagesToPDFScaffold extends StatefulWidget {
  static const String routeName = '/imagesToPDFScaffold';

  const ImagesToPDFScaffold({Key? key, this.arguments}) : super(key: key);

  final ImagesToPDFScaffoldArguments? arguments;

  @override
  _ImagesToPDFScaffoldState createState() => _ImagesToPDFScaffoldState();
}

class _ImagesToPDFScaffoldState extends State<ImagesToPDFScaffold> {
  late List<int>
      listOfRotation; //0 for no change, 1 for 90 degree right, 2 180 degree right, 3 for 270 degree right, 4 for 360 degree right. I know 0 and 4 are same in theory but they are required for some distinction. Check carousel animations for more clarity.
  late List tempImageFilesList = [];
  late List<bool> listOfDeletedImages; //false for delete

  late List<RotatedBox> decorationImageListForReorder;

  late List<int> reorderedList;

  late List<double> controllerValueList;

  @override
  void initState() {
    listOfRotation =
        new List<int>.generate(widget.arguments!.files.length, (i) {
      return 0;
    });

    for (int i = 0; i < widget.arguments!.files.length; i++) {
      tempImageFilesList.add(FileImage(widget.arguments!.compressedFiles[i]));
    }

    listOfDeletedImages =
        new List<bool>.generate(widget.arguments!.files.length, (i) {
      return true;
    });

    reorderedList = List<int>.generate(widget.arguments!.files.length, (i) {
      return i + 1;
    });

    controllerValueList =
        List<double>.generate(widget.arguments!.files.length, (i) {
      return 0.0;
    });

    decorationImageListForReorder =
        new List<RotatedBox>.generate(widget.arguments!.filePaths.length, (i) {
      return RotatedBox(
        quarterTurns: listOfRotation[i] == 0
            ? 0
            : listOfRotation[i] == 1
                ? 1
                : listOfRotation[i] == 2
                    ? 2
                    : listOfRotation[i] == 3
                        ? 3
                        : listOfRotation[i] == 4
                            ? 0
                            : 0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: tempImageFilesList[i],
              //MemoryImage(widget.arguments!.pdfPagesImages![i].bytes),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      );
    });

    appBarIconLeft = Icons.arrow_back;
    appBarIconLeftToolTip = 'Back';
    appBarIconLeftAction = () {
      return Navigator.of(context).pop();
    };

    appBarIconRight = Icons.check;
    appBarIconRightToolTip = 'Done';
    appBarIconRightAction = () async {
      shouldWePopScaffold = false;
      shouldDataBeProcessed = true;
      setState(() {
        selectedDataProcessed = true;
      });
      processingDialog(context); //shows the processing dialog

      PdfDocument? document;
      Future.delayed(const Duration(milliseconds: 500), () async {
        document = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'Page Rotations List': listOfRotation,
              'Deleted Page List': listOfDeletedImages,
              'Reordered Page List': reorderedList,
              'PDF File Name': "Image to pdf ${currentDateTimeInString()}.pdf",
              'Is Same Width Enabled': _isSameSizeEnabled,
            },
            processType: widget.arguments!.processType,
            // filesPaths: widget.arguments!.filePaths,
            filesPaths: widget.arguments!.compressedFilesPaths,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        map['_pdfFileName'] = "Image to pdf ${currentDateTimeInString()}.pdf";
        map['_extraBetweenNameAndExtension'] = '';
        map['_document'] = document;

        // final result = await compute(creatingAndSavingFileTemporarily, map);
        // return result;
        //todo: setup isolates to decrease the jitter in circular progress bar a little bit
        //todo: to do this first find the culprit and then find a solution if possible
        //the main delay is getting the processed document so try to optimise its loop using isolate

        return Future.delayed(const Duration(milliseconds: 500), () async {
          return document != null && shouldDataBeProcessed == true
              ? await creatingAndSavingPDFFileTemporarily(map)
              : null;
        });
      }).then((value) {
        // //Get the document security.
        // PdfSecurity security = document!.security;
        //
        // //Get the permissions
        // PdfPermissions permissions = security.permissions;
        //
        // permissions.clear();
        // print('permissions : ${permissions.count}');

        Future.delayed(const Duration(milliseconds: 500), () async {
          if (document != null &&
              shouldDataBeProcessed == true &&
              value != null) {
            Navigator.pop(context); //closes the processing dialog
            Navigator.pushNamed(
              context,
              PageRoutes.resultPDFScaffold,
              arguments: ResultPDFScaffoldArguments(
                document: document!,
                //pdfPagesSelectedImages: selectedImages,
                pdfFilePath: value,
                pdfFileName: "Image to pdf ${currentDateTimeInString()}.pdf",
                mapOfSubFunctionDetails:
                    widget.arguments!.mapOfSubFunctionDetails,
              ),
            );
          }
        }).whenComplete(() {
          setState(() {
            selectedDataProcessed = false;
            shouldWePopScaffold = true;
          });
        });
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late IconData appBarIconLeft;
  late String appBarIconLeftToolTip;
  late dynamic Function()? appBarIconLeftAction;

  late IconData appBarIconRight;
  late String appBarIconRightToolTip;
  late dynamic Function()? appBarIconRightAction;

  bool selectedDataProcessed = false;
  bool shouldDataBeProcessed = true;
  bool shouldWePopScaffold = true;

  Future<bool> _onWillPop() async {
    setState(() {
      shouldWePopScaffold = true;
      shouldDataBeProcessed = false;
      selectedDataProcessed = false;
    });
    return false;
  }

  Future<bool> _directPop() async {
    return true;
  }

  bool reorderStatus = false;
  bool rotationStatus = false;
  bool deleteStatus = false;

  bool proceedButton() {
    return true;
  }

  int currentIndex = 0;

  Widget carouselList() {
    return CarouselList(
      color: widget.arguments!.mapOfSubFunctionDetails['Button Color'] ??
          Colors.amber,
      onIndex: (int value) {
        setState(() {
          currentIndex = value;
        });
      },
      listOfRotation: listOfRotation,
      listOfImages: tempImageFilesList,
      listOfDeletedImages: listOfDeletedImages,
      controllerValueList: controllerValueList,
      onControllerValueList: (List<double> value) {
        setState(() {
          controllerValueList = value;
        });
      },
    );
  }

  bool _isSameSizeEnabled = false;

  @override
  Widget build(BuildContext context) {
    print('listOfRotation: $listOfRotation');
    print('listOfDeletedImages: $listOfDeletedImages');
    return ReusableAnnotatedRegion(
      child: WillPopScope(
        onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
        child: Stack(
          children: [
            Scaffold(
              appBar: ReusableSilverAppBar(
                title: 'Convert To PDF',
                titleColor: Colors.black,
                leftButtonColor: Colors.red,
                appBarIconLeft: appBarIconLeft,
                appBarIconLeftToolTip: appBarIconLeftToolTip,
                appBarIconLeftAction: appBarIconLeftAction,
                rightButtonColor: Colors.blue,
                appBarIconRight: appBarIconRight,
                appBarIconRightToolTip: appBarIconRightToolTip,
                appBarIconRightAction:
                    proceedButton() ? appBarIconRightAction : null,
              ),
              body: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Create same width(960px) document'),
                    value: _isSameSizeEnabled,
                    onChanged: tempImageFilesList.length < 2
                        ? null
                        : (bool? newValue) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _isSameSizeEnabled = newValue!;
                              print("_isSameSizeEnabled: $_isSameSizeEnabled");
                            });
                          },
                  ),
                  Expanded(
                    child: carouselList(),
                  ),
                  BannerAD(),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    bottomNavBarButtonsForFileModifications(
                      buttonIcon: Icon(Icons.rotate_right),
                      buttonLabel: Text('Rotate'),
                      onTapAction: () {
                        print('working');
                        setState(() {
                          decorationImageListForReorder[
                              currentIndex] = listOfDeletedImages[
                                      currentIndex] ==
                                  false
                              ? RotatedBox(
                                  quarterTurns:
                                      listOfRotation[currentIndex] == 3
                                          ? 0
                                          : listOfRotation[currentIndex] + 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: tempImageFilesList[currentIndex],
                                        fit: BoxFit.scaleDown,
                                        colorFilter: ColorFilter.mode(
                                            Colors.red.withOpacity(0.6),
                                            BlendMode.srcATop),
                                      ),
                                    ),
                                  ))
                              : RotatedBox(
                                  quarterTurns:
                                      listOfRotation[currentIndex] == 3
                                          ? 0
                                          : listOfRotation[currentIndex] + 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: tempImageFilesList[currentIndex],
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ));

                          listOfRotation[currentIndex] =
                              listOfRotation[currentIndex] == 3
                                  ? 0
                                  : listOfRotation[currentIndex] + 1;
                        });
                      },
                      mapOfSubFunctionDetails:
                          widget.arguments!.mapOfSubFunctionDetails,
                    ),
                    bottomNavBarButtonsForFileModifications(
                      buttonIcon: Icon(Icons.delete),
                      buttonLabel: listOfDeletedImages[currentIndex] == true
                          ? Text('Delete')
                          : Text('Restore'),
                      onTapAction: widget.arguments!.files.length != 1
                          ? () {
                              setState(() {
                                decorationImageListForReorder[
                                    currentIndex] = listOfDeletedImages[
                                            currentIndex] ==
                                        true
                                    ? RotatedBox(
                                        quarterTurns: listOfRotation[
                                                    currentIndex] ==
                                                0
                                            ? 0
                                            : listOfRotation[currentIndex] == 1
                                                ? 1
                                                : listOfRotation[
                                                            currentIndex] ==
                                                        2
                                                    ? 2
                                                    : listOfRotation[
                                                                currentIndex] ==
                                                            3
                                                        ? 3
                                                        : listOfRotation[
                                                                    currentIndex] ==
                                                                4
                                                            ? 0
                                                            : 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: tempImageFilesList[
                                                  currentIndex],
                                              fit: BoxFit.scaleDown,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.red.withOpacity(0.6),
                                                  BlendMode.srcATop),
                                            ),
                                          ),
                                        ))
                                    : RotatedBox(
                                        quarterTurns: listOfRotation[
                                                    currentIndex] ==
                                                0
                                            ? 0
                                            : listOfRotation[currentIndex] == 1
                                                ? 1
                                                : listOfRotation[
                                                            currentIndex] ==
                                                        2
                                                    ? 2
                                                    : listOfRotation[
                                                                currentIndex] ==
                                                            3
                                                        ? 3
                                                        : listOfRotation[
                                                                    currentIndex] ==
                                                                4
                                                            ? 0
                                                            : 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: tempImageFilesList[
                                                  currentIndex],
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ));

                                listOfDeletedImages[currentIndex] =
                                    listOfDeletedImages[currentIndex] == true
                                        ? false
                                        : true;
                              });
                            }
                          : null,
                      mapOfSubFunctionDetails:
                          widget.arguments!.mapOfSubFunctionDetails,
                    ),
                    bottomNavBarButtonsForFileModifications(
                      buttonIcon: Icon(Icons.reorder),
                      buttonLabel: Text('Reorder'),
                      onTapAction: widget.arguments!.files.length != 1
                          ? () {
                              Navigator.pushNamed(
                                context,
                                PageRoutes.reorderPDFPagesScaffold,
                                arguments: ReorderPDFPagesScaffoldArguments(
                                  pdfPagesImages: tempImageFilesList,
                                  //pdfFile: widget.arguments!.pdfFile,
                                  onPDFPagesImages: (List value) {
                                    setState(() {
                                      tempImageFilesList = value;
                                    });
                                  },
                                  listOfRotationOfImages: listOfRotation,
                                  onListOfRotationOfImages: (List<int> value) {
                                    setState(() {
                                      listOfRotation = value;
                                    });
                                  },
                                  listOfDeletedImagesRecord:
                                      listOfDeletedImages,
                                  onListOfDeletedImagesRecord:
                                      (List<bool> value) {
                                    setState(() {
                                      listOfDeletedImages = value;
                                    });
                                  },
                                  decorationImageListForReorder:
                                      decorationImageListForReorder,
                                  onDecorationImageListForReorder:
                                      (List<RotatedBox> value) {
                                    setState(() {
                                      decorationImageListForReorder = value;
                                    });
                                  },
                                  reorderedList: reorderedList,
                                  onReorderedList: (List<int> value) {
                                    setState(() {
                                      reorderedList = value;
                                    });
                                  },
                                  controllerValueList: controllerValueList,
                                  onControllerValueList: (List<double> value) {
                                    setState(() {
                                      controllerValueList = value;
                                    });
                                  },
                                ),
                              );
                            }
                          : null,
                      mapOfSubFunctionDetails:
                          widget.arguments!.mapOfSubFunctionDetails,
                    ),
                  ],
                ),
              ),
            ),
            //selectedDataProcessed == true ? progressFakeDialogBox : Container(),
          ],
        ),
      ),
    );
  }
}

class ImagesToPDFScaffoldArguments {
  //List imagesList;
  List<File> files;
  List<File> compressedFiles;
  List<String> filePaths;
  List<String> compressedFilesPaths;
  List<String> fileNames;
  List<int> fileSizes;
  String processType;
  Map<String, dynamic> mapOfSubFunctionDetails;

  ImagesToPDFScaffoldArguments({
    //required this.imagesList,
    required this.files,
    required this.compressedFiles,
    required this.filePaths,
    required this.compressedFilesPaths,
    required this.processType,
    required this.fileNames,
    required this.fileSizes,
    required this.mapOfSubFunctionDetails,
  });
}
