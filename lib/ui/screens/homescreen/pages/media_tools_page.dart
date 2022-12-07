import 'package:files_tools/ui/screens/homescreen/pages/components/image_tools_section.dart';
import 'package:flutter/cupertino.dart';

/// Widget for displaying media tools on home screen.
class MediaTools extends StatelessWidget {
  /// Defining [MediaTools] constructor.
  const MediaTools({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
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
