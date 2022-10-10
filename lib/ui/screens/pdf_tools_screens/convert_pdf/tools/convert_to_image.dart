import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:flutter/material.dart';

class ConvertToImage extends StatelessWidget {
  const ConvertToImage({Key? key, required this.pdfPages, required this.file})
      : super(key: key);

  final List<PdfPageModel> pdfPages;
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [],
    );
  }
}
