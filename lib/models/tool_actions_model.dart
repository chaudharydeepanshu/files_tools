class ToolActionsModel {
  final String actionText;
  final void Function()? actionOnTap;

  ToolActionsModel({
    required this.actionText,
    required this.actionOnTap,
  });

  // Implement toString to make it easier to see information
  // when using the print statement.
  @override
  String toString() {
    return 'ToolActionsModel{actionText: $actionText, actionOnTap: $actionOnTap}';
  }
}
