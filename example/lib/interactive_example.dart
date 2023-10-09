import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'modal-screen.dart';
import 'screens.dart';

class InteractiveExample extends StatefulWidget {
  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  bool _hideNavBar = false;
  NavBarStyle _navBarStyle = NavBarStyle.style15;
  bool _hideNavigationBarWhenKeyboardShows = true;
  bool _resizeToAvoidBottomInset = true;
  bool _stateManagement = true;
  bool _handleAndroidBackButtonPress = true;
  bool _popAllScreensOnTapOfSelectedTab = true;
  bool _confineInSafeArea = true;

  List<Widget> _buildScreens() {
    return [
      MainScreen(
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      MainScreen(
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      MainScreen(
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      MainScreen(
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      MainScreen(
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: ("Search"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.add),
          title: ("Add"),
          activeColorPrimary: Colors.blueAccent,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.white,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: '/',
            routes: {
              '/first': (context) => MainScreen2(),
              '/second': (context) => MainScreen3(),
            },
          ),
          onPressed: (context) {
            if (context != null) {
              pushDynamicScreen(context,
                  screen: SampleModalScreen(), withNavBar: true);
            }
          }),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: ("Messages"),
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Bar Demo')),
      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _hideNavBar,
                    onChanged: (value) {
                      setState(() {
                        _hideNavBar = value;
                      });
                    },
                  ),
                  Text("Hide Navigation Bar"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<NavBarStyle>(
                    value: _navBarStyle,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (newStyle) {
                      if (newStyle != null) {
                        setState(() {
                          _navBarStyle = newStyle;
                        });
                      }
                    },
                    items: NavBarStyle.values
                        .map<DropdownMenuItem<NavBarStyle>>(
                            (NavBarStyle style) {
                      return DropdownMenuItem<NavBarStyle>(
                        value: style,
                        child: Text(style.toString()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _hideNavigationBarWhenKeyboardShows,
                    onChanged: (value) {
                      setState(() {
                        _hideNavigationBarWhenKeyboardShows = value;
                      });
                    },
                  ),
                  Text("Hide Navigation Bar\nWhen Keyboard Shows"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _resizeToAvoidBottomInset,
                    onChanged: (value) {
                      setState(() {
                        _resizeToAvoidBottomInset = value;
                      });
                    },
                  ),
                  Text("Resize to avoid bottom inset"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _stateManagement,
                    onChanged: (value) {
                      setState(() {
                        _stateManagement = value;
                      });
                    },
                  ),
                  Text("State Management"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _handleAndroidBackButtonPress,
                    onChanged: (value) {
                      setState(() {
                        _handleAndroidBackButtonPress = value;
                      });
                    },
                  ),
                  Text("Handle Android Back Button Press"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _popAllScreensOnTapOfSelectedTab,
                    onChanged: (value) {
                      setState(() {
                        _popAllScreensOnTapOfSelectedTab = value;
                      });
                    },
                  ),
                  Text("Pop all screens when\ntapping current tab"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _confineInSafeArea,
                    onChanged: (value) {
                      setState(() {
                        _confineInSafeArea = value;
                      });
                    },
                  ),
                  Text("Confine in Safe Area"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: _confineInSafeArea,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: _handleAndroidBackButtonPress,
        resizeToAvoidBottomInset: _resizeToAvoidBottomInset,
        stateManagement: _stateManagement,
        navBarHeight: kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: _hideNavigationBarWhenKeyboardShows,
        margin: EdgeInsets.zero,
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        onWillPop: (context) async {
          if (context != null) {
            await showDialog(
              context: context,
              useSafeArea: true,
              builder: (context) => Container(
                height: 50.0,
                width: 50.0,
                color: Colors.white,
                child: ElevatedButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          }
          return false;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          borderRadius: BorderRadius.circular(20.0),
        ),
        popAllScreensOnTapOfSelectedTab: _popAllScreensOnTapOfSelectedTab,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: _navBarStyle,
      ),
    );
  }
}
