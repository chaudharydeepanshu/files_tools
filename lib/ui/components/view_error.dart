import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  const ShowError(
      {Key? key, required this.errorMessage, required this.taskMessage})
      : super(key: key);

  final String taskMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 16),
        Text(
          taskMessage,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            // height: 100,
            constraints: BoxConstraints(
              minHeight: 0,
              minWidth: 0,
              maxHeight: 100,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            color: Theme.of(context).colorScheme.errorContainer,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
