part of "../persistent_bottom_nav_bar_v2.dart";

class Style4BottomNavBar extends StatelessWidget {
  const Style4BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.height = kBottomNavigationBarHeight,
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double height;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeForegroundColor
                    : item.inactiveForegroundColor,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          if (item.title != null)
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

  @override
  Widget build(BuildContext context) {
    final double itemWidth = (MediaQuery.of(context).size.width -
            navBarDecoration.padding.horizontal) /
        navBarConfig.items.length;
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: height,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: itemAnimationProperties.duration,
                curve: itemAnimationProperties.curve,
                width: itemWidth * navBarConfig.selectedIndex,
                height: 4,
              ),
              AnimatedContainer(
                duration: itemAnimationProperties.duration,
                curve: itemAnimationProperties.curve,
                width: itemWidth,
                height: 4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: navBarConfig.selectedItem.activeForegroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navBarConfig.items.map((item) {
                final int index = navBarConfig.items.indexOf(item);
                return Flexible(
                  child: InkWell(
                    onTap: () {
                      navBarConfig.onItemSelected(index);
                    },
                    child: Center(
                      child: _buildItem(
                        item,
                        navBarConfig.selectedIndex == index,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
