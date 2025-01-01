part of "../persistent_bottom_nav_bar_v2.dart";

class Style8BottomNavBar extends StatelessWidget {
  const Style8BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.itemPadding = const EdgeInsets.all(5),
    this.height = kBottomNavigationBarHeight,
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets itemPadding;
  final double height;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected) => AnimatedContainer(
        width: isSelected ? 120 : 50,
        duration: itemAnimationProperties.duration,
        curve: itemAnimationProperties.curve,
        padding: itemPadding,
        decoration: BoxDecoration(
          color: isSelected
              ? item.activeBackgroundColor
              : item.inactiveBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (item.title != null && isSelected)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FittedBox(
                    child: Text(
                      item.title!,
                      style: item.textStyle.apply(
                        color: isSelected
                            ? item.activeForegroundColor
                            : item.inactiveForegroundColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => DecoratedNavBar(
        decoration: navBarDecoration,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navBarConfig.items.map((item) {
            final int index = navBarConfig.items.indexOf(item);
            return GestureDetector(
              onTap: () {
                navBarConfig.onItemSelected(index);
              },
              child: _buildItem(
                item,
                navBarConfig.selectedIndex == index,
              ),
            );
          }).toList(),
        ),
      );
}
