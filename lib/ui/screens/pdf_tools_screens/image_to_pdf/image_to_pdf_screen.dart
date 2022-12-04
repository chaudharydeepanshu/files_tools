import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/pdf_tools_screens/image_to_pdf/image_to_pdf_tools_screen.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pick_or_save/pick_or_save.dart';

class ImageToPDFPage extends StatefulWidget {
  const ImageToPDFPage({Key? key}) : super(key: key);

  @override
  State<ImageToPDFPage> createState() => _ImageToPDFPageState();
}

class _ImageToPDFPageState extends State<ImageToPDFPage> {
  @override
  void initState() {
    Utility.clearCache(clearCacheCommandFrom: 'ImageToPDFPage');
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
            title: const Text('Image To PDF'),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolsScreensState watchToolScreenStateProviderValue =
                  ref.watch(toolsScreensStateProvider);
              // final List<InputFileModel> selectedImages = ref.watch(
              //     toolScreenStateProvider
              //         .select((value) => value.selectedImages));
              final List<InputFileModel> selectedFiles = ref.watch(
                toolsScreensStateProvider
                    .select((ToolsScreensState value) => value.selectedFiles),
              );
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  SelectFilesCard(
                    selectFileType: SelectFileType.both,
                    files: watchToolScreenStateProviderValue.selectedFiles,
                    filePickerParams: FilePickerParams(
                      getCachedFilePath: false,
                      enableMultipleSelection: true,
                      mimeTypesFilter: [
                        // "image/*",
                        'image/png',
                        'image/gif',
                        'image/jpeg',
                      ],
                      allowedExtensions: [
                        '.JPEG',
                        '.JPG',
                        '.JP2',
                        '.GIF',
                        '.PNG',
                        '.BMP',
                        '.WMF',
                        '.TIFF',
                        '.CCITT',
                        '.JBIG2'
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
                      ToolActionModel(
                        actionText: 'Image To PDF',
                        actionOnTap: selectedFiles.isNotEmpty
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.imageToPDFToolsPage,
                                  arguments: ImageToPDFToolsPageArguments(
                                    actionType: ToolAction.imageToPdf,
                                    files: selectedFiles,
                                  ),
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
