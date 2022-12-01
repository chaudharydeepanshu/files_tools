import 'dart:developer';

import 'package:files_tools/route/route.dart' as route;
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:files_tools/ui/screens/image_viewer.dart';
import 'package:files_tools/ui/screens/pdf_viewer.dart';
import 'package:files_tools/utils/get_file_name_extension.dart';
import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  const FileTile(
      {Key? key,
      required this.fileName,
      required this.fileTime,
      required this.fileDate,
      this.filePath,
      this.fileUri,
      required this.fileSize,
      this.onRemove})
      : super(key: key);

  final String fileName;
  final String fileTime;
  final String fileDate;
  final String? filePath;
  final String? fileUri;
  final String fileSize;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      minVerticalPadding: 8,
      visualDensity: VisualDensity.comfortable,
      dense: true,
      onTap: () {
        String fileExtension = getFileNameExtension(fileName: fileName);
        if (fileExtension.toLowerCase() == '.pdf') {
          if (filePath != null || fileUri != null) {
            Navigator.pushNamed(
              context,
              route.pdfViewer,
              arguments: PdfViewerArguments(
                  fileName: fileName, filePathOrUri: filePath ?? fileUri!),
            );
          } else {
            log('File path or file uri both are null for opening file with extension $fileExtension');
          }
        } else if (fileExtension.toLowerCase() == '.png' ||
            fileExtension.toLowerCase() == '.jpg' ||
            fileExtension.toLowerCase() == '.jpeg' ||
            fileExtension.toLowerCase() == '.webp') {
          Navigator.pushNamed(
            context,
            route.imageViewer,
            arguments: ImageViewerArguments(
                fileName: fileName, filePath: filePath, fileUri: fileUri),
          );
        } else {
          log('No action found for opening file with extension $fileExtension');

          String? contentText =
              "Oh...No! We don't support opening this type of file.";
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
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: double.infinity,
          child: Icon(Icons.description),
        ),
      ),
      title: Text(
        fileName,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(fileDate,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis),
            ),
            VerticalDivider(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                width: 0),
            Expanded(
              child: Text(
                fileTime,
                style: Theme.of(context).textTheme.bodySmall,
                // overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            VerticalDivider(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                width: 0),
            Expanded(
              child: Text(
                fileSize,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      trailing: onRemove != null
          ? IconButton(
              style: IconButton.styleFrom(

                  // minimumSize: Size.zero,
                  // padding: EdgeInsets.zero,
                  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              onPressed: onRemove,
              icon: const SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.clear,
                  size: 24,
                ),
              ),
            )
          : null,
    );
  }
}
