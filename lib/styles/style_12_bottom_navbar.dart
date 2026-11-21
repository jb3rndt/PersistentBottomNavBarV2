part of "../persistent_bottom_nav_bar_v2.dart";

class Style12BottomNavBar extends StatelessWidget {
  const Style12BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.height,
    super.key,
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
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
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
      AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.0,
        duration: itemAnimationProperties.duration,
        child: AnimatedSlide(
          duration: itemAnimationProperties.duration,
          offset: Offset(0, isSelected ? 0 : 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: item.activeBackgroundColor,
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
