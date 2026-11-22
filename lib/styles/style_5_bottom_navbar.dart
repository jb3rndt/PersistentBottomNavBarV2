part of "../persistent_bottom_nav_bar_v2.dart";

class Style5BottomNavBar extends StatelessWidget {
  const Style5BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
    ),
    this.height,
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final double? height;

  Widget _buildItem(ItemConfig item, bool isSelected) => Column(
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
      const SizedBox(height: 2),
      Container(
        height: 5,
        width: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? item.activeBackgroundColor : Colors.transparent,
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
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              navBarConfig.onItemSelected(index);
            },
            child: _buildItem(item, navBarConfig.selectedIndex == index),
          ),
        );
      }).toList(),
    ),
  );
}
