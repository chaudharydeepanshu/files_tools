import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';

// class BannerAD extends StatefulWidget {
//   const BannerAD({Key? key}) : super(key: key);
//
//   @override
//   _BannerADState createState() => _BannerADState();
// }
//
// class _BannerADState extends State<BannerAD> {
//   BannerAd? banner;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final adState = Provider.of<AdState>(context);
//     adState.initialization.then((value) {
//       setState(() {
//         banner = BannerAd(
//           listener: adState.adListener,
//           adUnitId: adState.bannerAdUnitId,
//           request: AdRequest(),
//           size: AdSize.banner,
//         )..load();
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return banner == null
//         ? SizedBox(
//             height: AdSize.banner.height.toDouble(),
//           )
//         : Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: AdSize.banner.height.toDouble(),
//                 child: AdWidget(
//                   ad: banner!,
//                 ),
//               ),
//             ],
//           );
//   }
// }

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> with WidgetsBindingObserver {
  BannerAd? banner;

  AnchoredAdaptiveBannerAdSize? size;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).orientation == Orientation.portrait
          ? Orientation.portrait
          : Orientation.landscape,
      MediaQuery.of(context).size.width.toInt(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _createAnchoredBanner(context);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createAnchoredBanner(context).whenComplete(() {
      final adState = Provider.of<AdState>(context, listen: false);
      adState.initialization.then((value) {
        setState(() {
          banner = BannerAd(
            listener: adState.adListener,
            adUnitId: adState.bannerAdUnitId,
            request: AdRequest(),
            size: size!,
            //AdSize.banner,
          )..load();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return banner == null
        ? SizedBox(
            height: AdSize.banner.height.toDouble() + 10,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.grey,
                width: size!.width.toDouble(),
                height: size!.height.toDouble(),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ad loading please wait...',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    AdWidget(
                      ad: banner!,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
