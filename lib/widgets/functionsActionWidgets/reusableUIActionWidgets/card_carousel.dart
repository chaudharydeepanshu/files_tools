import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({
    Key? key,
    required this.pageRotationNumber,
    required this.controller,
    required this.pageImage,
    required this.markImageDeleted,
  }) : super(key: key);

  final int pageRotationNumber;
  final AnimationController controller;
  final dynamic pageImage;
  final bool markImageDeleted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
          height: pageRotationNumber == 1 || pageRotationNumber == 3
              ? 297 / 1.25
              : 297,
          width: pageRotationNumber == 1 || pageRotationNumber == 3
              ? 210 / 1.25
              : 210,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(16.0),
            // boxShadow: [
            //   BoxShadow(
            //       color: kShadowColor,
            //       offset: Offset(0, 20),
            //       blurRadius: 10.0),
            // ],
            image: markImageDeleted == true
                ? DecorationImage(
                    image: pageImage,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                        Colors.red.withOpacity(0.6), BlendMode.srcATop),
                  )
                : DecorationImage(
                    image: pageImage,
                    fit: BoxFit.scaleDown,
                  ),
            // DecorationImage(
            //     image: NetworkImage(car.image), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class CarouselList extends StatefulWidget {
  const CarouselList(
      {Key? key,
      this.onIndex,
      this.listOfRotation,
      this.listOfImages,
      this.listOfDeletedImages,
      this.controllerValueList,
      this.onControllerValueList,
      this.color})
      : super(key: key);

  final ValueChanged<int>? onIndex;
  final Color? color;
  final List<int>? listOfRotation;
  final List? listOfImages;
  final List<bool>? listOfDeletedImages;
  final List<double>? controllerValueList;
  final ValueChanged<List<double>>? onControllerValueList;

  @override
  _CarouselListState createState() => _CarouselListState();
}

class _CarouselListState extends State<CarouselList>
    with TickerProviderStateMixin {
  int currentPage = 0;

  Widget updateIndicators() {
    return Container(
      decoration: BoxDecoration(
        color: widget.color ?? Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Page ${currentPage + 1} of ${widget.listOfImages!.length}',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  late List<AnimationController> controllerList;

  @override
  void initState() {
    controllerList =
        List<AnimationController>.generate(widget.listOfImages!.length, (i) {
      AnimationController controller$i = AnimationController(
        value: widget.controllerValueList![i],
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      return controller$i;
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controllerList) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            itemBuilder: (context, index) {
              if (widget.listOfRotation![index] == 0) {
                debugPrint('Deciding to run animation or not: 0');
                if (controllerList[index].value != 0.0 &&
                    widget.controllerValueList![index] != 0.0) {
                  debugPrint(
                      'Animation Ran: 0 with controller.value: ${controllerList[index].value}');
                  controllerList[index].animateTo(1.0).whenComplete(() {
                    widget.controllerValueList![index] = 0.0;
                    WidgetsBinding.instance!.addPostFrameCallback((_) =>
                        widget.onControllerValueList?.call(widget
                            .controllerValueList!)); // can't call callback during the build phase as it forces a setState during build and would lead to errors
                  });
                } else if (widget.controllerValueList![index] == 0.0) {
                  controllerList[index].value = 0.0;
                }
              } else if (widget.listOfRotation![index] == 1) {
                debugPrint('Deciding to run animation or not: 1');
                if (controllerList[index].value != 0.25 &&
                    widget.controllerValueList![index] != 0.25) {
                  debugPrint(
                      'Animation Ran: 1 with controller.value: ${controllerList[index].value}');
                  controllerList[index].reset();
                  controllerList[index].animateTo(0.25).whenComplete(() {
                    widget.controllerValueList![index] = 0.25;
                    WidgetsBinding.instance!.addPostFrameCallback((_) =>
                        widget.onControllerValueList?.call(widget
                            .controllerValueList!)); // can't call callback during the build phase as it forces a setState during build and would lead to errors
                  });
                } else if (widget.controllerValueList![index] == 0.25) {
                  controllerList[index].value = 0.25;
                }
              } else if (widget.listOfRotation![index] == 2) {
                debugPrint('Deciding to run animation or not: 2');
                if (controllerList[index].value != 0.50 &&
                    widget.controllerValueList![index] != 0.50) {
                  debugPrint(
                      'Animation Ran: 2 with controller.value: ${controllerList[index].value}');
                  controllerList[index].animateTo(0.50).whenComplete(() {
                    widget.controllerValueList![index] = 0.50;
                    WidgetsBinding.instance!.addPostFrameCallback((_) =>
                        widget.onControllerValueList?.call(widget
                            .controllerValueList!)); // can't call callback during the build phase as it forces a setState during build and would lead to errors
                  });
                } else if (widget.controllerValueList![index] == 0.50) {
                  controllerList[index].value = 0.50;
                }
              } else if (widget.listOfRotation![index] == 3) {
                debugPrint('Deciding to run animation or not: 3');
                if (controllerList[index].value != 0.75 &&
                    widget.controllerValueList![index] != 0.75) {
                  debugPrint(
                      'Animation Ran: 3 with controller.value: ${controllerList[index].value}');
                  controllerList[index].animateTo(0.75).whenComplete(() {
                    widget.controllerValueList![index] = 0.75;
                    WidgetsBinding.instance!.addPostFrameCallback((_) =>
                        widget.onControllerValueList?.call(widget
                            .controllerValueList!)); // can't call callback during the build phase as it forces a setState during build and would lead to errors
                  });
                } else if (widget.controllerValueList![index] == 0.75) {
                  controllerList[index].value = 0.75;
                }
              }
              return Opacity(
                opacity: currentPage == index ? 1.0 : 0.8,
                child: CarouselCard(
                  pageRotationNumber: widget.listOfRotation![index],
                  controller: controllerList[index],
                  pageImage: widget.listOfImages![index],
                  markImageDeleted: widget.listOfDeletedImages![index] == false
                      ? true
                      : false,
                ),
              );
            },
            itemCount: widget.listOfImages!.length,
            controller: PageController(initialPage: 0, viewportFraction: 0.69),
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
                widget.onIndex?.call(index);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: updateIndicators(),
          ),
        ),
      ],
    );
  }
}
