import 'package:files_tools/ui/functionsMainBodies/pdf_function_pages_scaffold_body_for_selecting_single_image.dart';
import 'package:files_tools/widgets/annotated_region.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/functionsMainBodies/pdf_function_pages_scaffold_body_for_selecting_single_pdf_file.dart';
import 'package:files_tools/ui/functionsMainBodies/pdf_function_pages_scaffold_body_for_selecting_multiple_pdf_files.dart';
import 'package:files_tools/ui/functionsMainBodies/pdf_function_pages_scaffold_body_for_selecting_single_and_multiple_images.dart';
import 'package:files_tools/widgets/functionsMainWidgets/functions_appbar.dart';

class PDFFunctionsPageScaffold extends StatefulWidget {
  static const String routeName = '/pdfFunctionsPageScaffold';

  const PDFFunctionsPageScaffold({Key? key, this.arguments}) : super(key: key);
  final PDFFunctionsPageScaffoldArguments? arguments;

  @override
  _PDFFunctionsPageScaffoldState createState() =>
      _PDFFunctionsPageScaffoldState();
}

class _PDFFunctionsPageScaffoldState extends State<PDFFunctionsPageScaffold> {
  bool notifyBodyPoppingSplitPDFFunctionScaffold = false;
  bool notifyAppbarFileStatus = false;

  Map<String, dynamic>? mapOfFunctionDetails;
  Widget? body;

  @override
  void initState() {
    mapOfFunctionDetails = widget.arguments!.mapOfFunctionDetails;

    if (mapOfFunctionDetails!['Function Body Type'] == 'Single File Body') {
      body = PDFFunctionBody(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else if (mapOfFunctionDetails!['Function Body Type'] ==
        'Multiple File Body') {
      body = PDFFunctionBodyForMultipleFiles(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else if (mapOfFunctionDetails!['Function Body Type'] ==
        'Single And Multiple Images Body') {
      body = PDFFunctionBodyForSelectingSingleMultipleImages(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else if (mapOfFunctionDetails!['Function Body Type'] ==
        'Single Image Body') {
      body = PDFFunctionBodyForSelectingSingleImage(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else {
      debugPrint('empty body provided');
      body = Container();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: Scaffold(
        //backgroundColor: mapOfFunctionDetails!['BG Color'] ?? null,
        appBar: PdfFunctionsAppBar(
          onNotifyBodyPoppingSplitPDFFunctionScaffold: (bool value) {
            setState(() {
              notifyBodyPoppingSplitPDFFunctionScaffold = true;
            });
          },
          notifyAppbarFileStatus: notifyAppbarFileStatus,
          mapOfFunctionDetails: mapOfFunctionDetails,
        ),
        body: body,
      ),
    );
  }
}

class PDFFunctionsPageScaffoldArguments {
  final int? pdfFunctionCurrentIndex;
  final Map<String, dynamic>? mapOfFunctionDetails;

  PDFFunctionsPageScaffoldArguments(
      {required this.mapOfFunctionDetails, this.pdfFunctionCurrentIndex});
}
