import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "persistent_tab_view_test.dart";

typedef StyleBuilder = Widget Function(NavBarConfig navBarConfig);

Future<void> testStyle(WidgetTester tester, StyleBuilder builder) async {
  await tester.pumpWidget(
    wrapTabView(
      (context) => PersistentTabView(
        tabs: List.generate(3, (id) => tabConfig(id, defaultScreen(id))),
        navBarBuilder: (navBarConfig) => builder(navBarConfig),
      ),
    ),
  );

  await tester.pumpAndSettle();

  expect(
    find.byType(DecoratedNavBar).hitTestable(at: Alignment.centerLeft),
    findsOneWidget,
  );

  await tapItem(tester, 1);
}

void main() {
  testWidgets("builds every style", (tester) async {
    await testStyle(
      tester,
      (config) => NeumorphicBottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => NeumorphicBottomNavBar(
        navBarConfig: config,
        height: 80,
        neumorphicProperties: const NeumorphicProperties(
          decoration: NeumorphicDecoration(color: Colors.red),
          showSubtitleText: true,
        ),
      ),
    );
    await testStyle(
      tester,
      (config) => Style1BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style2BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style3BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style4BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style5BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style6BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style7BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style8BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style9BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style10BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style11BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style12BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style13BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style14BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style15BottomNavBar(navBarConfig: config),
    );
    await testStyle(
      tester,
      (config) => Style16BottomNavBar(navBarConfig: config),
    );
  });
}
