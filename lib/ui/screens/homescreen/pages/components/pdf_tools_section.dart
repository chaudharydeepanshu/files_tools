import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/ui/screens/homescreen/pages/components/grid_view_in_card_view.dart';
import 'package:flutter/material.dart';

/// Screen for displaying all PDF tools.
class PDFToolsPage extends StatelessWidget {
  /// Defining [PDFToolsPage] constructor.
  const PDFToolsPage({Key? key, required this.arguments}) : super(key: key);

  /// Arguments passed when screen pushed.
  final PDFToolsPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Tools'),
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

/// Takes [PDFToolsPage] arguments passed when screen pushed.
class PDFToolsPageArguments {
  /// Defining [PDFToolsPageArguments] constructor.
  PDFToolsPageArguments({required this.cardsDetails});

  /// Models for all the tools for PDF file.
  final List<GridCardDetail> cardsDetails;
}

/// Displays PDF tools for document tools tab on home screen.
class PDFToolsSection extends StatelessWidget {
  /// Defining [PDFToolsSection] constructor.
  const PDFToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GridCardDetail> exploreCardsDetails = <GridCardDetail>[
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.merge)],
        cardTitle: 'Merge PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.mergePDFsPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.call_split)],
        cardTitle: 'Split PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.splitPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: <Widget>[
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
              Icon(Icons.delete),
              Text(
                'Delete',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: const <Widget>[
              Icon(Icons.reorder),
              Text(
                'Reorder',
                style: TextStyle(fontSize: 8),
              ),
            ],
          ),
        ],
        cardTitle: 'Modify PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.modifyPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.cached)],
        cardTitle: 'Convert PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.convertPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.compress)],
        cardTitle: 'Compress PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.compressPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.branding_watermark)],
        cardTitle: 'Watermark PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.watermarkPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.image),
              Icon(Icons.arrow_forward),
              Icon(Icons.picture_as_pdf),
            ],
          )
        ],
        cardTitle: 'Image To PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.imageToPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.lock)],
        cardTitle: 'Encrypt PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.encryptPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.lock_open)],
        cardTitle: 'Decrypt PDF',
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.decryptPDFPage,
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
          route.AppRoutes.pdfToolsPage,
          arguments: PDFToolsPageArguments(cardsDetails: exploreCardsDetails),
        );
      },
    );
  }
}
