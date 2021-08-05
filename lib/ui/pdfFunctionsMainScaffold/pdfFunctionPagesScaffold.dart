import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:files_tools/ui/pdfFunctionsMainBodies/pdfFunctionPagesScaffoldBody.dart';
import 'package:files_tools/ui/pdfFunctionsMainBodies/pdfFunctionPagesScaffoldBodyForSelectingMultipleFiles.dart';
import 'package:files_tools/ui/pdfFunctionsMainBodies/pdfFunctionPagesScaffoldBodyForSelectingSingle&MultipleImages.dart';
import 'package:files_tools/widgets/pdfFunctionsMainWidgets/pdfFunctionsAppBar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../ad_state.dart';

class PDFFunctionsPageScaffold extends StatefulWidget {
  static const String routeName = '/pdfFunctionsPageScaffold';

  const PDFFunctionsPageScaffold({Key? key, this.arguments}) : super(key: key);
  final PDFFunctionsPageScaffoldArguments? arguments;

  @override
  _PDFFunctionsPageScaffoldState createState() =>
      _PDFFunctionsPageScaffoldState();
}

class _PDFFunctionsPageScaffoldState extends State<PDFFunctionsPageScaffold> {
  bool notifyBodyPoppingSplitPDFFunctionScaffold = false;
  bool notifyAppbarFileStatus = false;

  Map<String, dynamic>? mapOfFunctionDetails;
  Widget? body;

  @override
  void initState() {
    mapOfFunctionDetails = widget.arguments!.mapOfFunctionDetails;

    if (mapOfFunctionDetails!['Function Body Type'] == 'Single File Body') {
      body = PDFFunctionBody(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else if (mapOfFunctionDetails!['Function Body Type'] ==
        'Multiple File Body') {
      body = PDFFunctionBodyForMultipleFiles(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else if (mapOfFunctionDetails!['Function Body Type'] ==
        'Single And Multiple Images Body') {
      body = PDFFunctionBodyForSelectingSingleMultipleImages(
        notifyBodyPoppingSplitPDFFunctionScaffold:
            notifyBodyPoppingSplitPDFFunctionScaffold,
        onNotifyAppbarFileStatus: (bool value) {
          setState(() {
            notifyAppbarFileStatus = value;
          });
        },
        mapOfFunctionDetails: mapOfFunctionDetails,
      );
    } else {
      print('empty body provided');
      body = Container();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
          listener: adState.adListener,
          adUnitId: adState.bannerAdUnitId,
          request: AdRequest(),
          size: AdSize.banner,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: mapOfFunctionDetails!['BG Color'] ?? null,
      appBar: PdfFunctionsAppBar(
        onNotifyBodyPoppingSplitPDFFunctionScaffold: (bool value) {
          setState(() {
            notifyBodyPoppingSplitPDFFunctionScaffold = true;
          });
        },
        notifyAppbarFileStatus: notifyAppbarFileStatus,
        mapOfFunctionDetails: mapOfFunctionDetails,
      ),
      body: body,
      // bottomNavigationBar: banner == null
      //     ? SizedBox(
      //         height: AdSize.banner.height.toDouble(),
      //       )
      //     : Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           Container(
      //             height: AdSize.banner.height.toDouble(),
      //             child: AdWidget(
      //               ad: banner!,
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }
}

class PDFFunctionsPageScaffoldArguments {
  final int? pdfFunctionCurrentIndex;
  final Map<String, dynamic>? mapOfFunctionDetails;

  PDFFunctionsPageScaffoldArguments(
      {required this.mapOfFunctionDetails, this.pdfFunctionCurrentIndex});
}
