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
    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Tools'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
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
    final List<GridCardDetail> exploreCardsDetails = <GridCardDetail>[
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.compress)],
        cardTitle: 'Compress Image',
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
            children: const <Widget>[
              Icon(Icons.crop),
              Text(
                'Crop',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: const <Widget>[
              Icon(Icons.rotate_right),
              Text(
                'Rotate',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: const <Widget>[
              Icon(Icons.flip),
              Text(
                'Flip',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
        ],
        cardTitle: 'Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.cropRotateFlipImagesPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.cached)],
        cardTitle: 'Convert Image',
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.AppRoutes.convertPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.branding_watermark)],
        cardTitle: 'Watermark Image',
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
        cardTitle: 'PDF To Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.pdfToImagePage,
          );
        },
      ),
    ];

    return GridViewInCardSection(
      sectionTitle: 'Image Tools',
      emptySectionText: 'No tools found',
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
