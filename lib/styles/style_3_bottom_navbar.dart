part of "../persistent_bottom_nav_bar_v2.dart";

class Style3BottomNavBar extends StatelessWidget {
  const Style3BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.height = kBottomNavigationBarHeight,
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double height;

  Widget _buildItem(ItemConfig item, bool isSelected) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
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
                isSelected ? item.title! : " ",
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
