import 'package:flutter/material.dart';
import 'package:files_tools/route/route.dart' as route;

import 'grid_view_in_card_view.dart';

class PDFToolsPage extends StatelessWidget {
  const PDFToolsPage({Key? key, required this.arguments}) : super(key: key);

  final PDFToolsPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Tools"),
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

class PDFToolsPageArguments {
  final List<GridCardDetail> cardsDetails;

  PDFToolsPageArguments({required this.cardsDetails});
}

class PDFToolsSection extends StatelessWidget {
  const PDFToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> exploreCardsDetails = [
      GridCardDetail(
        cardIcon: const Icon(Icons.merge),
        cardTitle: 'Merge PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.mergePDFsPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.call_split),
        cardTitle: 'Split PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.splitPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Icon(Icons.rotate_right),
                  Text(
                    "Rotate",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
              const VerticalDivider(width: 0),
              Column(
                children: const [
                  Icon(Icons.delete),
                  Text(
                    "Delete",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
              const VerticalDivider(width: 0),
              Column(
                children: const [
                  Icon(Icons.reorder),
                  Text(
                    "Reorder",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
        cardTitle: 'Modify PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.modifyPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.cached),
        cardTitle: 'Convert PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.convertPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.compress),
        cardTitle: 'Compress PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.compressPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.branding_watermark),
        cardTitle: 'Watermark PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.watermarkPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image),
            Icon(Icons.arrow_forward),
            Icon(Icons.picture_as_pdf),
          ],
        ),
        cardTitle: 'Image To PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.imageToPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.lock),
        cardTitle: 'Encrypt PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.encryptPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcon: const Icon(Icons.lock_open),
        cardTitle: 'Decrypt PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.decryptPDFPage,
          );
        },
      ),
    ];

    return GridViewInCardSection(
      sectionTitle: 'PDF Tools',
      emptySectionText: 'No tools found',
      gridCardsDetails: exploreCardsDetails,
      cardShowAllOnTap: () {
        Navigator.pushNamed(
          context,
          route.pdfToolsPage,
          arguments: PDFToolsPageArguments(cardsDetails: exploreCardsDetails),
        );
      },
    );
  }
}
