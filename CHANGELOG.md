# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [6.3.0] - 2026-02-23
## [6.2.0] - 2025-10-28
### Changed
- bump gorouter to 16.3.0

## [6.1.0] - 2025-06-22
### Changed
- bump gorouter to 15.2.3

## [6.0.1] - 2025-05-18
### Fixed
- If no custom NavigatorKeys were specified, the state of each tab got lost when reloading.

## [6.0.0] - 2025-05-17
### Added
- Hide the NavBar on scroll: Set `hideOnScrollVelocity` to x (x != 0) to make the NavBar disappear after x pixels have been scrolled (and reappear respectively)
- `SelectedTabPressConfig`, which is responsible for any configuration when the selected tab is pressed again.
  - `SelectedTabPressConfig.popAction` allows to specify how many screens of the current tab should be popped if the tab is pressed again
  - `SelectedTabPressConfig.scrollToTop` enables automatically scrolling the tab content to top if the current tab is pressed again. This requires a ScrollController on each `PersistentTabConfig.scrollController` for each tab this should be activated for.
  - `SelectedTabPressConfig.onPressed` is a callback that gets executed whenever the current tab is pressed again. I also provides an argument whether there are any pages pushed to the tab.
- Navigator function that pop all screens of the current tab: `popAllScreensOfCurrentTab`
- Animated Icons: Animate the navigation bar icons by using the provided `AnimatedIconWrapper` (see README for more)
- PersistentTabController now gives you access to the previousIndex

### Breaking Changes
- Change the default of `navBarOverlap` to `NavBarOverlap.none()` (previously was `NavBarOverlap.full()`)
- Removed ItemConfig.opacity. Instead, set the opacity on the NavBarDecoration.color directly
- Removed ItemConfig.filter. Use NavBarDecoration.filter instead
- Removed default value of NavBarDecoration.filter
- Removed `selectedTabContext`. Use the list of your tabs instead to get the current tab context like so: `tabs[controller.index].navigatorConfig.navigatorKey.currentContext`
- Removed `PersistentTabController.onIndexChanged`. Use `PersistentTabController.listen` instead.
- Replaced `popAllScreensOnTapAnyTabs` with `keepNavigatorHistory`. The meaning (and default value) of this parameter is thus inverted. To migrate, flip the boolean value for that parameter if you use it.
- Combined `popAllScreensOnTapOfSelectedTab` and `popActionScreens` into the `SelectedTabPressConfig.popAction`.
  - Set `SelectedTabPressConfig.popAction` to `PopActionType.all` to pop all screens of the selected tab if it is pressed again
  - Set `SelectedTabPressConfig.popAction` to `PopActionType.single` to pop a single screen of the selected tab if it is pressed again
  - Set `SelectedTabPressConfig.popAction` to `PopActionType.none` to do nothing if it the selected tab pressed again
- Replaced `onSelectedTabPressWhenNoScreensPushed` with `SelectedTabPressConfig.onPressed`. The `onPressed` parameter informs you whether any pages are currently pushed to that tab.
- Removed `navBarHeight` parameter. Use the `height` parameter of each style instead if needed. `height` is not mandatory, so by default no specific height is set. Use `kBottomNavigationBarHeight` if you want the default previous behavior.

### Fixed
- Adjusting the number of tabs at runtime threw an error
- The state of each tab was not disposed if stateManagement was true and gestures were enabled

## [5.4.0] - 2025-05-04
## Fixed
- Allow changing the tabs at runtime

## [5.3.1] - 2024-10-03
### Fixed
- Improve documentation on the historyLength (https://github.com/jb3rndt/PersistentBottomNavBarV2/pull/138)
- Fix opacity overriding NavBarDecoration color (https://github.com/jb3rndt/PersistentBottomNavBarV2/issues/181)

## [5.3.0] - 2024-07-06
### Fixed
- Only dispose PersistentTabController if it is automatically created. If you pass your own, you are responsible to dispose it manually.
- Handle popAllScreensOnTapAnyTabs correctly

## [5.2.3] - 2024-04-24
### Fixed
- popAllScreensOnTapOfSelectedTab and onSelectedTabPressWhenNoScreensPushed did not work properly when an initialRoute was set for that tab

## [5.2.2] - 2024-04-11
### Fixed
- NavigatorConfig.initialRoute did not get passed to the respective Navigator
- Mark ItemConfig.color and filter as deprecated

## [5.2.1] - 2024-04-10
### Fixed
- Navbar got clipped and thus didnt show a boxShadow

## [5.2.0] - 2024-04-03
### Changed
- Mark onWillPop as deprecated

### Fixed
- Navigator.copyWith didn't properly copy the navigatorKey
- Rewrite usage of PopScope by providing `canPop: true` when all child navigators are clear and the initial tab is selected to the give pop control to the ancestors or correctly pop/close the app if no parent PopScope exists (thus maintaining natural PopScope behavior)
- PopScope now just blocks popping until the initial tab is selected and the child navigator cant be popped anymore

## [5.1.0] - 2024-03-28
### Fixed
- Fix deprecation of colorScheme.background
- The Main Scaffold only extends its body if necessary (full overlap or hidden navbar) to prevent unnecessary padding (equal to navbar height)
- Replace NavBar SlideTransition with SizeTransition to correctly report its size to the Main Scaffold
- Pass on the source padding to the Main Scaffold Body if the navbar is hidden
- Pass the source viewPadding if navbar is hidden and the new body padding of the Main Scaffold as a new viewPadding to the tabs to ensure better placement of FABs on individual screens
- Prevent Navbar jumping when keyboard opens because the keyboard consumes the MediaQuery.padding.bottom
- Prevent Navbar jumping when keyboard opens because the keyboard consumes the MediaQuery.padding.bottom
- Fix tabs overlaying each other if no transition animation should be shown

## [5.0.0] - 2024-03-13
### Added
- Easier and less error-prone usage api ([MIGRATION GUIDE](https://github.com/jb3rndt/PersistentBottomNavBarV2/blob/master/MigrationGuide.md))
- Support for go\_router
- Change the tab by sliding left/right (if enabled)

### Fixed
- A ton of internal improvements

## [5.0.0-beta.10] - 2024-03-13
### Changed
- Rename ItemConfig color attributes

### Fixed
- Make PersistentTabConfig.noScreen onPressed mandatory

## [5.0.0-beta.9] - 2024-03-04
## [5.0.0-beta.8] - 2024-01-15
### Fixed
- Make ItemConfig inactiveIcon of Type Widget

## [5.0.0-beta.7] - 2023-12-06
### Fixed
- Upgrade go\_router to 12.1.1
- Make page switching transition rtl compatible
- Fix \_animation not initialized error
- Switching tabs without stateManagement caused re-initializations of all loaded pages

## [5.0.0-beta.6] - 2023-09-12
### Added
- Add `animatedTabBuilder` to customize the transition when switching tabs
- Support for Router API

### Fixed
- Tab slide animation no longer shows intermediate tabs in the slide animation when switching to non adjacent tabs

## [4.2.8] - 2023-03-27
### Fixed
- Remove label padding in simple style
- Check if context is non-null before popping all screens

## [5.0.0-beta.5] - 2023-02-27
### Added
- Tab history when using android back button

### Fixed
- ScreenTransitionAnimation with Duration.zero was throwing an error in the animation phase

### Removed
- Remove unused attribute `_animateTabTransition` on `ScreenTransitionAnimation`

## [5.0.0-beta.4] - 2023-02-12
### Added
- Support `drawerEdgeDragWidth`

## [5.0.0-beta.3] - 2023-02-12
### Added
- A drawer can be passed to the PersistentTabView to be usable in every tab

### Changed
- Renamed ItemAnimationProperties to ItemAnimation
- Made ScreenTransitionAnimation.animateTabTransition private
- Improved Example

## [5.0.0-beta.2] - 2022-11-28
### Fixed
- Migration Guide Link in the Readme

## [5.0.0-beta.1] - 2022-11-19
### Breaking Changes
- `itemAnimationProperties`, `neumorphicProperties` and `navBarDecoration` now have to be applied to the NavBar Widget directly
- navBarStyle now is a widget builder which also allows to pass a custom Widget instead of only the predefined ones
- Remove `PersistenTabView.custom` (use `PersistentTabView` instead) constructor
- Make items primary color the title and icon color and secondary the background color
- `backgroundColor` now changes the color of the background
- `NavBarOverlap` replaces the `buttomScreenMargin`

### Changed
- Remove PersistentTabViewBase
- Replace `CupertinoPageScaffold` with `Scaffold`
- Trimmed the styles
- Make inactiveIcon default to icon globally
- Tabs Navigators inherit the settings of the root Navigator
- Make null-safety safer

## [4.2.7] - 2022-11-13
### Fixed
- Scroll to top on iOS (#34 via #72)
- Fix text color in dark mode on iOS (#71)

## [4.2.6] - 2022-10-30
### Fixed
- Fix text color issues with style 3

## [4.2.5] - 2022-08-16
### Fixed
- Fix cast error when using `onWillPop` with `handleAndroidBackButtonPress: false`

## [4.2.4] - 2022-07-01
### Fixed
- Using bottom item TextStyle on style3 caused cast error

## [4.2.3] - 2022-06-03
### Fixed
- `selectedTabScreenContext` returned a wrong context after visiting the tabs the first time

## [4.2.2] - 2022-05-31
### Fixed
- Using one border side in NavbarDecoration caused an error (see [\#21](https://github.com/jb3rndt/PersistentBottomNavBarV2/issues/21))

## [4.2.1] - 2022-05-29
### Added
- Add basic tests

### Fixed
- Change `NavBarPadding.fromLTRB to use correct order`

## [4.2.0] - 2022-05-23
### Changed
- Fixed bug where the NavigatorObservers of a custom PersistenTabView threw errors when switching to another tab
- Fixed using the correct navigatorKeys for the correct tab
- **Breaking Change**: The `CustomWidgetRouteAndNavigatorSettings.navigatorObservers` are now a list of lists of NavigatorObservers, so each tab has its own list of NavigatorObervers. See the attribute for more information and an example

## [4.1.11] - 2022-05-13
### Changed
- Support Flutter 3.0.0 without triggering warnings (see `_ambiguate` function for more)

## [4.1.10] - 2022-04-25
### Changed
- Remove label top padding in most styles because it broke layout for custom image icons (see [\#20](https://github.com/jb3rndt/PersistentBottomNavBarV2/issues/20))

## [4.1.9] - 2022-04-02
### Changed
- Add `navBarHeight` to `PersistentTabView.custom`

## [4.1.8] - 2022-03-19
### Fixed
- Fix animation repeating when dependencies change

## [4.1.7] - 2022-03-19
### Added
- Re-add example
- Add more documentation

## [4.1.6] - 2022-03-19
### Fixed
- Fixed empty tabs when fastly switching tabs with animations enabled

## [4.1.5] - 2022-03-17
### Fixed
- Fix issue with `navbarDecoration.borderRadius` being null but expected to not be null by styles 15 and 16

## [4.1.4] - 2022-03-17
### Added
- Adding interactive example

### Changed
- `PersistentTabView.custom` passes `hideNavigationBarWhenKeyboardShows` to `super`
- **Breaking** `resizeToAvoidBottomInset` defaults to `true` as per docs

### Fixed
- `hideNavigationBarWhenKeyboardShows` no longer depends on `resizeToAvoidBottomInset` to work properly

## [4.1.3] - 2022-03-05
### Fixed
- Respect background color config in navbar

## [4.1.2] - 2022-03-02
### Fixed
- Remove old debugging print

## [4.1.1] - 2022-01-20
### Fixed
- Hotfix for `popAllScreensOnTapOfSelectedTab` of `PersistentTabView.custom`
- `PersistentTabView.custom` now also needs the items
- You have to call `navBarEssentials.onItemSelected(index)` to trigger navigator stack clearing
- **Breaking**: `customWidget` now is a builder that receives `navBarEssentials`
- **Breaking**: To make `popAllScreensOnTapOfSelectedTab` work, specify your `onItemSelected` function of the `CustomWidget` like this:

## [4.1.0] - 2022-01-20
### Added
- `PersistentTabView.custom` now supports `popAllScreensOnTapOfSelectedTab`

### Fixed
- **Breaking**: `CutsomWidgetRouteAndNavigatorSettings` got renamed to `CustomWidgetRouteAndNavigatorSettings`

## [4.0.3] - 2022-01-20
### Changed
- Republish package to [persistent\_bottom\_nav\_bar\_v2](https://pub.dev/packages/persistent_bottom_nav_bar_v2)

## [4.0.2] - 2021-03-27
### Fixed
- Fixed error while pushing new screens through the included Navigator functions.

## [4.0.1] - 2021-03-27
### Fixed
- Fixed type cast error with `NavigatorObserver`.

## [4.0.0] - 2021-03-22
### Changed
- Null safety migration.

## [3.2.0] - 2021-03-21
### Added
- `inactiveIcon` is now available in `PersistentBottomNavBarItem`.
- Fixed the bug where all screens of a tab would be popped while switching between tabs.
- Bug fixes.
- **Breaking Changes**
- `onWillPop` function now will return the selected screen's context.
- **PersistentBottomNavBarItem**
- `routeAndNavigatorSettings` has been removed for **non-custom** navigation bar. Instead, you must now declare `routeAndNavigatorSettings` in `PersistentBottomNavBarItem`.
- `activeColor` is now `activeColorPrimary`.
- `inactiveColor` is now `inactiveColorPrimary`.
- `activeColorAlternate` is now `activeColorSecondary`.
- `onPressed` now returns context of the selected screen.

## [3.1.0] - 2020-12-06
### Added
- Argument `routeAndNavigatorSettings` added to handle `Navigator.pushNamed(context, 'routeName')`. Please define your routes and other navigator settings like navigator observers here as well.
- **Breaking Changes**
- Arguments `initalRoute`, `navigatorObservers` and `navigatorKeys` removed and shifted to `routeAndNavigatorSettings`.

## [3.0.0] - 2020-12-06
### Added
- Added new arguments `navigatorObservers` and `navigatorKeys` for the main navigation bar widget.
- No need to call `setState` when updating active tab using the PersistentTabController.
- Function argument `selectedTabScreenContext` exposes `context` of the selected tab.
- Bug fixes and code refactoring.
- **Breaking Changes**
- `context` is now required in the constructor.
- For custom widget, use this constructor `PersistentTabView.custom()`.
- `NavBarStyle.custom` has been removed. Please use `PersistentTabView.custom()`.
- Argument `iconSize` has been shifted to PersistentBottomNavBarItem.
- PersistentBottomNavBarItem argument `activeContentColor`'s name has been changed to `activeColorSecondary`. Functionality remains the same.
- PersistentBottomNavBarItem argument `titleStyle`'s name has been changed to `textStyle`. Functionality remains the same.

## [2.1.0] - 2020-10-02
### Added
- Added `TextStyle` property for title in the PersistentBottomNavBarItem.
- Added `margin` property for the navigation bar.
- Bug fixes.

## [2.0.5] - 2020-07-16
### Fixed
- Bug fixes related to decoration border.

## [2.0.4] - 2020-07-16
### Fixed
- Bug fixes.

## [2.0.3] - 2020-07-16
### Fixed
- Bug fixes.

## [2.0.2] - 2020-07-15
### Fixed
- Fixed `hideNavigationBar` animation jitter and updated Readme.

## [2.0.1] - 2020-07-15
### Changed
- README updated.

## [2.0.0] - 2020-07-15
### Added
- Added transition animations to the Navigator functions.
- Padding simplified into a single property and uses `NavBarPadding` instead of EdgeInsets.
- New property called 'decoration' where are decoration related properties have been moved like curveRadius, boxShadow etc.
- New property to hide the Navigation Bar when keyboard appears.
- For those wanting to display a custom dialog when user tries to exit the app on **Android only**, use `onWillPop` the callback function.
- 8 new styles added.
- Animation properties for all styles can now be controlled through the property `itemAnimationProperties`.
- Ability to turn off state management.
- Screen transition animation added. Can be controlled with the property `screenTransitionAnimation`.
- Ability to use custom behavior on tapping of a navigation bar's tab/item through `onPressed` callback method in the `PersistentBottomNavBarItem`.
- Removed `platformSpecific` property from Navigator functions to make it compatible with Flutter-Web.
- Minor new features, bug fixes and stability improvements.

## [1.5.5] - 2020-05-11
### Added
- Added property `bottomScreenPadding` to control a screen's bottom padding.
- Added property `navBarCurveRadius` to change the nav bar curve's radius.
- Added property `popAllScreensOnTapOfSelectedTab` to toggle between the ability to pop all pushed screens of a particular selected tab on the second press of the said tab.

## [1.5.4] - 2020-05-07
### Fixed
- Fixed background shadow issue when translucency was turned on with `showElevation == true`.

## [1.5.3] - 2020-05-07
### Changed
- Updated Readme file.

## [1.5.2] - 2020-05-07
### Added
- Added an example for the navigator function `pushDynamicScreen` in the sample project.
- Minor improvements to some styles.

### Fixed
- Fixed nav bar background color consistency when translucency enabled.

## [1.5.1] - 2020-04-30
### Changed
- Reverted changes to `PersistentTabController`.

## [1.5.0] - 2020-04-30
### Added
- Added feature to pop back to first screen on tapping of an already selected tab.

### Fixed
- Fixed the issue when new tab was added dynamically.
- Fixed safe area issues.
- Removed property `selectedIndex` as it was redundant. Use `PersistentTabController` to control it instead. `Breaking Change`
- Bug fixes.

## [1.4.5] - 2020-04-29
### Fixed
- Fixed nav bar translucency for provided styles.

## [1.4.4] - 2020-04-29
### Changed
- Updated dependencies.
- Removed `allCorners` value from `NavBarCurve` as it became redundant after a fix.

## [1.4.1] - 2020-04-29
### Changed
- Improvements to readme.

## [1.4.0] - 2020-04-29
### Added
- Implemented handling of the Android back button.

### Changed
- Updated navigation bar height to give it the default platform look.
- Updated styles to fix the issue where a tap would not be registered.

### Fixed
- Fixed the issue where the app would not close at all on Android back button press.

## [1.3.0] - 2020-04-25
### Added
- Incorporated the much requested ability to customize your own bottom navigation bar widget.
- Android's back button will no longer close the app.

## [1.2.1] - 2020-03-23
### Fixed
- Fixed centering of label text in style 1, 7, 9 and 10.

## [1.2.0] - 2020-03-20
### Added
- Added `navBarHeight` and `floatingActionWidget` properties, some bug fixes and (`BREAKING CHANGE`) `isCurved` property is now replaced with `navBarCurve` which accepts `NavBarCurve`.

## [1.1.5] - 2020-03-04
### Fixed
- Fixed issue for style 6 and 8 where a tap would not be registered occasionally.

## [1.1.4] - 2020-03-03
### Fixed
- Bug fixes and improvements for style 6 and 8.

## [1.1.3] - 2020-03-02
### Fixed
- Bug fixes.

## [1.1.2] - 2020-03-01
### Changed
- Updated project description.

## [1.1.1] - 2020-03-01
### Fixed
- Memory leakage improvements.

## [1.1.0] - 2020-03-01
### Added
- Added `Neumorphic` design for the navigation bar.
- Scale animations for style 7 and 8.
- More control over translucency.
- Bug fixes and improvements.

## [1.0.15] - 2020-01-27
### Fixed
- bug fixes.

## [1.0.14] - 2020-01-27
### Changed
- Fixed `showElevation` invisible shadow issue.

## [1.0.13] - 2020-01-27
### Fixed
- bug fixes.

## [1.0.12] - 2020-01-27
### Changed
- Increased space between icon and text for most styles (can be reverted by the use of `bottomPadding` property).

## [1.0.11] - 2020-01-27
### Fixed
- bug fixes.

## [1.0.10] - 2020-01-26
### Fixed
- bug fixes.

## [1.0.9+2] - 2020-01-26
### Changed
- transparency color improvements.

## [1.0.9+1] - 2020-01-26
### Fixed
- bug fixes.

## [1.0.9] - 2020-01-26
### Added
- Added `isTranslucent` property for `PersistentBottomNavBarItem`.
- Tweaked `style8` and `style9`'s magnification.

## [1.0.8] - 2020-01-24
### Fixed
- Fixed error thrown if `onItemSelected` was not declared.
- Wrapped screens with `Material` for material elements.

## [1.0.7+4] - 2020-01-23
### Changed
- Updated README file.

## [1.0.7+3] - 2020-01-20
### Changed
- Updated `style10`'s and `style7`'s shadow.

## [1.0.7+2] - 2020-01-20
### Changed
- Updated `style10`'s and `style7`'s shadow.

## [1.0.7+1] - 2020-01-20
### Changed
- Updated `style10`'s borders.

## [1.0.7] - 2020-01-20
### Changed
- Updated `style8`'s text magnification and added new `style10`.

## [1.0.6+1] - 2020-01-20
### Changed
- Updated navigator functions' arguments `BREAKING CHANGE`.

## [1.0.6] - 2020-01-20
### Changed
- Updated navigator functions' arguments and added a new nav bar style.

## [1.0.5] - 2020-01-18
### Changed
- Updated return type of navigator functions.

## [1.0.4] - 2020-01-16
### Added
- Added function for pushing `modal` screens.

## [1.0.3+5] - 2020-01-16
### Changed
- Updated style8's magnification.

## [1.0.3+4] - 2020-01-16
### Added
- Added another style for the nav bar.
- Added `horizontalPadding` property for the nav bar.

### Changed
- Updated navigator functions.

## [1.0.3+3] - 2020-01-10
### Fixed
- Fixed issue with `bottomPadding`.

## [1.0.3+2] - 2020-01-09
### Changed
- Updated `pushNewScreen` functions.

## [1.0.3+1] - 2020-01-09
### Changed
- Updated project description.

## [1.0.3] - 2020-01-09
### Added
- 'bottomPadding` property for navigation bar items.

### Changed
- Updated font sizes

## [1.0.2+1] - 2020-01-09
### Fixed
- Fixes in `pushNewScreen`.

## [1.0.2] - 2020-01-09
### Fixed
- Fixes in `pushNewScreen`.

## [1.0.1] - 2020-01-09
### Changed
- Updated package's description.

## [1.0.0] - 2020-01-09
### Added
- Stable version released.

## [0.0.5] - 2020-01-09
### Fixed
- Fixed formatting.

## [0.0.4] - 2020-01-09
### Added
- Example project added to repository.

## [0.0.3] - 2020-01-08
### Changed
- Updated README.md

## [0.0.2] - 2020-01-08
### Changed
- Updated README.md

## [0.0.1] - 2020-01-08
### Added
- Persistent Bottom Navigation.
- Ability to push new screen with or without bottom navigation bar.
- 8 styles for the bottom navigation bar (includes BottomNavyBar style).
- Includes function for pushing screen with or without the bottom navigation bar i.e. pushNewScreen() and pushNewScreenWithRouteSettings().
- Includes platform specific behavior as an option (specify it in the two navigator functions).
- Based on flutter's Cupertino(iOS) bottom navigation bar.

[6.3.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/6.2.0...6.3.0
[6.2.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/6.1.0...6.2.0
[6.1.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/6.0.1...6.1.0
[6.0.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/6.0.0...6.0.1
[6.0.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.4.0...6.0.0
[5.4.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.3.1...5.4.0
[5.3.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.3.0...5.3.1
[5.3.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.2.3...5.3.0
[5.2.3]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.2.2...5.2.3
[5.2.2]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.2.1...5.2.2
[5.2.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.2.0...5.2.1
[5.2.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.1.0...5.2.0
[5.1.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0...5.1.0
[5.0.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.10...5.0.0
[5.0.0-beta.10]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.9...5.0.0-beta.10
[5.0.0-beta.9]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.8...5.0.0-beta.9
[5.0.0-beta.8]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.7...5.0.0-beta.8
[5.0.0-beta.7]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.6...5.0.0-beta.7
[5.0.0-beta.6]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.5...5.0.0-beta.6
[4.2.8]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.7...4.2.8
[5.0.0-beta.5]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.4...5.0.0-beta.5
[5.0.0-beta.4]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.3...5.0.0-beta.4
[5.0.0-beta.3]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/5.0.0-beta.2...5.0.0-beta.3
[5.0.0-beta.2]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.7...5.0.0-beta.2
[5.0.0-beta.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.7...5.0.0-beta.1
[4.2.7]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.6...4.2.7
[4.2.6]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.5...4.2.6
[4.2.5]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.4...4.2.5
[4.2.4]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.3...4.2.4
[4.2.3]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.2...4.2.3
[4.2.2]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.1...4.2.2
[4.2.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2/compare/4.2.0...4.2.1
[4.2.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2/releases/tag/v4.2.0
[4.1.11]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.10]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.9]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.8]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.7]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.6]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.5]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.4]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.3]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.2]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.1]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.1.0]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.0.3]: https://github.com/jb3rndt/PersistentBottomNavBarV2
[4.0.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[4.0.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[4.0.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[3.2.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[3.1.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[3.0.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.1.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[2.0.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.5.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.4.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.4.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.4.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.4.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.3.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.2.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.2.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.1.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.15]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.14]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.13]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.12]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.11]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.10]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.9+2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.9+1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.9]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.8]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.7+4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.7+3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.7+2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.7+1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.7]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.6+1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.6]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3+5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3+4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3+3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3+2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3+1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.2+1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
[1.0.0]: https://github.com/BilalShahid13/PersistentBottomNavBar
[0.0.5]: https://github.com/BilalShahid13/PersistentBottomNavBar
[0.0.4]: https://github.com/BilalShahid13/PersistentBottomNavBar
[0.0.3]: https://github.com/BilalShahid13/PersistentBottomNavBar
[0.0.2]: https://github.com/BilalShahid13/PersistentBottomNavBar
[0.0.1]: https://github.com/BilalShahid13/PersistentBottomNavBar
