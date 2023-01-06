import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/ui/screens/homescreen/pages/components/grid_view_in_card_view.dart';
import 'package:flutter/material.dart';

/// Screen for displaying all image tools.
class ImageToolsPage extends StatelessWidget {
  /// Defining [ImageToolsPage] constructor.
  const ImageToolsPage({Key? key, required this.arguments}) : super(key: key);

  /// Arguments passed when screen pushed.
  final ImageToolsPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocale.imageTools),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxCrossAxisExtent =
              constraints.maxWidth / (constraints.maxWidth / 280);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisExtent: 100,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: cardsDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return GridViewCard(
                gridCardDetail: cardsDetails[index],
              );
            },
          );
        },
      ),
    );
  }
}

/// Takes [ImageToolsPage] arguments passed when screen pushed.
class ImageToolsPageArguments {
  /// Defining [ImageToolsPageArguments] constructor.
  ImageToolsPageArguments({required this.cardsDetails});

  /// Models for all the tools for image file.
  final List<GridCardDetail> cardsDetails;
}

/// Displays image tools for media tools tab on home screen.
class ImageToolsSection extends StatelessWidget {
  /// Defining [ImageToolsSection] constructor.
  const ImageToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String compressImage =
        appLocale.tool_CompressFileOrFiles(appLocale.image(1));
    String crop = appLocale.crop;
    String rotate = appLocale.rotate;
    String flip = appLocale.flip;
    String modifyImage = appLocale.tool_ModifyFileOrFiles(appLocale.image(1));
    String convertImageFormat =
        appLocale.tool_ConvertFileOrFilesFormat(appLocale.image(1));
    String watermarkImage =
        appLocale.tool_WatermarkFileOrFiles(appLocale.image(1));
    String pdfToImage = appLocale.tool_FileOrFiles1ToFileOrFiles2(
      appLocale.pdf(1),
      appLocale.image(1),
    );
    String imageTools = appLocale.imageTools;
    String noToolsAvailable = appLocale.noToolsAvailable;

    final List<GridCardDetail> exploreCardsDetails = <GridCardDetail>[
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.compress)],
        cardTitle: compressImage,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.compressImagePage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: <Widget>[
          Column(
            children: <Widget>[
              const Icon(Icons.crop),
              Text(
                crop,
                style: const TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const Icon(Icons.rotate_right),
              Text(
                rotate,
                style: const TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const Icon(Icons.flip),
              Text(
                flip,
                style: const TextStyle(fontSize: 8),
              ),
            ],
          ),
        ],
        cardTitle: modifyImage,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.cropRotateFlipImagesPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.cached)],
        cardTitle: convertImageFormat,
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.AppRoutes.convertPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.branding_watermark)],
        cardTitle: watermarkImage,
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.AppRoutes.watermarkPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcons: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.picture_as_pdf),
              Icon(Icons.arrow_forward),
              Icon(Icons.image),
            ],
          )
        ],
        cardTitle: pdfToImage,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.pdfToImagePage,
          );
        },
      ),
    ];

    return GridViewInCardSection(
      sectionTitle: imageTools,
      emptySectionText: noToolsAvailable,
      gridCardsDetails: exploreCardsDetails,
      cardShowAllOnTap: () {
        Navigator.pushNamed(
          context,
          route.AppRoutes.imageToolsPage,
          arguments: ImageToolsPageArguments(cardsDetails: exploreCardsDetails),
        );
      },
    );
  }
}
