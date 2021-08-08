import 'package:flutter/material.dart';

class ReusableSilverAppBar extends StatefulWidget with PreferredSizeWidget {
  const ReusableSilverAppBar({
    this.title,
    this.appBarIconLeft,
    this.appBarIconLeftToolTip,
    this.appBarIconRight,
    this.appBarIconRightToolTip,
    this.appBarIconLeftAction,
    this.appBarIconRightAction,
    this.titleColor,
    this.leftButtonColor,
    this.rightButtonColor,
  });
  final String? title;
  final Color? titleColor;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final IconData? appBarIconLeft;
  final String? appBarIconLeftToolTip;
  final Function()? appBarIconLeftAction;
  final IconData? appBarIconRight;
  final String? appBarIconRightToolTip;
  final Function()? appBarIconRightAction;

  @override
  _ReusableSilverAppBarState createState() => _ReusableSilverAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ReusableSilverAppBarState extends State<ReusableSilverAppBar> {
  // String _title;
  //
  // void initState() {
  //   super.initState();
  //   _title = widget.title;
  // }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //automaticallyImplyLeading: false,
            elevation: 5,
            pinned: true,
            centerTitle: true,
            title: Text(
              widget.title ?? 'Title',
              //style: TextStyle(color: widget.titleColor ?? Colors.black),
            ),
            //backgroundColor: Colors.white,
            leading: widget.appBarIconLeft != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                    child: SizedBox(
                      width: 51,
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        shape: StadiumBorder(),
                        child: Tooltip(
                          message: widget.appBarIconLeftToolTip ?? "Search",
                          child: InkWell(
                            onTap: widget.appBarIconLeftAction ?? () {},
                            customBorder: StadiumBorder(),
                            focusColor: widget.leftButtonColor != null
                                ? widget.leftButtonColor!.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            highlightColor: widget.leftButtonColor != null
                                ? widget.leftButtonColor!.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            splashColor: widget.leftButtonColor != null
                                ? widget.leftButtonColor!.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            hoverColor: widget.leftButtonColor != null
                                ? widget.leftButtonColor!.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            child: Icon(
                              widget.appBarIconLeft ?? null,
                              size: 24,
                              color: widget.leftButtonColor ?? null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            actions: widget.appBarIconRight != null
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 5, top: 8, bottom: 8),
                      child: SizedBox(
                        width: 51,
                        height: 40,
                        child: Material(
                          color: Colors.transparent,
                          shape: StadiumBorder(),
                          child: Tooltip(
                            message:
                                widget.appBarIconRightToolTip ?? "Settings",
                            child: InkWell(
                              onTap: widget.appBarIconRightAction != null
                                  ? widget.appBarIconRightAction
                                  : null,
                              customBorder: StadiumBorder(),
                              focusColor: widget.rightButtonColor != null
                                  ? widget.rightButtonColor!.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              highlightColor: widget.rightButtonColor != null
                                  ? widget.rightButtonColor!.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              splashColor: widget.rightButtonColor != null
                                  ? widget.rightButtonColor!.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              hoverColor: widget.rightButtonColor != null
                                  ? widget.rightButtonColor!.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              child: Icon(
                                widget.appBarIconRight ?? null,
                                size: 24,
                                color: widget.appBarIconRightAction != null
                                    ? widget.rightButtonColor
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                : null,
          ),
        ],
      ),
    );
  }
}
