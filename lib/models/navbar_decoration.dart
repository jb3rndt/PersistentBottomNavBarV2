part of "../persistent_bottom_nav_bar_v2.dart";

enum PopActionType { single, all, none }

/// Decoration configuration for the persistent navigation bar.
/// It is suggested to be used in conjunction with [DecoratedNavBar]
/// to style the navigation bar. Serves as a container for commonly
/// used styling properties.
class NavBarDecoration extends BoxDecoration {
  const NavBarDecoration({
    super.color = Colors.white,
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.gradient,
    super.backgroundBlendMode,
    super.shape,
    this.padding = const EdgeInsets.all(5),
    this.filter,
  });

  /// `padding` for the NavigationBar content.
  @override
  final EdgeInsets padding;

  /// Filter used when the opacity of the NavBarDecoration.color is < 1.
  /// Can be used to create 'frosted glass' effect with
  /// `ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)`.
  final ImageFilter? filter;

  double borderHeight() => border?.dimensions.vertical ?? 0.0;

  double exposedHeight() {
    if (borderRadius != BorderRadius.zero &&
        borderRadius != null &&
        borderRadius is BorderRadius) {
      final BorderRadius radius = borderRadius! as BorderRadius;
      return max(radius.topRight.y, radius.topLeft.y) + borderHeight();
    } else {
      return 0;
    }
  }
}
