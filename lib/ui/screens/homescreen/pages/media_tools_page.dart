import 'package:files_tools/ui/screens/homescreen/pages/components/image_tools_section.dart';
import 'package:flutter/cupertino.dart';

class MediaTools extends StatelessWidget {
  const MediaTools({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16,
        ),
        ImageToolsSection(),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
