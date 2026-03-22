import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

PersistentTabConfig tabConfig(
  int id,
  Widget screen, [
  ScrollController? scrollController,
]) =>
    PersistentTabConfig(
      screen: screen,
      scrollController: scrollController,
      item: ItemConfig(
        title: "Item$id",
        icon: Icon(key: Key("Item$id"), Icons.add),
      ),
    );

Widget defaultScreen(
  int tab, {
  int level = 0,
  void Function(BuildContext)? onTap,
}) =>
    Column(
      children: [
        Text("Tab $tab"),
        Text("Level $level"),
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              if (onTap != null) {
                onTap(context);
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => defaultScreen(tab, level: level + 1),
                ),
              );
            },
            child: const Text("Push Screen"),
          ),
        ),
      ],
    );

Widget scrollableScreen(
  int tab, {
  int level = 0,
  ScrollController? controller,
  ScrollPhysics? physics,
}) =>
    ListView(
      physics: physics,
      controller: controller,
      children: [
        Text("Tab $tab"),
        Text("Level $level"),
        ...List.generate(
          40,
          (id) => Container(
            padding: const EdgeInsets.all(16),
            child: Text("Item $id"),
          ),
        ),
      ],
    );

List<PersistentTabConfig> tabs([int count = 3]) => List.generate(
      count,
      (id) => tabConfig(id, defaultScreen(id)),
    );

List<PersistentRouterTabConfig> routerTabs([
  int count = 3,
  List<ScrollController>? scrollControllers,
]) =>
    List.generate(
      count,
      (id) => PersistentRouterTabConfig(
        scrollController:
            scrollControllers != null ? scrollControllers[id] : null,
        item: ItemConfig(
          icon: Icon(key: Key("Item$id"), Icons.add),
          title: "Item$id",
        ),
      ),
    );

Future<void> tapAndroidBackButton(WidgetTester tester) async {
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  // ignore: avoid_dynamic_calls
  await widgetsAppState.didPopRoute();
  await tester.pumpAndSettle();
}

Future<void> tapElevatedButton(WidgetTester tester) async {
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}

Future<void> tapItem(WidgetTester tester, int id) async {
  await tester.tap(find.byKey(Key("Item$id")));
  await tester.pumpAndSettle();
}

Future<void> scroll(
  WidgetTester tester,
  Offset start,
  Offset moveBy,
) async {
  final gesture = await tester.startGesture(start);

  await gesture.moveBy(moveBy);
  await tester.pumpAndSettle();

  await gesture.removePointer();
  await gesture.cancel();
}

void expectTab(int tab, {int level = 0}) {
  expect(find.text("Tab $tab"), findsOneWidget);
  expect(find.text("Level $level"), findsOneWidget);
}

void expectNotTab(int tab) {
  expect(find.text("Tab $tab"), findsNothing);
}

void expectNotLevel(int level) {
  expect(find.text("Level $level"), findsNothing);
}

void expectMainScreen() {
  expect(find.text("Main Screen"), findsOneWidget);
}

Widget wrapTabView(WidgetBuilder builder) => MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );

Widget wrapTabViewWithMainScreen(WidgetBuilder builder) => wrapTabView(
      (context) => ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => builder(context),
          ),
        ),
        child: const Text("Main Screen"),
      ),
    );

GoRouter wrapWithGoRouter(
  Widget Function(BuildContext, GoRouterState, StatefulNavigationShell)?
      builder, {
  List<ScrollController>? scrollControllers,
}) =>
    GoRouter(
      initialLocation: "/tab-0",
      routes: [
        StatefulShellRoute.indexedStack(
          builder: builder,
          branches: List.generate(
            3,
            (id) => StatefulShellBranch(
              initialLocation: "/tab-$id",
              routes: <RouteBase>[
                GoRoute(
                  path: "/tab-$id",
                  builder: (context, state) => scrollControllers != null
                      ? scrollableScreen(id, controller: scrollControllers[id])
                      : defaultScreen(id),
                ),
              ],
            ),
          ),
        ),
      ],
    );
