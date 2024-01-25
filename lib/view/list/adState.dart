import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialisation;

  AdState(this.initialisation);

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716'; // ios

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(

    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded: ${ad.adUnitId}.'),

    onAdClosed: (Ad ad) {
      ad.dispose();
      print('Ad closed: ${ad.adUnitId}.');
    },

    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: : ${ad.adUnitId}, $error');
    },

    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened: ${ad.adUnitId}.'),

    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression: ${ad.adUnitId}.'),
  );
}