part of "../persistent_bottom_nav_bar_v2.dart";

@optionalTypeArgs
Future<T?> pushScreen<T extends Object?>(
  BuildContext context, {
  required Widget screen,
  bool withNavBar = false,
  PageTransitionAnimation pageTransitionAnimation =
      PageTransitionAnimation.platform,
  RouteSettings? settings,
}) =>
    Navigator.of(context, rootNavigator: !withNavBar).push<T>(
      getPageRoute(
        pageTransitionAnimation,
        screen: screen,
        settings: settings,
      ) as Route<T>,
    );

@optionalTypeArgs
Future<T?> pushWithNavBar<T>(BuildContext context, Route<T> route) =>
    Navigator.of(context).push<T>(route);

@optionalTypeArgs
Future<T?> pushWithoutNavBar<T>(BuildContext context, Route<T> route) =>
    Navigator.of(context, rootNavigator: true).push<T>(route);

@optionalTypeArgs
Future<T?> pushScreenWithNavBar<T>(BuildContext context, Widget screen) =>
    pushScreen<T>(context, screen: screen, withNavBar: true);

@optionalTypeArgs
Future<T?> pushScreenWithoutNavBar<T>(BuildContext context, Widget screen) =>
    pushScreen<T>(context, screen: screen);

@optionalTypeArgs
Future<T?> pushReplacementWithNavBar<T extends Object?, TO extends Object?>(
  BuildContext context,
  Route<T> route, {
  TO? result,
}) =>
    Navigator.of(context).pushReplacement<T, TO>(route);

@optionalTypeArgs
Future<T?> pushReplacementWithoutNavBar<T extends Object?, TO extends Object?>(
  BuildContext context,
  Route<T> route, {
  TO? result,
}) =>
    Navigator.of(context, rootNavigator: true).pushReplacement<T, TO>(route);

void popAllScreensOfCurrentTab(BuildContext context) {
  Navigator.popUntil(context, (route) => route.isFirst);
}
