import 'dart:io';
import 'dart:typed_data';
import 'package:files_tools/ads/ad_state.dart';
import 'package:files_tools/ads/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingImageFileUsingBytesTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingZipFileTemporarily.dart';
import 'package:files_tools/basicFunctionalityFunctions/currentDateTimeInString.dart';
import 'package:files_tools/basicFunctionalityFunctions/fileNameManager.dart';
import 'package:files_tools/basicFunctionalityFunctions/getFileNameFromFilePath.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultImageScaffold.dart';
import 'package:files_tools/ui/functionsResultsScaffold/resultZipScaffold.dart';
import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/widgets/functionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';
import 'package:provider/provider.dart';

class CompressImagesScaffold extends StatefulWidget {
  static const String routeName = '/compressImagesScaffold';

  const CompressImagesScaffold({Key? key, this.arguments}) : super(key: key);

  final CompressImagesScaffoldArguments? arguments;

  @override
  _CompressImagesScaffoldState createState() => _CompressImagesScaffoldState();
}

enum Qualities { low, medium, high, custom }

class _CompressImagesScaffoldState extends State<CompressImagesScaffold>
    with TickerProviderStateMixin {
  String? extensionOfFileName;

  @override
  void initState() {
    super.initState();

    customQualityTextEditingController.text = 88.toString();

    appBarIconLeft = Icons.arrow_back;
    appBarIconLeftToolTip = 'Back';
    appBarIconLeftAction = () {
      return Navigator.of(context).pop();
    };

    appBarIconRight = Icons.check;
    appBarIconRightToolTip = 'Done';
    appBarIconRightAction = () async {
      FocusManager.instance.primaryFocus?.unfocus();
      shouldWePopScaffold = false;
      shouldDataBeProcessed = true;
      setState(() {
        selectedDataProcessed = true;
      });
      processingDialog(context); //shows the processing dialog

      List<String>? compressedFilesPaths = [];
      Future.delayed(const Duration(milliseconds: 500), () async {
        compressedFilesPaths = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'File Names': widget.arguments!.fileNames,
              'Qualities Method': _method,
              'Quality Custom Value':
                  int.parse(customQualityTextEditingController.text),
              //'State': editorKey.currentState!,
            },
            processType: widget.arguments!.processType,
            filesPaths: widget.arguments!.filePaths,
            //filesPaths: widget.arguments!.compressedFilesPaths,
            shouldDataBeProcessed: shouldDataBeProcessed);

        Map map = Map();
        if (compressedFilesPaths!.length == 1) {
          // map['_imageName'] =
          //     "Modified Image ${currentDateTimeInString() + extensionOfFileName!}";
          // map['_extraBetweenNameAndExtension'] = '';
          // map['_imageBytes'] = compressedFilesPaths![0];
        } else {
          map['_pdfFileName'] =
              "Modified Images ${currentDateTimeInString()} .xyz";
          map['_extraBetweenNameAndExtension'] = '';
          map['_rangesPdfsFilePaths'] = compressedFilesPaths;
        }

        // final result = await compute(creatingAndSavingFileTemporarily, map);
        // return result;
        //todo: setup isolates to decrease the jitter in circular progress bar a little bit
        //todo: to do this first find the culprit and then find a solution if possible
        //the main delay is getting the processed document so try to optimise its loop using isolate

        return Future.delayed(const Duration(milliseconds: 500), () async {
          return compressedFilesPaths != null && shouldDataBeProcessed == true
              ? compressedFilesPaths!.length == 1
                  ? compressedFilesPaths![0]
                  : await creatingAndSavingZipFileTemporarily(map)
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
          if (compressedFilesPaths != null &&
              shouldDataBeProcessed == true &&
              value != null) {
            Navigator.pop(context); //closes the processing dialog
            if (compressedFilesPaths!.length == 1) {
              extensionOfFileName =
                  extensionOfString(fileName: getFileNameFromFilePath(value));
              Navigator.pushNamed(
                context,
                PageRoutes.resultImageScaffold,
                arguments: ResultImageScaffoldArguments(
                  //fileData: fileData!,
                  filePath: value,
                  pdfFileName:
                      "Compressed Image ${currentDateTimeInString() + extensionOfFileName!}",
                  mapOfSubFunctionDetails:
                      widget.arguments!.mapOfSubFunctionDetails,
                ),
              );
            } else {
              Navigator.pushNamed(
                context,
                PageRoutes.resultZipScaffold,
                arguments: ResultZipScaffoldArguments(
                  rangesPdfsFilePaths: compressedFilesPaths!,
                  rangesPdfsZipFilePath: value,
                  //pdfFile: widget.arguments!.pdfFile,
                  mapOfSubFunctionDetails:
                      widget.arguments!.mapOfSubFunctionDetails,
                ),
              );
            }
          }
        }).whenComplete(() {
          setState(() {
            selectedDataProcessed = false;
            shouldWePopScaffold = true;
          });
        });
      });
    };
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

  Qualities? _method = Qualities.medium;

  var bannerAdSize = Size.zero;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController customQualityTextEditingController =
      TextEditingController();

  //todo dispose text editing controller

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: WillPopScope(
          onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Scaffold(
                  appBar: ReusableSilverAppBar(
                    title: 'Specify Compression',
                    titleColor: Colors.black,
                    leftButtonColor: Colors.red,
                    appBarIconLeft: appBarIconLeft,
                    appBarIconLeftToolTip: appBarIconLeftToolTip,
                    appBarIconLeftAction: appBarIconLeftAction,
                    rightButtonColor: Colors.blue,
                    appBarIconRight: appBarIconRight,
                    appBarIconRightToolTip: appBarIconRightToolTip,
                    appBarIconRightAction: _formKey.currentState != null
                        ? _formKey.currentState!.validate()
                            ? appBarIconRightAction
                            : null
                        : null,
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              RadioListTile<Qualities>(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: const Text('Less Compression'),
                                subtitle: const Text(
                                    'High quality, less compression'),
                                value: Qualities.high,
                                groupValue: _method,
                                onChanged: (Qualities? value) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    _method = value;
                                  });
                                },
                              ),
                              RadioListTile<Qualities>(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: const Text('Recommended Compression'),
                                subtitle: const Text(
                                    'Good quality, good compression'),
                                value: Qualities.medium,
                                groupValue: _method,
                                onChanged: (Qualities? value) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    _method = value;
                                  });
                                },
                              ),
                              RadioListTile<Qualities>(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: const Text('Extreme Compression'),
                                subtitle: const Text(
                                    'less quality, High compression'),
                                value: Qualities.low,
                                groupValue: _method,
                                onChanged: (Qualities? value) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    _method = value;
                                  });
                                },
                              ),
                              RadioListTile<Qualities>(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Row(
                                  children: [
                                    const Text('Custom Compression'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller:
                                            customQualityTextEditingController,
                                        decoration: const InputDecoration(
                                          hintText: '88',
                                          labelText: 'Quality % *',
                                          helperText: ' ',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (String? value) {
                                          return (_method == Qualities.custom &&
                                                  (value == null ||
                                                      value.isEmpty))
                                              ? 'Can\'t be Empty'
                                              : (_method == Qualities.custom &&
                                                      (int.parse(value!) < 1 ||
                                                          int.parse(value) >
                                                              100))
                                                  ? 'Enter from 1 - 100'
                                                  : null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle:
                                    const Text('Enter quality from 1 to 100'),
                                value: Qualities.custom,
                                groupValue: _method,
                                onChanged: (Qualities? value) {
                                  setState(() {
                                    _method = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Note: ',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Expanded(
                                    child: Text(
                                        'Images that are already compressed may result in a larger or same size image if compressed again.'),
                                  ),
                                ],
                              ),
                              Provider.of<AdState>(context).bannerAdUnitId !=
                                      null
                                  ? SizedBox(
                                      height: bannerAdSize.height.toDouble(),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: Column(
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
              ),
              // selectedDataProcessed == true ? progressFakeDialogBox : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CompressImagesScaffoldArguments {
  List<File> files;
  List<File> compressedFiles;
  List<String> filePaths;
  List<String> compressedFilesPaths;
  List<String> fileNames;
  List<int> fileSizes;
  String processType;
  Map<String, dynamic> mapOfSubFunctionDetails;

  CompressImagesScaffoldArguments({
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
