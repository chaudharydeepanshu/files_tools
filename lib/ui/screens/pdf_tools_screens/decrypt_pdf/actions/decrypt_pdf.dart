import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for decrypting PDF.
class DecryptPDF extends StatelessWidget {
  /// Defining [DecryptPDF] constructor.
  const DecryptPDF({Key? key, required this.file}) : super(key: key);

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String aboutDecryptTitle = appLocale.tool_Decrypt_InfoTitle(pdfSingular);
    String aboutDecryptPDFBody =
        appLocale.tool_DecryptPDF_InfoBody(pdfSingular);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        DecryptPDFActionCard(file: file),
        const SizedBox(height: 16),
        AboutActionCard(
          aboutTitle: aboutDecryptTitle,
          aboutBody: aboutDecryptPDFBody,
        ),
      ],
    );
  }
}

/// Card for decryption configuration.
class DecryptPDFActionCard extends StatefulWidget {
  /// Defining [DecryptPDFActionCard] constructor.
  const DecryptPDFActionCard({Key? key, required this.file}) : super(key: key);

  /// Takes input file.
  final InputFileModel file;

  @override
  State<DecryptPDFActionCard> createState() => _DecryptPDFActionCardState();
}

class _DecryptPDFActionCardState extends State<DecryptPDFActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String enterOwnerOrUserPw =
        appLocale.textField_LabelText_EnterOwnerOrUserPw;
    String enterOwnerOrUserPwHlpText =
        appLocale.textField_HelperText_LeaveFldEmptyIfNoOwnerPwSet;
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterOwnerOrUserPw,
                      isDense: true,
                      helperText: enterOwnerOrUserPwHlpText,
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: <Widget>[
                const Divider(),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final ToolsActionsState
                        watchToolsActionsStateProviderValue =
                        ref.watch(toolsActionsStateProvider);
                    return FilledButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .mangeDecryptPdfFileAction(
                            sourceFile: widget.file,
                            password: passwordController.value.text,
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
            ),
          ],
        ),
      ),
    );
  }
}
