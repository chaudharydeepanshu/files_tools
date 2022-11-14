import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

class EncryptPDF extends StatelessWidget {
  const EncryptPDF({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        EncryptPDFActionCard(file: file),
      ],
    );
  }
}

class EncryptPDFActionCard extends StatefulWidget {
  const EncryptPDFActionCard({Key? key, required this.file}) : super(key: key);

  final InputFileModel file;

  @override
  State<EncryptPDFActionCard> createState() => _EncryptPDFActionCardState();
}

class _EncryptPDFActionCardState extends State<EncryptPDFActionCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController ownerPasswordController =
      TextEditingController(text: '');

  TextEditingController userPasswordController =
      TextEditingController(text: '');

  bool allowPrinting = false;
  bool allowModifyContents = false;
  bool allowCopy = false;
  bool allowModifyAnnotations = false;
  bool allowFillIn = false;
  bool allowScreenReaders = false;
  bool allowAssembly = false;
  bool allowDegradedPrinting = false;
  bool encryptEmbeddedFilesOnly = false;
  bool doNotEncryptMetadata = false;

  final List<bool> isSelectedForEncryptionTypes = <bool>[
    false,
    false,
    false,
    true
  ];

  List<Widget> encryptionTypes = const [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('Standard\nAES\n40', textAlign: TextAlign.center),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('Standard\nAES\n128', textAlign: TextAlign.center),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('AES\n128', textAlign: TextAlign.center),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('AES\n256', textAlign: TextAlign.center),
    )
  ];

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
                    controller: ownerPasswordController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter Owner Password',
                      isDense: true,
                      helperText: '',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          (allowPrinting == true ||
                              allowModifyContents == true ||
                              allowCopy == true ||
                              allowModifyAnnotations == true ||
                              allowFillIn == true ||
                              allowScreenReaders == true ||
                              allowAssembly == true ||
                              allowDegradedPrinting == true)) {
                        return 'Please enter owner Password for permissions.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: userPasswordController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Enter User Password',
                      isDense: true,
                      helperText: '',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          (ownerPasswordController.value.text.isEmpty)) {
                        return 'Please provide at least user or owner Password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Set Permissions :-',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Printing",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowPrinting,
                onChanged: (bool? value) {
                  setState(() {
                    allowPrinting = value ?? !allowPrinting;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Modifying Contents",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowModifyContents,
                onChanged: (bool? value) {
                  setState(() {
                    allowModifyContents = value ?? !allowModifyContents;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Copy",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowCopy,
                onChanged: (bool? value) {
                  setState(() {
                    allowCopy = value ?? !allowCopy;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Modifying Annotations",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowModifyAnnotations,
                onChanged: (bool? value) {
                  setState(() {
                    allowModifyAnnotations = value ?? !allowModifyAnnotations;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Fill In",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowFillIn,
                onChanged: (bool? value) {
                  setState(() {
                    allowFillIn = value ?? !allowFillIn;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Screen Readers",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowScreenReaders,
                onChanged: (bool? value) {
                  setState(() {
                    allowScreenReaders = value ?? !allowScreenReaders;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Assembly",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowAssembly,
                onChanged: (bool? value) {
                  setState(() {
                    allowAssembly = value ?? !allowAssembly;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Allow Degraded Printing",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: allowDegradedPrinting,
                onChanged: (bool? value) {
                  setState(() {
                    allowDegradedPrinting = value ?? !allowDegradedPrinting;
                  });
                }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Set Encryption :-',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 5),
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelectedForEncryptionTypes.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelectedForEncryptionTypes[buttonIndex] = true;
                    } else {
                      isSelectedForEncryptionTypes[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelectedForEncryptionTypes,
              children: encryptionTypes,
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Encrypt Embedded Files Only",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: encryptEmbeddedFilesOnly,
                onChanged: (bool? value) {
                  setState(() {
                    encryptEmbeddedFilesOnly =
                        value ?? !encryptEmbeddedFilesOnly;
                  });
                }),
            const SizedBox(height: 5),
            CheckboxListTile(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text("Do Not Encrypt Metadata",
                    style: Theme.of(context).textTheme.bodyMedium),
                value: doNotEncryptMetadata,
                onChanged: (bool? value) {
                  setState(() {
                    doNotEncryptMetadata = value ?? !doNotEncryptMetadata;
                  });
                }),
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
                              .encryptSelectedFile(
                            files: [widget.file],
                            ownerPassword: ownerPasswordController.value.text,
                            userPassword: userPasswordController.value.text,
                            allowPrinting: allowPrinting,
                            allowModifyContents: allowModifyContents,
                            allowCopy: allowCopy,
                            allowModifyAnnotations: allowModifyAnnotations,
                            allowFillIn: allowFillIn,
                            allowScreenReaders: allowScreenReaders,
                            allowAssembly: allowAssembly,
                            allowDegradedPrinting: allowDegradedPrinting,
                            standardEncryptionAES40:
                                isSelectedForEncryptionTypes[0],
                            standardEncryptionAES128:
                                isSelectedForEncryptionTypes[1],
                            encryptionAES128: isSelectedForEncryptionTypes[2],
                            encryptionAES256: isSelectedForEncryptionTypes[3],
                            encryptEmbeddedFilesOnly: encryptEmbeddedFilesOnly,
                            doNotEncryptMetadata: doNotEncryptMetadata,
                          );
                          Navigator.pushNamed(
                            context,
                            route.resultPage,
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Encrypt PDF"),
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
