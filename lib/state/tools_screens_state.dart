import 'dart:developer';

import 'package:files_tools/main.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:files_tools/utils/pdf_tools_actions.dart';
import 'package:files_tools/utils/pick_save.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pick_or_save/pick_or_save.dart';

/// App tools screens state class.
class ToolsScreensState extends ChangeNotifier {
  /// Provides tools screen picked / input files.
  List<InputFileModel> get inputFiles => _inputFiles;
  List<InputFileModel> _inputFiles = <InputFileModel>[];

  /// Provides tools screen file picking processing status.
  bool get isFilePickProcessing => _isFilePickProcessing;
  bool _isFilePickProcessing = false;

  /// Provides tools screen file picking error status.
  bool get filePickErrorStatus => _filePickErrorStatus;
  bool _filePickErrorStatus = false;

  /// Provides ToolsScreensState provider mounted status.
  bool get mounted => _mounted;
  bool _mounted = true;

  @override
  void dispose() {
    super.dispose();
    // Setting ToolsScreensState provider mounted status false on disposing
    // provider.
    _mounted = false;
  }

  /// Called to pick input files.
  Future<void> mangePickFileAction({
    required final FilePickModel filePickModel,
  }) async {
    if (!filePickModel.continuePicking) {
      // Clearing any leftover input files.
      _inputFiles.clear();
    }
    // Updating file pick error status to false.
    updateFilePickErrorStatus(false);
    // Updating save processing status to true.
    updateFilePickProcessingStatus(true);

    List<String>? pickResult;

    // Preparing file picking params.
    FilePickerParams params = FilePickerParams(
      allowedExtensions: filePickModel.allowedExtensions,
      mimeTypesFilter: filePickModel.mimeTypesFilter,
      localOnly: filePickModel.localOnly,
      getCachedFilePath: filePickModel.getCachedFilePath,
      pickerType: filePickModel.pickerType,
      enableMultipleSelection: filePickModel.enableMultipleSelection,
    );

    // TODO(chaudharydeepanshu): Provide user option to report pick error.
    try {
      // Picking files and storing result paths in pickResult.
      pickResult = await PickSave.pickFile(
        params: params,
      );
    } on PlatformException catch (e, s) {
      log(e.toString());
      log(s.toString());
      _filePickErrorStatus = true;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      _filePickErrorStatus = true;
    } finally {
      if (pickResult == null) {
        // Means pick cancelled not an error.
      } else if (pickResult.isNotEmpty) {
        // Means some files were picked.
        // If pickResult not empty generating input files.
        for (int i = 0; i < pickResult.length; i++) {
          InputFileModel file = await Utility.getInputFileModelFromUri(
            filePathOrUri: pickResult[i],
          );
          _inputFiles.add(file);
        }
        // Now processing picked files based on other provided parameters.
        List<InputFileModel> discardedFiles = await getFilteredPickedFiles(
          filePickModel: filePickModel,
          pickedInputFiles: inputFiles,
        );
        _inputFiles = _inputFiles
            .where((final InputFileModel e) => !discardedFiles.contains(e))
            .toList();

        showDiscardedFilesSnackBar(discardedFiles: discardedFiles);
      }

      // Updating action processing status to false.
      updateFilePickProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// Called for updating selected files.
  void updateSelectedFiles({required final List<InputFileModel> files}) {
    _inputFiles = files;
    customNotifyListener();
  }

  /// Called to update an file pick error status.
  void updateFilePickErrorStatus(final bool status) {
    _filePickErrorStatus = status;
    customNotifyListener();
  }

  /// Called for initiating file picking.
  void updateFilePickProcessingStatus(final bool status) {
    _isFilePickProcessing = status;
    notifyListeners();
  }

  /// Called to notify ToolsActionsState listeners.
  void customNotifyListener() {
    // Due to cancelling a running action the state gets disposed but
    // cancellation action or any other action may still be running and can
    // call [customNotifyListener] once they finish which will lead to getting
    // error of using disposed state. So, checking state before
    // calling notifyListeners.
    if (_mounted) {
      notifyListeners();
    }
  }
}

/// For filtering picked files based on various parameters.
Future<List<InputFileModel>> getFilteredPickedFiles({
  required final FilePickModel filePickModel,
  required final List<InputFileModel> pickedInputFiles,
}) async {
  // Holds input files to be discarded.
  List<InputFileModel> discardedInputFiles = <InputFileModel>[];

  for (int i = 0; i < pickedInputFiles.length; i++) {
    String extensionOfFile =
        Utility.getFileNameExtension(fileName: pickedInputFiles[i].fileName);

    if ((filePickModel.discardInvalidPdfFiles ||
            filePickModel.discardProtectedPdfFiles) &&
        extensionOfFile == '.pdf') {
      // Means discarding was chosen and file is also PDF.
      PdfValidityAndProtection? pdfInfo = await PdfToolsActions.pdfInfo(
        sourceFile: pickedInputFiles[i],
      );
      if (pdfInfo == null) {
        // If pdfInfo is null then it's a high probability that this PDF file
        // is a trouble and should be discarded as invalid.
        discardedInputFiles.add(pickedInputFiles[i]);
      } else {
        if (pdfInfo.isPDFValid == false &&
            filePickModel.discardInvalidPdfFiles) {
          // If true then PDF file is invalid and should be discarded.
          discardedInputFiles.add(pickedInputFiles[i]);
        }
        if (pdfInfo.isOpenPasswordProtected == true &&
            filePickModel.discardProtectedPdfFiles) {
          // If true then PDF file is protected and should be discarded.
          discardedInputFiles.add(pickedInputFiles[i]);
        }
      }
    } else {
      // Not doing anything as either no discarding for PDF was chosen or
      // the file is not a PDF so it should not be checked or discarded.
    }
  }
  return discardedInputFiles;
}

/// Called to show snackBar displaying discarded files.
void showDiscardedFilesSnackBar({
  required final List<InputFileModel> discardedFiles,
}) {
  BuildContext? context = navigatorKey.currentState?.context;
  if (context != null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (discardedFiles.isNotEmpty) {
      // Only show snackBar if discardedFiles is not empty.
      List<String> discardedFilesNames = List<String>.generate(
        discardedFiles.length,
        (final int index) => discardedFiles[index].fileName,
      );
      String? contentText = "Discarded invalid or encrypted pdf files:\n"
          "${discardedFilesNames.join("\n")}";
      //'Oh...No! There is no old data available.';
      Color? backgroundColor = Theme.of(context).colorScheme.errorContainer;
      Duration? duration = const Duration(seconds: 20);
      IconData? iconData = Icons.warning;
      Color? iconAndTextColor = Theme.of(context).colorScheme.error;
      TextStyle? textStyle = Theme.of(context).textTheme.bodySmall;

      showCustomSnackBar(
        context: context,
        contentText: contentText,
        backgroundColor: backgroundColor,
        duration: duration,
        iconData: iconData,
        iconAndTextColor: iconAndTextColor,
        textStyle: textStyle,
      );
    }
  }
}
