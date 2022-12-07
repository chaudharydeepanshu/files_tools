import 'package:flutter/material.dart';

/// For saving the state of loaded PgeViews to avoid loading them again.
class CustomKeepAlive extends StatefulWidget {
  /// Defining [CustomKeepAlive] constructor.
  const CustomKeepAlive({super.key, required this.widget});

  /// Widget to be kept alive.
  final Widget widget;

  @override
  State<CustomKeepAlive> createState() => _CustomKeepAliveState();
}

class _CustomKeepAliveState extends State<CustomKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.widget;
  }
}
