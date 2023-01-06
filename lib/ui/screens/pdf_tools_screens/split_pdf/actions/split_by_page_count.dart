import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for splitting PDF by page count.
class SplitByPageCount extends StatelessWidget {
  /// Defining [SplitByPageCount] constructor.
  const SplitByPageCount({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String pdfPlural = appLocale.pdf(2);
    String example = appLocale.example;
    String splitWithPageIntervalInfoTitle =
        appLocale.tool_Split_WithPageInterval_InfoTitle(pdfSingular, pdfPlural);
    String splitWithPageIntervalInfoBody =
        appLocale.tool_Split_WithPageInterval_InfoBody(pdfSingular, pdfPlural);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        SplitByPageCountActionCard(pdfPageCount: pdfPageCount, file: file),
        const SizedBox(height: 16),
        AboutActionCard(
          aboutTitle: splitWithPageIntervalInfoTitle,
          aboutBodyTitle: '$example:-',
          aboutBody: splitWithPageIntervalInfoBody,
        ),
      ],
    );
  }
}

/// Card for page count for splitting configuration.
class SplitByPageCountActionCard extends StatefulWidget {
  /// Defining [SplitByPageCountActionCard] constructor.
  const SplitByPageCountActionCard({
    Key? key,
    required this.pdfPageCount,
    required this.file,
  }) : super(key: key);

  /// Takes PDF file total page number..
  final int pdfPageCount;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<SplitByPageCountActionCard> createState() =>
      _SplitByPageCountActionCardState();
}

class _SplitByPageCountActionCardState
    extends State<SplitByPageCountActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController pageCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String enterPageInterval = appLocale.textField_LabelText_EnterPageInterval;
    String enterNumberFrom0ToPageCountExcludingEnd =
        appLocale.textField_ErrorText_EnterNumberInRangeExcludingBegin(
      0,
      widget.pdfPageCount,
    );
    String extractSinglePageFileError =
        appLocale.tool_Split_ExtractSinglePageFileError(pdfSingular);
    String process = appLocale.button_Process;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.looks_3),
            const Divider(),
            Text(
              appLocale.noOfPagesInFile(appLocale.pdf(1), widget.pdfPageCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            widget.pdfPageCount > 1
                ? Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: pageCountController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: enterPageInterval,
                            // isDense: true,
                            helperText: '${appLocale.example}- '
                                '${widget.pdfPageCount ~/ 2}',
                            // enabledBorder: const UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // The validator receives the text that the user
                          // has entered.
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) > widget.pdfPageCount ||
                                int.parse(value) <= 0) {
                              return enterNumberFrom0ToPageCountExcludingEnd;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Divider(),
                      Consumer(
                        builder: (
                          BuildContext context,
                          WidgetRef ref,
                          Widget? child,
                        ) {
                          final ToolsActionsState
                              watchToolsActionsStateProviderValue =
                              ref.watch(toolsActionsStateProvider);
                          return FilledButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                watchToolsActionsStateProviderValue
                                    .mangeSplitPdfFileAction(
                                  toolAction: ToolAction.splitPdfByPageCount,
                                  sourceFile: widget.file,
                                  pageCount: int.parse(
                                    pageCountController.value.text,
                                  ),
                                );
                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.resultPage,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: Text(process),
                          );
                        },
                      ),
                    ],
                  )
                : Text(
                    extractSinglePageFileError,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
          ],
        ),
      ),
    );
  }
}
