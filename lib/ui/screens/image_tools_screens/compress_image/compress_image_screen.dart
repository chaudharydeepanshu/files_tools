import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:files_tools/models/file_model.dart';
import 'package:files_tools/models/file_pick_save_model.dart';
import 'package:files_tools/models/tool_actions_model.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/providers.dart';
import 'package:files_tools/state/tools_actions_state.dart';
import 'package:files_tools/state/tools_screens_state.dart';
import 'package:files_tools/ui/components/select_file_section.dart';
import 'package:files_tools/ui/components/tool_actions_section.dart';
import 'package:files_tools/ui/screens/image_tools_screens/compress_image/compress_image_tool_action_screen.dart';
import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tool screen for compressing image.
class CompressImagePage extends StatefulWidget {
  /// Defining [CompressImagePage] constructor.
  const CompressImagePage({Key? key}) : super(key: key);

  @override
  State<CompressImagePage> createState() => _CompressPDFPageState();
}

class _CompressPDFPageState extends State<CompressImagePage> {
  @override
  void initState() {
    Utility.clearTempDirectory(clearCacheCommandFrom: 'CompressImagePage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);

    String imageSingular = appLocale.image(1);
    String imagePlural = appLocale.image(2);
    String compressImage = appLocale.tool_CompressFileOrFiles(imageSingular);
    String compressImages = appLocale.tool_CompressFileOrFiles(imagePlural);

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
            title: Text(compressImage),
            centerTitle: true,
          ),
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ToolsScreensState watchToolScreenStateProviderValue =
                  ref.watch(toolsScreensStateProvider);
              final List<InputFileModel> selectedFiles = ref.watch(
                toolsScreensStateProvider
                    .select((ToolsScreensState value) => value.inputFiles),
              );
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: <Widget>[
                  SelectFilesCard(
                    fileTypeSingular: imageSingular,
                    fileTypePlural: imagePlural,
                    files: watchToolScreenStateProviderValue.inputFiles,
                    filePickModel: const FilePickModel(
                      allowedExtensions: <String>[
                        '.png',
                        '.jpeg',
                        '.jpg',
                        '.webp',
                      ],
                      mimeTypesFilter: <String>[
                        'image/png',
                        'image/jpeg',
                        'image/webp',
                      ],
                      enableMultipleSelection: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ToolActionsCard(
                    toolActions: <ToolActionModel>[
                      ToolActionModel(
                        actionText: selectedFiles.length > 1
                            ? compressImages
                            : compressImage,
                        actionOnTap: selectedFiles.isNotEmpty
                            ? () {
                                // Removing any snack bar or keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();

                                Navigator.pushNamed(
                                  context,
                                  route.AppRoutes.compressImageToolsPage,
                                  arguments: CompressImageToolsPageArguments(
                                    actionType: ToolAction.compressImages,
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
