import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/ui/components/drawer.dart';
import 'package:files_tools/ui/screens/homescreen/pages/document_tools_page.dart';
import 'package:files_tools/ui/screens/homescreen/pages/media_tools_page.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// It is the home screen widget.
class HomePage extends StatefulWidget {
  /// Defining [HomePage] constructor.
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    Utility.clearTempDirectory(clearCacheCommandFrom: 'HomePage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String homeScreenTile = appLocale.home_ScreenTitle;
    String documentTools = appLocale.documentTools;
    String mediaTools = appLocale.mediaTools;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: Text(homeScreenTile),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: documentTools,
                icon: const Icon(Icons.description),
              ),
              Tab(
                text: mediaTools,
                icon: const Icon(Icons.image),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            DocumentTools(),
            MediaTools(),
          ],
        ),
      ),
    );
  }
}
