import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/models/pdf_page_model.dart';
import 'package:files_tools/utils/image_tools_actions.dart';
import 'package:files_tools/utils/pdf_tools_actions.dart';
import 'package:files_tools/utils/pick_save.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:pick_or_save/pick_or_save.dart';

/// All types of tools action.
enum ToolAction {
  /// Merge PDF tool action type for merging multiple PDFs.
  mergePdfs,

  /// Split PDF tool action type for splitting PDF by page count.
  splitPdfByPageCount,

  /// Split PDF tool action type for splitting PDF by size(KB, MB, GB).
  splitPdfByByteSize,

  /// Split PDF tool action type for splitting PDF by page numbers.
  splitPdfByPageNumbers,

  /// Split PDF tool action type for splitting PDF by page ranges.
  splitPdfByPageRanges,

  /// Split PDF tool action type for splitting PDF by page range.
  extractPdfByPageRange,

  /// Split PDF tool action type for extracting chosen pages from a PDF.
  extractPdfByPageSelection,

  /// Modify PDF tool action type for rotating, deleting & reordering PDF pages.
  modifyPdf,

  /// Convert PDF tool action type for converting PDF to images.
  convertPdfToImage,

  /// Compress PDF tool action type for compressing PDF.
  compressPdf,

  /// Watermark PDF tool action type for watermarking PDF.
  watermarkPdf,

  /// Encrypt PDF tool action type for encrypting PDF.
  encryptPdf,

  /// Decrypt PDF tool action type for decrypting PDF.
  decryptPdf,

  /// Compress image tool action type for compressing image.
  compressImages,

  /// Image tool action type for rotating, deleting & reordering PDF pages.
  cropRotateFlipImages,

  /// PDF & Image tool action type for converting images to PDF.
  imageToPdf,
}

/// App tools actions screens state class.
class ToolsActionsState extends ChangeNotifier {
  List<OutputFileModel> _outputFiles = <OutputFileModel>[];

  /// Provides tools actions result files.
  List<OutputFileModel> get outputFiles => _outputFiles;

  bool _actionErrorStatus = false;

  /// Provides tools actions error status.
  bool get actionErrorStatus => _actionErrorStatus;

  String _errorMessage = 'Unknown error';

  /// Provides tools actions error message.
  String get errorMessage => _errorMessage;

  StackTrace _errorStackTrace = StackTrace.current;

  /// Provides tools actions error StackTrace.
  StackTrace get errorStackTrace => _errorStackTrace;

  bool _isActionProcessing = false;

  /// Provides tools actions processing status.
  bool get isActionProcessing => _isActionProcessing;

  bool _isSaveProcessing = false;

  /// Provides tools actions result save processing status.
  bool get isSaveProcessing => _isSaveProcessing;

  bool _fileSaveErrorStatus = false;

  /// Provides tools actions result save error status.
  bool get saveErrorStatus => _fileSaveErrorStatus;

  late ToolAction _currentActionType;

  /// Provides tools actions current action type.
  ToolAction get currentActionType => _currentActionType;

  bool _mounted = true;

  /// Provides ToolsActionsState provider mounted status.
  bool get mounted => _mounted;

  @override
  void dispose() {
    super.dispose();
    // Setting ToolsActionsState provider mounted status false on disposing
    // provider.
    _mounted = false;
  }

  /// [ToolAction.mergePdfs] action for merging multiple PDFs.
  Future<void> mangeMergePdfFileAction({
    required List<InputFileModel> sourceFiles,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.mergePdfs);

    try {
      // Merging the PDFs and storing result in output files.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.mergePdfFiles(sourceFiles: sourceFiles),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// For splitting PDF.
  ///
  /// For split tool actions: [ToolAction.splitPdfByByteSize],
  /// [ToolAction.splitPdfByPageCount], [ToolAction.splitPdfByPageNumbers],
  /// [ToolAction.extractPdfByPageRange], [ToolAction.splitPdfByPageRanges]
  Future<void> mangeSplitPdfFileAction({
    required ToolAction toolAction,
    required InputFileModel sourceFile,
    int? pageCount,
    int? byteSize,
    List<int>? pageNumbers,
    List<String>? pageRanges,
    String? pageRange,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(toolAction);

    try {
      // Splitting the PDF based on action type and then storing result PDF
      // files paths in resultFilesPaths.
      if (toolAction == ToolAction.splitPdfByPageCount) {
        // If ToolAction.splitPdfByPageCount then use pageCount.
        if (pageCount != null) {
          _outputFiles = await PdfToolsActions.splitPdfFile(
            sourceFile: sourceFile,
            pageCount: pageCount,
          );
        } else {
          throw 'PageCount is null for ToolAction.splitPdfByPageCount';
        }
      } else if (toolAction == ToolAction.splitPdfByByteSize) {
        // If ToolAction.splitPdfByByteSize then use byteSize.
        if (byteSize != null) {
          _outputFiles = await PdfToolsActions.splitPdfFile(
            sourceFile: sourceFile,
            byteSize: byteSize,
          );
        } else {
          throw 'ByteSize is null for ToolAction.splitPdfByByteSize';
        }
      } else if (toolAction == ToolAction.splitPdfByPageNumbers) {
        // If ToolAction.splitPdfByPageNumbers then use pageNumbers.
        if (pageNumbers != null) {
          _outputFiles = await PdfToolsActions.splitPdfFile(
            sourceFile: sourceFile,
            pageNumbers: pageNumbers,
          );
        } else {
          throw 'PageNumbers is null for ToolAction.splitPdfByPageNumbers';
        }
      } else if (toolAction == ToolAction.extractPdfByPageRange) {
        // If ToolAction.extractPdfByPageRange then use pageRange.
        if (pageRange != null) {
          _outputFiles = await PdfToolsActions.splitPdfFile(
            sourceFile: sourceFile,
            pageRange: pageRange,
          );
        } else {
          throw 'PageRange is null for ToolAction.extractPdfByPageRange';
        }
      } else if (toolAction == ToolAction.splitPdfByPageRanges) {
        // If ToolAction.splitPdfByPageRanges then use pageRanges.
        if (pageRanges != null) {
          _outputFiles = await PdfToolsActions.splitPdfFile(
            sourceFile: sourceFile,
            pageRanges: pageRanges,
          );
        } else {
          throw 'PageRanges is null for ToolAction.splitPdfByPageRanges';
        }
      } else {
        throw 'No splitting set for ToolAction: $toolAction';
      }
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// For modifying PDF.
  ///
  /// For tools actions:
  /// [ToolAction.modifyPdf] for rotating, deleting & reordering PDF pages.
  /// [ToolAction.extractPdfByPageSelection] for extracting chosen PDF pages.
  Future<void> mangeModifyPdfFileAction({
    required ToolAction toolAction,
    required InputFileModel sourceFile,
    List<PageRotationInfo>? pagesRotationInfo,
    List<int>? pageNumbersForReorder,
    List<int>? pageNumbersForDeleter,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(toolAction);

    try {
      // Modifying the PDF and storing result PDF file path in outputFiles.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.modifyPdfFile(
          sourceFile: sourceFile,
          pagesRotationInfo: pagesRotationInfo,
          pageNumbersForReorder: pageNumbersForReorder,
          pageNumbersForDeleter: pageNumbersForDeleter,
        ),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// For converting PDF.
  ///
  /// For tools actions:
  /// [ToolAction.convertPdfToImage] for converting PDF pages to images.
  Future<void> mangeConvertPdfFileAction({
    required ToolAction toolAction,
    required InputFileModel sourceFile,
    required List<PdfPageModel> selectedPages,
    double? imageScaling,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(toolAction);

    try {
      // Converting the PDF based on action type and then storing result
      // files paths in resultFilesPaths.
      if (toolAction == ToolAction.convertPdfToImage) {
        // If ToolAction.convertPdfToImage then use imageScaling.
        if (imageScaling != null) {
          _outputFiles = await PdfToolsActions.convertPdfFilePagesToImages(
            sourceFile: sourceFile,
            selectedPages: selectedPages,
            imageScaling: imageScaling,
          );
        } else {
          throw 'ImageScaling is null for ToolAction.convertPdfToImage';
        }
      } else {
        throw 'No converting set for ToolAction: $toolAction';
      }
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.compressPdf] action for compressing PDF.
  Future<void> mangeCompressPdfFileAction({
    required InputFileModel sourceFile,
    double? imageScale,
    int? imageQuality,
    bool? unEmbedFonts,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.compressPdf);

    try {
      // Compressing the PDF and storing result PDF file path in outputFiles.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.compressPdfFile(
          sourceFile: sourceFile,
          imageScale: imageScale ?? 1,
          imageQuality: imageQuality ?? 100,
          unEmbedFonts: unEmbedFonts ?? false,
        ),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.watermarkPdf] action for watermarking PDF.
  Future<void> mangeWatermarkPdfFileAction({
    required InputFileModel sourceFile,
    required String text,
    double? fontSize,
    WatermarkLayer? watermarkLayer,
    double? opacity,
    double? rotationAngle,
    Color? watermarkColor,
    PositionType? positionType,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.watermarkPdf);

    try {
      // Watermark the PDF and storing result PDF file path in outputFiles.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.watermarkPdfFile(
          sourceFile: sourceFile,
          text: text,
          fontSize: fontSize ?? 30,
          watermarkLayer: watermarkLayer ?? WatermarkLayer.overContent,
          opacity: opacity ?? 0.5,
          rotationAngle: rotationAngle ?? 45,
          watermarkColor: watermarkColor ?? Colors.black,
          positionType: positionType ?? PositionType.center,
        ),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.encryptPdf] action for encrypting PDF.
  Future<void> mangeEncryptPdfFileAction({
    required InputFileModel sourceFile,
    String? ownerPassword,
    String? userPassword,
    bool? allowPrinting,
    bool? allowModifyContents,
    bool? allowCopy,
    bool? allowModifyAnnotations,
    bool? allowFillIn,
    bool? allowScreenReaders,
    bool? allowAssembly,
    bool? allowDegradedPrinting,
    bool? standardEncryptionAES40,
    bool? standardEncryptionAES128,
    bool? encryptionAES128,
    bool? encryptionAES256,
    bool? encryptEmbeddedFilesOnly,
    bool? doNotEncryptMetadata,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.encryptPdf);

    try {
      // Encrypting the PDF and storing result PDF file path in outputFiles.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.encryptPdfFile(
          sourceFile: sourceFile,
          ownerPassword: ownerPassword ?? '',
          userPassword: userPassword ?? '',
          allowPrinting: allowPrinting ?? false,
          allowModifyContents: allowModifyContents ?? false,
          allowCopy: allowCopy ?? false,
          allowModifyAnnotations: allowModifyAnnotations ?? false,
          allowFillIn: allowFillIn ?? false,
          allowScreenReaders: allowScreenReaders ?? false,
          allowAssembly: allowAssembly ?? false,
          allowDegradedPrinting: allowDegradedPrinting ?? false,
          standardEncryptionAES40: standardEncryptionAES40 ?? false,
          standardEncryptionAES128: standardEncryptionAES128 ?? false,
          encryptionAES128: encryptionAES128 ?? false,
          encryptionAES256: encryptionAES256 ?? false,
          encryptEmbeddedFilesOnly: encryptEmbeddedFilesOnly ?? false,
          doNotEncryptMetadata: doNotEncryptMetadata ?? false,
        ),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.decryptPdf] action for decrypting PDF.
  Future<void> mangeDecryptPdfFileAction({
    required InputFileModel sourceFile,
    String? password,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.decryptPdf);

    try {
      // Decrypting the PDF and storing result PDF file path in outputFiles.
      _outputFiles = <OutputFileModel>[
        await PdfToolsActions.decryptPdfFile(
          sourceFile: sourceFile,
          password: password ?? '',
        ),
      ];
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// For converting Image.
  ///
  /// For tools actions:
  /// [ToolAction.imageToPdf] for converting images to PDFs.
  Future<void> mangeConvertImageFileAction({
    required ToolAction toolAction,
    required List<InputFileModel> sourceFiles,
    required bool createSinglePdf,
    required List<GlobalKey<ExtendedImageEditorState>> editorKeys,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(toolAction);

    try {
      // Updating the source images based on editorKeys.
      List<OutputFileModel> modifiedOutputFiles =
          await ImageToolsActions.modifyImageFiles(
        sourceFiles: sourceFiles,
        editorKeys: editorKeys,
      );

      // Now converting modifiedOutputFiles OutputFileModel to InputFileModel
      // and then resetting the name of updated source files back to to the
      // original source files names and then storing in updatedSourceImages.
      List<InputFileModel> updatedSourceFiles = modifiedOutputFiles
          .mapIndexed(
            (int index, OutputFileModel element) => InputFileModel(
              fileName: sourceFiles[index].fileName,
              fileDate: element.fileDate,
              fileTime: element.fileTime,
              fileSizeFormatBytes: element.fileSizeFormatBytes,
              fileSizeBytes: element.fileSizeBytes,
              fileUri: element.filePath,
            ),
          )
          .toList();

      // Converting the updated images based on action type and then
      // storing result Image file path in outputFiles.
      if (toolAction == ToolAction.imageToPdf) {
        _outputFiles = await ImageToolsActions.convertImageFilesToPdfs(
          sourceFiles: updatedSourceFiles,
          createSinglePdf: createSinglePdf,
        );
      } else {
        throw 'No image converting set for ToolAction: $toolAction';
      }
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.compressImages] action for compressing images.
  Future<void> mangeCompressImageFileAction({
    required List<InputFileModel> sourceFiles,
    double? imageScale,
    int? imageQuality,
    bool? removeExifData,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.compressImages);

    try {
      // Compressing images and storing result image file path in outputFiles.
      _outputFiles = await ImageToolsActions.compressImageFiles(
        sourceFiles: sourceFiles,
        imageScale: imageScale,
        imageQuality: imageQuality,
        removeExifData: removeExifData,
      );
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// [ToolAction.cropRotateFlipImages] action for rotating, cropping and
  /// flipping images.
  Future<void> mangeModifyImageFileAction({
    required List<InputFileModel> sourceFiles,
    required List<GlobalKey<ExtendedImageEditorState>> editorKeys,
  }) async {
    // Clearing any leftover output files.
    _outputFiles.clear();
    // Updating action error status to false.
    updateActionErrorStatus(false);
    // Updating action processing status to true.
    updateActionProcessingStatus(true);
    // Updating action type to current action.
    updateActionType(ToolAction.cropRotateFlipImages);

    try {
      // Modifying images and storing result image file path in outputFiles.
      _outputFiles = await ImageToolsActions.modifyImageFiles(
        sourceFiles: sourceFiles,
        editorKeys: editorKeys,
      );
    } on PlatformException catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      updateActionErrorStatus(true);
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } finally {
      // Updating action processing status to false.
      updateActionProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// Called to cancel any running action.
  ///
  /// It was specifically designed to free resources from cancelled heavy tasks
  /// such as merging, splitting, etc of PDFs. So for now it will not quickly
  /// free resources of other kind of light tasks and will let them
  /// continue in the background till they complete.
  /// Also, all cancelled tasks result is rejected even if we already
  /// have the result.
  ///
  /// It will make the app reusable for using any new tool immediately.
  void cancelAction() {
    Utility.clearCache(clearCacheCommandFrom: 'Cancel Running Action');
    updateActionProcessingStatus(true);
    try {
      PdfManipulator().cancelManipulations();
    } on PlatformException catch (e, s) {
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    }
    updateActionProcessingStatus(false);
    customNotifyListener();
  }

  /// Called to save output files.
  Future<void> mangeSaveFileAction({
    required FileSaveModel fileSaveModel,
  }) async {
    // Updating save error status to false.
    updateFileSaveErrorStatus(false);
    // Updating save processing status to true.
    updateFileSaveProcessingStatus(true);

    List<String>? saveResult;

    // Preparing save files.
    List<SaveFileInfo> saveFiles = List<SaveFileInfo>.generate(
      fileSaveModel.saveFiles.length,
      (int index) => SaveFileInfo(
        filePath: fileSaveModel.saveFiles[index].filePath,
        fileName: fileSaveModel.saveFiles[index].fileName,
      ),
    );
    FileSaverParams params = FileSaverParams(
      saveFiles: saveFiles,
      mimeTypesFilter: fileSaveModel.mimeTypesFilter,
    );

    // Todo: Provide user option to report save error or exception.
    try {
      // Saving files and storing result paths in saveResult.
      saveResult = await PickSave.saveFiles(
        params: params,
      );
    } on PlatformException catch (e, s) {
      log(e.toString());
      log(s.toString());
      _fileSaveErrorStatus = true;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      _fileSaveErrorStatus = true;
    } finally {
      if (saveResult == null) {
        // Means save cancelled not an error.
      }

      // Updating action processing status to false.
      updateFileSaveProcessingStatus(false);

      // Notifying ToolsActionsState listeners.
      customNotifyListener();
    }
  }

  /// Called to cancel any running saving of output files.
  void cancelFileSaving() {
    try {
      PickOrSave().cancelActions(
        params: const CancelActionsParams(cancelType: CancelType.filesSaving),
      );
    } on PlatformException catch (e, s) {
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    } catch (e, s) {
      log(e.toString());
      _errorMessage = e.toString();
      _errorStackTrace = s;
    }
    updateFileSaveProcessingStatus(false);
    customNotifyListener();
  }

  /// Called to update an action error status.
  void updateActionErrorStatus(bool status) {
    _actionErrorStatus = status;
    customNotifyListener();
  }

  /// Called to update an action processing status.
  void updateActionProcessingStatus(bool status) {
    _isActionProcessing = status;
    customNotifyListener();
  }

  /// Called to update an saving error status.
  void updateFileSaveErrorStatus(bool status) {
    _fileSaveErrorStatus = status;
    customNotifyListener();
  }

  /// Called to update saving of output files processing status.
  void updateFileSaveProcessingStatus(bool status) {
    _isSaveProcessing = status;
    customNotifyListener();
  }

  /// Called to update current action type.
  void updateActionType(ToolAction actionType) {
    _currentActionType = actionType;
    customNotifyListener();
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
