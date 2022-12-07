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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Files Tools'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Document Tools',
                icon: Icon(Icons.description),
              ),
              Tab(
                text: 'Media Tools',
                icon: Icon(Icons.image),
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
