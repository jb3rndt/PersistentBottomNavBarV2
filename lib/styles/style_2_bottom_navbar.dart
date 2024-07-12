part of "../persistent_bottom_nav_bar_v2.dart";


class Style2BottomNavBar extends StatelessWidget {
  const Style2BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.itemPadding = const EdgeInsets.all(5),
    this.itemDecoration = const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50))),
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets itemPadding;
  final BoxDecoration itemDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Widget _buildItem(ItemConfig item, bool isSelected, double deviceWidth) =>
      AnimatedContainer(
        width: isSelected ? deviceWidth * 0.29 : deviceWidth * 0.12,
        duration: itemAnimationProperties.duration,
        curve: itemAnimationProperties.curve,
        padding: itemPadding,
        decoration: itemDecoration.copyWith(
            color: isSelected
                ? item.activeBackgroundColor
                : item.inactiveBackgroundColor),
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
                  child: Text(
                    item.title!,
                    softWrap: false,
                    style: item.textStyle.apply(
                      color: isSelected
                          ? item.activeForegroundColor
                          : item.inactiveForegroundColor,
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
        filter: navBarConfig.selectedItem.filter,
        opacity: navBarConfig.selectedItem.opacity,
        height: navBarConfig.navBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navBarConfig.items.map((item) {
            final int index = navBarConfig.items.indexOf(item);
            return InkWell(
              onTap: () {
                navBarConfig.onItemSelected(index);
              },
              child: _buildItem(
                item,
                navBarConfig.selectedIndex == index,
                MediaQuery.of(context).size.width,
              ),
            );
          }).toList(),
        ),
      );
}

