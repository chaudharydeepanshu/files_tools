import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class DecryptPDF extends StatelessWidget {
  const DecryptPDF({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        DecryptPDFActionCard(file: file),
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
  final _formKey = GlobalKey<FormState>();

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
                    validator: (value) {
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
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          watchToolsActionsStateProviderValue
                              .decryptSelectedFile(
                            files: [widget.file],
                            password: passwordController.value.text,
                          );
                          Navigator.pushNamed(
                            context,
                            route.resultPage,
                          );
                        }
                      },
                      child: const Text("Decrypt PDF"),
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
