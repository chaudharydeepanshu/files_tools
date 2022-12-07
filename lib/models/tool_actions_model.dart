/// Model class for an tool action.
///
/// It holds action name and action onTap function for a tool action.
/// For example: A tool 'Split PDF' consists actions such as 'Split by Size',
/// 'Split by Page Count', etc.
class ToolActionModel {
  /// Defining [ToolActionModel] constructor.
  ToolActionModel({
    required this.actionText,
    required this.actionOnTap,
  });

  /// Tool action name.
  final String actionText;

  /// Tool action name.
  final void Function()? actionOnTap;

  /// Overriding ToolActionModel equality operator.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolActionModel &&
          runtimeType == other.runtimeType &&
          actionText == other.actionText &&
          actionOnTap == other.actionOnTap;

  /// Overriding ToolActionModel hashCode.
  @override
  int get hashCode => actionText.hashCode ^ actionOnTap.hashCode;

  /// Overriding ToolActionModel toString to make it easier to see information.
  /// when using the print statement.
  @override
  String toString() {
    return 'ToolActionModel{'
        'actionText: $actionText, '
        'actionOnTap: $actionOnTap'
        '}';
  }
}
