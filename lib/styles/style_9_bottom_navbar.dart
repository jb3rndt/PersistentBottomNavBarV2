part of "../persistent_bottom_nav_bar_v2.dart";

class Style9BottomNavBar extends StatelessWidget {
  const Style9BottomNavBar({
    required this.navBarConfig,
    super.key,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.height,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double? height;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected, int itemIndex) => Column(
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
      if (item.title != null)
        AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.0,
          duration: itemAnimationProperties.duration,
          child: AnimatedSlide(
            duration: itemAnimationProperties.duration,
            offset: Offset(0, isSelected ? 0 : 1),
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
  );

  @override
  Widget build(BuildContext context) => DecoratedNavBar(
    decoration: navBarDecoration,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: navBarConfig.items.map((item) {
        final int index = navBarConfig.items.indexOf(item);
        return Expanded(
          child: InkWell(
            onTap: () {
              navBarConfig.onItemSelected(index);
            },
            child: _buildItem(item, navBarConfig.selectedIndex == index, index),
          ),
        );
      }).toList(),
    ),
  );
}
