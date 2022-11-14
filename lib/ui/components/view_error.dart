import 'package:device_info_plus/device_info_plus.dart';
import 'package:files_tools/ui/components/url_launcher.dart';
import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      ],
    );
  }
}

class ShowError extends StatelessWidget {
  const ShowError(
      {Key? key,
      required this.errorMessage,
      required this.taskMessage,
      this.allowBack = false})
      : super(key: key);

  final String taskMessage;
  final String errorMessage;
  final bool allowBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ErrorIndicator(),
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
          const SizedBox(height: 16),
          Row(
            children: [
              if (allowBack)
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back'),
                ),
              TextButton(
                onPressed: () async {
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                  AndroidDeviceInfo androidDeviceInfo =
                      await deviceInfo.androidInfo;

                  String userDeviceInfo =
                      '''version.securityPatch: ${androidDeviceInfo.version.securityPatch}
                          version.sdkInt: ${androidDeviceInfo.version.sdkInt}
                          version.release: ${androidDeviceInfo.version.release}
                          version.previewSdkInt: ${androidDeviceInfo.version.previewSdkInt}
                          version.incrementa: ${androidDeviceInfo.version.incremental}
                          version.codename: ${androidDeviceInfo.version.codename}
                          version.baseOS: ${androidDeviceInfo.version.baseOS}
                          board: ${androidDeviceInfo.board}
                          bootloader: ${androidDeviceInfo.bootloader}
                          brand: ${androidDeviceInfo.brand}
                          device: ${androidDeviceInfo.device}
                          display: ${androidDeviceInfo.display}
                          fingerprint: ${androidDeviceInfo.fingerprint}
                          hardware: ${androidDeviceInfo.hardware}
                          host: ${androidDeviceInfo.host}
                          id: ${androidDeviceInfo.id}
                          manufacturer: ${androidDeviceInfo.manufacturer}
                          model: ${androidDeviceInfo.model}
                          product: ${androidDeviceInfo.product}
                          supported32BitAbis: ${androidDeviceInfo.supported32BitAbis}
                          supported64BitAbis: ${androidDeviceInfo.supported64BitAbis}
                          supportedAbis: ${androidDeviceInfo.supportedAbis}
                          tags: ${androidDeviceInfo.tags}
                          type: ${androidDeviceInfo.type}
                          isPhysicalDevice: ${androidDeviceInfo.isPhysicalDevice}
                          systemFeatures: ${androidDeviceInfo.systemFeatures}
                          ''';

                  var url =
                      'mailto:pureinfoapps@gmail.com?subject=Files Tools Bug Report&body=Error Message:\n$errorMessage\n\nUser Device Info:\n$userDeviceInfo';

                  await urlLauncher(url);
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
