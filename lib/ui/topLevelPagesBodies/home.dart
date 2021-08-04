import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/widgets/topLevelPagesWidgets/homeWidgets/expanding_container/expanding_container.dart';
import '../../toolExpandingContainersAndFunctionsMaps/tool_cards_details_maps.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController controller = PageController(initialPage: 0);
  List listOfToolCardsForDocuments = [];
  List listOfToolCardsForMedia = [];

  @override
  void initState() {
    super.initState();
    listOfToolCardsForDocuments = [
      mapOfCardDetailsForPDF,
    ];
    listOfToolCardsForMedia = [
      mapOfCardDetailsForImages,
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Document Tools',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: List<Widget>.generate(
                  listOfToolCardsForDocuments.length, (int index) {
                return Column(
                  children: [
                    ExpandingContainer(
                        mapOfCardDetails: listOfToolCardsForDocuments[index]),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  'Media Tools',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: List<Widget>.generate(listOfToolCardsForMedia.length,
                  (int index) {
                return Column(
                  children: [
                    ExpandingContainer(
                        mapOfCardDetails: listOfToolCardsForMedia[index]),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
