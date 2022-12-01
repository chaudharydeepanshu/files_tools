import 'package:flutter/material.dart';

class AboutActionCard extends StatelessWidget {
  const AboutActionCard(
      {Key? key,
      required this.aboutText,
      this.aboutTextBody,
      this.aboutTextBodyTitle})
      : super(key: key);

  final String aboutText;
  final String? aboutTextBody;
  final String? aboutTextBodyTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info),
                Text(
                  "Function Info",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const Divider(),
            Text(
              aboutText,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (aboutTextBody != null && aboutTextBody!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (aboutTextBodyTitle != null &&
                            aboutTextBodyTitle!.trim().isNotEmpty)
                          Text(
                            "$aboutTextBodyTitle\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,
                          ),
                        Text(
                          "$aboutTextBody",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
