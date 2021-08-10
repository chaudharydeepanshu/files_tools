import 'package:files_tools/ads_state/banner_ad.dart';
import 'package:files_tools/basicFunctionalityFunctions/sizeCalculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/widgets/topLevelPagesWidgets/homeWidgets/expanding_container/expanding_container.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ads_state/ad_state.dart';
import '../../toolExpandingContainersAndFunctionsMaps/tool_cards_details_maps.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with WidgetsBindingObserver {
  final PageController controller = PageController(initialPage: 0);
  List listOfToolCardsForDocuments = [];
  List listOfToolCardsForMedia = [];

  @override
  void didChangePlatformBrightness() {
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    bool darkModeOn = brightness == Brightness.dark;
    if (darkModeOn == true) {
      setState(() {
        listOfToolCardsForDocuments = [
          mapOfCardDetailsForPDF,
        ];
        listOfToolCardsForMedia = [
          mapOfCardDetailsForImagesForDarkMode,
        ];
      });
    } else {
      setState(() {
        listOfToolCardsForDocuments = [
          mapOfCardDetailsForPDF,
        ];
        listOfToolCardsForMedia = [
          mapOfCardDetailsForImages,
        ];
      });
    }
    super.didChangePlatformBrightness();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this); //most important
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    print(brightness);
    // > should print Brightness.light / Brightness.dark when you switch
    bool darkModeOn = brightness == Brightness.dark;
    if (darkModeOn == true) {
      setState(() {
        listOfToolCardsForDocuments = [
          mapOfCardDetailsForPDF,
        ];
        listOfToolCardsForMedia = [
          mapOfCardDetailsForImagesForDarkMode,
        ];
      });
    } else {
      setState(() {
        listOfToolCardsForDocuments = [
          mapOfCardDetailsForPDF,
        ];
        listOfToolCardsForMedia = [
          mapOfCardDetailsForImages,
        ];
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Document Tools',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                                mapOfCardDetails:
                                    listOfToolCardsForDocuments[index]),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: List<Widget>.generate(
                          listOfToolCardsForMedia.length, (int index) {
                        return Column(
                          children: [
                            ExpandingContainer(
                                mapOfCardDetails:
                                    listOfToolCardsForMedia[index]),
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
              SizedBox(
                height: AdSize.banner.height.toDouble() + 10,
              ),
            ],
          ),
        ),
        BannerAD(),
      ],
    );
  }
}
