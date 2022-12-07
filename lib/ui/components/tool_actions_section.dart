import 'package:files_tools/models/tool_actions_model.dart';
import 'package:flutter/material.dart';

/// Widget for showing all tools actions buttons.
class ToolActionsCard extends StatelessWidget {
  /// Defining [ToolActionsCard] constructor.
  const ToolActionsCard({Key? key, required this.toolActions})
      : super(key: key);

  /// Takes tools actions models list.
  final List<ToolActionModel> toolActions;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Icon(Icons.looks_two),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return FilledButton(
                    onPressed: toolActions[index].actionOnTap,
                    child: Text(toolActions[index].actionText),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                itemCount: toolActions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
