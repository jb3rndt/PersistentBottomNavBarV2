import "package:example/interactive_example.dart";
import "package:example/screens.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const PersistenBottomNavBarDemo());
}

class PersistenBottomNavBarDemo extends StatelessWidget {
  const PersistenBottomNavBarDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Persistent Bottom Navigation Bar Demo",
        home: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/minimal"),
                  child: const Text("Show Minimal Example"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/interactive"),
                  child: const Text("Show Interactive Example"),
                ),
              ],
            ),
          ),
        ),
        routes: {
          "/minimal": (context) => const MinimalExample(),
          "/interactive": (context) => const InteractiveExample(),
        },
      );
}

class MinimalExample extends StatelessWidget {
  const MinimalExample({super.key});

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
          navigatorConfig: NavigatorConfig(
            initialRoute: "/home",
            navigatorObservers: [AnalyticsNavigatorObserver()],
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Messages",
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
    tabs: _tabs(),
    navBarBuilder: (navBarConfig) => Style1BottomNavBar(
      navBarConfig: navBarConfig,
    ),
  );
}



class AnalyticsNavigatorObserver extends NavigatorObserver {
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("didPush");
    print("new route: ${route.settings.name}");
    print("previous route: ${previousRoute?.settings.name}");
    print("------------------------------------------------");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("didPop");
    print("new route: ${route.settings.name}");
    print("previous route: ${previousRoute?.settings.name}");
    print("------------------------------------------------");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("didRemove");
    print("new route: ${route.settings.name}");
    print("previous route: ${previousRoute?.settings.name}");
    print("------------------------------------------------");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print("didReplace");
    print("new route: ${newRoute?.settings.name}");
    print("previous route: ${oldRoute?.settings.name}");
    print("------------------------------------------------");
  }
}