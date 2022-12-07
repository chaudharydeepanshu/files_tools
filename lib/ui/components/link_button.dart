import 'package:files_tools/utils/utility.dart';
import 'package:flutter/material.dart';

/// For showing a link button between a continuous long text.
class LinkButton extends StatelessWidget {
  /// Defining [LinkButton] constructor.
  const LinkButton({
    Key? key,
    required this.urlLabel,
    required this.url,
    this.urlIcon,
  }) : super(key: key);

  /// Link button text.
  final String urlLabel;

  /// Link button icon.
  final IconData? urlIcon;

  /// Link url.
  final String url;

  @override
  Widget build(BuildContext context) {
    return urlIcon != null
        ? TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(0, 0),
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {
              Utility.urlLauncher(url);
            },
            icon: Icon(
              urlIcon,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
            ),
            label: Text(
              urlLabel,
              textAlign: TextAlign.center,
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(0, 0),
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {
              Utility.urlLauncher(url);
            },
            child: Text(urlLabel),
          );
  }
}
