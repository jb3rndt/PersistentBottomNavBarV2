part of "../persistent_bottom_nav_bar_v2.dart";

class PersistentTabViewScaffold extends StatefulWidget {
  const PersistentTabViewScaffold({
    required this.tabBar,
    required this.tabBuilder,
    required this.controller,
    required this.tabCount,
    super.key,
    this.opacities = const [],
    this.backgroundColor,
    this.avoidBottomPadding = true,
    this.margin = EdgeInsets.zero,
    this.resizeToAvoidBottomInset = true,
    this.stateManagement = false,
    this.gestureNavigationEnabled = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
    this.hideNavigationBar = false,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentTopWidget,
    this.drawer,
    this.drawerEdgeDragWidth,
    this.animatedTabBuilder,
    this.navigationShell,
  });

  final Widget tabBar;

  final Widget? drawer;

  final double? drawerEdgeDragWidth;

  final PersistentTabController controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final int tabCount;

  final bool avoidBottomPadding;

  final EdgeInsets margin;

  final List<double> opacities;

  final bool hideNavigationBar;

  final bool stateManagement;

  final bool gestureNavigationEnabled;

  final NavBarOverlap navBarOverlap;

  final ScreenTransitionAnimation screenTransitionAnimation;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? persistentTopWidget;

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

  Widget buildTab(BuildContext context, int index) {
    double overlap = 0;
    final bool isNotOpaque = index > widget.opacities.length
        ? false
        : widget.opacities[index] != 1.0;
    if ((isNotOpaque && widget.navBarOverlap.fullOverlapWhenNotOpaque) ||
        !_navBarFullyShown ||
        widget.margin.bottom != 0) {
      overlap = double.infinity;
    } else {
      overlap = widget.navBarOverlap.overlap;
    }

    return PersistentTab(
      bottomMargin: max(
        0,
        MediaQuery.of(context).padding.bottom - overlap,
      ),
      child: widget.tabBuilder(context, index),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            ),
            child: widget.navigationShell ??
                (widget.gestureNavigationEnabled
                    ? _SwipableTabSwitchingView(
                        currentTabIndex: widget.controller.index,
                        tabCount: widget.tabCount,
                        controller: widget.controller,
                        tabBuilder: buildTab,
                        stateManagement: widget.stateManagement,
                        screenTransitionAnimation:
                            widget.screenTransitionAnimation,
                      )
                    : _TabSwitchingView(
                        currentTabIndex: widget.controller.index,
                        tabCount: widget.tabCount,
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
                bottom: widget.avoidBottomPadding && widget.margin.bottom != 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (widget.persistentTopWidget != null)
                      widget.persistentTopWidget!,
                    widget.tabBar,
                  ],
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

class _SwipableTabSwitchingView extends StatefulWidget {
  const _SwipableTabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    required this.controller,
  }) : assert(tabCount > 0, "tabCount must be greater 0");

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;
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
    _pageController = PageController(initialPage: widget.currentTabIndex);
  }

  @override
  void didUpdateWidget(_SwipableTabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabIndex != oldWidget.currentTabIndex &&
        !pageUpdateCausedBySwipe) {
      isSwiping = false;
      if (widget.screenTransitionAnimation.duration == Duration.zero) {
        _pageController.jumpToPage(widget.currentTabIndex);
      } else {
        _pageController.animateToPage(
          widget.currentTabIndex,
          duration: widget.screenTransitionAnimation.duration,
          curve: widget.screenTransitionAnimation.curve,
        );
      }
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
          children: List.generate(
            widget.tabCount,
            (index) => FocusScope(
              node: FocusScopeNode(),
              child: widget.stateManagement
                  ? KeepAlivePage(
                      child: widget.tabBuilder(context, index),
                    )
                  : widget.tabBuilder(context, index),
            ),
          ),
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
    required this.currentTabIndex,
    required this.tabCount,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    this.animatedTabBuilder,
  }) : assert(tabCount > 0, "tabCount must be greater 0");

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool stateManagement;
  final ScreenTransitionAnimation screenTransitionAnimation;
  final AnimatedTabBuilder? animatedTabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView>
    with TickerProviderStateMixin {
  late final List<bool> shouldBuildTab =
      List<bool>.filled(widget.tabCount, false);
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _currentTabIndex = widget.currentTabIndex;
  late int _previousTabIndex = -1;
  late final bool _showAnimation =
      widget.screenTransitionAnimation.duration != Duration.zero;
  late Key? key = widget.stateManagement ? null : UniqueKey();

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
  }

  void _initAnimationControllers() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.screenTransitionAnimation.duration,
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        if (!widget.stateManagement) {
          setState(() {
            key = UniqueKey();
          });
        }
      }
    });

    _animation = Tween<double>(begin: 1, end: 1)
        .chain(CurveTween(curve: widget.screenTransitionAnimation.curve))
        .animate(_animationController);
    if (_showAnimation) {
      _animationController.animateTo(1, duration: Duration.zero);
    }
  }

  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (index) => FocusScopeNode(
              debugLabel:
                  "$CupertinoTabScaffold Tab ${index + tabFocusNodes.length}",
            ),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[_currentTabIndex]);
  }

  void _startAnimation() {
    if (_previousTabIndex == _currentTabIndex || _previousTabIndex == -1) {
      return;
    }
    _animationController.reset();
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation.curve))
        .animate(_animationController);

    _animationController.forward();
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
        children: List<Widget>.generate(widget.tabCount, (index) {
          final bool active = index == _currentTabIndex ||
              (!_animation.isCompleted &&
                  index == _previousTabIndex &&
                  _showAnimation);
          shouldBuildTab[index] =
              active || (shouldBuildTab[index] && widget.stateManagement);

          return Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(
                  builder: (context) => shouldBuildTab[index]
                      ? (_showAnimation
                          ? AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) =>
                                  widget.animatedTabBuilder?.call(
                                    context,
                                    index,
                                    _animation.value,
                                    _currentTabIndex,
                                    _previousTabIndex,
                                    child!,
                                  ) ??
                                  _buildAnimatedTab(
                                    context,
                                    index,
                                    _animation.value,
                                    _currentTabIndex,
                                    _previousTabIndex,
                                    child!,
                                  ),
                              child: widget.tabBuilder(context, index),
                            )
                          : widget.tabBuilder(context, index))
                      : Container(),
                ),
              ),
            ),
          );
        }),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff != 0 ||
        oldWidget.screenTransitionAnimation !=
            widget.screenTransitionAnimation) {
      _initAnimationControllers();
    }
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    if (widget.currentTabIndex != oldWidget.currentTabIndex) {
      _currentTabIndex = widget.currentTabIndex;
      _previousTabIndex = oldWidget.currentTabIndex;
      _focusActiveTab();
      if (_showAnimation) {
        _startAnimation();
      }
    }
  }

  @override
  void dispose() {
    for (FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    _animationController.dispose();
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
