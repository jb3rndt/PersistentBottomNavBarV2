part of "../persistent_bottom_nav_bar_v2.dart";

/// A highly customizable persistent bottom navigation bar for flutter.
///
/// To learn more, check out the [Readme](https://github.com/jb3rndt/PersistentBottomNavBarV2).
class PersistentTabView extends StatefulWidget {
  /// Creates a fullscreen container with a navigation bar at the bottom. The
  /// navigation bar style can be chosen from [NavBarStyle]. If you want to
  /// make a custom style use [PersistentTabView.custom].
  ///
  /// The different screens get displayed in the container when an item is
  /// selected in the navigation bar.
  const PersistentTabView({
    required this.tabs,
    required this.navBarBuilder,
    super.key,
    this.controller,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onTabChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.selectedTabContext,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.popAllScreensOnTapAnyTabs = false,
    this.popActionScreens = PopActionScreensType.all,
    this.avoidBottomPadding = true,
    @Deprecated(
      "Wrap [PersistentTabView] with [PopScope] instead. Look here for migration: https://docs.flutter.dev/release/breaking-changes/android-predictive-back",
    )
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
    this.drawer,
    this.drawerEdgeDragWidth,
    this.gestureNavigationEnabled = false,
    this.animatedTabBuilder,
  }) : navigationShell = null;

  const PersistentTabView.router({
    required List<PersistentRouterTabConfig> this.tabs,
    required this.navBarBuilder,
    required StatefulNavigationShell this.navigationShell,
    super.key,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onTabChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.selectedTabContext,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.popAllScreensOnTapAnyTabs = false,
    this.popActionScreens = PopActionScreensType.all,
    this.avoidBottomPadding = true,
    @Deprecated(
      "Wrap [PersistentTabView] with [PopScope] instead. Look here for migration: https://docs.flutter.dev/release/breaking-changes/android-predictive-back",
    )
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.drawer,
    this.drawerEdgeDragWidth,
    this.gestureNavigationEnabled = false,
    this.animatedTabBuilder,
  })  : screenTransitionAnimation = const ScreenTransitionAnimation(),
        controller = null;

  /// List of persistent bottom navigation bar items to be displayed in the navigation bar.
  final List<PersistentTabConfig> tabs;

  /// Controller for persistent bottom navigation bar. Will be declared if left empty.
  final PersistentTabController? controller;

  /// Background color of the Tab View. If your tabs have transparent background
  /// or your navbar has rounded corners, this color will be visible.
  /// If you want to change the navbar color, use [NavBarDecoration] directly
  /// on your navbar.
  final Color backgroundColor;

  /// Callback when the tab changed. The index of the new tab is passed as a parameter.
  final ValueChanged<int>? onTabChanged;

  /// A button displayed floating above the screens content.
  /// The position can be changed using [floatingActionButtonLocation].
  /// The button will be displayed on all screens equally.
  ///
  /// Typically a [FloatingActionButton].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  ///
  /// Defaults to [FloatingActionButtonLocation.endFloat].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Specifies the navBarHeight
  ///
  /// Defaults to `kBottomNavigationBarHeight` which is `56.0`.
  final double navBarHeight;

  /// Specifies how much the navBar should float above
  /// the tab content. Defaults to [NavBarOverlap.full].
  final NavBarOverlap navBarOverlap;

  /// The margin around the navigation bar.
  final EdgeInsets margin;

  /// Builder for the Navigation Bar Widget. This also exposes
  /// [NavBarConfig] for further control. You can either pass a custom
  /// Widget or choose one of the predefined Navigation Bars.
  final Widget Function(NavBarConfig) navBarBuilder;

  /// If `true`, the navBar will be positioned so the content does not overlap with the bottom padding caused by system elements. If ``false``, the navBar will be positioned at the bottom of the screen. Defaults to `true`.
  final bool avoidBottomPadding;

  /// Handles android back button actions. Defaults to `true`.
  ///
  /// Action based on scenarios:
  /// 1. If the you are on the first tab with all screens popped of the given tab, the app will close.
  /// 2. If you are on another tab with all screens popped of that given tab, you will be switched to first tab.
  /// 3. If there are screens pushed on the selected tab, a screen will pop on a respective back button press.
  final bool handleAndroidBackButtonPress;

  /// If an already selected tab is pressed/tapped again, all the screens pushed
  /// on that particular tab will pop until the first screen in the stack.
  /// Defaults to `true`.
  final bool popAllScreensOnTapOfSelectedTab;

  /// All the screens pushed on that particular tab will pop until the first screen in the stack, whether the tab is already selected or not. Defaults to `false`.
  final bool popAllScreensOnTapAnyTabs;

  /// If set all pop until to first screen else set once pop once
  final PopActionScreensType? popActionScreens;

  final bool resizeToAvoidBottomInset;

  /// Preserves the state of each tab's screen. `true` by default.
  final bool stateManagement;

  /// If you want to perform a custom action on Android when exiting the app,
  /// you can write your logic here. Returns context of the selected screen.
  @Deprecated(
    "Wrap [PersistentTabView] with [PopScope] instead. Look here for migration: https://docs.flutter.dev/release/breaking-changes/android-predictive-back",
  )
  final Future<bool> Function(BuildContext)? onWillPop;

  /// Returns the context of the selected tab.
  final Function(BuildContext)? selectedTabContext;

  /// Screen transition animation properties when switching tabs.
  final ScreenTransitionAnimation screenTransitionAnimation;

  /// Hides the navigation bar with a transition animation. Defaults to `false`.
  final bool hideNavigationBar;

  /// If set to `true`, you can additionally swipe left/right to change the tab. Defaults to `false`.
  final bool gestureNavigationEnabled;

  /// A Drawer that should be accessible in every tab. To open the drawer, call `controller.openDrawer()` on your [PersistentTabController]. The hamburger menu button will not be automatically added to the appbar, but you can add it easily by using the following code in the initial screen of each tab:
  /// ```dart
  /// appBar: AppBar(
  ///   ...
  ///   leading: IconButton(
  ///     icon: const Icon(Icons.menu),
  ///     iconSize: 24,
  ///     onPressed: () {
  ///       controller.openDrawer();
  ///     },
  ///     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  ///   ),
  /// )
  /// ```
  final Widget? drawer;

  final double? drawerEdgeDragWidth;

  /// With this builder, you can customize the animation of the transition between tabs.
  /// This is called everytime the tab changes and builds the transition for that.
  /// You will be given
  /// 1. a BuildContext
  /// 2. the index of the tab that is currently built (while the animation is running, two tabs are built simultaneously, so you might need to change the behavior of your builder, depending on whether you are looking at the previous or the new tab)
  /// 3. the animation value (so the progress of the animation between 0 and 1)
  /// 4. the index of the old tab
  /// 5. the index of the newly selected tab
  /// 6. the child, so the tab itself
  ///
  /// The default animation builder looks like this:
  /// ```dart
  ///  final double yOffset = newIndex > index
  ///      ? -animationValue
  ///      : (newIndex < index
  ///          ? animationValue
  ///          : (index < oldIndex ? animationValue - 1 : 1 - animationValue));
  ///  return FractionalTranslation(
  ///    translation: Offset(yOffset, 0),
  ///    child: child,
  ///  );
  /// ```
  final AnimatedTabBuilder? animatedTabBuilder;

  final StatefulNavigationShell? navigationShell;

  @override
  State<PersistentTabView> createState() => _PersistentTabViewState();
}

class _PersistentTabViewState extends State<PersistentTabView> {
  late List<BuildContext?> _contextList;
  late PersistentTabController _controller;
  bool _sendScreenContext = false;
  late final List<GlobalKey<CustomTabViewState>> _tabKeys = List.generate(
    widget.tabs.length,
    (index) => GlobalKey<CustomTabViewState>(),
  );
  late bool canPop =
      widget.handleAndroidBackButtonPress && widget.onWillPop == null;
  late final _navigatorKeys = widget.tabs
      .map((config) => config.navigatorConfig.navigatorKey)
      .fillNullsWith((index) => GlobalKey<NavigatorState>())
      .toList();

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ??
        PersistentTabController(
          initialIndex: widget.navigationShell?.currentIndex ?? 0,
        );
    _controller.onIndexChanged = widget.onTabChanged;

    _contextList = List<BuildContext?>.filled(widget.tabs.length, null);

    _controller.addListener(() {
      if (widget.selectedTabContext != null) {
        _sendScreenContext = true;
      }
      if (mounted) {
        setState(() {
          canPop = calcCanPop();
        });
      }
    });

    if (widget.selectedTabContext != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        widget.selectedTabContext!(_contextList[_controller.index]!);
      });
    }
  }

  @override
  void didUpdateWidget(covariant PersistentTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell != null &&
        widget.navigationShell != oldWidget.navigationShell &&
        widget.navigationShell!.currentIndex != _controller.index) {
      _controller.jumpToTab(widget.navigationShell!.currentIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildScreen(int index) => CustomTabView(
        key: _tabKeys[index],
        navigatorConfig: widget.tabs[index].navigatorConfig
            .copyWith(navigatorKey: _navigatorKeys[index]),
        home: (screenContext) {
          _contextList[index] = screenContext;
          if (_sendScreenContext && index == _controller.index) {
            _sendScreenContext = false;
            widget.selectedTabContext!(_contextList[_controller.index]!);
          }
          return widget.tabs[index].screen;
        },
      );

  Widget navigationBarWidget() => PersistentTabViewScaffold(
        controller: _controller,
        hideNavigationBar: widget.hideNavigationBar,
        tabCount: widget.tabs.length,
        stateManagement: widget.stateManagement,
        backgroundColor: widget.backgroundColor,
        navBarOverlap: widget.navBarOverlap,
        opacities: widget.tabs.map((e) => e.item.opacity).toList(),
        screenTransitionAnimation: widget.screenTransitionAnimation,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        avoidBottomPadding: widget.avoidBottomPadding,
        margin: widget.margin,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        gestureNavigationEnabled: widget.gestureNavigationEnabled,
        tabBar: widget.navBarBuilder(
          NavBarConfig(
            selectedIndex: _controller.index,
            items: widget.tabs.map((e) => e.item).toList(),
            navBarHeight: widget.navBarHeight,
            onItemSelected: (index) {
              if (widget.tabs[index].onPressed != null) {
                widget.tabs[index].onPressed!(context);
              } else {
                if (widget.navigationShell != null) {
                  widget.navigationShell!.goBranch(
                    index,
                    initialLocation: widget.popAllScreensOnTapOfSelectedTab &&
                        index == widget.navigationShell!.currentIndex,
                  );
                } else if (widget.popAllScreensOnTapOfSelectedTab &&
                    _controller.index == index) {
                  popAllScreens();
                } else {
                  _controller.jumpToTab(index);
                }
              }
            },
          ),
        ),
        tabBuilder: (context, index) => _buildScreen(index),
        animatedTabBuilder: widget.animatedTabBuilder,
        navigationShell: widget.navigationShell,
      );

  @override
  Widget build(BuildContext context) {
    if (_contextList.length != widget.tabs.length) {
      _contextList = List<BuildContext?>.filled(widget.tabs.length, null);
    }
    if ((widget.handleAndroidBackButtonPress || widget.onWillPop != null) &&
        widget.navigationShell == null) {
      return PopScope(
        canPop: canPop,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final navigator = Navigator.of(context);
          final shouldPop = await _canPopTabView();
          // This is only used when onWillPop is provided
          if (shouldPop) {
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              await SystemNavigator.pop();
            }
          }
        },
        child: NotificationListener<NavigationNotification>(
          onNotification: (notification) {
            final newCanPop =
                calcCanPop(subtreeCantHandlePop: !notification.canHandlePop);
            if (newCanPop != canPop) {
              setState(() {
                canPop = newCanPop;
              });
            }
            return false;
          },
          child: navigationBarWidget(),
        ),
      );
    } else {
      return navigationBarWidget();
    }
  }

  Future<bool> _canPopTabView() async {
    if (!widget.handleAndroidBackButtonPress && widget.onWillPop != null) {
      return widget.onWillPop!(_contextList[_controller.index]!);
    } else {
      final navigator = _navigatorKeys[_controller.index].currentState!;
      if (_controller.historyIsEmpty() && !navigator.canPop()) {
        if (widget.handleAndroidBackButtonPress && widget.onWillPop != null) {
          return widget.onWillPop!(_contextList[_controller.index]!);
        }
        // CanPop should be true in this case, so we dont return true because the pop already happened
        return false;
      } else {
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          _controller.jumpToPreviousTab();
        }
        return false;
      }
    }
  }

  void popAllScreens() {
    if (widget.popAllScreensOnTapOfSelectedTab ||
        widget.popAllScreensOnTapAnyTabs) {
      final navigator = _navigatorKeys[_controller.index].currentState!;
      if (!navigator.canPop()) {
        widget.tabs[_controller.index].onSelectedTabPressWhenNoScreensPushed
            ?.call();
      } else {
        if (widget.popActionScreens == PopActionScreensType.once) {
          navigator.maybePop(context);
        } else {
          navigator.popUntil((route) => route.isFirst);
        }
      }
    }
  }

  bool calcCanPop({bool? subtreeCantHandlePop}) =>
      widget.handleAndroidBackButtonPress &&
      widget.onWillPop == null &&
      _controller.historyIsEmpty() &&
      _navigatorKeys[_controller.index].currentState !=
          null && // Required if historyLength == 0 because historyIsEmpty() is already true when switching to uninitialized tabs instead of only when going back.
      (subtreeCantHandlePop ??
          !_navigatorKeys[_controller.index].currentState!.canPop());
}
