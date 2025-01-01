// ignore_for_file: avoid_redundant_argument_values

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

void main() {
  group("ScreenTransitionAnimation", () {
    test("== and hashCode", () {
      const animation = ScreenTransitionAnimation();
      expect(animation, equals(animation));
      expect(animation, equals(const ScreenTransitionAnimation()));
      expect(
        animation.hashCode,
        equals(const ScreenTransitionAnimation().hashCode),
      );
    });
  });

  group("NavBarConfig", () {
    test("copyWith", () {
      bool didRun = false;

      final config = NavBarConfig(
        selectedIndex: 0,
        items: List.empty(),
        onItemSelected: (index) {},
      );
      final newConfig = config.copyWith(
        selectedIndex: 1,
        items: [ItemConfig(icon: const Icon(Icons.home), title: "Home")],
        onItemSelected: (index) {
          didRun = true;
        },
      );
      expect(newConfig.selectedIndex, equals(1));
      expect(newConfig.items.first.title, equals("Home"));
      newConfig.onItemSelected(0);
      expect(didRun, isTrue);
    });

    test("copyWith without new values", () {
      bool didRun = false;

      final config = NavBarConfig(
        selectedIndex: 0,
        items: List.empty(),
        onItemSelected: (index) {
          didRun = true;
        },
      );
      final newConfig = config.copyWith();
      expect(newConfig.selectedIndex, equals(0));
      expect(newConfig.items, isEmpty);
      newConfig.onItemSelected(0);
      expect(didRun, isTrue);
    });
  });

  group("NavigatorConfig", () {
    test("copyWith", () {
      final config = NavigatorConfig(
        defaultTitle: "Default Title",
        routes: {"route": (context) => const SizedBox()},
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        initialRoute: "/",
        navigatorObservers: [NavigatorObserver()],
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      final newConfig = config.copyWith(
        defaultTitle: "New Title",
        routes: {"newRoute": (context) => const SizedBox()},
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        initialRoute: "/new",
        navigatorObservers: [NavigatorObserver()],
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      expect(newConfig.defaultTitle, equals("New Title"));
      expect(newConfig.routes.keys.first, equals("newRoute"));
      expect(newConfig.initialRoute, equals("/new"));
    });

    test("copyWith without new values", () {
      final config = NavigatorConfig(
        defaultTitle: "Default Title",
        routes: {"route": (context) => const SizedBox()},
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        initialRoute: "/",
        navigatorObservers: [NavigatorObserver()],
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      final newConfig = config.copyWith();
      expect(newConfig.defaultTitle, equals("Default Title"));
      expect(newConfig.routes.keys.first, equals("route"));
      expect(newConfig.initialRoute, equals("/"));
    });
  });

  group("NavBarDecoration", () {
    test("exposedHeight is calculated correctly", () {
      final decoration = NavBarDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      );
      expect(decoration.exposedHeight(), equals(14));
    });
  });

  group("NeumorphicDecoration", () {
    test("copyWith", () {
      final decoration = NeumorphicDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
        shape: BoxShape.rectangle,
      );
      final newDecoration = decoration.copyWith(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 4),
        shape: BoxShape.circle,
      );
      expect(newDecoration.color, equals(Colors.blue));
      expect(newDecoration.borderRadius, equals(BorderRadius.circular(20)));
      expect(newDecoration.border, equals(Border.all(width: 4)));
      expect(newDecoration.shape, equals(BoxShape.circle));
    });

    test("copyWith without new values", () {
      final decoration = NeumorphicDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
        shape: BoxShape.rectangle,
      );
      final newDecoration = decoration.copyWith();
      expect(newDecoration.color, equals(Colors.red));
      expect(newDecoration.borderRadius, equals(BorderRadius.circular(10)));
      expect(newDecoration.border, equals(Border.all(width: 2)));
      expect(newDecoration.shape, equals(BoxShape.rectangle));
    });
  });
}
