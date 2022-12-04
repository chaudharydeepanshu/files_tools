import 'package:flutter/services.dart';
import 'package:pick_or_save/pick_or_save.dart';

/// PickSave is a utility class for all the picking and saving.
class PickSave {
  /// For saving files.
  static Future<List<String>?> saveFiles({
    required FileSaverParams params,
  }) async {
    // Holds save result.
    List<String>? saveResult;

    try {
      // Saving the files and storing result paths in saveResult.
      saveResult = await PickOrSave().fileSaver(
        params: params,
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    return saveResult;
  }

  /// For file picking.
  static Future<List<String>?> pickFile({
    required FilePickerParams params,
  }) async {
    // Holds picking result.
    List<String>? pickResult;

    try {
      // Picking the files and storing result paths in pickResult.
      pickResult = await PickOrSave().filePicker(params: params);
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    return pickResult;
  }
}
