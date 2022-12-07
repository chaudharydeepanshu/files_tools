import 'package:files_tools/main.dart';
import 'package:files_tools/state/preferences.dart';
import 'package:files_tools/ui/components/custom_snack_bar.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

/// Widget for error icon.
class ErrorIndicator extends StatelessWidget {
  /// Defining [ErrorIndicator] constructor.
  const ErrorIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      ],
    );
  }
}

/// Widget for showing error state.
class ShowError extends StatefulWidget {
  /// Defining [ShowError] constructor.
  const ShowError({
    Key? key,
    required this.errorMessage,
    required this.taskMessage,
    this.allowBack = false,
    required this.errorStackTrace,
  }) : super(key: key);

  /// Takes message describing the task for which the error occurred.
  final String taskMessage;

  /// Takes message describing the error.
  final String errorMessage;

  /// Takes error StackTrace.
  final StackTrace? errorStackTrace;

  /// Decides if a back button should be shown or not.
  final bool allowBack;

  @override
  State<ShowError> createState() => _ShowErrorState();
}

class _ShowErrorState extends State<ShowError> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ErrorIndicator(),
          const SizedBox(height: 16),
          Text(
            widget.taskMessage,
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
                maxHeight: 100,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              color: Theme.of(context).colorScheme.errorContainer,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.errorMessage,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.allowBack)
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back'),
                ),
              TextButton(
                onPressed: () async {
                  if (Preferences.crashlyticsCollectionStatus == false) {
                    await crashlyticsInstance
                        .setCrashlyticsCollectionEnabled(true);
                  }

                  FirebaseCrashlytics.instance.recordError(
                    'User Reported Error: ${widget.errorMessage}',
                    widget.errorStackTrace,
                    reason: 'Task Message: ${widget.taskMessage}',
                  );

                  if (mounted) {
                    String? contentText = 'Error reported successfully';
                    TextStyle? textStyle =
                        Theme.of(context).textTheme.bodySmall;

                    showCustomSnackBar(
                      contentText: contentText,
                      textStyle: textStyle,
                      context: context,
                    );
                  }

                  if (Preferences.crashlyticsCollectionStatus == false) {
                    await crashlyticsInstance
                        .setCrashlyticsCollectionEnabled(false);
                  }
                },
                child: const Text('Report Error'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
