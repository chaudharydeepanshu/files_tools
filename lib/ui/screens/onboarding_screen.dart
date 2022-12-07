import 'package:carousel_slider/carousel_slider.dart';
import 'package:files_tools/route/app_routes.dart' as route;
import 'package:files_tools/state/preferences.dart';
import 'package:files_tools/ui/components/dynamic_theme_switch_tile.dart';
import 'package:files_tools/ui/components/reset_app_theme_settings.dart';
import 'package:files_tools/ui/components/theme_chooser_widget.dart';
import 'package:files_tools/ui/components/theme_mode_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// It is on boarding screen widget.
class OnBoardingScreen extends StatelessWidget {
  /// Defining [OnBoardingScreen] constructor.
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Running on boarding finish method.
        onBoardingFinish(context);
        // Returning false to prevent the pop.
        // As we are just replacing the route.
        return false;
      },
      child: const OnBoardScreenTabView(),
    );
  }
}

/// Called to finish on boarding.
void onBoardingFinish(BuildContext context) async {
  Navigator.pushReplacementNamed(
    context,
    route.AppRoutes.homePage,
  );
  Preferences.persistOnBoardingStatus(true);
}

/// Widget for creating on boarding screen interactive holes.
class HoledScaffold extends StatelessWidget {
  /// Defining [HoledScaffold] constructor.
  const HoledScaffold({
    Key? key,
    required this.firstHoleColor,
    required this.secondHoleColor,
    required this.firstHoleBorderColor,
    required this.secondHoleBorderColor,
    this.firstHoleChild,
    this.secondHoleChild,
    this.disableFirstHoleBorder = true,
    this.disableSecondHoleBorder = true,
  }) : super(key: key);

  /// Color of top hole.
  final Color firstHoleColor;

  /// Color of bottom hole.
  final Color secondHoleColor;

  /// Border color of top hole.
  final Color firstHoleBorderColor;

  /// Border color of bottom hole.
  final Color secondHoleBorderColor;

  /// Top hole child widget.
  final Widget? firstHoleChild;

  /// Bottom hole child widget.
  final Widget? secondHoleChild;

  /// Disables top hole border.
  final bool disableFirstHoleBorder;

  /// Disables bottom hole border.
  final bool disableSecondHoleBorder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                // height: 300,
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
            Expanded(
              child: Container(
                // height: 300,
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
        ),
      ),
    );
  }
}

/// Widget for creating on boarding screen TabView.
class OnBoardScreenTabView extends StatefulWidget {
  /// Defining [OnBoardScreenTabView] constructor.
  const OnBoardScreenTabView({Key? key}) : super(key: key);

  @override
  State<OnBoardScreenTabView> createState() => _OnBoardScreenTabViewState();
}

class _OnBoardScreenTabViewState extends State<OnBoardScreenTabView>
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
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                  Colors.transparent,
                ],
                stops: const <double>[0, 0.5, 0.5],
              ),
            ),
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: const <Widget>[
                TabViewFirstScreen(),
                TabViewSecondScreen(),
              ],
            ),
          ),
          IgnorePointer(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                BlendMode.srcOut,
              ), // This one will create the magic
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
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
                          child: const Text('Skip'),
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
              child: TabViewControlArrows(
                currentIndex: currentIndex,
                totalTabs: totalPages,
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

/// Widget for creating on boarding screen TabView control arrows.
class TabViewControlArrows extends StatelessWidget {
  /// Defining [TabViewControlArrows] constructor.
  const TabViewControlArrows({
    Key? key,
    required this.currentIndex,
    required this.totalTabs,
    required this.onBackward,
    required this.onForward,
  }) : super(key: key);

  /// Gives the current index of the TabView.
  final int currentIndex;

  /// Gives the number of tabs in TabView.
  final int totalTabs;

  /// Backward arrow action.
  final void Function()? onBackward;

  /// forward arrow action.
  final void Function()? onForward;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        0 < currentIndex
            ? TextButton(
                onPressed: onBackward,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox(),
        totalTabs - 1 != currentIndex
            ? TextButton(
                onPressed: onForward,
                child: const Icon(Icons.arrow_forward),
              )
            : const DoneButton(),
      ],
    );
  }
}

/// First screen of on boarding screen TabView.
class TabViewFirstScreen extends StatelessWidget {
  /// Defining [TabViewFirstScreen] constructor.
  const TabViewFirstScreen({Key? key}) : super(key: key);

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
          children: const <Widget>[
            MovingToolsList(
              noOfElementsToRemoveFromList: 10,
              noOfElementsToAddInIndex: 0,
              delayMilliseconds: 100,
              durationSeconds: 100,
            ),
            VerticalDivider(width: 0),
            MovingToolsList(
              noOfElementsToRemoveFromList: 10,
              noOfElementsToAddInIndex: 5,
              delayMilliseconds: 100,
              durationSeconds: 100,
            ),
            VerticalDivider(width: 0),
            MovingToolsList(
              noOfElementsToRemoveFromList: 10,
              noOfElementsToAddInIndex: 10,
              delayMilliseconds: 100,
              durationSeconds: 100,
            ),
          ],
        ),
      ),
      secondHoleChild:
          const Center(child: OnBoardingText(onBoardingText: 'Welcome!')),
    );
  }
}

/// Second screen of on boarding screen TabView.
class TabViewSecondScreen extends StatelessWidget {
  /// Defining [TabViewSecondScreen] constructor.
  const TabViewSecondScreen({Key? key}) : super(key: key);

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
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                ThemeChooserWidget(),
                DynamicThemeSwitchTile(),
                ThemeModeSwitcher(),
                Align(
                  alignment: Alignment.topRight,
                  child: ResetAppThemeSettings(),
                ),
              ],
            ),
          ),
        ),
      ),
      secondHoleChild: const Center(
        child: OnBoardingText(onBoardingText: 'Customize App Theme!'),
      ),
    );
  }
}

/// Widget for on boarding screen TabView done button.
class DoneButton extends StatelessWidget {
  /// Defining [DoneButton] constructor.
  const DoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return FilledButton.icon(
          onPressed: () {
            onBoardingFinish(context);
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Done'),
        );
      },
    );
  }
}

/// Widget for creating on boarding screen texts.
class OnBoardingText extends StatelessWidget {
  /// Defining [OnBoardingText] constructor.
  const OnBoardingText({Key? key, required this.onBoardingText})
      : super(key: key);

  /// Takes on boarding screen text.
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

/// Used to create moving list of tools for decoration in on boarding screen.
class MovingToolsList extends StatelessWidget {
  /// Defining [MovingToolsList] constructor.
  const MovingToolsList({
    Key? key,
    required this.noOfElementsToRemoveFromList,
    required this.noOfElementsToAddInIndex,
    required this.delayMilliseconds,
    required this.durationSeconds,
  }) : super(key: key);

  /// Takes no. of elements that should be removed from the [appTools] list.
  final int noOfElementsToRemoveFromList;

  /// Takes no. of elements that should be added in the [appTools] list.
  final int noOfElementsToAddInIndex;

  /// Takes the delay that should be taken before starting the animation.
  final int delayMilliseconds;

  /// Takes the duration in which the animation should be completed.
  final int durationSeconds;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).colorScheme.surface,
              Colors.transparent,
              Colors.transparent,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const <double>[
              0.0,
              0.2,
              0.8,
              1.0
            ], // 10% surface, 80% transparent, 10% surface
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: LayoutBuilder(
          builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
            double viewportFraction = 1 / (boxConstraints.maxHeight / 100);
            return CarouselSlider.builder(
              options: CarouselOptions(
                pageSnapping: false,
                viewportFraction: viewportFraction,
                height: boxConstraints.maxHeight,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                scrollDirection: Axis.vertical,
              ),
              itemCount: appTools.length - noOfElementsToRemoveFromList,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final int first = index + noOfElementsToAddInIndex;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Divider(height: 0),
                    Expanded(
                      child: AppToolDisplayWidget(index: first),
                    ),
                    const Divider(height: 0),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// A widget for displaying a app tool anywhere in on boarding screen.
class AppToolDisplayWidget extends StatelessWidget {
  /// Defining [AppToolDisplayWidget] constructor.
  const AppToolDisplayWidget({Key? key, required this.index}) : super(key: key);

  /// Index of the app tool from [appTools].
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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

/// Model class for describing tools provided by app.
class AppTool {
  /// Defining [AppTool] constructor.
  const AppTool({required this.toolName, required this.toolIconsData});

  /// Name of the tool.
  final String toolName;

  /// [IconData] of the tool.
  final IconData toolIconsData;
}

/// App all tools names and icons.
final List<AppTool> appTools = <AppTool>[
  const AppTool(toolName: 'Merge PDF', toolIconsData: Icons.merge),
  const AppTool(toolName: 'Split PDF', toolIconsData: Icons.call_split),
  const AppTool(
    toolName: 'Rotate PDF Pages',
    toolIconsData: Icons.rotate_right,
  ),
  const AppTool(toolName: 'Delete PDF Pages', toolIconsData: Icons.delete),
  const AppTool(toolName: 'Reorder PDF Pages', toolIconsData: Icons.reorder),
  const AppTool(toolName: 'PDF To Image', toolIconsData: Icons.image),
  const AppTool(toolName: 'Compress PDF', toolIconsData: Icons.compress),
  const AppTool(
    toolName: 'Watermark PDF',
    toolIconsData: Icons.branding_watermark,
  ),
  const AppTool(toolName: 'Image To PDF', toolIconsData: Icons.picture_as_pdf),
  const AppTool(toolName: 'Encrypt PDF', toolIconsData: Icons.lock),
  const AppTool(toolName: 'Decrypt PDF', toolIconsData: Icons.lock_open),
  const AppTool(toolName: 'Compress Image', toolIconsData: Icons.compress),
  const AppTool(toolName: 'Crop Image', toolIconsData: Icons.crop),
  const AppTool(toolName: 'Rotate Image', toolIconsData: Icons.rotate_right),
  const AppTool(toolName: 'Flip Image', toolIconsData: Icons.flip),
];
