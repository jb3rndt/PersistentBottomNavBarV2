part of "../persistent_bottom_nav_bar_v2.dart";

enum PageTransitionAnimation {
  platform,
  cupertino,
  slideRight,
  scale,
  rotate,
  sizeUp,
  fade,
  scaleRotate,
  slideUp
}

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  SlideUpPageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation),
            child: child,
          ),
        );
}

class SlideRightPageRoute<T> extends PageRouteBuilder<T> {
  SlideRightPageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                    .animate(animation),
            child: child,
          ),
        );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  ScalePageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) => ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          ),
        );
}

class RotationPageRoute<T> extends PageRouteBuilder<T> {
  RotationPageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) =>
              RotationTransition(
            turns: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.linear),
            ),
            child: child,
          ),
        );
}

class SizePageRoute<T> extends PageRouteBuilder<T> {
  SizePageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) => Align(
            child: SizeTransition(sizeFactor: animation, child: child),
          ),
        );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

class ScaleRotatePageRoute<T> extends PageRouteBuilder<T> {
  ScaleRotatePageRoute({required Widget page, RouteSettings? routeSettings})
      : super(
          settings: routeSettings,
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) => ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.linear),
              ),
              child: child,
            ),
          ),
        );
}

Route<T> getPageRoute<T extends Object>(
  PageTransitionAnimation transitionAnimation, {
  required Widget screen,
  RouteSettings? settings,
}) {
  switch (transitionAnimation) {
    case PageTransitionAnimation.cupertino:
      return CupertinoPageRoute<T>(
        settings: settings,
        builder: (context) => screen,
      );
    case PageTransitionAnimation.platform:
      return MaterialPageRoute<T>(
        settings: settings,
        builder: (context) => screen,
      );
    case PageTransitionAnimation.slideRight:
      return SlideRightPageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.scale:
      return ScalePageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.rotate:
      return RotationPageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.sizeUp:
      return SizePageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.fade:
      return FadePageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.scaleRotate:
      return ScaleRotatePageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
    case PageTransitionAnimation.slideUp:
      return SlideUpPageRoute<T>(
        routeSettings: settings,
        page: screen,
      );
  }
}
