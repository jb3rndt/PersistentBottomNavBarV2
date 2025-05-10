part of "../persistent_bottom_nav_bar_v2.dart";

class PersistentTabViewScaffold extends StatefulWidget {
  const PersistentTabViewScaffold({
    required this.tabBar,
    required this.tabBuilder,
    required this.controller,
    required this.tabIDsOrder,
    super.key,
    this.backgroundColor,
    this.avoidBottomPadding = true,
    this.margin = EdgeInsets.zero,
    this.resizeToAvoidBottomInset = true,
    this.stateManagement = false,
    this.gestureNavigationEnabled = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
    this.hideNavigationBar = false,
    this.hideOnScrollVelocity = 0,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.drawerEdgeDragWidth,
    this.animatedTabBuilder,
    this.navigationShell,
  });

  final Widget tabBar;

  final Widget? drawer;

  final double? drawerEdgeDragWidth;

  final PersistentTabController controller;

  final List<String> tabIDsOrder;

  final IDWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final bool avoidBottomPadding;

  final EdgeInsets margin;

  final bool hideNavigationBar;

  final int hideOnScrollVelocity;

  final bool stateManagement;

  final bool gestureNavigationEnabled;

  final NavBarOverlap navBarOverlap;

  final ScreenTransitionAnimation screenTransitionAnimation;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final AnimatedTabBuilder? animatedTabBuilder;

  final StatefulNavigationShell? navigationShell;

  @override
  State<PersistentTabViewScaffold> createState() =>
      _PersistentTabViewScaffoldState();
}

class _PersistentTabViewScaffoldState extends State<PersistentTabViewScaffold>
    with TickerProviderStateMixin {
  late bool _navBarFullyShown = !widget.hideNavigationBar;
  late final AnimationController _hideNavBarAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _animation = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(
    CurvedAnimation(
      parent: _hideNavBarAnimationController,
      curve: Curves.ease,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (widget.hideNavigationBar) {
      _hideNavBarAnimationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(PersistentTabViewScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hideNavigationBar != oldWidget.hideNavigationBar) {
      if (widget.hideNavigationBar) {
        _hideNavBarAnimationController.forward();
        setState(() {
          _navBarFullyShown = false;
        });
      } else {
        _hideNavBarAnimationController.reverse().whenComplete(() {
          setState(() {
            _navBarFullyShown = true;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _hideNavBarAnimationController.dispose();
    super.dispose();
  }

  Widget buildTab(BuildContext context, String tabID) {
    double overlap = 0;
    if (!_navBarFullyShown || widget.margin.bottom != 0) {
      overlap = double.infinity;
    } else {
      overlap = widget.navBarOverlap.overlap;
    }

    return PersistentTab(
      bottomMargin: max(
        0,
        MediaQuery.of(context).padding.bottom - overlap,
      ),
      child: widget.tabBuilder(context, tabID),
    );
  }

  @override
  Widget build(BuildContext context) => HideOnScroll(
        hideOnScrollVelocity: widget.hideOnScrollVelocity,
        onScroll: (offsetPercentage) {
          final currentValue = _hideNavBarAnimationController.value;
          if (currentValue < 1 && offsetPercentage > 0) {
            // Hide NavBar
            _hideNavBarAnimationController.value =
                min(currentValue + offsetPercentage, 1);
          } else if (currentValue > 0 && offsetPercentage < 0) {
            // Reveal NavBar
            _hideNavBarAnimationController.value =
                max(currentValue + offsetPercentage, 0);
          }
        },
        child: Scaffold(
          key: widget.controller.scaffoldKey,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          backgroundColor: widget.backgroundColor,
          extendBody: widget.navBarOverlap.overlap != 0 || !_navBarFullyShown,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
          drawer: widget.drawer,
          body: Builder(
            builder: (bodyContext) => MediaQuery(
              data: MediaQuery.of(bodyContext).copyWith(
                padding:
                    _navBarFullyShown ? null : MediaQuery.of(context).padding,
                viewPadding: !_navBarFullyShown
                    ? MediaQuery.of(context).viewPadding
                    : widget.navBarOverlap.overlap != 0
                        ? MediaQuery.of(bodyContext).padding
                        : null,
                viewInsets: EdgeInsets.zero,
              ),
              child: widget.navigationShell ??
                  (widget.gestureNavigationEnabled
                      ? _SwipableTabSwitchingView(
                          currentTabID:
                              widget.tabIDsOrder[widget.controller.index],
                          tabIDsOrder: widget.tabIDsOrder,
                          controller: widget.controller,
                          tabBuilder: buildTab,
                          stateManagement: widget.stateManagement,
                          screenTransitionAnimation:
                              widget.screenTransitionAnimation,
                        )
                      : _TabSwitchingView(
                          currentTabID:
                              widget.tabIDsOrder[widget.controller.index],
                          tabIDsOrder: widget.tabIDsOrder,
                          tabBuilder: buildTab,
                          stateManagement: widget.stateManagement,
                          screenTransitionAnimation:
                              widget.screenTransitionAnimation,
                          animatedTabBuilder: widget.animatedTabBuilder,
                        )),
            ),
          ),
          bottomNavigationBar: NCSizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: widget.margin,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: !widget.avoidBottomPadding
                      // safespace should be ignored, so the bottom inset is removed before it could be applied by any safearea child (e.g. in DecoratedNavBar).
                      ? EdgeInsets.zero
                      // The padding might have been consumed by the keyboard, so it is maintained here. Using maintainBottomViewPadding would require that in the DecoratedNavBar as well, but only if the bottom padding should not be avoided. So it is easier to just maintain the padding here.
                      : MediaQuery.of(context).viewPadding,
                ),
                child: SafeArea(
                  top: false,
                  right: false,
                  left: false,
                  bottom:
                      widget.avoidBottomPadding && widget.margin.bottom != 0,
                  child: widget.tabBar,
                ),
              ),
            ),
          ),
        ),
      );
}

class PersistentTab extends StatelessWidget {
  const PersistentTab({
    super.key,
    this.child,
    this.bottomMargin = 0.0,
  });

  final Widget? child;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: bottomMargin),
        child: child,
      );
}

class HideOnScroll extends StatefulWidget {
  const HideOnScroll({
    required this.onScroll,
    required this.child,
    super.key,
    this.hideOnScrollVelocity = 0,
  });

  final int hideOnScrollVelocity;
  final Widget child;
  final Function(double) onScroll;

  @override
  State<HideOnScroll> createState() => _HideOnScrollState();
}

class _HideOnScrollState extends State<HideOnScroll> {
  double scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.hideOnScrollVelocity == 0) {
      return widget.child;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        final diff = scrollInfo.metrics.pixels - scrollOffset;
        scrollOffset = scrollInfo.metrics.pixels;
        widget.onScroll(diff / widget.hideOnScrollVelocity);
        return true;
      },
      child: widget.child,
    );
  }
}

class _SwipableTabSwitchingView extends StatefulWidget {
  const _SwipableTabSwitchingView({
    required this.currentTabID,
    required this.tabIDsOrder,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    required this.controller,
  }) : assert(tabIDsOrder.length > 0, "tabIDsOrder must contain items");

  final String currentTabID;
  final List<String> tabIDsOrder;
  final IDWidgetBuilder tabBuilder;
  final bool stateManagement;
  final ScreenTransitionAnimation screenTransitionAnimation;
  final PersistentTabController controller;

  @override
  _SwipableTabSwitchingViewState createState() =>
      _SwipableTabSwitchingViewState();
}

class _SwipableTabSwitchingViewState extends State<_SwipableTabSwitchingView> {
  late PageController _pageController;
  bool isSwiping = false;
  bool pageUpdateCausedBySwipe = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.tabIDsOrder.indexOf(widget.currentTabID));
  }

  @override
  void didUpdateWidget(_SwipableTabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabID != oldWidget.currentTabID &&
        !pageUpdateCausedBySwipe) {
      isSwiping = false;
      _pageController.animateToPage(
        widget.tabIDsOrder.indexOf(widget.currentTabID),
        duration: widget.screenTransitionAnimation.duration,
        curve: widget.screenTransitionAnimation.curve,
      );
    }
    pageUpdateCausedBySwipe = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (event) {
          isSwiping = true;
          pageUpdateCausedBySwipe = true;
          widget.controller.jumpToTab(_pageController.page!.round());
          pageUpdateCausedBySwipe = false;
        },
        child: PageView(
          controller: _pageController,
          scrollBehavior: const ScrollBehavior().copyWith(
            overscroll: false,
          ),
          children: widget.tabIDsOrder
              .map(
                (id) => FocusScope(
                  key: widget.stateManagement ? null : UniqueKey(),
                  node: FocusScopeNode(),
                  child: widget.stateManagement
                      ? KeepAlivePage(
                          child: widget.tabBuilder(context, id),
                        )
                      : widget.tabBuilder(context, id),
                ),
              )
              .toList(),
          onPageChanged: (i) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (isSwiping) {
              pageUpdateCausedBySwipe = true;
              widget.controller.jumpToTab(i);
            }
          },
        ),
      );
}

class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

typedef AnimatedTabBuilder = Widget Function(
  BuildContext context,
  int index,
  double animationValue,
  int newIndex,
  int oldIndex,
  Widget child,
);

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabID,
    required this.tabIDsOrder,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    this.animatedTabBuilder,
  }) : assert(tabIDsOrder.length > 0, "tabIDsOrder must contain items");

  final String currentTabID;
  final List<String> tabIDsOrder;
  final IDWidgetBuilder tabBuilder;
  final bool stateManagement;
  final ScreenTransitionAnimation screenTransitionAnimation;
  final AnimatedTabBuilder? animatedTabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView>
    with TickerProviderStateMixin {
  late final Map<String, TabMetaData> tabMetaData = {
    for (final tabID in widget.tabIDsOrder) tabID: TabMetaData(),
  };
  late AnimationController animationController;
  late Animation<double> animation;
  late String currentTabID = widget.currentTabID;
  String? previousTabID;
  late Key? key = widget.stateManagement ? null : UniqueKey();
  bool get showAnimation =>
      previousTabID != currentTabID &&
      widget.screenTransitionAnimation.duration != Duration.zero &&
      previousTabID != null &&
      widget.tabIDsOrder.contains(previousTabID);

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  void _initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.screenTransitionAnimation.duration,
    );
    animationController.addListener(() {
      if (animationController.isCompleted) {
        if (!widget.stateManagement) {
          setState(() {
            key = UniqueKey();
          });
        } else {
          setState(() {});
        }
      }
    });

    animation = Tween<double>(begin: 1, end: 1)
        .chain(CurveTween(curve: widget.screenTransitionAnimation.curve))
        .animate(animationController);
    if (showAnimation) {
      animationController.animateTo(1, duration: Duration.zero);
    }
  }

  void startAnimation() {
    animationController.reset();
    animation = Tween<double>(
      begin: 0,
      end: 1,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation.curve))
        .animate(animationController);

    animationController.forward();
    return;
  }

  Widget _buildAnimatedTab(
    BuildContext context,
    int index,
    double animationValue,
    int newIndex,
    int oldIndex,
    Widget child,
  ) {
    final bool slideLeft = Directionality.of(context) == TextDirection.ltr
        ? newIndex > oldIndex
        : newIndex < oldIndex;
    final bool isNewPage = index == newIndex;
    final double offset = slideLeft
        ? (isNewPage ? 1 - animationValue : -animationValue)
        : (isNewPage ? animationValue - 1 : animationValue);
    return FractionalTranslation(
      translation: Offset(offset, 0),
      child: child,
    );
  }

  Widget _buildScreens() => Stack(
        fit: StackFit.expand,
        children: widget.tabIDsOrder.map((tabID) {
          tabMetaData[tabID] ??= TabMetaData();
          final metaData = tabMetaData[tabID]!;
          final bool active = tabID == currentTabID ||
              (!animation.isCompleted &&
                  tabID == previousTabID &&
                  showAnimation);
          metaData.shouldBuild =
              active || (metaData.shouldBuild && widget.stateManagement);

          return Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabMetaData[tabID]?.focusNode,
                child: Builder(
                  builder: (context) => metaData.shouldBuild
                      ? showAnimation
                          ? AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) =>
                                  widget.animatedTabBuilder?.call(
                                    context,
                                    widget.tabIDsOrder.indexOf(tabID),
                                    animation.value,
                                    widget.tabIDsOrder.indexOf(currentTabID),
                                    widget.tabIDsOrder.indexOf(previousTabID!),
                                    child!,
                                  ) ??
                                  _buildAnimatedTab(
                                    context,
                                    widget.tabIDsOrder.indexOf(tabID),
                                    animation.value,
                                    widget.tabIDsOrder.indexOf(currentTabID),
                                    widget.tabIDsOrder.indexOf(previousTabID!),
                                    child!,
                                  ),
                              child: widget.tabBuilder(context, tabID),
                            )
                          : widget.tabBuilder(context, tabID)
                      : Container(),
                ),
              ),
            ),
          );
        }).toList(),
      );

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // this assumes the tabIDsOrder does not change in place, so oldWidget.tabIDsOrder is actually a different object from widget.tabIDsOrder
    final commonIDs =
        oldWidget.tabIDsOrder.toSet().intersection(widget.tabIDsOrder.toSet());

    if (commonIDs.length != oldWidget.tabIDsOrder.length ||
        commonIDs.length != widget.tabIDsOrder.length ||
        oldWidget.screenTransitionAnimation !=
            widget.screenTransitionAnimation) {
      animationController.dispose();
      _initAnimationController();
    }

    if (commonIDs.length != oldWidget.tabIDsOrder.length ||
        commonIDs.length != widget.tabIDsOrder.length) {
      tabMetaData.alignKeys(
        widget.tabIDsOrder,
        (id) => TabMetaData(),
        onRemove: (id, metaData) => metaData.focusNode.dispose(),
      );
    }
    if (widget.currentTabID != oldWidget.currentTabID) {
      currentTabID = widget.currentTabID;
      previousTabID = oldWidget.currentTabID;
      tabMetaData[previousTabID]?.focusNode.unfocus();
      if (showAnimation) {
        startAnimation();
      }
    }
  }

  @override
  void dispose() {
    for (final tabMetaData in tabMetaData.values) {
      tabMetaData.focusNode.dispose();
    }
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.stateManagement
      ? _buildScreens()
      : KeyedSubtree(
          key: key,
          child: _buildScreens(),
        );
}

class NCSizeTransition extends AnimatedWidget {
  const NCSizeTransition({
    required Animation<double> sizeFactor,
    super.key,
    this.child,
  }) : super(listenable: sizeFactor);

  Animation<double> get sizeFactor => listenable as Animation<double>;

  final Widget? child;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        heightFactor: max(sizeFactor.value, 0),
        child: child,
      );
}

class TabMetaData {
  TabMetaData()
      : shouldBuild = false,
        focusNode = FocusScopeNode();

  bool shouldBuild;
  FocusScopeNode focusNode;
}
