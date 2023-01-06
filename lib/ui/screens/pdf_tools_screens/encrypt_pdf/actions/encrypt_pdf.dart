import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tools_about_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Action screen for encrypting PDF.
class EncryptPDF extends StatelessWidget {
  /// Defining [EncryptPDF] constructor.
  const EncryptPDF({Key? key, required this.file}) : super(key: key);

  /// Takes input file.
  final InputFileModel file;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String pdfSingular = appLocale.pdf(1);
    String aboutEncryptTitle = appLocale.tool_Encrypt_InfoTitle(pdfSingular);
    String aboutEncryptPDFBody =
        appLocale.tool_EncryptPDF_InfoBody(pdfSingular);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: <Widget>[
        EncryptPDFActionCard(file: file),
        const SizedBox(height: 16),
        AboutActionCard(
          aboutTitle: aboutEncryptTitle,
          aboutBody: aboutEncryptPDFBody,
        ),
      ],
    );
  }
}

/// Card for encryption configuration.
class EncryptPDFActionCard extends StatefulWidget {
  /// Defining [EncryptPDFActionCard] constructor.
  const EncryptPDFActionCard({Key? key, required this.file}) : super(key: key);

  /// Takes input file.
  final InputFileModel file;

  @override
  State<EncryptPDFActionCard> createState() => _EncryptPDFActionCardState();
}

class _EncryptPDFActionCardState extends State<EncryptPDFActionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController ownerPasswordController =
      TextEditingController(text: '');

  TextEditingController userPasswordController =
      TextEditingController(text: '');

  bool allowPrintingStatus = false;
  bool allowModifyContentsStatus = false;
  bool allowCopyStatus = false;
  bool allowModifyAnnotationsStatus = false;
  bool allowFillInStatus = false;
  bool allowScreenReadersStatus = false;
  bool allowAssemblyStatus = false;
  bool allowDegradedPrintingStatus = false;
  bool encryptEmbeddedFilesOnlyStatus = false;
  bool doNotEncryptMetadataStatus = false;

  final List<bool> isSelectedForEncryptionTypes = <bool>[
    false,
    false,
    false,
    true
  ];

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String enterOwnerPw = appLocale.textField_LabelText_EnterOwnerPw;
    String enterOwnerPwErrText =
        appLocale.textField_ErrorText_EnterOwnerPwIfUserPwEmpty;
    String enterUserPw = appLocale.textField_LabelText_EnterUserPw;
    String enterUserPwErrText =
        appLocale.textField_ErrorText_EnterOwnerPwIfUserPwEmpty;
    String encryptTypeStandardAES40 =
        appLocale.tool_Encrypt_encryptionType_StandardAES40;
    String encryptTypeStandardAES128 =
        appLocale.tool_Encrypt_encryptionType_StandardAES128;
    String encryptTypeAES128 = appLocale.tool_Encrypt_encryptionType_AES128;
    String encryptTypeAES256 = appLocale.tool_Encrypt_encryptionType_AES256;
    String setEncryptionPermissions =
        appLocale.tool_Encrypt_SetEncryptionPermissions;
    String allowPrinting = appLocale.tool_Encrypt_Permission_AllowPrinting;
    String allowModifyingContents =
        appLocale.tool_Encrypt_Permission_AllowModifyingContents;
    String allowCopy = appLocale.tool_Encrypt_Permission_AllowCopy;
    String allowModifyingAnnotations =
        appLocale.tool_Encrypt_Permission_AllowModifyingAnnotations;
    String allowFillIn = appLocale.tool_Encrypt_Permission_AllowFillIn;
    String allowScreenReaders =
        appLocale.tool_Encrypt_Permission_AllowScreenReaders;
    String allowAssembly = appLocale.tool_Encrypt_Permission_AllowAssembly;
    String allowDegradedPrinting =
        appLocale.tool_Encrypt_Permission_AllowDegradedPrinting;
    String setEncryptionType = appLocale.tool_Encrypt_SetEncryptionType;
    String encryptEmbeddedFilesOnly =
        appLocale.tool_Encrypt_Setting_EncryptEmbeddedFilesOnly;
    String doNotEncryptMetadata =
        appLocale.tool_Encrypt_Setting_DoNotEncryptMetadata;
    String process = appLocale.button_Process;

    List<Widget> encryptionTypes = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          encryptTypeStandardAES40,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          encryptTypeStandardAES128,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          encryptTypeAES128,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          encryptTypeAES256,
          textAlign: TextAlign.center,
        ),
      ),
    ];

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
                    controller: ownerPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterOwnerPw,
                      isDense: true,
                      helperText: '',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      if ((value == null || value.isEmpty) &&
                          (allowPrintingStatus == true ||
                              allowModifyContentsStatus == true ||
                              allowCopyStatus == true ||
                              allowModifyAnnotationsStatus == true ||
                              allowFillInStatus == true ||
                              allowScreenReadersStatus == true ||
                              allowAssemblyStatus == true ||
                              allowDegradedPrintingStatus == true)) {
                        return enterOwnerPwErrText;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: enterUserPw,
                      isDense: true,
                      helperText: '',
                      // enabledBorder: const UnderlineInputBorder(),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // The validator receives the text that the user
                    // has entered.
                    validator: (String? value) {
                      if ((value == null || value.isEmpty) &&
                          (ownerPasswordController.value.text.isEmpty)) {
                        return enterUserPwErrText;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text(
                  '$setEncryptionPermissions :-',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowPrinting,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowPrintingStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowPrintingStatus = value ?? !allowPrintingStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowModifyingContents,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowModifyContentsStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowModifyContentsStatus =
                      value ?? !allowModifyContentsStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowCopy,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowCopyStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowCopyStatus = value ?? !allowCopyStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowModifyingAnnotations,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowModifyAnnotationsStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowModifyAnnotationsStatus =
                      value ?? !allowModifyAnnotationsStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowFillIn,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowFillInStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowFillInStatus = value ?? !allowFillInStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowScreenReaders,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowScreenReadersStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowScreenReadersStatus = value ?? !allowScreenReadersStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowAssembly,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowAssemblyStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowAssemblyStatus = value ?? !allowAssemblyStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                allowDegradedPrinting,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: allowDegradedPrintingStatus,
              onChanged: (bool? value) {
                setState(() {
                  allowDegradedPrintingStatus =
                      value ?? !allowDegradedPrintingStatus;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text(
                  '$setEncryptionType :-',
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
              visualDensity: VisualDensity.compact,
              title: Text(
                encryptEmbeddedFilesOnly,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: encryptEmbeddedFilesOnlyStatus,
              onChanged: (bool? value) {
                setState(() {
                  encryptEmbeddedFilesOnlyStatus =
                      value ?? !encryptEmbeddedFilesOnlyStatus;
                });
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                doNotEncryptMetadata,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: doNotEncryptMetadataStatus,
              onChanged: (bool? value) {
                setState(() {
                  doNotEncryptMetadataStatus =
                      value ?? !doNotEncryptMetadataStatus;
                });
              },
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
                              .mangeEncryptPdfFileAction(
                            sourceFile: widget.file,
                            ownerPassword: ownerPasswordController.value.text,
                            userPassword: userPasswordController.value.text,
                            allowPrinting: allowPrintingStatus,
                            allowModifyContents: allowModifyContentsStatus,
                            allowCopy: allowCopyStatus,
                            allowModifyAnnotations:
                                allowModifyAnnotationsStatus,
                            allowFillIn: allowFillInStatus,
                            allowScreenReaders: allowScreenReadersStatus,
                            allowAssembly: allowAssemblyStatus,
                            allowDegradedPrinting: allowDegradedPrintingStatus,
                            standardEncryptionAES40:
                                isSelectedForEncryptionTypes[0],
                            standardEncryptionAES128:
                                isSelectedForEncryptionTypes[1],
                            encryptionAES128: isSelectedForEncryptionTypes[2],
                            encryptionAES256: isSelectedForEncryptionTypes[3],
                            encryptEmbeddedFilesOnly:
                                encryptEmbeddedFilesOnlyStatus,
                            doNotEncryptMetadata: doNotEncryptMetadataStatus,
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
