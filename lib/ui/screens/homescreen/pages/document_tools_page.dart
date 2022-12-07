import 'package:files_tools/ui/screens/homescreen/pages/components/pdf_tools_section.dart';
import 'package:flutter/cupertino.dart';

/// Widget for displaying document tools on home screen.
class DocumentTools extends StatelessWidget {
  /// Defining [DocumentTools] constructor.
  const DocumentTools({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        SizedBox(
          height: 16,
        ),
        PDFToolsSection(),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
