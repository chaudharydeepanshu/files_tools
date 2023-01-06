import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/levitating_options_bar.dart';
import 'package:files_tools/ui/components/loading.dart';
import 'package:files_tools/ui/components/pdf_pages_gridview_components.dart';
import 'package:files_tools/ui/components/view_error.dart';
import 'package:files_tools/utils/decimal_text_input_formatter.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for converting PDF to image.
class ConvertToImage extends StatefulWidget {
  /// Defining [ConvertToImage] constructor.
  const ConvertToImage({Key? key, required this.pdfPages, required this.file})
      : super(key: key);

  /// Takes list of model of PDF pages.
  final List<PdfPageModel> pdfPages;

  /// Takes input file.
  final InputFileModel file;

  @override
  State<ConvertToImage> createState() => _ConvertToImageState();
}

class _ConvertToImageState extends State<ConvertToImage> {
  bool isPageProcessing = false;

  late List<PdfPageModel> pdfPages;

  void updatePdfPages({required int index}) async {
    if (pdfPages[index].pageBytes == null &&
        pdfPages[index].pageErrorStatus == false &&
        isPageProcessing == false) {
      isPageProcessing = true;
      PdfPageModel updatedPdfPage = await Utility.getUpdatedPdfPageModel(
        index: index,
        pdfPath: widget.file.fileUri,
        scale: 0.3,
        pdfPageModel: pdfPages[index],
      );
      if (mounted) {
        setState(() {
          pdfPages[index] = updatedPdfPage;
          isPageProcessing = false;
        });
      }
    }
  }

  double scrollSpeedVariable = 5;

  late List<int> removedPdfPagesIndexes = <int>[];

  bool? isSelectAllEnabled = true;

  TextEditingController pdfPagesQualityController =
      TextEditingController(text: '2');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pdfPages = widget.pdfPages;

    for (int i = 0; i < pdfPages.length; i++) {
      PdfPageModel temp = pdfPages[i];
      pdfPages[i] = PdfPageModel(
        pageIndex: temp.pageIndex,
        pageBytes: temp.pageBytes,
        pageErrorStatus: temp.pageErrorStatus,
        pageSelected: isSelectAllEnabled ?? temp.pageSelected,
        pageRotationAngle: temp.pageRotationAngle,
        pageHidden: temp.pageHidden,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String selectAllPages = appLocale.tool_Action_selectAllPages_ListTileTitle;
    String enterImageScaling = appLocale.textField_LabelText_EnterImageScaling;
    String enterImageScalingHlpText =
        appLocale.textField_HelperText_HigherScalingHigherQuality;
    String enterNumberFrom0To5Excluding0 =
        appLocale.textField_ErrorText_EnterNumberInRangeExcludingBegin(
      0,
      5,
    );
    String process = appLocale.button_Process;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 16.0,
            right: 16.0,
          ),
          child: CheckboxListTile(
            tristate: true,
            visualDensity: VisualDensity.compact,
            title: Text(selectAllPages),
            // subtitle: Text(appLocale.selectAllPagesTileSubTitle),
            value: isSelectAllEnabled,
            onChanged: (bool? value) {
              setState(() {
                isSelectAllEnabled = isSelectAllEnabled == null
                    ? true
                    : isSelectAllEnabled == true
                        ? isSelectAllEnabled == false
                        : true;
              });
              for (int i = 0; i < pdfPages.length; i++) {
                PdfPageModel temp = pdfPages[i];
                pdfPages[i] = PdfPageModel(
                  pageIndex: temp.pageIndex,
                  pageBytes: temp.pageBytes,
                  pageErrorStatus: temp.pageErrorStatus,
                  pageSelected: isSelectAllEnabled ?? temp.pageSelected,
                  pageRotationAngle: temp.pageRotationAngle,
                  pageHidden: temp.pageHidden,
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: pdfPagesQualityController,
              decoration: InputDecoration(
                filled: true,
                labelText: enterImageScaling,
                // isDense: true,
                helperText: enterImageScalingHlpText,
                // enabledBorder: const UnderlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                DecimalTextInputFormatter(decimalRange: 2),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // The validator receives the text that the user has entered.
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    double.parse(value) <= 0 ||
                    double.parse(value) > 5) {
                  return enterNumberFrom0To5Excluding0;
                }
                return null;
              },
            ),
          ),
        ),
        const Divider(indent: 16.0, endIndent: 16.0),
        Expanded(
          child: Stack(
            children: <Widget>[
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 150,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: pdfPages.length,
                itemBuilder: (BuildContext context, int index) {
                  updatePdfPages(index: index);
                  if (pdfPages[index].pageErrorStatus) {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: const ErrorIndicator(),
                    );
                  } else if (pdfPages[index].pageBytes != null) {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: PageImageView(
                        pdfPage: pdfPages[index],
                        pageIndex: index,
                        onUpdatePdfPage: (PdfPageModel value) {
                          setState(() {
                            pdfPages[index] = value;
                          });

                          if (pdfPages.every(
                            (PdfPageModel w) => w.pageSelected == true,
                          )) {
                            setState(() {
                              isSelectAllEnabled = true;
                            });
                          } else if (pdfPages.every(
                            (PdfPageModel w) => w.pageSelected == false,
                          )) {
                            setState(() {
                              isSelectAllEnabled = false;
                            });
                          } else {
                            setState(() {
                              isSelectAllEnabled = null;
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    return GridImageWidget(
                      key: Key('$index'),
                      child: const LoadingIndicator(),
                    );
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LevitatingOptionsBar(
                  optionsList: <Widget>[
                    Expanded(
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: pdfPages
                                .where(
                                  (PdfPageModel w) => w.pageSelected == true,
                                )
                                .isEmpty
                            ? null
                            : () {
                                setState(() {
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pdfPages[i] = PdfPageModel(
                                        pageIndex: temp.pageIndex,
                                        pageBytes: temp.pageBytes,
                                        pageErrorStatus: temp.pageErrorStatus,
                                        pageSelected: temp.pageSelected,
                                        pageRotationAngle:
                                            temp.pageRotationAngle - 90,
                                        pageHidden: temp.pageHidden,
                                      );
                                    }
                                  }
                                });
                              },
                        child: const SizedBox.expand(
                          child: Icon(Icons.rotate_left),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: pdfPages
                                .where(
                                  (PdfPageModel w) => w.pageSelected == true,
                                )
                                .isEmpty
                            ? null
                            : () {
                                setState(() {
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pdfPages[i] = PdfPageModel(
                                        pageIndex: temp.pageIndex,
                                        pageBytes: temp.pageBytes,
                                        pageErrorStatus: temp.pageErrorStatus,
                                        pageSelected: temp.pageSelected,
                                        pageRotationAngle:
                                            temp.pageRotationAngle + 90,
                                        pageHidden: temp.pageHidden,
                                      );
                                    }
                                  }
                                });
                              },
                        child: const SizedBox.expand(
                          child: Icon(Icons.rotate_right),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: pdfPages.every(
                                  (PdfPageModel w) => w.pageSelected == true,
                                ) ||
                                pdfPages.every(
                                  (PdfPageModel w) => w.pageSelected == false,
                                )
                            ? null
                            : () {
                                setState(() {
                                  List<int> pagesToRemoveWithPageIndex =
                                      <int>[];
                                  for (int i = 0; i < pdfPages.length; i++) {
                                    PdfPageModel temp = pdfPages[i];
                                    if (temp.pageSelected) {
                                      pagesToRemoveWithPageIndex
                                          .add(temp.pageIndex);
                                    }
                                  }
                                  pdfPages.removeWhere(
                                    (PdfPageModel element) =>
                                        pagesToRemoveWithPageIndex
                                            .contains(element.pageIndex),
                                  );
                                  removedPdfPagesIndexes
                                      .addAll(pagesToRemoveWithPageIndex);
                                });
                              },
                        child: SizedBox.expand(
                          child: Icon(
                            Icons.delete,
                            color: pdfPages.every(
                                      (PdfPageModel w) =>
                                          w.pageSelected == true,
                                    ) ||
                                    pdfPages.every(
                                      (PdfPageModel w) =>
                                          w.pageSelected == false,
                                    )
                                ? null
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      flex: 2,
                      child: Consumer(
                        builder: (
                          BuildContext context,
                          WidgetRef ref,
                          Widget? child,
                        ) {
                          final ToolsActionsState
                              watchToolsActionsStateProviderValue =
                              ref.watch(toolsActionsStateProvider);
                          List<PdfPageModel> selectedPages = pdfPages
                              .where(
                                (PdfPageModel element) =>
                                    element.pageSelected == true &&
                                    !removedPdfPagesIndexes
                                        .contains(element.pageIndex),
                              )
                              .toList();
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: pdfPages.every(
                              (PdfPageModel w) => w.pageSelected == false,
                            )
                                ? null
                                : () {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      watchToolsActionsStateProviderValue
                                          .mangeConvertPdfFileAction(
                                        toolAction:
                                            ToolAction.convertPdfToImage,
                                        sourceFile: widget.file,
                                        selectedPages: selectedPages,
                                        imageScaling: double.parse(
                                          pdfPagesQualityController.value.text,
                                        ),
                                      );

                                      Navigator.pushNamed(
                                        context,
                                        route.AppRoutes.resultPage,
                                      );
                                    }
                                  },
                            child: SizedBox.expand(
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(Icons.check),
                                    const SizedBox(width: 10),
                                    Text(process),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
