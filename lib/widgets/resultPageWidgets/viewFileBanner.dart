import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class NoFileOpenerAvailableNotifierBanner extends StatelessWidget {
  const NoFileOpenerAvailableNotifierBanner(
      {Key? key,
      required this.bannerText,
      required this.redirectAndroidAppId,
      required this.onViewZipBannerStatus})
      : super(key: key);

  final String bannerText;
  final String redirectAndroidAppId;
  final ValueChanged<bool> onViewZipBannerStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
                //top: BorderSide(color: Colors.grey, width: 1.5),
                ),
          ),
          child: MaterialBanner(
            padding: EdgeInsets.all(5),
            content: Text(bannerText),
            leading: Icon(Icons.info_outline_rounded),
            //backgroundColor: Color(0xffDBF0F3),
            actions: <Widget>[
              OutlinedButton(
                child: Text('INSTALL'),
                onPressed: () {
                  onViewZipBannerStatus.call(false);
                  StoreRedirect.redirect(androidAppId: redirectAndroidAppId);
                },
              ),
              OutlinedButton(
                child: Text('DISMISS'),
                onPressed: () {
                  onViewZipBannerStatus.call(false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}