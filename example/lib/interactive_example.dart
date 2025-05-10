import "package:example/screens.dart";
import "package:example/settings.dart";
import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

class InteractiveExample extends StatefulWidget {
  const InteractiveExample({super.key});

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  final PersistentTabController _controller = PersistentTabController();
  Settings settings = Settings();
  bool _hideTab = false;

  List<PersistentTabConfig> _tabs() => [
        if (!_hideTab)
          PersistentTabConfig(
            screen: const MainScreen(),
            item: ItemConfig(
              icon: const Icon(Icons.home),
              title: "Home",
              activeForegroundColor: Colors.blue,
              inactiveForegroundColor: Colors.grey,
            ),
          ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.search),
            title: "Search",
            activeForegroundColor: Colors.teal,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: const Icon(Icons.add),
            title: "Add",
            activeForegroundColor: Colors.blueAccent,
            inactiveForegroundColor: Colors.grey,
          ),
          onPressed: (context) {
            setState(() {
              _hideTab = !_hideTab;
            });
          },
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Messages",
            activeForegroundColor: Colors.deepOrange,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
            activeForegroundColor: Colors.indigo,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        controller: _controller,
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => settings.navBarBuilder(
          navBarConfig,
          NavBarDecoration(
            color: settings.navBarColor,
            borderRadius: BorderRadius.circular(10),
          ),
          const ItemAnimation(),
          const NeumorphicProperties(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SettingsView(
                settings: settings,
                onChanged: (newSettings) => setState(() {
                  settings = newSettings;
                }),
              ),
            ),
          ),
          child: const Icon(Icons.settings),
        ),
        backgroundColor: Colors.green,
        margin: settings.margin,
        avoidBottomPadding: settings.avoidBottomPadding,
        handleAndroidBackButtonPress: settings.handleAndroidBackButtonPress,
        resizeToAvoidBottomInset: settings.resizeToAvoidBottomInset,
        stateManagement: settings.stateManagement,
        hideNavigationBar: settings.hideNavBar,
        hideOnScrollVelocity: settings.hideOnScrollVelocity,
        selectedTabPressConfig: settings.selectedTabPressConfig,
      );
}
