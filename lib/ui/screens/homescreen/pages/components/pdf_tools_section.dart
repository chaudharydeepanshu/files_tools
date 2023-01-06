import 'package:files_tools/l10n/generated/app_locale.dart';
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
    AppLocale appLocale = AppLocale.of(context);

    final List<GridCardDetail> cardsDetails = arguments.cardsDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocale.pdfTools),
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
    AppLocale appLocale = AppLocale.of(context);
    String mergePdf = appLocale.tool_MergeFileOrFiles(appLocale.pdf(1));
    String splitPdf = appLocale.tool_SplitFileOrFiles(appLocale.pdf(1));
    String rotate = appLocale.rotate;
    String delete = appLocale.delete;
    String reorder = appLocale.reorder;
    String modifyPdf = appLocale.tool_ModifyFileOrFiles(appLocale.pdf(1));
    String convertPdfFormat =
        appLocale.tool_ConvertFileOrFilesFormat(appLocale.pdf(1));
    String compressPdf = appLocale.tool_CompressFileOrFiles(appLocale.pdf(1));
    String watermarkPdf = appLocale.tool_WatermarkFileOrFiles(appLocale.pdf(1));
    String imageToPdf = appLocale.tool_FileOrFiles1ToFileOrFiles2(
      appLocale.image(1),
      appLocale.pdf(1),
    );
    String encryptPdf = appLocale.tool_EncryptFileOrFiles(appLocale.pdf(1));
    String decryptPdf = appLocale.tool_DecryptFileOrFiles(appLocale.pdf(1));
    String pdfTools = appLocale.pdfTools;
    String noToolsAvailable = appLocale.noToolsAvailable;

    final List<GridCardDetail> exploreCardsDetails = <GridCardDetail>[
      GridCardDetail(
        cardIcons: <Widget>[const Icon(Icons.merge)],
        cardTitle: mergePdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.mergePDFsPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: <Widget>[const Icon(Icons.call_split)],
        cardTitle: splitPdf,
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
              const Icon(Icons.delete),
              Text(
                delete,
                style: const TextStyle(fontSize: 8),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const Icon(Icons.reorder),
              Text(
                reorder,
                style: const TextStyle(fontSize: 8),
              ),
            ],
          ),
        ],
        cardTitle: modifyPdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.modifyPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.cached)],
        cardTitle: convertPdfFormat,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.convertPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.compress)],
        cardTitle: compressPdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.compressPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.branding_watermark)],
        cardTitle: watermarkPdf,
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
        cardTitle: imageToPdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.imageToPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.lock)],
        cardTitle: encryptPdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.encryptPDFPage,
          );
        },
      ),
      GridCardDetail(
        cardIcons: const <Widget>[Icon(Icons.lock_open)],
        cardTitle: decryptPdf,
        cardOnTap: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.decryptPDFPage,
          );
        },
      ),
    ];

    return GridViewInCardSection(
      sectionTitle: pdfTools,
      emptySectionText: noToolsAvailable,
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
