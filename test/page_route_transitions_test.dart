import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

Widget mainScreen(void Function() onPressed) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text("Push Route"),
          ),
        ),
      ),
    );

void main() {
  group("PageTransitionAnimation", () {
    testWidgets("material", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.platform,
              screen: const Column(
                children: [
                  Text("Material"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Material"), findsOneWidget);
    });

    testWidgets("cupertino", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.cupertino,
              screen: const Column(
                children: [
                  Text("Cupertino"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Cupertino"), findsOneWidget);
    });

    testWidgets("slideUp", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.slideUp,
              screen: const Column(
                children: [
                  Text("SlideUp"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);
      expect(tester.getCenter(find.byType(Column)).dy, greaterThan(400));

      await tester.pumpAndSettle();

      expect(find.text("SlideUp"), findsOneWidget);
    });

    testWidgets("slideRight", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.slideRight,
              screen: const Column(
                children: [
                  Text("SlideRight"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);
      expect(tester.getCenter(find.byType(Column)).dx, lessThan(0));

      await tester.pumpAndSettle();

      expect(find.text("SlideRight"), findsOneWidget);
    });

    testWidgets("scale", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.scale,
              screen: const Column(
                children: [
                  Text("Scale"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getRect(find.byType(Column)).width, lessThan(600));
      expect(tester.getRect(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("Scale"), findsOneWidget);
    });

    testWidgets("rotate", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.rotate,
              screen: const Column(
                children: [
                  Text("Rotate"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Rotate"), findsOneWidget);
    });

    testWidgets("sizeUp", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.sizeUp,
              screen: const Column(
                children: [
                  Text("SizeUp"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getSize(find.byType(Column)).width, lessThan(600));
      expect(tester.getSize(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("SizeUp"), findsOneWidget);
    });

    testWidgets("fade", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.fade,
              screen: const Column(
                children: [
                  Text("Fade"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Fade"), findsOneWidget);
    });

    testWidgets("scaleRotate", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            getPageRoute(
              PageTransitionAnimation.scaleRotate,
              screen: const Column(
                children: [
                  Text("ScaleRotate"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getRect(find.byType(Column)).width, lessThan(600));
      expect(tester.getRect(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("ScaleRotate"), findsOneWidget);
    });
  });
}
