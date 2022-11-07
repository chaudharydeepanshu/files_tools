import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/select_file_state.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_tools_screen.dart';
import 'package:files_tools/utils/clear_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;
import 'package:pick_or_save/pick_or_save.dart';

import '../../../components/select_file_section.dart';

class ImageToPDFPage extends StatefulWidget {
  const ImageToPDFPage({Key? key}) : super(key: key);

  @override
  State<ImageToPDFPage> createState() => _ImageToPDFPageState();
}

class _ImageToPDFPageState extends State<ImageToPDFPage> {
  @override
  void initState() {
    clearCache(clearCacheCommandFrom: "ImageToPDFPage");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Removing any snack bar or keyboard
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Returning true allows the pop to happen, returning false prevents it.
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Image To PDF"),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolScreenState watchToolScreenStateProviderValue =
                  ref.watch(toolScreenStateProvider);
              // final List<InputFileModel> selectedImages = ref.watch(
              //     toolScreenStateProvider
              //         .select((value) => value.selectedImages));
              final List<InputFileModel> selectedFiles = ref.watch(
                  toolScreenStateProvider
                      .select((value) => value.selectedFiles));
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  SelectFilesCard(
                    selectFileType: SelectFileType.both,
                    files: watchToolScreenStateProviderValue.selectedFiles,
                    filePickerParams: FilePickerParams(
                      copyFileToCacheDir: false,
                      pickerType: PickerType.file,
                      enableMultipleSelection: true,
                      mimeTypesFilter: [
                        // "image/*",
                        "image/png",
                        "image/gif",
                        "image/jpeg",
                      ],
                      allowedExtensions: [
                        ".JPEG",
                        ".JPG",
                        ".JP2",
                        ".GIF",
                        ".PNG",
                        ".BMP",
                        ".WMF",
                        ".TIFF",
                        ".CCITT",
                        ".JBIG2"
                      ],
                    ),
                  ),
                  // SelectImagesCard(
                  //   selectImageType: SelectImageType.both,
                  //   images: watchToolScreenStateProviderValue.selectedImages,
                  //   allowedExtensions: const [
                  //     ".JPEG",
                  //     ".JPG",
                  //     ".JP2",
                  //     ".GIF",
                  //     ".PNG",
                  //     ".BMP",
                  //     ".WMF",
                  //     ".TIFF",
                  //     ".CCITT",
                  //     ".JBIG2"
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: [
                      ToolActionsModel(
                        actionText: "Image To PDF",
                        actionOnTap: selectedFiles.isNotEmpty
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.imageToPDFToolsPage,
                                  arguments: ImageToPDFToolsPageArguments(
                                      actionType: ToolsActions.imageToPDF,
                                      files: selectedFiles),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
