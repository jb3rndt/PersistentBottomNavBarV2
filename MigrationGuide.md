# V4 -> V5 Migration Guide

All PRs on how to improve this [migration guide](https://github.com/jb3rndt/PersistentBottomNavBarV2/edit/master/MigrationGuide.md) are very welcome :)

## Using Predefined Navigation Bar Styles

To specify the style you want to use, you now have to use the corresponding widget directly, instead of `NavBarStyle.style1`. Also notice that the parameter is named differently:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
  ...,
  navBarStyle: NavBarStyle.style1
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  navBarBuilder: (navBarConfig) =>
    Style1BottomNavBar(
      navBarConfig: navBarConfig
    )
),
```

</td>
</tr>
</table>

## Using Custom Navigation Bar Styles

The additional constructor `PersistentTabView.custom` is now gone, so you now can also use the main one. Also, in your `onItemSelected` function you dont need to call `setState` anymore, just call the `navBarConfig.onItemSelected` (either by passing the function to your navigation bar (like here) or by passing `navBarConfig` into your navigation bar (like in the example in the main Readme)):

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView.custom(
  ...,
  customWidget: (navBarEssentials) =>
  CustomNavBarWidget(
      items: _navBarItems(),
      onItemSelected: (index) {
        setState(() {
            navBarEssentials
            .onItemSelected(index);
        })
      },
      selectedIndex: _controller.index,
  )
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  navBarBuilder: (navBarConfig) =>
  CustomNavBarWidget(
      items: navBarConfig.items,
      onItemSelected:
        navBarConfig
        .onItemSelected,
      selectedIndex:
        navBarConfig
        .selectedIndex,
  )
),
```

</td>
</tr>
</table>


<details>
  <summary>Removed Parameters</summary>

- itemCount
- routeAndNavigatorSettings: They are now applied inside `ItemConfig` if you need. By default they are inherited from the root navigator. More on that [here](#navigator)

</details>

## Tabs and Screens

Previously, there were two lists, one for the tab items and one for the screens. They are merged into one list now. Also, the `PersistentBottomNavBarItem` got renamed to `ItemConfig`. That concludes to the following change:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
  ...,
  screens: <Widget>[
    Screen1(),
    Screen2(),
    Screen3(),
  ],
  items: [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
  ]
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  tabs: [
    PersistentTabConfig(
      screen: Screen1(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
    PersistentTabConfig(
      screen: Screen2(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
    PersistentTabConfig(
      screen: Screen3(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
  ],
),
```

</td>
</tr>
</table>

## `PersistentTabView` and `PersistentTabView.custom`

Some of the parameters of these constructors have been removed, some changed in behavior and some got added. So everything that changed is listed here:

### Removed

- **`screens`**: Is now incorporated in `tabs` (see [above](#tabs-and-screens))
- **`bottomScreenMargin`**: The same functionality can be accomplished with `navBarOverlap: NavBarOverlap.custom(overlap: x)`
- **`context`**

### Changed

- **`backgroundColor`**: This did previously set the color of the navigation bar. Now is sets the background of the whole `PersistentTabView`.
- **`confineToSafeArea`**: Renamed to `avoidBottomPadding`
- **`selectedTabScreenContext`**: Renamed to `selectedTabContext`

### Added

- **`floatingActionButtonLocation`**: Can be used to set the location of the `floatingActionButton` like in a Scaffold
- **`navBarOverlap`**: Can be used to specify to which extend the navbar should overlap the content

## PersistentBottomNavBarItem

This got renamed to `ItemConfig`.

### `contentPadding`

This argument was only used in styles 1, 7, 9 and 10. It now has to be applied to the styles directly when building the navigation bar in form of `itemPadding`. Please note that Styles 7 and 10 have been removed due to redundancy and style 1 got renamed to style 2 and style 9 got renamed to style 8.

### Colors

The behavior of primary and secondary colors and their defaults got changed (hopefully in favor of better understandability). Without going into too much detail, the roles of primary and secondary colors swapped. Also the `activeColorPrimary` no longer serves as a default for `activeColorSecondary` (but the other way around).

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentBottomNavBarItem(
  ...,
  activeColorPrimary: Colors.red,
  inactiveColorPrimary: Colors.white,
  activeColorSecondary: Colors.blue,
  inactiveColorSecondary: Colors.grey,
),
```

</td>
<td>

```dart
ItemConfig(
  ...,
  activeColorPrimary: Colors.blue,
  inactiveColorPrimary: Colors.grey,
  activeColorSecondary: Colors.red,
  inactiveColorSecondary: Colors.white,
),
```

</td>
</tr>
</table>

### `onPressed`

This argument moved to the `PersistentTabConfig`. There you can set a method to invoke (-> `onPressed`) instead of switching to that screen:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentBottomNavBarItem(
  ...,
  onPressed: (ctx) => showDialog(...),
),
```

</td>
<td>

```dart
PersistentTabConfig.noScreen(
  item: ItemConfig(
    ...,
  ),
  onPressed: (ctx) => showDialog(...),
),
```

</td>
</tr>
</table>

### `onSelectedTabPressWhenNoScreensPushed`

Moved to `PersistentTabConfig`.

### `routeAndNavigatorSettings`

Moved to `PersistentTabConfig.navigatorConfig`. More info on that can be read [here](#routeandnavigatorsettings-1)

## RouteAndNavigatorSettings

This settings got renamed to `NavigatorConfig`. Previously you were required to pass a `RouteAndNavigatorSettings` to each of your tab items. That is not the case anymore, so you can just drop them. The Navigators for each tab now inherit everything from the root navigator above them. So if you define all your routes and route generators in your `MaterialApp` or `CupertinoApp`, they should work in your tabs just fine.

If you still need specific configuration for individual tabs, you can pass a `NavigatorConfig` to the tabs you want, like before. In the background the navigator of that tab will search through that individual `NavigatorConfig` and tries to generate a route. If it succeeds, this route will be taken, if not, it will fall back to the configuration of the root navigator and try the same with that. So you can shadow and add any routes of your root navigator.

## NavBarDecoration

This now extends the `BoxDecoration` and thus includes some more options. Extra notes on the following attributes:

- the attribute `colorBehindNavBar` moved to `PersistentTabView.backgroundColor` (which previously was the navigation bar color. The color of the navigation bar must now be set in `NavBarDecoration.decoration.color`)
- the attribute `adjustScreenBottomPaddingOnCurve` got removed in favor of more flexibility. You can accomplish the same functionality by setting `NavBarOverlap.custom(overlap: navBarDecoration.exposedHeight)` on `PersistentTabView.navBarOverlap` where `navBarDecoration` must be what you pass to you navigation bar so you might need to store that somewhere in between.

## Styles

All navigation bar styles receive the `NavBarDecoration` ([see here](#navbardecoration) for the migration of that) directly, instead of being passed through the `PersistentTabView`. So just move the `NavBarDecoration` from the `PersistentTabView` to the navigation bar widget you use:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
    ...,
    decoration: NavBarDecoration(
        color: Colors.green,
    ),
),
```

</td>
<td>

```dart
PersistentTabView(
    ...,
    navBarBuilder: (config) => Style1BottomNavBar(
        navBarConfig: config,
        navBarDecoration: NavBarDecoration(
            color: Colors.white,
        ),
    ),
),
```

</td>
</tr>
</table>

### Removed Styles

- `BottomNavStyle4` (`NavBarStyle.style4`): Use `Style4BottomNavBar` from now on
- `BottomNavStyle7` (`NavBarStyle.style7`): Use `Style2BottomNavBar`. You might need to change `ItemConfig.activeColorSecondary` to fit the design you had before.
- `BottomNavStyle10` (`NavBarStyle.style10`): Use `Style8BottomNavBar`. You might need to change `ItemConfig.activeColorSecondary` to fit the design you had before.

### Renamed Styles

- `BottomNavSimple` (`NavBarStyle.simple`) -> `Style1BottomNavBar`
- `BottomNavStyle1` (`NavBarStyle.style1`) -> `Style2BottomNavBar`
- `BottomNavStyle2` (`NavBarStyle.style2`) -> `Style3BottomNavBar`
- `BottomNavStyle3` (`NavBarStyle.style3`) -> `Style4BottomNavBar`
- `BottomNavStyle5` (`NavBarStyle.style5`) -> `Style5BottomNavBar`
- `BottomNavStyle6` (`NavBarStyle.style6`) -> `Style6BottomNavBar`
- `BottomNavStyle8` (`NavBarStyle.style8`) -> `Style7BottomNavBar`
- `BottomNavStyle9` (`NavBarStyle.style9`) -> `Style8BottomNavBar`
- `BottomNavStyle11` (`NavBarStyle.style11`) -> `Style9BottomNavBar`
- `BottomNavStyle12` (`NavBarStyle.style12`) -> `Style10BottomNavBar`
- `BottomNavStyle13` (`NavBarStyle.style13`) -> `Style11BottomNavBar`
- `BottomNavStyle14` (`NavBarStyle.style14`) -> `Style12BottomNavBar`
- `BottomNavStyle15` (`NavBarStyle.style15`) -> `Style13BottomNavBar`
- `BottomNavStyle16` (`NavBarStyle.style16`) -> `Style14BottomNavBar`
- `BottomNavStyle17` (`NavBarStyle.style17`) -> `Style15BottomNavBar`
- `BottomNavStyle18` (`NavBarStyle.style18`) -> `Style16BottomNavBar`
