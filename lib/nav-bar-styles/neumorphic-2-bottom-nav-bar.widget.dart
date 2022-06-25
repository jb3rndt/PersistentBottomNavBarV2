part of persistent_bottom_nav_bar_v2;

class Neumorphic2BottomNavBar extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;
  final NeumorphicProperties neumorphicProperties;

  Neumorphic2BottomNavBar({
    Key? key,
    this.navBarEssentials,
    this.neumorphicProperties = const NeumorphicProperties(),
  });

  Widget _buildItem(
      BuildContext context, PersistentBottomNavBarItem item, bool isSelected) {
    return this.navBarEssentials!.navBarHeight == 0
        ? SizedBox.shrink()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NeumorphicContainer(
                decoration: NeumorphicDecoration(
                  borderRadius: this.neumorphicProperties.borderRadius,
                  color: isSelected
                      ? item.activeColorPrimary.withOpacity(0.2)
                      : this.navBarEssentials!.backgroundColor,
                  border: this.neumorphicProperties.border,
                  shape: this.neumorphicProperties.shape,
                ),
                bevel: isSelected ? 0.0 : this.neumorphicProperties.bevel,
                curveType: isSelected
                    ? CurveType.emboss
                    : this.neumorphicProperties.curveType,
                padding: EdgeInsets.all(8.0),
                child: IconTheme(
                  data: IconThemeData(
                      size: item.iconSize,
                      color: isSelected
                          ? item.activeColorSecondary ?? item.activeColorPrimary
                          : item.inactiveColorPrimary ??
                              item.activeColorPrimary),
                  child:
                      isSelected ? item.icon : item.inactiveIcon ?? item.icon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: FittedBox(
                    child: Text(
                      item.title!,
                      style: item.textStyle != null
                          ? (item.textStyle!.apply(
                              color: isSelected
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary))
                          : TextStyle(
                              color: isSelected
                                  ? item.activeColorPrimary
                                  : item.inactiveColorPrimary ??
                                      item.activeColorPrimary,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: this.navBarEssentials!.navBarHeight!,
      padding: EdgeInsets.only(
          left: this.navBarEssentials!.padding?.left ??
              MediaQuery.of(context).size.width * 0.04,
          right: this.navBarEssentials!.padding?.right ??
              MediaQuery.of(context).size.width * 0.04,
          top: this.navBarEssentials!.padding?.top ??
              this.navBarEssentials!.navBarHeight! * 0.15,
          bottom: this.navBarEssentials!.padding?.bottom ??
              this.navBarEssentials!.navBarHeight! * 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials!.items!.map((item) {
          int index = this.navBarEssentials!.items!.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () {
                if (this.navBarEssentials!.items![index].onPressed != null) {
                  this.navBarEssentials!.items![index].onPressed!(
                      this.navBarEssentials!.selectedScreenBuildContext);
                } else {
                  this.navBarEssentials!.onItemSelected!(index);
                }
              },
              child: _buildItem(
                  context, item, this.navBarEssentials!.selectedIndex == index),
            ),
          );
        }).toList(),
      ),
    );
  }
}
