import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'custom_expansion_tile.dart';

class ExpandingContainer extends StatelessWidget {
  ExpandingContainer(
      {Key? key,
      this.containerLeadingIconAsset,
      this.containerLeadingIconColor,
      this.containerTitle,
      this.containerSubtitle,
      this.mapOfCardDetails})
      : super(key: key);

  final String? containerLeadingIconAsset;
  final Color? containerLeadingIconColor;
  final String? containerTitle;
  final String? containerSubtitle;
  final Map<String, dynamic>? mapOfCardDetails;

  final GlobalKey expansionTileKey = GlobalKey();

  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      // initiallyExpanded:
      //     mapOfCardDetails!['Card Title'] == "Customize PDF" ? true : false,
      key: expansionTileKey,
      onExpansionChanged: (value) {
        if (value) {
          _scrollToSelectedContent(expansionTileKey: expansionTileKey);
        }
      },
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      collapsedBackgroundColor: mapOfCardDetails!['Collapsed Card BG Color'] ??
          Colors.green.shade50, //Colors.pink.withOpacity(0.2),
      expandedBackgroundColor:
          mapOfCardDetails!['Expanded Sublist BG Color'], //Color(0xFFDEEAEC),
      expandedSublistBackgroundColor:
          mapOfCardDetails!['Expanded Sublist BG Color'] ??
              Colors.pink.withOpacity(0.25),
      effectsColor: mapOfCardDetails!['Card BG Effects Color'] ??
          Colors.black.withOpacity(0.1),
      childrenPadding: EdgeInsets.only(right: 12, left: 12, top: 8.0),
      cardTrailingArrowColor:
          mapOfCardDetails!['Card Trailing Arrow Color'] ?? null,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 68,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(200)),
              color: mapOfCardDetails!['Card Asset BG Color'] ?? null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                  mapOfCardDetails!['Card Asset'] ??
                      'assets/images/tools_icons/pdf_tools_icon.svg',
                  fit: BoxFit.fitHeight,
                  height: 45,
                  color: mapOfCardDetails!['Card Asset Color'] ?? null,
                  alignment: Alignment.center,
                  semanticsLabel: 'A red up arrow'),
            ),
          ),
        ],
      ),
      title: Text(
        mapOfCardDetails!['Card Title'] ?? 'PDF',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: mapOfCardDetails!['Card Title Color'] ?? Colors.black,
        ),
      ),
      subtitle: Text(
        mapOfCardDetails!['Card Subtitle'] ??
            'Perform actions like merge, split and etc on PDF',
        style: TextStyle(
          color: mapOfCardDetails!['Card Subtitle Color'] ?? Colors.black,
        ),
      ),
      children: List<Widget>.generate(
          mapOfCardDetails!['Functions Details'].length, (int index) {
        return Column(
          children: [
            ButtonsOfDocFunctions(
              mapOfFunctionIconAndAction: mapOfCardDetails!['Functions Details']
                  [index],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        );
      }),
    );
  }
}

class ButtonsOfDocFunctions extends StatelessWidget {
  const ButtonsOfDocFunctions(
      {Key? key,
      this.buttonColor,
      this.buttonText,
      this.buttonIconAsset,
      this.buttonIconAndTextColor,
      this.mapOfFunctionIconAndAction})
      : super(key: key);

  final Color? buttonColor;
  final Color? buttonIconAndTextColor;
  final String? buttonText;
  final String? buttonIconAsset;
  final Map? mapOfFunctionIconAndAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: mapOfFunctionIconAndAction!['Button Color'] ?? Colors.pink,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: InkWell(
        onTap: () => mapOfFunctionIconAndAction!['Action'](context) ?? () {},
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.red)),
        focusColor: Colors.black.withOpacity(0.1),
        highlightColor: Colors.black.withOpacity(0.1),
        splashColor: Colors.black.withOpacity(0.1),
        hoverColor: Colors.black.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                      mapOfFunctionIconAndAction!['Icon Asset'] ??
                          'assets/images/tools_icons/pdf_tools_icon.svg',
                      height: 40,
                      color:
                          mapOfFunctionIconAndAction!['Icon And Text Color'] ??
                              Color(0xFFF9C7D8),
                      semanticsLabel: 'A red up arrow'),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 105,
                    child: Text(
                      mapOfFunctionIconAndAction!['Function'] ?? 'Merge PDF',
                      style: TextStyle(
                        color: mapOfFunctionIconAndAction![
                                'Icon And Text Color'] ??
                            Color(0xFFF9C7D8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
