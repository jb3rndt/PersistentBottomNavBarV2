part of "../persistent_bottom_nav_bar_v2.dart";

/// Navigation bar controller for `PersistentTabView`.
///
/// [historyLength] is the number of tab switches that are kept in history.
/// Switching to another tab will add another entry in history, overwriting previous entry if the history gets too big.
/// Initial tab will always be on the first position in history.
/// Pressing the back button will switch to previous tab from history.
/// If [historyLength]=0 there will be no history, pressing back button will exit.
/// If [historyLength]=1 there will be one entry kept in history, pressing back button will switch to initial tab, pressing again will exit.
/// If [historyLength]=n there will be n entries kept in history, pressing back button will switch to previous tab.
///
/// [clearHistoryOnInitialIndex] specifies if history should be cleared when switching to initial tab.
/// Clearing history means that next back button press will exit.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({
    int initialIndex = 0,
    int historyLength = 5,
    bool clearHistoryOnInitialIndex = false,
  })  : _initialIndex = initialIndex,
        _historyLength = historyLength,
        _clearHistoryOnInitialIndex = clearHistoryOnInitialIndex,
        _index = initialIndex,
        assert(initialIndex >= 0, "Nav Bar item index cannot be less than 0"),
        assert(
            historyLength >= 0, "Nav Bar history length cannot be less than 0");

  final int _initialIndex;
  final int _historyLength;
  final bool _clearHistoryOnInitialIndex;
  int get index => _index;
  int _index;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<int> _tabHistory = [];
  ValueChanged<int>? onIndexChanged;

  void _updateIndex(int value, [bool isUndo = false]) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    if (!isUndo) {
      if (_clearHistoryOnInitialIndex && value == _initialIndex) {
        _tabHistory.clear();
      } else {
        if (_historyLength == 1 &&
            _tabHistory.length == 1 &&
            _tabHistory[0] == value) {
          // Clear history when switching to initial tab and it is the only entry in history.
          _tabHistory.clear();
        } else if (_historyLength > 0) {
          // Removes duplicates tab from history
          _tabHistory
            ..remove(_index)
            ..add(_index);
        }

        if (_tabHistory.length > _historyLength) {
          _tabHistory.removeAt(1);
          if (_tabHistory.length > 1 && _tabHistory[0] == _tabHistory[1]) {
            _tabHistory.removeAt(1);
          }
        }
      }
    }
    _index = value;
    onIndexChanged?.call(value);
    notifyListeners();
  }

  void jumpToTab(int value) {
    _updateIndex(value);
  }

  void jumpToPreviousTab() {
    if (!historyIsEmpty()) {
      _updateIndex(_tabHistory.removeLast(), true);
    }
  }

  bool historyIsEmpty() => _tabHistory.isEmpty;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
