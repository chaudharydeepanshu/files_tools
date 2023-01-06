import 'package:files_tools/l10n/generated/app_locale.dart';
import 'package:flutter/material.dart';

/// Model class for tools buttons in document and media tools.
class GridCardDetail {
  /// Defining [GridCardDetail] constructor.
  GridCardDetail({
    required this.cardIcons,
    required this.cardTitle,
    this.cardOnTap,
  });

  /// Tool button icon widget.
  final List<Widget> cardIcons;

  /// Tool button title text.
  final String cardTitle;

  /// Tool button click action.
  final void Function()? cardOnTap;

  /// Overriding GridCardDetail toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'CardDetail{'
        'cardIcons: $cardIcons, '
        'cardTitle: $cardTitle, '
        'cardOnTap: $cardOnTap'
        '}';
  }
}

/// Widget for displaying tools for a file(PDF, image, etc).
class GridViewInCardSection extends StatelessWidget {
  /// Defining [GridViewInCardSection] constructor.
  const GridViewInCardSection({
    Key? key,
    required this.sectionTitle,
    required this.emptySectionText,
    required this.gridCardsDetails,
    this.cardShowAllOnTap,
  }) : super(key: key);

  /// Text to show if no tools are available.
  final String emptySectionText;

  /// Type of file for tools.
  final String sectionTitle;

  /// Models for all the tools for the file.
  final List<GridCardDetail> gridCardsDetails;

  /// Action for viewing all tools(as this widget only displays 8 tools).
  final void Function()? cardShowAllOnTap;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String showAll = appLocale.button_ShowAll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            sectionTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          // elevation: 0,
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(
          //     color: Theme.of(context).colorScheme.outline,
          //   ),
          //   borderRadius: const BorderRadius.all(Radius.circular(12)),
          // ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: gridCardsDetails.isNotEmpty
                    ? LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double maxCrossAxisExtent = constraints.maxWidth /
                              (constraints.maxWidth / 280);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: maxCrossAxisExtent,
                              mainAxisExtent: 100,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: gridCardsDetails.length <= 8
                                ? gridCardsDetails.length
                                : 8,
                            itemBuilder: (BuildContext context, int index) {
                              return GridViewCard(
                                gridCardDetail: gridCardsDetails[index],
                              );
                            },
                          );
                        },
                      )
                    : Row(
                        children: <Widget>[
                          Expanded(child: Text(emptySectionText)),
                        ],
                      ),
              ),
              gridCardsDetails.length > 8
                  ? Column(
                      children: <Widget>[
                        const Divider(
                          height: 0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: cardShowAllOnTap,
                                icon: const Icon(Icons.arrow_forward),
                                label: Text(showAll),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget for tool button.
class GridViewCard extends StatelessWidget {
  /// Defining [GridViewCard] constructor.
  const GridViewCard({Key? key, required this.gridCardDetail})
      : super(key: key);

  /// Models for the tool.
  final GridCardDetail gridCardDetail;

  @override
  Widget build(BuildContext context) {
    AppLocale appLocale = AppLocale.of(context);
    String comingSoon = appLocale.comingSoon;

    List<Widget> iconsList = <Widget>[];

    for (int i = 0; i < gridCardDetail.cardIcons.length; i++) {
      iconsList.addAll(
        <Widget>[
          gridCardDetail.cardIcons[i],
          if (i != gridCardDetail.cardIcons.length - 1)
            VerticalDivider(
              width: 0,
              color: gridCardDetail.cardOnTap == null
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.onSecondaryContainer,
            )
        ],
      );
    }

    return FilledButton.tonal(
      clipBehavior: Clip.antiAlias,
      onPressed: gridCardDetail.cardOnTap,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: gridCardDetail.cardOnTap == null
                      ? Text(
                          comingSoon,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: iconsList,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                gridCardDetail.cardTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
