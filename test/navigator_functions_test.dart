import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "persistent_tab_view_test.dart";

void main() {
  group("pushScreen", () {
    testWidgets("pushes with navBar", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(
              3,
              (id) => tabConfig(
                id,
                defaultScreen(
                  id,
                  onTap: (context) => pushScreen(
                    context,
                    screen: defaultScreen(id, level: 1),
                    withNavBar: true,
                  ),
                ),
              ),
            ),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("pushes without navBar", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(
              3,
              (id) => tabConfig(
                id,
                defaultScreen(
                  id,
                  onTap: (context) => pushScreen(
                    context,
                    screen: defaultScreen(id, level: 1),
                  ),
                ),
              ),
            ),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
    });
  });

  testWidgets("pushWithNavBar pushes with navBar", (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushWithNavBar(
                  context,
                  MaterialPageRoute(
                    builder: (context) => defaultScreen(id, level: 1),
                  ),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
  });

  testWidgets("pushWithoutNavBar pushes without navBar", (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushWithoutNavBar(
                  context,
                  MaterialPageRoute(
                    builder: (context) => defaultScreen(id, level: 1),
                  ),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
  });

  testWidgets("pushScreenWithNavBar pushes with navBar", (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushScreenWithNavBar(
                  context,
                  defaultScreen(id, level: 1),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
  });

  testWidgets("pushScreenWithoutNavBar pushes without navBar", (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushScreenWithoutNavBar(
                  context,
                  defaultScreen(id, level: 1),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
  });

  testWidgets("pushReplacementWithNavBar pushes replacement with navBar",
      (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushScreenWithNavBar(
                  context,
                  defaultScreen(
                    id,
                    level: 1,
                    onTap: (context) => pushReplacementWithNavBar(
                      context,
                      MaterialPageRoute(
                        builder: (context) => defaultScreen(id, level: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    expectTabAndLevel(tab: 0, level: 0);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expectTabAndLevel(tab: 0, level: 2);
    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    await tapAndroidBackButton(tester);
    expectTabAndLevel(tab: 0, level: 0);
  });

  testWidgets("pushReplacementWithoutNavBar pushes replacement without navBar",
      (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushScreenWithoutNavBar(
                  context,
                  defaultScreen(
                    id,
                    level: 1,
                    onTap: (context) => pushReplacementWithoutNavBar(
                      context,
                      MaterialPageRoute(
                        builder: (context) => defaultScreen(id, level: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);

    expectTabAndLevel(tab: 0, level: 0);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expectTabAndLevel(tab: 0, level: 2);
    expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);

    await tapAndroidBackButton(tester);
    expectTabAndLevel(tab: 0, level: 0);
  });

  testWidgets("popAllScreensOfCurrentTab pops all screens of current tab",
      (tester) async {
    await tester.pumpWidget(
      wrapTabView(
        (context) => PersistentTabView(
          tabs: List.generate(
            3,
            (id) => tabConfig(
              id,
              defaultScreen(
                id,
                onTap: (context) => pushScreenWithNavBar(
                  context,
                  defaultScreen(
                    id,
                    level: 1,
                    onTap: (context) => pushScreenWithNavBar(
                      context,
                      defaultScreen(
                        id,
                        level: 2,
                        onTap: popAllScreensOfCurrentTab,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
        ),
      ),
    );

    expectTabAndLevel(tab: 0, level: 0);

    await tapElevatedButton(tester);
    await tapElevatedButton(tester);

    expectTabAndLevel(tab: 0, level: 2);

    await tapElevatedButton(tester);
    expectTabAndLevel(tab: 0, level: 0);
  });
}
