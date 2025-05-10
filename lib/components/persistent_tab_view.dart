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
    this.navBarOverlap = const NavBarOverlap.none(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onTabChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.keepNavigatorHistory = true,
    this.selectedTabPressConfig = const SelectedTabPressConfig(),
    this.avoidBottomPadding = true,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.hideOnScrollVelocity = 0,
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
    this.navBarOverlap = const NavBarOverlap.none(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onTabChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.keepNavigatorHistory = true,
    this.selectedTabPressConfig = const SelectedTabPressConfig(),
    this.avoidBottomPadding = true,
    this.stateManagement = true,
    this.hideOnScrollVelocity = 0,
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

  /// Controller for persistent bottom navigation bar. You can use this to e.g. change the selected tab programmatically. If you don't provide a controller, a new one will be created.
  ///
  /// **Important**: If you provide a controller, you are responsible for disposing it. If you don't provide a controller, the controller will be disposed automatically.
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

  /// Works similar to [Scaffold.extendBody].
  ///
  /// If set to [NavBarOverlap.full], the tabs will extend to the bottom of
  /// the screen, so the [bottomNavigationBar] will overlap the tab content.
  ///
  /// If set to [NavBarOverlap.none], the tabs will only extend to the top of
  /// the [bottomNavigationBar], so it will not overlap the tab content.
  ///
  /// This is useful when the [bottomNavigationBar] has a non-rectangular shape,
  /// like rounded corners or [CircularNotchedRectangle]. In this case
  /// specifying `NavBarOverlap.full` ensures that the tab content will be
  /// visible through the exposed spaces.
  ///
  /// Defaults to [NavBarOverlap.none].
  final NavBarOverlap navBarOverlap;

  /// The margin around the navigation bar.
  final EdgeInsets margin;

  /// Builder for the Navigation Bar Widget. This also exposes
  /// [NavBarConfig] for further control. You can either pass a custom
  /// Widget or choose one of the predefined Navigation Bars.
  final Widget Function(NavBarConfig) navBarBuilder;

  /// If `true`, the navBar will be positioned so the content does not overlap
  /// with the bottom padding caused by system elements. If `false`, the navBar
  /// will be positioned at the bottom of the screen. Defaults to `true`.
  final bool avoidBottomPadding;

  /// Handles android back button actions. Defaults to `true`.
  ///
  /// Action based on scenarios:
  /// 1. If there are screens pushed on the selected tab, it will pop one screen.
  /// 2. If there are no screens pushed on the selected tab, it will go to the previous tab or exit the app, depending on what you set for [PersistentTabController.historyLength].
  final bool handleAndroidBackButtonPress;

  /// This defines the behavior when the selected tab is pressed again.
  /// Possible configs are:
  /// 1. `onPressed` - A callback that gets called when the selected tab is pressed again.
  /// 2. `popAction` - Defines how many screens should be popped of the navigator of the selected tab, when the selected tab is pressed again.
  /// 3. `scrollToTop` - If set to `true`, the selected tab will scroll to the top when the selected tab is pressed again. (Requires a [ScrollController] to be set in the [PersistentTabConfig] of the tab this should apply to.)
  final SelectedTabPressConfig selectedTabPressConfig;

  final bool resizeToAvoidBottomInset;

  /// Preserves the state of each tab's screen, including pushed screens inside that tab. `true` by default.
  /// If you only want to preserve the state of each tab but not the screens pushed inside that tab, set `keepNavigatorHistory` to `false`.
  final bool stateManagement;

  /// If set to `false`, the history of each tab's navigator will be cleared when switching tabs. Defaults to `true`.
  ///
  /// NOTE: This will only have an effect if `stateManagement` is set to `true`.
  final bool keepNavigatorHistory;

  /// Screen transition animation properties when switching tabs.
  final ScreenTransitionAnimation screenTransitionAnimation;

  /// Use this to hide the navigation bar when the user scrolls down and show
  /// it when the user scrolls up. This feature will be enabled if you provide
  /// a value greater than 0. Defaults to `0`. Recommended value is `200`. This
  /// means that the user has to scroll 200 pixels in the opposite direction to
  /// hide/show the navigation bar.
  final int hideOnScrollVelocity;

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
  late PersistentTabController _controller;
  late final Map<String, GlobalKey<CustomTabViewState>> _tabKeys = {
    for (var tab in widget.tabs) tab.id: GlobalKey<CustomTabViewState>(),
  };
  late final List<String> tabIDs = widget.tabs.map((e) => e.id).toList();
  late bool canPop = widget.handleAndroidBackButtonPress;

  PersistentTabConfig tab(String id) => widget.tabs.firstWhere(
        (tab) => tab.id == id,
      );

  @override
  void initState() {
    super.initState();

    validateTabConfigs(widget.tabs);

    _controller = widget.controller ??
        PersistentTabController(
          initialIndex: widget.navigationShell?.currentIndex ?? 0,
        );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          canPop = calcCanPop();
        });
      }
      widget.onTabChanged?.call(_controller.index);

      tryGetAnimatedIconWrapperState(_controller.index)?.forward();
      if (_controller.previousIndex != null) {
        tryGetAnimatedIconWrapperState(_controller.previousIndex!)?.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        tryGetAnimatedIconWrapperState(_controller.index)
            ?.controller
            .animateTo(1, duration: Duration.zero);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PersistentTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    validateTabConfigs(widget.tabs);

    final newIDs = widget.tabs.map((e) => e.id).toList();
    final commonIDs = tabIDs.toSet().intersection(newIDs.toSet());

    if (commonIDs.length != tabIDs.length ||
        commonIDs.length != newIDs.length) {
      _tabKeys.alignKeys(newIDs, (id) => GlobalKey<CustomTabViewState>());

      var index = newIDs.indexOf(tabIDs[_controller.index]);
      if (index == -1) {
        index = _controller.initialIndex;
      }
      tabIDs
        ..clear()
        ..addAll(newIDs);

      _controller.jumpToTab(index);
    }
    if (widget.navigationShell != null &&
        widget.navigationShell != oldWidget.navigationShell &&
        widget.navigationShell!.currentIndex != _controller.index) {
      _controller.jumpToTab(widget.navigationShell!.currentIndex);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Widget _buildScreen(String id) {
    final screen = tab(id).screen;
    return CustomTabView(
      key: _tabKeys[id],
      navigatorConfig: tab(id).navigatorConfig,
      home: (context) => screen,
    );
  }

  Widget navigationBarWidget() => PersistentTabViewScaffold(
        controller: _controller,
        hideNavigationBar: widget.hideNavigationBar,
        hideOnScrollVelocity: widget.hideOnScrollVelocity,
        tabIDsOrder: tabIDs,
        stateManagement: widget.stateManagement,
        backgroundColor: widget.backgroundColor,
        navBarOverlap: widget.navBarOverlap,
        screenTransitionAnimation: widget.screenTransitionAnimation,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        avoidBottomPadding: widget.avoidBottomPadding,
        margin: widget.margin,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        gestureNavigationEnabled: widget.gestureNavigationEnabled,
        tabBuilder: (context, id) => _buildScreen(id),
        animatedTabBuilder: widget.animatedTabBuilder,
        navigationShell: widget.navigationShell,
        tabBar: widget.navBarBuilder(
          NavBarConfig(
            selectedIndex: _controller.index,
            items: widget.tabs.map((e) => e.item).toList(),
            onItemSelected: onItemSelected,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.navigationShell == null && widget.handleAndroidBackButtonPress) {
      return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          _handlePop();
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

  void onItemSelected(index) {
    if (widget.tabs[index].onPressed != null) {
      widget.tabs[index].onPressed!.call(context);
      return;
    }

    final oldIndex = _controller.index;

    if (widget.navigationShell != null) {
      final isSameTab = index == widget.navigationShell!.currentIndex;
      if (isSameTab) {
        widget.selectedTabPressConfig.onPressed?.call(false);
        if (widget.selectedTabPressConfig.scrollToTop) {
          tryScrollToTop(index);
        }
      }

      widget.navigationShell!.goBranch(
        index,
        initialLocation:
            widget.selectedTabPressConfig.popAction == PopActionType.all &&
                isSameTab,
      );
      return;
    }

    _controller.jumpToTab(index);
    if (!widget.keepNavigatorHistory) {
      popScreensAccodingToAction(PopActionType.all);
    }
    if (oldIndex == index) {
      final canPopScreens = _currentNavigatorState()?.canPop() ?? false;
      widget.selectedTabPressConfig.onPressed?.call(canPopScreens);
      if (canPopScreens) {
        popScreensAccodingToAction(
          widget.selectedTabPressConfig.popAction,
        );
      } else {
        if (widget.selectedTabPressConfig.scrollToTop) {
          tryScrollToTop(index);
        }
      }
    }
  }

  void tryScrollToTop(int index) {
    if (widget.tabs[index].scrollController != null) {
      widget.tabs[index].scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePop() {
    final navigator = _currentNavigatorState()!;
    if (navigator.canPop()) {
      navigator.pop();
    } else if (!_controller.historyIsEmpty()) {
      _controller.jumpToPreviousTab();
    }
  }

  NavigatorState? _currentNavigatorState() =>
      widget.tabs[_controller.index].navigatorConfig.navigatorKey.currentState;

  void popScreensAccodingToAction(PopActionType action) {
    final navigator = _currentNavigatorState();
    if (navigator != null) {
      switch (action) {
        case PopActionType.single:
          navigator.maybePop();
          break;
        case PopActionType.all:
          navigator.popUntil((route) => route.isFirst);
          break;
        case PopActionType.none:
          break;
      }
    }
  }

  bool calcCanPop({bool? subtreeCantHandlePop}) =>
      widget.handleAndroidBackButtonPress &&
      _controller.historyIsEmpty() &&
      _currentNavigatorState() !=
          null && // Required if historyLength == 0 because historyIsEmpty() is already true when switching to uninitialized tabs instead of only when going back.
      (subtreeCantHandlePop ?? !(_currentNavigatorState()?.canPop() ?? false));

  AnimatedIconWrapperState? tryGetAnimatedIconWrapperState(int index) {
    if (index < widget.tabs.length &&
        widget.tabs[index].item.icon is AnimatedIconWrapper) {
      final key = widget.tabs[index].item.icon.key!
          as GlobalKey<AnimatedIconWrapperState>;
      return key.currentState;
    }
    return null;
  }

  void validateTabConfigs(List<PersistentTabConfig> tabs) {
    assert(
      tabs.map((t) => t.id).toSet().length == tabs.length,
      "Tab IDs must be unique. Please make sure that all tabs have a unique ID. If left empty, a unique ID will be assigned automatically.",
    );
  }
}
