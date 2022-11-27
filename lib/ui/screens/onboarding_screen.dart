import 'package:carousel_slider/carousel_slider.dart';
import 'package:files_tools/shared_preferences/preferences.dart';
import 'package:files_tools/ui/components/color_picker.dart';
import 'package:files_tools/ui/theme/app_theme_data.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:files_tools/route/route.dart' as route;

import '../../state/providers.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          onBoardingFinish(context);
          // Returning true allows the pop to happen, returning false prevents it.
          return false;
        },
        child: const OnBoardScreenPageView());
  }
}

void onBoardingFinish(BuildContext context) async {
  Navigator.pushReplacementNamed(
    context,
    route.homePage,
  );
  Preferences preferences = Preferences();
  await preferences.init(sharedPreferencesInstance);
  preferences.persistOnBoardingStatus(true);
  // if (Navigator.canPop(context)) {
  //   // Popping only if it can be popped.
  //   Navigator.pop(context);
  // }
}

class HoledScaffold extends StatelessWidget {
  const HoledScaffold(
      {Key? key,
      required this.firstHoleColor,
      required this.secondHoleColor,
      required this.firstHoleBorderColor,
      required this.secondHoleBorderColor,
      this.firstHoleChild,
      this.secondHoleChild,
      this.disableFirstHoleBorder = true,
      this.disableSecondHoleBorder = true})
      : super(key: key);

  final Color firstHoleColor;
  final Color secondHoleColor;
  final Color firstHoleBorderColor;
  final Color secondHoleBorderColor;
  final Widget? firstHoleChild;
  final Widget? secondHoleChild;
  final bool disableFirstHoleBorder;
  final bool disableSecondHoleBorder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: firstHoleColor,
              border: disableFirstHoleBorder
                  ? null
                  : Border.all(color: firstHoleBorderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: firstHoleChild,
          ),
        ),
        Flexible(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: secondHoleColor,
              border: disableSecondHoleBorder
                  ? null
                  : Border.all(color: secondHoleBorderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: secondHoleChild,
          ),
        ),
      ],
    );
  }
}

class OnBoardScreenPageView extends StatefulWidget {
  const OnBoardScreenPageView({Key? key}) : super(key: key);

  @override
  State<OnBoardScreenPageView> createState() => _OnBoardScreenPageViewState();
}

class _OnBoardScreenPageViewState extends State<OnBoardScreenPageView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int totalPages = 2;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: totalPages, vsync: this);

    tabController.animation?.addListener(() {
      setState(() {
        int? value = tabController.animation?.value.round();
        if (value != null && value != currentIndex) {
          setState(() {
            currentIndex = value;
          });
        }
      });
    });

    tabController.addListener(() {
      setState(() {
        currentIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                  Colors.transparent,
                ],
                stops: const [0, 0.5, 0.5],
              ),
            ),
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: const <Widget>[
                PageViewFirstScreen(),
                PageViewSecondScreen(),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
                  BlendMode.srcOut), // This one will create the magic
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      backgroundBlendMode: BlendMode.dstOut,
                    ), // This one will handle background + difference out
                  ),
                  const HoledScaffold(
                    firstHoleColor: Colors.black,
                    secondHoleColor: Colors.black,
                    firstHoleBorderColor: Colors.black,
                    secondHoleBorderColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: HoledScaffold(
              firstHoleColor: Colors.transparent,
              secondHoleColor: Colors.transparent,
              firstHoleBorderColor: Theme.of(context).colorScheme.outline,
              secondHoleBorderColor: Theme.of(context).colorScheme.outline,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: TabPageSelector(
                controller: tabController,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: totalPages - 1 != currentIndex
                  ? Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                          onPressed: () {
                            onBoardingFinish(context);
                          },
                          child: const Text("Skip"),
                        );
                      },
                    )
                  : const SizedBox(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: PageViewControlArrows(
                currentIndex: currentIndex,
                totalPages: totalPages,
                onBackward: tabController.indexIsChanging ||
                        currentIndex != tabController.index
                    ? null
                    : () {
                        if (0 <= currentIndex - 1) {
                          int animateTo = currentIndex - 1;
                          tabController.animateTo(animateTo);
                        }
                      },
                onForward: tabController.indexIsChanging ||
                        currentIndex != tabController.index
                    ? null
                    : () {
                        if (totalPages > currentIndex + 1) {
                          int animateTo = currentIndex + 1;

                          tabController.animateTo(animateTo);
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewControlArrows extends StatelessWidget {
  const PageViewControlArrows(
      {Key? key,
      required this.currentIndex,
      required this.totalPages,
      required this.onBackward,
      required this.onForward})
      : super(key: key);

  final int currentIndex;
  final int totalPages;
  final void Function()? onBackward;
  final void Function()? onForward;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        0 < currentIndex
            ? TextButton(
                onPressed: onBackward,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox(),
        totalPages - 1 != currentIndex
            ? TextButton(
                onPressed: onForward,
                child: const Icon(Icons.arrow_forward),
              )
            : const GetStartedButton(),
      ],
    );
  }
}

class PageViewFirstScreen extends StatelessWidget {
  const PageViewFirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoledScaffold(
        firstHoleColor: Colors.transparent,
        secondHoleColor: Colors.transparent,
        firstHoleBorderColor: Theme.of(context).colorScheme.outline,
        secondHoleBorderColor: Colors.transparent,
        disableFirstHoleBorder: false,
        firstHoleChild: AbsorbPointer(
          absorbing: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ToolsMovingList1(
                  noOfElementsToRemoveFromList: 10,
                  noOfElementsToAddInIndex: 0,
                  delayMilliseconds: 100,
                  durationSeconds: 100),
              VerticalDivider(width: 0),
              ToolsMovingList1(
                  noOfElementsToRemoveFromList: 10,
                  noOfElementsToAddInIndex: 5,
                  delayMilliseconds: 100,
                  durationSeconds: 100),
              VerticalDivider(width: 0),
              ToolsMovingList1(
                  noOfElementsToRemoveFromList: 10,
                  noOfElementsToAddInIndex: 10,
                  delayMilliseconds: 100,
                  durationSeconds: 100),
            ],
          ),
        ),
        secondHoleChild: const OnBoardingText(onBoardingText: 'Welcome!'));
  }
}

class PageViewSecondScreen extends StatelessWidget {
  const PageViewSecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoledScaffold(
        firstHoleColor: Colors.transparent,
        secondHoleColor: Colors.transparent,
        firstHoleBorderColor: Theme.of(context).colorScheme.outline,
        secondHoleBorderColor: Colors.transparent,
        disableFirstHoleBorder: false,
        firstHoleChild: AbsorbPointer(
          absorbing: false,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ThemeWidget(),
                DynamicThemeCheckboxTile(),
                ThemeModeSwitcher(),
              ],
            ),
          ),
        ),
        secondHoleChild: Column(
          children: const [
            OnBoardingText(onBoardingText: 'Customize App Theme!'),
            // OnBoardingText(onBoardingText: "Thank You!"),
          ],
        ));
  }
}

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return FilledButton.icon(
          onPressed: () {
            onBoardingFinish(context);
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Done"),
        );
      },
    );
  }
}

class DynamicThemeCheckboxTile extends StatelessWidget {
  const DynamicThemeCheckboxTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool isDynamicThemeEnabled = ref.watch(appThemeStateProvider
            .select((value) => value.isDynamicThemeEnabled));
        ColorScheme? lightDynamicColorScheme = ref.watch(appThemeStateProvider
            .select((value) => value.lightDynamicColorScheme));

        return lightDynamicColorScheme != null
            ? CheckboxListTile(
                title: const Text("Enable Dynamic Theme"),
                subtitle: const Text("Wallpaper as theme"),
                value: isDynamicThemeEnabled,
                onChanged: (bool? value) {
                  ref.read(appThemeStateProvider).updateDynamicThemeStatus();
                },
              )
            : const SizedBox();
      },
    );
  }
}

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ThemeMode themeMode =
            ref.watch(appThemeStateProvider.select((value) => value.themeMode));
        String buttonText = themeMode == ThemeMode.light
            ? "Light"
            : themeMode == ThemeMode.dark
                ? "Dark"
                : "System";
        IconData iconData = themeMode == ThemeMode.light
            ? Icons.light_mode
            : themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.android;
        return ListTile(
          leading: Icon(iconData),
          title: Text('Theme - $buttonText'),
          onTap: () {
            ref.read(appThemeStateProvider).updateThemeMode();
          },
        );
      },
    );
  }
}

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ColorScheme userLightColorScheme = ref.watch(appThemeStateProvider
            .select((value) => value.userLightColorScheme));
        ColorScheme userDarkColorScheme = ref.watch(
            appThemeStateProvider.select((value) => value.userDarkColorScheme));
        final Color themePrimaryColor =
            Theme.of(context).brightness != Brightness.dark
                ? AppThemeData.lightThemeData(userLightColorScheme)
                    .colorScheme
                    .primary
                : AppThemeData.darkThemeData(userDarkColorScheme)
                    .colorScheme
                    .primary;
        return ListTile(
          title: const Text('Theme color'),
          subtitle: Text(
            '${ColorTools.materialNameAndCode(themePrimaryColor)} '
            'aka '
            '${ColorTools.nameThatColor(themePrimaryColor)}',
          ),
          trailing: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: 22,
            color: themePrimaryColor,
          ),
          onTap: () async {
            // Store current color before we open the dialog.
            final Color colorBeforeDialog = themePrimaryColor;
            // Wait for the picker to close, if dialog was dismissed,
            // then restore the color we had before it was opened.
            bool dialogStatus = await colorPickerDialog(
                context: context,
                dialogPickerColor: themePrimaryColor,
                onColorChanged: (Color value) {
                  ref.read(appThemeStateProvider).updateUserTheme(value);
                });

            if (!dialogStatus) {
              ref
                  .read(appThemeStateProvider)
                  .updateUserTheme(colorBeforeDialog);
            }
          },
        );
      },
    );
  }
}

class OnBoardingText extends StatelessWidget {
  const OnBoardingText({Key? key, required this.onBoardingText})
      : super(key: key);

  final String onBoardingText;

  @override
  Widget build(BuildContext context) {
    return Text(
      onBoardingText,
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }
}

class ToolsMovingList1 extends StatelessWidget {
  const ToolsMovingList1(
      {Key? key,
      required this.noOfElementsToRemoveFromList,
      required this.noOfElementsToAddInIndex,
      required this.delayMilliseconds,
      required this.durationSeconds})
      : super(key: key);

  final int noOfElementsToRemoveFromList;
  final int noOfElementsToAddInIndex;
  final int delayMilliseconds;
  final int durationSeconds;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Colors.transparent,
              Colors.transparent,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [
              0.0,
              0.2,
              0.8,
              1.0
            ], // 10% surface, 80% transparent, 10% surface
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: CarouselSlider.builder(
          options: CarouselOptions(
              pageSnapping: false,
              viewportFraction: 0.333,
              height: 300.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.vertical),
          itemCount: appTools.length - noOfElementsToRemoveFromList,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final int first = index + noOfElementsToAddInIndex;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Divider(height: 0),
                Flexible(
                  child: AppToolDisplayElement(index: first),
                ),
                const Divider(height: 0),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AppToolDisplayElement extends StatelessWidget {
  const AppToolDisplayElement({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      // width: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            appTools[index].toolIconsData,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            appTools[index].toolName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class AppTool {
  final String toolName;
  final IconData toolIconsData;

  const AppTool({required this.toolName, required this.toolIconsData});
}

final List<AppTool> appTools = [
  const AppTool(toolName: "Merge PDF", toolIconsData: Icons.merge),
  const AppTool(toolName: "Split PDF", toolIconsData: Icons.call_split),
  const AppTool(
      toolName: "Rotate PDF Pages", toolIconsData: Icons.rotate_right),
  const AppTool(toolName: "Delete PDF Pages", toolIconsData: Icons.delete),
  const AppTool(toolName: "Reorder PDF Pages", toolIconsData: Icons.reorder),
  const AppTool(toolName: "PDF To Image", toolIconsData: Icons.image),
  const AppTool(toolName: "Compress PDF", toolIconsData: Icons.compress),
  const AppTool(
      toolName: "Watermark PDF", toolIconsData: Icons.branding_watermark),
  const AppTool(toolName: "Image To PDF", toolIconsData: Icons.picture_as_pdf),
  const AppTool(toolName: "Encrypt PDF", toolIconsData: Icons.lock),
  const AppTool(toolName: "Decrypt PDF", toolIconsData: Icons.lock_open),
  const AppTool(toolName: "Compress Image", toolIconsData: Icons.compress),
  const AppTool(toolName: "Crop Image", toolIconsData: Icons.crop),
  const AppTool(toolName: "Rotate Image", toolIconsData: Icons.rotate_right),
  const AppTool(toolName: "Flip Image", toolIconsData: Icons.flip),
];