import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ad_state.dart';

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
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
    return banner == null
        ? SizedBox(
            height: AdSize.banner.height.toDouble(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: AdSize.banner.height.toDouble(),
                child: AdWidget(
                  ad: banner!,
                ),
              ),
            ],
          );
  }
}
