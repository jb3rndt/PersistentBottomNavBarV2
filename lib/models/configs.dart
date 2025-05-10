part of "../persistent_bottom_nav_bar_v2.dart";

/// Configuration for an individual Tab Item in the navbar.
/// Styling depends on the styling of the navigation bar.
/// Needs to be passed to the [PersistentTabView] widget via [PersistentTabConfig].
class ItemConfig {
  ItemConfig({
    required this.icon,
    Widget? inactiveIcon,
    this.title,
    this.activeForegroundColor = CupertinoColors.activeBlue,
    this.inactiveForegroundColor = CupertinoColors.systemGrey,
    Color? activeColorSecondary,
    this.inactiveBackgroundColor = Colors.transparent,
    this.textStyle = const TextStyle(
      color: CupertinoColors.systemGrey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
    this.iconSize = 26.0,
  })  : inactiveIcon = inactiveIcon ?? icon,
        activeBackgroundColor =
            activeColorSecondary ?? activeForegroundColor.withOpacity(0.2);

  /// Icon for the bar item.
  final Widget icon;

  /// Inactive icon for the bar item. Defaults to `icon`
  final Widget inactiveIcon;

  /// Title for the bar item. Might not appear is some `styles`.
  final String? title;

  /// Color for `icon` and `title` if item is selected. Defaults to `CupertinoColors.activeBlue`
  final Color activeForegroundColor;

  /// Color for `icon` and `title` if item is unselected. Defaults to `CupertinoColors.systemGrey`
  final Color inactiveForegroundColor;

  /// Color for the item background if selected (not used in every prebuilt style). Defaults to `activeColorPrimary.withOpacity(0.2)`
  final Color activeBackgroundColor;

  /// Color for the item background if unselected (not used in every prebuilt style). Defaults to `Colors.transparent`
  final Color inactiveBackgroundColor;

  /// `TextStyle` of the title's text. Defaults to `TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w400, fontSize: 12.0)`
  final TextStyle textStyle;

  final double iconSize;
}

/// Configuration for an individual Tab, including the screen to
/// be displayed and the item in the navbar.
/// Use `PersistentTabConfig.noScreen` if you want to use custom
/// behavior on a press of a NavBar item like display a modal
/// screen instead of switching the tab.
class PersistentTabConfig {
  PersistentTabConfig({
    required this.screen,
    required this.item,
    NavigatorConfig? navigatorConfig,
    this.scrollController,
  })  : navigatorConfig = navigatorConfig ?? NavigatorConfig(),
        onPressed = null,
        id = UniqueKey().toString();

  PersistentTabConfig.noScreen({
    required this.item,
    required void Function(BuildContext) this.onPressed,
    NavigatorConfig? navigatorConfig,
    this.scrollController,
  })  : navigatorConfig = navigatorConfig ?? NavigatorConfig(),
        screen = Container(),
        id = UniqueKey().toString();

  /// Unique identifier for the tab. This is used to identify the tab in the
  /// [PersistentTabView] widget.
  final String id;

  final Widget screen;

  final ItemConfig item;

  final NavigatorConfig navigatorConfig;

  /// Use this if you want an item in your navigation bar to perform an action instead of showing a tab. Example: display a modal screen.
  ///
  /// NOTE: This will override the default tab switiching behavior for this particular item.
  final void Function(BuildContext)? onPressed;

  /// This is required for each tab that should scroll to the top when the tab is pressed again. Pass the scroll controller of the content of the tab.
  final ScrollController? scrollController;

  @override
  int get hashCode => Object.hash(
        item,
        navigatorConfig,
        scrollController,
        screen,
        super.hashCode,
      );

  @override
  bool operator ==(Object other) =>
      other is PersistentTabConfig &&
      id == other.id &&
      screen == other.screen &&
      item == other.item &&
      navigatorConfig == other.navigatorConfig &&
      onPressed == other.onPressed &&
      scrollController == other.scrollController;
}

class SelectedTabPressConfig {
  const SelectedTabPressConfig({
    this.onPressed,
    this.popAction = PopActionType.all,
    this.scrollToTop = true,
  });

  /// Use this callback to get notified when the selected tab is pressed again. The provided parameter indicates whether there were any screens pushed on the navigator of that tab **before** the user pressed the selected tab.
  ///
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool)? onPressed;

  /// Defines how many screens should be popped of the navigator of the selected tab, when the selected tab is pressed again.
  /// If set to `PopActionType.all`, all screens will be popped on a single press.
  /// If set to `PopActionType.single`, only one screen will be popped on each press.
  /// If set to `PopActionType.none`, no screens will be popped on a press.
  /// Defaults to `PopActionScreensType.all`.
  final PopActionType popAction;

  /// Defines whether the content of the selected tab should be scrolled to the top when the selected tab is pressed again. This requires the content to be a scrollable widget and the scroll controller has to be passed to `PersistentTabConfig.scrollController` of the tab this should apply to.
  /// Defaults to `true`.
  final bool scrollToTop;
}

class PersistentRouterTabConfig extends PersistentTabConfig {
  PersistentRouterTabConfig({
    required super.item,
    super.scrollController,
  }) : super(screen: Container());
}

/// This is automatically generated. This is used to be passed to the
/// NavBar Widget and includes all the necessary configurations
/// for the NavBar.
class NavBarConfig {
  const NavBarConfig({
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });
  final int selectedIndex;
  final List<ItemConfig> items;
  final void Function(int) onItemSelected;

  ItemConfig get selectedItem => items[selectedIndex];

  NavBarConfig copyWith({
    int? selectedIndex,
    List<ItemConfig>? items,
    void Function(int)? onItemSelected,
  }) =>
      NavBarConfig(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        items: items ?? this.items,
        onItemSelected: onItemSelected ?? this.onItemSelected,
      );
}

class NavigatorConfig {
  NavigatorConfig({
    this.defaultTitle,
    this.routes = const {},
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final String? defaultTitle;

  final Map<String, WidgetBuilder> routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final String? initialRoute;

  final List<NavigatorObserver> navigatorObservers;

  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorConfig copyWith({
    String? defaultTitle,
    Map<String, WidgetBuilder>? routes,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    String? initialRoute,
    List<NavigatorObserver>? navigatorObservers,
    GlobalKey<NavigatorState>? navigatorKey,
  }) =>
      NavigatorConfig(
        defaultTitle: defaultTitle ?? this.defaultTitle,
        routes: routes ?? this.routes,
        onGenerateRoute: onGenerateRoute ?? this.onGenerateRoute,
        onUnknownRoute: onUnknownRoute ?? this.onUnknownRoute,
        initialRoute: initialRoute ?? this.initialRoute,
        navigatorObservers: navigatorObservers ?? this.navigatorObservers,
        navigatorKey: navigatorKey ?? this.navigatorKey,
      );
}
