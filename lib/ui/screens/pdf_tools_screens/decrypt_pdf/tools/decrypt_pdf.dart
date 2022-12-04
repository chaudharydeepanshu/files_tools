import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DecryptPDF extends StatelessWidget {
  const DecryptPDF({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        DecryptPDFActionCard(file: file),
        const SizedBox(height: 16),
        const AboutActionCard(
          aboutText: 'This function removes encryption from a pdf.',
          aboutTextBody:
              'If a have PDF has owner/permission password set but not user/open password set then you leave the input blank and proceed as it can remove the owner/permission password without password.\n\nBut if the PDF has a user password set then you must provide the user password to decrypt it.\n\nA owner/permission password is generally used to restrict printing, editing, and copying content in the PDF. And it requires a user to type a password to change those permission settings.\n\nA user/open password requires a user to type a password to open the PDF.',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class DecryptPDFActionCard extends StatefulWidget {
  const DecryptPDFActionCard({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

  @override
  State<DecryptPDFActionCard> createState() => _DecryptPDFActionCardState();
}

class _DecryptPDFActionCardState extends State<DecryptPDFActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController(text: '');

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
            const Icon(Icons.looks_3),
            const Divider(),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Owner/User Password',
                      isDense: true,
                      helperText: 'Leave blank if only owner password is set',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (String? value) {
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
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
                      label: const Text('Decrypt PDF'),
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
