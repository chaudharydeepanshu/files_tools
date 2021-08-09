import 'package:files_tools/widgets/annotatedRegion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents Homepage for Navigation
class PDFScaffold extends StatefulWidget {
  static const String routeName = '/pdfScaffold';

  final PDFScaffoldArguments? arguments;

  const PDFScaffold({Key? key, this.arguments}) : super(key: key);

  @override
  _HomePage createState() => _HomePage(test: 'sdfdsf');
}

class _HomePage extends State<PDFScaffold> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final test;

  _HomePage({this.test});
  // @override
  // void initState() {
  //   super.initState();
  // }

  // Widget pdfView() => PdfView(
  //       controller: PdfController(
  //         document: PdfDocument.openFile(widget.arguments.pdfPath),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return ReusableAnnotatedRegion(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Files Tools PDF Viewer'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                //color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
          ],
        ),
        body:
            // TextButton(
            //   onPressed: () {
            //     OpenFile.open(widget.arguments!.pdfPath);
            //   },
            //   child: Text('Test'),
            // )

            //PdfViewer.openFile(widget.arguments.pdfPath),
            // pdfView(),
            SfPdfViewer.file(
          File(widget.arguments!.pdfPath.toString()),
          // File(
          //     '/storage/emulated/0/Download/Schedule_Term End Examinations_Winter Semester 2020-21.pdf'),
          enableDoubleTapZooming: true,
          key: _pdfViewerKey,
        ),
      ),
    );
  }
}

class PDFScaffoldArguments {
  final String? pdfPath;

  PDFScaffoldArguments({this.pdfPath});
}
