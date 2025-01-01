part of "../persistent_bottom_nav_bar_v2.dart";

class Style13BottomNavBar extends StatelessWidget {
  Style13BottomNavBar({
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

  Widget _buildItem(BuildContext context, ItemConfig item, bool isSelected) =>
      Column(
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

  Widget _buildMiddleItem(ItemConfig item, bool isSelected) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 150,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.activeForegroundColor,
              boxShadow: navBarDecoration.boxShadow,
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  size: item.iconSize,
                  color: item.inactiveForegroundColor,
                ),
                child: isSelected ? item.icon : item.inactiveIcon,
              ),
            ),
          ),
          if (item.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
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
  Widget build(BuildContext context) {
    final midIndex = (navBarConfig.items.length / 2).floor();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 23),
            DecoratedNavBar(
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
                          ? Container()
                          : _buildItem(
                              context,
                              item,
                              navBarConfig.selectedIndex == index,
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                navBarConfig.onItemSelected(midIndex);
              },
              child: _buildMiddleItem(
                navBarConfig.items[midIndex],
                navBarConfig.selectedIndex == midIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
