import 'package:flutter/material.dart';

/// Widget for showing about or info card in actions screen.
class AboutActionCard extends StatelessWidget {
  /// Defining [AboutActionCard] constructor.
  const AboutActionCard({
    Key? key,
    required this.aboutTitle,
    this.aboutBody,
    this.aboutBodyTitle,
  }) : super(key: key);

  /// About card title text.
  final String aboutTitle;

  /// About card body text.
  final String? aboutBody;

  /// About card body title text.
  final String? aboutBodyTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.info),
                Text(
                  'Function Info',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const Divider(),
            Text(
              aboutTitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (aboutBody != null && aboutBody!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (aboutBodyTitle != null &&
                            aboutBodyTitle!.trim().isNotEmpty)
                          Text(
                            '$aboutBodyTitle\n',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        Text(
                          '$aboutBody',
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
