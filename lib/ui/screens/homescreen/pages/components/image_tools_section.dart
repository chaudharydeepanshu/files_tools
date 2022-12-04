import 'package:files_tools/route/app_routes.dart' as route;
import 'package:flutter/material.dart';

import 'package:files_tools/ui/screens/homescreen/pages/components/grid_view_in_card_view.dart';

class ImageToolsPage extends StatelessWidget {
  const ImageToolsPage({Key? key, required this.arguments}) : super(key: key);

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

class ImageToolsPageArguments {

  ImageToolsPageArguments({required this.cardsDetails});
  final List<GridCardDetail> cardsDetails;
}

class ImageToolsSection extends StatelessWidget {
  const ImageToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> exploreCardsDetails = [
      GridCardDetail(
        cardIcons: const [Icon(Icons.compress)],
        cardTitle: 'Compress Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.compressImagePage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: [
          Column(
            children: const [
              Icon(Icons.crop),
              Text(
                'Crop',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: const [
              Icon(Icons.rotate_right),
              Text(
                'Rotate',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: const [
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
        cardIcons: const [Icon(Icons.cached)],
        cardTitle: 'Convert Image',
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.AppRoutes.convertPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcons: const [Icon(Icons.branding_watermark)],
        cardTitle: 'Watermark Image',
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.AppRoutes.watermarkPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
