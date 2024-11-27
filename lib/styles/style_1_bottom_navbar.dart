part of "../persistent_bottom_nav_bar_v2.dart";

class Style1BottomNavBar extends StatelessWidget {
  const Style1BottomNavBar({
    required this.navBarConfig,
    super.key,
    this.navBarDecoration = const NavBarDecoration(),
    this.height = kBottomNavigationBarHeight,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double height;

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
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Material(
                type: MaterialType.transparency,
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
                child: _buildItem(
                  item,
                  navBarConfig.selectedIndex == index,
                ),
              ),
            );
          }).toList(),
        ),
      );
}
