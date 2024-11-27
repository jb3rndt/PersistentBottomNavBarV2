part of "../persistent_bottom_nav_bar_v2.dart";

class Style16BottomNavBar extends StatelessWidget {
  Style16BottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.height = kBottomNavigationBarHeight,
    super.key,
  }) : assert(
          navBarConfig.items.length.isOdd,
          "The number of items must be odd for this style",
        );

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

  Widget _buildMiddleItem(
    BuildContext context,
    ItemConfig item,
    bool isSelected,
  ) =>
      Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: item.activeForegroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent, width: 5),
        ),
        child: Column(
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
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final midIndex = (navBarConfig.items.length / 2).floor();
    return DecoratedNavBar(
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
              child: index == midIndex
                  ? _buildMiddleItem(
                      context,
                      item,
                      navBarConfig.selectedIndex == index,
                    )
                  : _buildItem(
                      item,
                      navBarConfig.selectedIndex == index,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
