part of "../persistent_bottom_nav_bar_v2.dart";

class NeumorphicBottomNavBar extends StatelessWidget {
  const NeumorphicBottomNavBar({
    required this.navBarConfig,
    super.key,
    this.navBarDecoration = const NavBarDecoration(),
    this.neumorphicProperties = const NeumorphicProperties(),
    this.height = kBottomNavigationBarHeight,
  });

  final NavBarConfig navBarConfig;
  final NeumorphicProperties neumorphicProperties;
  final NavBarDecoration navBarDecoration;
  final double height;

  Widget _getNavItem(
    ItemConfig item,
    bool isSelected,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color: isSelected
                  ? item.activeForegroundColor
                  : item.inactiveForegroundColor,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (neumorphicProperties.showSubtitleText)
            FittedBox(
              child: Text(
                item.title!,
                style: item.textStyle.apply(
                  color: isSelected
                      ? item.activeForegroundColor
                      : item.inactiveForegroundColor,
                ),
              ),
            ),
        ],
      );

  Widget _buildItem(
    BuildContext context,
    ItemConfig item,
    bool isSelected,
  ) =>
      neumorphicProperties.decoration?.color?.opacity == 1.0
          ? NeumorphicContainer(
              decoration: neumorphicProperties.decoration,
              bevel: neumorphicProperties.bevel,
              curveType: isSelected
                  ? CurveType.emboss
                  : neumorphicProperties.curveType,
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: _getNavItem(item, isSelected),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: neumorphicProperties.decoration?.borderRadius,
                color: neumorphicProperties.decoration?.color,
              ),
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: _getNavItem(item, isSelected),
            );

  @override
  Widget build(BuildContext context) => DecoratedNavBar(
        decoration: navBarDecoration,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: navBarConfig.items.map((item) {
            final int index = navBarConfig.items.indexOf(item);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  navBarConfig.onItemSelected(index);
                },
                child: _buildItem(
                  context,
                  item,
                  navBarConfig.selectedIndex == index,
                ),
              ),
            );
          }).toList(),
        ),
      );
}
