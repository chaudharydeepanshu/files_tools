import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:files_tools/ads_state/banner_ad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:files_tools/basicFunctionalityFunctions/creatingAndSavingPDFFileTemporarily.dart';
import 'package:files_tools/navigation/page_routes_model.dart';
import 'package:files_tools/basicFunctionalityFunctions/processSelectedDataFromUser.dart';
import 'package:files_tools/ui/pdfFunctionsResultsScaffold/resultPdfScaffold.dart';
import 'package:files_tools/widgets/pdfFunctionsActionWidgets/reusableUIActionWidgets/progressFakeDialogBox.dart';
import 'package:files_tools/widgets/reusableUIWidgets/ReusableTopAppBar.dart';

class DecryptPDFScaffold extends StatefulWidget {
  static const String routeName = '/decryptPDFScaffold';

  const DecryptPDFScaffold({Key? key, this.arguments}) : super(key: key);

  final DecryptPDFScaffoldArguments? arguments;

  @override
  _DecryptPDFScaffoldState createState() => _DecryptPDFScaffoldState();
}

class _DecryptPDFScaffoldState extends State<DecryptPDFScaffold>
    with TickerProviderStateMixin {
  late List<bool> selectedImages;
  List<TextInputFormatter>? listTextInputFormatter;
  TextEditingController textEditingControllerOwnerPassword =
      TextEditingController();
  TextEditingController textEditingControllerUserPassword =
      TextEditingController();
  late int pdfPagesCount;
  int numberOfPDFCreated = 0;
  @override
  void initState() {
    super.initState();
    listTextInputFormatter = [
      FilteringTextInputFormatter.deny(RegExp('[ ]')),
    ];
    pdfPagesCount = widget.arguments!.pdfPagesImages!.length;
    textEditingControllerOwnerPassword.addListener(() {
      setState(() {});
    });
    textEditingControllerUserPassword.addListener(() {
      setState(() {});
    });
    // [
    //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 \"‘\'‘,-]')),
    // ];
    // print(
    //     "test: ${_controller.text.substring(_controller.text.length - 1)}");
    // if()
    // listTextInputFormatter = [
    //   FilteringTextInputFormatter.allow(RegExp('[0-9,-]')),
    // ];
    super.initState();

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

      var document;
      Future.delayed(const Duration(milliseconds: 500), () async {
        document = await processSelectedDataFromUser(
            pdfChangesDataMap: {
              'PDF File Name': '${widget.arguments!.pdfFile.name}',
              'Owner Password TextEditingController':
                  textEditingControllerOwnerPassword,
              'User Password TextEditingController':
                  textEditingControllerUserPassword,
            },
            processType: widget.arguments!.processType,
            filePath: widget.arguments!.pdfFile.path!,
            shouldDataBeProcessed: shouldDataBeProcessed);
        if (document == 'BothPasswordFailed') {
          _onWillPop();
          final snackBar = SnackBar(
            content: const Text('Both Owner And User Password Are Wrong'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        Map map = Map();
        map['_pdfFileName'] = '${widget.arguments!.pdfFile.name}';
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
                pdfFilePath: value,
                pdfFileName: widget.arguments!.pdfFile.name,
                mapOfSubFunctionDetails:
                    widget.arguments!.mapOfSubFunctionDetails,
              ),
            );
          }
        }).whenComplete(() {
          // setState(() {
          selectedDataProcessed = false;
          shouldWePopScaffold = true;
          // });
        });
      });
    };
  }

  @override
  void dispose() {
    textEditingControllerOwnerPassword.dispose();
    textEditingControllerUserPassword.dispose();
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

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool obscureOwnerPassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: shouldWePopScaffold == true ? _directPop : _onWillPop,
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Scaffold(
                appBar: ReusableSilverAppBar(
                  title: 'Specify Decryption Info',
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
                            TextFormFieldsForEncryptPDF(
                              helperText:
                                  'Owner Password will be used to remove security permissions',
                              labelText: 'Enter Owner Password',
                              textEditingController:
                                  textEditingControllerOwnerPassword,
                              validator: (value) {
                                return null;
                              },
                              listTextInputFormatter: listTextInputFormatter!,
                              onTextEditingController:
                                  (TextEditingController value) {
                                setState(() {
                                  textEditingControllerOwnerPassword = value;
                                });
                              },
                            ),
                            TextFormFieldsForEncryptPDF(
                              helperText: 'User Password is used to access PDF',
                              labelText: 'Enter User Password *',
                              textEditingController:
                                  textEditingControllerUserPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'User password is required';
                                }
                                return null;
                              },
                              listTextInputFormatter: listTextInputFormatter!,
                              onTextEditingController:
                                  (TextEditingController value) {
                                setState(() {
                                  textEditingControllerUserPassword = value;
                                });
                              },
                            ),
                            // TextFormField(
                            //   controller: textEditingController,
                            //   keyboardType: TextInputType.number,
                            //   inputFormatters: listTextInputFormatter,
                            //   onChanged: (String value) {
                            //     if (value.isNotEmpty) {
                            //       if (int.parse(value.substring(0, 1)) == 0) {
                            //         String newValue = value.substring(0, 0) +
                            //             '' +
                            //             value.substring(0 + 1);
                            //         textEditingController.value =
                            //             TextEditingValue(
                            //           text: newValue,
                            //           selection: TextSelection.fromPosition(
                            //             TextPosition(offset: newValue.length),
                            //           ),
                            //         );
                            //       }
                            //     }
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: 'Type a number',
                            //     //helperText: ' ',
                            //     hintText: 'Ex: ${pdfPagesCount - 1}',
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   //autofocus: true,
                            //   showCursor: true,
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Empty Field';
                            //     } else if (int.parse(value) == pdfPagesCount)
                            //     //RegExp('[a-zA-Z0-9 \"‘\'‘,-]')
                            //     {
                            //       return 'Type a shorter number than total number of pages';
                            //     } else if (int.parse(value) > pdfPagesCount)
                            //     //RegExp('[a-zA-Z0-9 \"‘\'‘,-]')
                            //     {
                            //       return 'Out of range';
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                    BannerAD(),
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

class DecryptPDFScaffoldArguments {
  List? pdfPagesImages;
  PlatformFile pdfFile;
  String processType;
  Map<String, dynamic>? mapOfSubFunctionDetails;

  DecryptPDFScaffoldArguments({
    this.pdfPagesImages,
    required this.pdfFile,
    required this.processType,
    this.mapOfSubFunctionDetails,
  });
}

class TextFormFieldsForEncryptPDF extends StatefulWidget {
  const TextFormFieldsForEncryptPDF(
      {Key? key,
      required this.labelText,
      required this.helperText,
      required this.textEditingController,
      required this.validator,
      required this.listTextInputFormatter,
      required this.onTextEditingController})
      : super(key: key);

  final String labelText;
  final String helperText;
  final TextEditingController textEditingController;
  final FormFieldValidator validator;
  final List<TextInputFormatter> listTextInputFormatter;
  final ValueChanged<TextEditingController> onTextEditingController;

  @override
  _TextFormFieldsForEncryptPDFState createState() =>
      _TextFormFieldsForEncryptPDFState();
}

class _TextFormFieldsForEncryptPDFState
    extends State<TextFormFieldsForEncryptPDF> {
  late TextEditingController _textEditingController;
  late bool _obscureText = true;

  @override
  void initState() {
    _textEditingController = widget.textEditingController;
    _textEditingController.addListener(() {
      widget.onTextEditingController.call(_textEditingController);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      enableSuggestions: false,
      autocorrect: false,
      controller: _textEditingController,
      inputFormatters: widget.listTextInputFormatter,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      //initialValue: 'Input text',
      //maxLength: 20,
      decoration: InputDecoration(
        //icon: Icon(Icons.favorite),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        hintText: 'Password@123',
        helperText: widget.helperText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.remove_red_eye : Icons.password,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
    );
  }
}
