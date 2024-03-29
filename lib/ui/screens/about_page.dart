import 'package:files_tools/constants.dart';
import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/ui/components/link_button.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// It is the about screen widget.
class AboutPage extends StatelessWidget {
  /// Defining [AboutPage] constructor.
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String aboutUs = appLocale.aboutUs_ScreenTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(aboutUs),
        centerTitle: true,
      ),
      body: ListView(
        children: const <Widget>[
          SizedBox(
            height: 16,
          ),
          AppDescription(),
          SizedBox(
            height: 16,
          ),
          AppBadges(),
          SizedBox(
            height: 16,
          ),
          AppCreator(),
          SizedBox(
            height: 16,
          ),
          // Uncomment to add app contributors.
          // AppContributions(),
          // SizedBox(
          //   height: 16,
          // ),
          Credits(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

/// App description widget of about screen.
class AppDescription extends StatelessWidget {
  /// Defining [AppDescription] constructor.
  const AppDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String appDescription = appLocale.appDescription;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          appDescription,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Widget for showing badges related to app like open source, ad free, etc.
class AppBadges extends StatelessWidget {
  /// Defining [AppBadges] constructor.
  const AppBadges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String openSource = appLocale.openSource;
    String noAds = appLocale.noAds;
    String showSourceCode = appLocale.button_ShowSourceCode;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      openSourceAssetName,
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      openSource,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image.asset(
                      noAdsAssetName,
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      noAds,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinkButton(urlLabel: showSourceCode, url: sourceCodeUrl),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for showing app creator info.
class AppCreator extends StatelessWidget {
  /// Defining [AppCreator] constructor.
  const AppCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String creator = appLocale.creator;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              creator,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Text(
              'Deepanshu',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinkButton(urlLabel: 'LinkedIn', url: creatorLinkedInUrl),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Follow',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          Utility.urlLauncher(creatorGithubUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                githubAssetName,
                                height: 30,
                                width: 30,
                              ),
                              const Text(
                                'Github Profile',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '⭐ Project',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          Utility.urlLauncher(sourceCodeUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                githubAssetName,
                                height: 30,
                                width: 30,
                              ),
                              const Text(
                                'Github Project',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for showing app contributors info.
class AppContributions extends StatelessWidget {
  /// Defining [AppContributions] constructor.
  const AppContributions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String contributors = appLocale.contributors;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              contributors,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Text(
              'App Testers',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Text(
              'XYZ',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                LinkButton(urlLabel: 'Github', url: 'https://github.com/xyz'),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

/// Widget for showing app credits info.
class Credits extends StatelessWidget {
  /// Defining [Credits] constructor.
  const Credits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String credits = appLocale.credits;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              credits,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Icons by ',
                style: Theme.of(context).textTheme.bodySmall,
                children: <InlineSpan>[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: LinkButton(
                      urlLabel: 'Icons8',
                      url: icons8Url,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Animations by ',
                style: Theme.of(context).textTheme.bodySmall,
                children: <InlineSpan>[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: LinkButton(
                      urlLabel: 'Rive Community',
                      url: riveCommunityUrl,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
