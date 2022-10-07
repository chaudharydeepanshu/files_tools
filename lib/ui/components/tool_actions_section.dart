import 'package:files_tools/models/tool_actions_model.dart';
import 'package:flutter/material.dart';

class ToolActionsCard extends StatelessWidget {
  const ToolActionsCard({Key? key, required this.toolActions})
      : super(key: key);

  final List<ToolActionsModel> toolActions;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.looks_two),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 0, maxHeight: 300),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
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
