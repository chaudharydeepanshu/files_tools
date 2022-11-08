import 'package:flutter/material.dart';
import 'package:files_tools/route/route.dart' as route;

import 'grid_view_in_card_view.dart';

class ImageToolsPage extends StatelessWidget {
  const ImageToolsPage({Key? key, required this.arguments}) : super(key: key);

  final ImageToolsPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Tools"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1,
            maxCrossAxisExtent: 200,
            mainAxisExtent: 100,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: cardsDetails.length,
          itemBuilder: (BuildContext context, int index) {
            return GridViewCard(
              gridCardDetail: cardsDetails[index],
            );
          },
        ),
      ),
    );
  }
}

class ImageToolsPageArguments {
  final List<GridCardDetail> cardsDetails;

  ImageToolsPageArguments({required this.cardsDetails});
}

class ImageToolsSection extends StatelessWidget {
  const ImageToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> exploreCardsDetails = [
      GridCardDetail(
        cardIcon: const Icon(Icons.compress),
        cardTitle: 'Compress Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.compressImagePage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Icon(Icons.crop),
                  Text(
                    "Crop",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
              const VerticalDivider(),
              Column(
                children: const [
                  Icon(Icons.rotate_right),
                  Text(
                    "Rotate",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
              const VerticalDivider(),
              Column(
                children: const [
                  Icon(Icons.flip),
                  Text(
                    "Flip",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
        cardTitle: 'Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.cropRotateFlipImagesPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.cached),
        cardTitle: 'Convert Image',
        cardOnTap: null,
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.convertPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.branding_watermark),
        cardTitle: 'Watermark Image',
        cardOnTap: null,
        //     () {
        //   Navigator.pushNamed(
        //     context,
        //     route.watermarkPDFPage,
        //   );
        // },
      ),
      GridCardDetail(
        cardIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.picture_as_pdf),
            Icon(Icons.arrow_forward),
            Icon(Icons.image),
          ],
        ),
        cardTitle: 'PDF To Image',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.pdfToImagePage,
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
          route.imageToolsPage,
          arguments: ImageToolsPageArguments(cardsDetails: exploreCardsDetails),
        );
      },
    );
  }
}
