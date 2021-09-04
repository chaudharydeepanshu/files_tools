import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);

  String? get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-4350200185776333/3077024944' //real
      //? 'ca-app-pub-3940256099942544/6300978111' //test
      //? null
      : 'ca-app-pub-3940256099942544/2934735716';

  static bool adStatus = true;

  AdManagerBannerAdListener get adListener => _adListener;

  AdManagerBannerAdListener _adListener = AdManagerBannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      print('Ad loaded.');
      adStatus = true;
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
      adStatus = false;
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
    onAppEvent: (ad, name, data) =>
        print('App event : ${ad.adUnitId}, $name, $data.'),
  );
}
