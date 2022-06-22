part of persistent_bottom_nav_bar_v2;

class PersistentBottomNavBar extends StatelessWidget {
  final EdgeInsets? margin;
  final bool? confineToSafeArea;
  final Widget Function(NavBarEssentials navBarEssentials)? customNavBarWidget;
  final bool? hideNavigationBar;
  final Function(bool, bool)? onAnimationComplete;
  final NeumorphicProperties? neumorphicProperties;
  final NavBarEssentials? navBarEssentials;
  final NavBarDecoration? navBarDecoration;
  final NavBarStyle? navBarStyle;
  final bool? isCustomWidget;

  const PersistentBottomNavBar({
    Key? key,
    this.margin,
    this.confineToSafeArea,
    this.customNavBarWidget,
    this.hideNavigationBar,
    this.onAnimationComplete,
    this.neumorphicProperties = const NeumorphicProperties(),
    this.navBarEssentials,
    this.navBarDecoration,
    this.navBarStyle,
    this.isCustomWidget = false,
  }) : super(key: key);

  Widget _navBarWidget() => Padding(
        padding: this.margin!,
        child: isCustomWidget!
            ? this.margin!.bottom > 0
                ? SafeArea(
                    top: false,
                    bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                            (this.hideNavigationBar ?? false)
                        ? false
                        : confineToSafeArea ?? true,
                    child: Container(
                      color: this.navBarEssentials!.backgroundColor,
                      height: this.navBarEssentials!.navBarHeight,
                      child:
                          this.customNavBarWidget?.call(this.navBarEssentials!),
                    ),
                  )
                : Container(
                    color: this.navBarEssentials!.backgroundColor,
                    child: SafeArea(
                      top: false,
                      bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                              (this.hideNavigationBar ?? false)
                          ? false
                          : confineToSafeArea ?? true,
                      child: Container(
                        height: this.navBarEssentials!.navBarHeight,
                        child: this
                            .customNavBarWidget
                            ?.call(this.navBarEssentials!),
                      ),
                    ),
                  )
            : this.navBarStyle == NavBarStyle.style15 ||
                    this.navBarStyle == NavBarStyle.style16
                ? this.margin!.bottom > 0
                    ? SafeArea(
                        top: false,
                        right: false,
                        left: false,
                        bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                                (this.hideNavigationBar ?? false)
                            ? false
                            : confineToSafeArea ?? true,
                        child: Container(
                          decoration: getNavBarDecoration(
                            decoration: this.navBarDecoration,
                            color: this.navBarEssentials!.backgroundColor,
                            opacity: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: getNavBarStyle(),
                        ),
                      )
                    : Container(
                        decoration: getNavBarDecoration(
                          decoration: this.navBarDecoration,
                          color: this.navBarEssentials!.backgroundColor,
                          opacity: this
                              .navBarEssentials!
                              .items![this.navBarEssentials!.selectedIndex!]
                              .opacity,
                        ),
                        child: SafeArea(
                          top: false,
                          right: false,
                          left: false,
                          bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                                  (this.hideNavigationBar ?? false)
                              ? false
                              : confineToSafeArea ?? true,
                          child: getNavBarStyle()!,
                        ),
                      )
                : Container(
                    decoration: getNavBarDecoration(
                      decoration: this.navBarDecoration,
                      showBorder: false,
                      color: this.navBarEssentials!.backgroundColor,
                      opacity: this
                          .navBarEssentials!
                          .items![this.navBarEssentials!.selectedIndex!]
                          .opacity,
                    ),
                    child: ClipRRect(
                      borderRadius: this.navBarDecoration!.borderRadius ??
                          BorderRadius.zero,
                      child: BackdropFilter(
                        filter: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .filter ??
                            ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          decoration: getNavBarDecoration(
                            showOpacity: false,
                            decoration: navBarDecoration,
                            color: this.navBarEssentials!.backgroundColor,
                            opacity: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: SafeArea(
                            top: false,
                            right: false,
                            left: false,
                            bottom:
                                this.navBarEssentials!.navBarHeight == 0.0 ||
                                        (this.hideNavigationBar ?? false)
                                    ? false
                                    : confineToSafeArea ?? true,
                            child: getNavBarStyle()!,
                          ),
                        ),
                      ),
                    ),
                  ),
      );

  @override
  Widget build(BuildContext context) {
    return this.hideNavigationBar == null
        ? _navBarWidget()
        : OffsetAnimation(
            hideNavigationBar: this.hideNavigationBar,
            navBarHeight: this.navBarEssentials!.navBarHeight,
            onAnimationComplete: (isAnimating, isComplete) {
              this.onAnimationComplete!(isAnimating, isComplete);
            },
            child: _navBarWidget(),
          );
  }

  PersistentBottomNavBar copyWith({
    EdgeInsets? margin,
    bool? confineToSafeArea,
    Widget Function(NavBarEssentials)? customNavBarWidget,
    bool? hideNavigationBar,
    Function(bool, bool)? onAnimationComplete,
    NeumorphicProperties? neumorphicProperties,
    NavBarEssentials? navBarEssentials,
    NavBarDecoration? navBarDecoration,
    NavBarStyle? navBarStyle,
    bool? isCustomWidget,
  }) =>
      PersistentBottomNavBar(
        margin: margin ?? this.margin,
        confineToSafeArea: confineToSafeArea ?? this.confineToSafeArea,
        customNavBarWidget: customNavBarWidget ?? this.customNavBarWidget,
        hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
        onAnimationComplete: onAnimationComplete ?? this.onAnimationComplete,
        neumorphicProperties: neumorphicProperties ?? this.neumorphicProperties,
        navBarEssentials: navBarEssentials ?? this.navBarEssentials,
        navBarDecoration: navBarDecoration ?? this.navBarDecoration,
        navBarStyle: navBarStyle ?? this.navBarStyle,
        isCustomWidget: isCustomWidget ?? this.isCustomWidget,
      );

  bool opaque(int? index) {
    return this.navBarEssentials!.items == null
        ? true
        : !(this.navBarEssentials!.items![index!].opacity < 1.0);
  }

  Widget? getNavBarStyle() {
    if (isCustomWidget!) {
      return customNavBarWidget?.call(this.navBarEssentials!);
    } else {
      switch (navBarStyle) {
        case NavBarStyle.style1:
          return BottomNavStyle1(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style2:
          return BottomNavStyle2(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style3:
          return BottomNavStyle3(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style4:
          return BottomNavStyle4(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style5:
          return BottomNavStyle5(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style6:
          return BottomNavStyle6(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style7:
          return BottomNavStyle7(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style8:
          return BottomNavStyle8(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style9:
          return BottomNavStyle9(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style10:
          return BottomNavStyle10(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style11:
          return BottomNavStyle11(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style12:
          return BottomNavStyle12(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style13:
          return BottomNavStyle13(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style14:
          return BottomNavStyle14(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.style15:
          return BottomNavStyle15(
            navBarEssentials: this.navBarEssentials,
            navBarDecoration: this.navBarDecoration,
          );
        case NavBarStyle.style16:
          return BottomNavStyle16(
            navBarEssentials: this.navBarEssentials,
            navBarDecoration: this.navBarDecoration,
          );
        case NavBarStyle.style17:
          return BottomNavStyle17(
            navBarEssentials: this.navBarEssentials,
            navBarDecoration: this.navBarDecoration,
          );
        case NavBarStyle.style18:
          return BottomNavStyle18(
            navBarEssentials: this.navBarEssentials,
            navBarDecoration: this.navBarDecoration,
          );
        case NavBarStyle.neumorphic:
          return NeumorphicBottomNavBar(
            navBarEssentials: this.navBarEssentials,
            neumorphicProperties:
                this.neumorphicProperties ?? NeumorphicProperties(),
          );
        default:
          return BottomNavSimple(
            navBarEssentials: this.navBarEssentials,
          );
      }
    }
  }
}
