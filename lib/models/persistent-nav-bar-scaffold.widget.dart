part of persistent_bottom_nav_bar_v2;

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0);

  bool _isDisposed = false;
  int get index => _index;
  int _index;

  set index(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  jumpToTab(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  @mustCallSuper
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

class PersistentTabScaffold extends StatefulWidget {
  PersistentTabScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
    required this.statusColor,
    this.controller,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.bottomScreenMargin,
    this.stateManagement,
    this.screenTransitionAnimation,
    this.itemCount,
    this.animatePadding = false,

  })  : assert(
  controller == null || controller.index < itemCount!,
  "The PersistentTabController's current index ${controller.index} is "
      'out of bounds for the tab bar with ${tabBar.navBarEssentials!.items!.length} tabs'),
        super(key: key);

  final PersistentBottomNavBar tabBar;

  final PersistentTabController? controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final int? itemCount;

  final double? bottomScreenMargin;

  final bool? stateManagement;

  final ScreenTransitionAnimation? screenTransitionAnimation;

  final Color statusColor;
  final bool animatePadding;

  @override
  _PersistentTabScaffoldState createState() => _PersistentTabScaffoldState();
}

class _PersistentTabScaffoldState extends State<PersistentTabScaffold> {
  PersistentTabController? _controller;
  int? _selectedIndex;
  late bool _isTapAction;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.controller!.index;
    _isTapAction = false;
    _updateTabController();
  }

  void _updateTabController({bool shouldDisposeOldController = false}) {
    final PersistentTabController newController = widget.controller ??
        PersistentTabController(
            initialIndex: widget.tabBar.navBarEssentials!.selectedIndex!);

    if (newController == _controller) {
      return;
    }

    if (shouldDisposeOldController) {
      _controller?.dispose();
    } else if (_controller?._isDisposed == false) {
      _controller!.removeListener(_onCurrentIndexChange);
    }

    newController.addListener(_onCurrentIndexChange);
    _controller = newController;
  }

  void _onCurrentIndexChange() {
    assert(
    _controller!.index >= 0 && _controller!.index < widget.itemCount!,
    "The $runtimeType's current index ${_controller!.index} is "
        'out of bounds for the tab bar with ${widget.itemCount} tabs');
    setState(() {});
  }

  @override
  void didUpdateWidget(PersistentTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController(
          shouldDisposeOldController: oldWidget.controller == null);
    } else if (_controller!.index >= widget.itemCount!) {
      _controller!.index = widget.itemCount! - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData existingMediaQuery = MediaQuery.of(context);
    MediaQueryData newMediaQuery = MediaQuery.of(context);
    if (_isTapAction) {
      _isTapAction = false;
    } else {
      _selectedIndex = widget.tabBar.navBarEssentials!.selectedIndex;
    }
    Widget content = _TabSwitchingView(
      key: Key("TabSwitchingView"),
      currentTabIndex: _controller!.index,
      tabCount: widget.itemCount,
      tabBuilder: widget.tabBuilder,
      stateManagement: widget.stateManagement,
      statusColor: widget.statusColor,
      screenTransitionAnimation: widget.screenTransitionAnimation,
      backgroundColor: widget.tabBar.navBarEssentials!.backgroundColor,
    );
    double contentPadding = 0.0;

    if (widget.resizeToAvoidBottomInset) {
      newMediaQuery = newMediaQuery.removeViewInsets(removeBottom: true);
    }

    if (!widget.tabBar.opaque(_selectedIndex)) {
      contentPadding = 0.0;
    } else if (widget
        .tabBar.navBarDecoration!.adjustScreenBottomPaddingOnCurve &&
        widget.tabBar.navBarDecoration!.borderRadius != BorderRadius.zero) {
      final double bottomPadding = widget.bottomScreenMargin ??
          widget.tabBar.navBarEssentials!.navBarHeight! -
              (widget.tabBar.navBarDecoration!.borderRadius != null
                  ? min(
                  widget.tabBar.navBarEssentials!.navBarHeight!,
                  max(
                      widget.tabBar.navBarDecoration!.borderRadius!
                          .topRight.y,
                      widget.tabBar.navBarDecoration!.borderRadius!
                          .topLeft.y) +
                      (widget.tabBar.navBarDecoration?.border != null
                          ? widget.tabBar.navBarDecoration!.border!
                          .dimensions.vertical
                          : 0.0))
                  : 0.0);
      contentPadding = bottomPadding;
    } else {
      if ((!widget.resizeToAvoidBottomInset ||
          widget.tabBar.navBarEssentials!.navBarHeight! >
              existingMediaQuery.viewInsets.bottom)) {
        final double bottomPadding = widget.bottomScreenMargin ??
            widget.tabBar.navBarEssentials!.navBarHeight! +
                (widget.tabBar.navBarDecoration?.border != null
                    ? widget
                    .tabBar.navBarDecoration!.border!.dimensions.vertical
                    : 0.0);
        contentPadding = bottomPadding;
      }
    }

    contentPadding += widget.resizeToAvoidBottomInset
        ? existingMediaQuery.viewInsets.bottom
        : 0.0;

    if (widget.tabBar.hideNavigationBar != null) {
      content = MediaQuery(
        data: newMediaQuery,
        child: AnimatedContainer(
          duration: Duration(
              milliseconds:
              widget.animatePadding || widget.tabBar.hideNavigationBar!
                  ? widget.tabBar.hideNavigationBar!
                  ? 200
                  : 400
                  : 0),
          curve:
          widget.tabBar.hideNavigationBar! ? Curves.linear : Curves.easeIn,
          color: widget.tabBar.navBarDecoration!.colorBehindNavBar,
          padding: EdgeInsets.only(bottom: contentPadding),
          child: content,
        ),
      );
    } else {
      content = MediaQuery(
        data: newMediaQuery,
        child: Container(
          color: widget.tabBar.navBarDecoration!.colorBehindNavBar,
          padding: EdgeInsets.only(bottom: contentPadding),
          child: content,
        ),
      );
    }

    return DecoratedBox(
      decoration:
      widget.tabBar.navBarDecoration!.borderRadius != BorderRadius.zero
          ? BoxDecoration(
        color: CupertinoColors.black.withOpacity(0.0),
        borderRadius: widget.tabBar.navBarDecoration!.borderRadius,
      )
          : BoxDecoration(color: CupertinoColors.black.withOpacity(1.0)),
      child: Stack(
        children: <Widget>[
          content,
          MediaQuery(
            data: existingMediaQuery.copyWith(textScaleFactor: 1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: widget.tabBar,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller?.dispose();
    } else if (_controller?._isDisposed == false) {
      _controller!.removeListener(_onCurrentIndexChange);
    }

    super.dispose();
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    Key? key,
    required this.currentTabIndex,
    required this.tabCount,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    required this.backgroundColor,required this.statusColor
  })  : assert(tabCount != null && tabCount > 0),
        super(key: key);

  final int currentTabIndex;
  final int? tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool? stateManagement;
  final ScreenTransitionAnimation? screenTransitionAnimation;
  final Color? backgroundColor;
  final Color? statusColor;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView>
    with TickerProviderStateMixin {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];
  late List<AnimationController?> _animationControllers;
  late List<Animation<double>?> _animations;
  int? _tabCount;
  late int _currentTabIndex;
  late int _previousTabIndex;
  bool? _showAnimation;
  double? _animationValue;
  Curve? _animationCurve;
  Key? key;

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount!, false));
    _currentTabIndex = widget.currentTabIndex;
    _previousTabIndex = widget.currentTabIndex;
    _tabCount = widget.tabCount;
    _showAnimation = widget.screenTransitionAnimation!.animateTabTransition;

    if (!widget.stateManagement!) {
      key = UniqueKey();
    }

    _initAnimationControllers();
  }

  _initAnimationControllers() {
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      _animationControllers =
      List<AnimationController?>.filled(widget.tabCount!, null);
      _animations = List<Animation<double>?>.filled(widget.tabCount!, null);
      _animationCurve = widget.screenTransitionAnimation!.curve;
      for (int i = 0; i < widget.tabCount!; ++i) {
        _animationControllers[i] = AnimationController(
            vsync: this, duration: widget.screenTransitionAnimation!.duration);
        _animations[i] = Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
            .animate(_animationControllers[i]!);
      }

      for (int i = 0; i < widget.tabCount!; ++i) {
        _animationControllers[i]!.addListener(() {
          if (_animationControllers[i]!.isCompleted) {
            _previousTabIndex = _currentTabIndex;
            setState(() {
              if (!widget.stateManagement!) {
                key = UniqueKey();
              }
            });
          }
        });
      }
    }
  }

  void _focusActiveTab() {
    if (widget.screenTransitionAnimation!.animateTabTransition)
      _startAnimation();
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount!) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount!));
        tabFocusNodes.removeRange(widget.tabCount!, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount! - tabFocusNodes.length,
                (int index) => FocusScopeNode(
                debugLabel:
                '$CupertinoTabScaffold Tab ${index + tabFocusNodes.length}'),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[_currentTabIndex]);
  }

  /// Starts the animation from one tab to another by shifting the previous
  /// tab to the left/right and making the new tab appear from left/right.
  /// This method must only be called once when [_previousTabIndex]
  /// and [_currentTabIndex] change.
  void _startAnimation() {
    if (_previousTabIndex == _currentTabIndex) return;
    _animationControllers[_previousTabIndex]!.reset();
    _animations[_previousTabIndex] = Tween(
        begin: 0.0,
        end: (_previousTabIndex > _currentTabIndex)
            ? _animationValue
            : -_animationValue!)
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_previousTabIndex]!);

    _animationControllers[_currentTabIndex]!.reset();
    _animations[_currentTabIndex] = Tween(
      begin: (_previousTabIndex > _currentTabIndex)
          ? -_animationValue!
          : _animationValue!,
      end: 0.0,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_currentTabIndex]!);

    _animationControllers[_previousTabIndex]!.forward();
    _animationControllers[_currentTabIndex]!.forward();
    return;
  }

  Widget _buildScreens() {
    return Container(
      color: widget.statusColor,
      child: Stack(
        fit: StackFit.expand,
        children: List<Widget>.generate(widget.tabCount!, (int index) {
          final bool active = index == _currentTabIndex ||
              (widget.screenTransitionAnimation!.animateTabTransition &&
                  index == _previousTabIndex);
          shouldBuildTab[index] = active || shouldBuildTab[index];

          return Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(
                  builder: (BuildContext context) {
                    return shouldBuildTab[index]
                        ? (widget
                        .screenTransitionAnimation!.animateTabTransition
                        ? AnimatedBuilder(
                      animation: _animations[index]!,
                      builder: (context, child) =>
                          Transform.translate(
                            offset: Offset(_animations[index]!.value, 0),
                            child: widget.tabBuilder(context, index),
                          ),
                    )
                        : widget.tabBuilder(context, index))
                        : Container();
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int lengthDiff = widget.tabCount! - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount!, shouldBuildTab.length);
    }
    if (widget.currentTabIndex != oldWidget.currentTabIndex) {
      _currentTabIndex = widget.currentTabIndex;
      _previousTabIndex = oldWidget.currentTabIndex;
      _focusActiveTab();
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
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      for (AnimationController? controller in _animationControllers) {
        controller!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationValue = MediaQuery.of(context).size.width;
    if (_tabCount != widget.tabCount) {
      _tabCount = widget.tabCount;
      _initAnimationControllers();
    }
    if (widget.screenTransitionAnimation!.animateTabTransition &&
        _animationControllers.first!.duration !=
            widget.screenTransitionAnimation!.duration ||
        _animationCurve != widget.screenTransitionAnimation!.curve) {
      _initAnimationControllers();
    }
    if (_showAnimation !=
        widget.screenTransitionAnimation!.animateTabTransition) {
      _showAnimation = widget.screenTransitionAnimation!.animateTabTransition;
      key = UniqueKey();
    }
    return Container(
      color: widget.backgroundColor,
      child: widget.stateManagement!
          ? _buildScreens()
          : KeyedSubtree(
        key: key,
        child: _buildScreens(),
      ),
    );
  }
}
