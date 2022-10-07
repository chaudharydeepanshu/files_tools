import 'package:files_tools/ui/screens/homescreen/pages/components/pdf_tools_section.dart';
import 'package:flutter/cupertino.dart';

class DocumentTools extends StatelessWidget {
  const DocumentTools({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
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
