import 'package:files_tools/ui/components/url_launcher.dart';
import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  const LinkButton(
      {Key? key, required this.urlLabel, required this.url, this.urlIcon})
      : super(key: key);

  final String urlLabel;
  final IconData? urlIcon;
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
              urlLauncher(url);
            },
            icon: Icon(
              urlIcon,
              size: 12,
            ),
            label: Text(urlLabel),
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
              urlLauncher(url);
            },
            child: Text(urlLabel),
          );
  }
}
