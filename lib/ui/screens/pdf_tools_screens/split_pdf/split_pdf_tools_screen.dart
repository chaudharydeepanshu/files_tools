import 'dart:developer';

import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/screens/pdf_screen.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_count.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_numbers.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_range.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_page_ranges.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/split_pdf/tools/split_by_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitPDFToolsPage extends StatefulWidget {
  const SplitPDFToolsPage({Key? key, required this.arguments})
      : super(key: key);

  final SplitPDFToolsPageArguments arguments;

  @override
  State<SplitPDFToolsPage> createState() => _SplitPDFToolsPageState();
}

class _SplitPDFToolsPageState extends State<SplitPDFToolsPage> {
  late Future<bool> initPageCount;
  int? pdfPageCount;

  Future<bool> initPdfPageCount() async {
    pdfPageCount = await generatePdfPageCount(
        pdfUri: widget.arguments.file.fileUri, pdfPath: null);
    return true;
  }

  @override
  void initState() {
    initPageCount = initPdfPageCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(getAppBarTitleForActionType(
              actionType: widget.arguments.actionType)),
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
          future: initPageCount, // async work
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const ProcessingBody();
              default:
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else if (pdfPageCount == null) {
                  log(snapshot.error.toString());
                  return const ErrorBody();
                } else {
                  return SplitPDFToolsBody(
                      actionType: widget.arguments.actionType,
                      file: widget.arguments.file,
                      pdfPageCount: pdfPageCount!);
                }
            }
          },
        ),
      ),
    );
  }
}

class SplitPDFToolsPageArguments {
  final ToolsActions actionType;
  final InputFileModel file;

  SplitPDFToolsPageArguments({required this.actionType, required this.file});
}

class SplitPDFToolsBody extends StatelessWidget {
  const SplitPDFToolsBody(
      {Key? key,
      required this.actionType,
      required this.file,
      required this.pdfPageCount})
      : super(key: key);

  final ToolsActions actionType;
  final InputFileModel file;
  final int pdfPageCount;

  @override
  Widget build(BuildContext context) {
    if (actionType == ToolsActions.splitByPageCount) {
      return SplitByPageCount(pdfPageCount: pdfPageCount, file: file);
    } else if (actionType == ToolsActions.splitByByteSize) {
      return SplitBySize(pdfPageCount: pdfPageCount, file: file);
    } else if (actionType == ToolsActions.splitByPageNumbers) {
      return SplitByPageNumbers(pdfPageCount: pdfPageCount, file: file);
    } else if (actionType == ToolsActions.splitByPageRange) {
      return SplitByPageRange(pdfPageCount: pdfPageCount, file: file);
    } else if (actionType == ToolsActions.splitByPageRanges) {
      return SplitByPageRanges(pdfPageCount: pdfPageCount, file: file);
    } else {
      return Container();
    }
  }
}

String getAppBarTitleForActionType({required ToolsActions actionType}) {
  String title = "Action Successful";
  if (actionType == ToolsActions.splitByPageCount) {
    title = "Provide Page Count";
  } else if (actionType == ToolsActions.splitByByteSize) {
    title = "Provide Size";
  } else if (actionType == ToolsActions.splitByPageNumbers) {
    title = "Provide Page Numbers";
  } else if (actionType == ToolsActions.splitByPageRanges) {
    title = "Provide Page Ranges";
  } else if (actionType == ToolsActions.splitByPageRange) {
    title = "Provide Page Range";
  }
  return title;
}

class ErrorBody extends StatelessWidget {
  const ErrorBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Sorry, failed to process the pdf.",
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return TextButton(
                onPressed: () {
                  ref.read(toolsActionsStateProvider).cancelAction();
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProcessingBody extends StatelessWidget {
  const ProcessingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            'Getting pdf info please wait ...',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}

class AboutActionCard extends StatelessWidget {
  const AboutActionCard(
      {Key? key, required this.aboutText, this.exampleText = ""})
      : super(key: key);

  final String aboutText;
  final String exampleText;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info),
            const Divider(),
            Text(
              aboutText,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (exampleText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Example:-",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          exampleText,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
