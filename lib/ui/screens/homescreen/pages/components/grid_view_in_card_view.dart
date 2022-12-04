import 'package:flutter/material.dart';

class GridCardDetail {

  GridCardDetail({
    required this.cardIcons,
    required this.cardTitle,
    this.cardOnTap,
  });
  final List<Widget> cardIcons;

  final String cardTitle;
  final Function()? cardOnTap;

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'CardDetail{cardIcons: $cardIcons, cardTitle: $cardTitle, cardOnTap: $cardOnTap}';
  }
}

class GridViewInCardSection extends StatelessWidget {
  const GridViewInCardSection({
    Key? key,
    required this.sectionTitle,
    required this.emptySectionText,
    required this.gridCardsDetails,
    this.cardShowAllOnTap,
  }) : super(key: key);

  final String emptySectionText;
  final String sectionTitle;
  final List<GridCardDetail> gridCardsDetails;
  final Function()? cardShowAllOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: gridCardsDetails.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
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
                      )
                    : Row(
                        children: [
                          Expanded(child: Text(emptySectionText)),
                        ],
                      ),
              ),
              gridCardsDetails.length > 8
                  ? Column(
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        Row(
                          children: [
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
                                label: const Text('Show All'),
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

class GridViewCard extends StatelessWidget {
  const GridViewCard({Key? key, required this.gridCardDetail})
      : super(key: key);

  final GridCardDetail gridCardDetail;

  @override
  Widget build(BuildContext context) {
    List<Widget> iconsList = [];

    for (int i = 0; i < gridCardDetail.cardIcons.length; i++) {
      iconsList.addAll([
        gridCardDetail.cardIcons[i],
        if (i != gridCardDetail.cardIcons.length - 1)
          VerticalDivider(
              width: 0,
              color: gridCardDetail.cardOnTap == null
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.onSecondaryContainer,)
      ]);
    }

    return FilledButton.tonal(
      clipBehavior: Clip.antiAlias,
      onPressed: gridCardDetail.cardOnTap,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: gridCardDetail.cardOnTap == null
                      ? Text(
                          'Coming Soon',
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
            children: [
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
