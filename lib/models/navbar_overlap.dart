part of "../persistent_bottom_nav_bar_v2.dart";

class NavBarOverlap {
  const NavBarOverlap.full() : overlap = double.infinity;

  const NavBarOverlap.none() : overlap = 0.0;

  const NavBarOverlap.custom({
    this.overlap = 0.0,
  });

  final double overlap;
}
