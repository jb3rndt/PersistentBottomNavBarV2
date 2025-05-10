part of "../persistent_bottom_nav_bar_v2.dart";

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  /// Creates a navigation bar controller for `PersistentTabView`.
  PersistentTabController({
    this.initialIndex = 0,
    this.historyLength = 5,
    this.clearHistoryOnInitialIndex = false,
  })  : _index = initialIndex,
        assert(initialIndex >= 0, "Nav Bar item index cannot be less than 0"),
        assert(
          historyLength >= 0,
          "Nav Bar history length cannot be less than 0",
        );

  final int initialIndex;

  /// Number of tab switches that are kept in history.
  /// When the history length is exceeded, the oldest entry after the initial tab is removed.
  ///
  /// Default is 5.
  ///
  /// If the history length is 0, the history is disabled. This effectively exits the app when the back button is pressed (and no pages are pushed on the current tab).
  ///
  /// If the history length is 1, the back button will switch to the initial tab and exit the app when pressed again.
  ///
  /// Any value greater than 1 will keep the history of the last [historyLength] - 1 tab switches and always return to the initial tab when the history is empty.
  final int historyLength;

  // This is used to clear the history when the initial index is selected. This way, the user can always immediately exit the app from the initial tab but keep the history when switching between tabs.
  final bool clearHistoryOnInitialIndex;
  int get index => _index;
  int _index;
  int? _previousIndex;
  int? get previousIndex => _previousIndex;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<int> _tabHistory = [];
  List<int> get tabHistory => _tabHistory;

  void _updateIndex(int value, [bool isUndo = false]) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    if (!isUndo) {
      if (clearHistoryOnInitialIndex && value == initialIndex) {
        _tabHistory.clear();
      } else {
        if (historyLength == 1 &&
            _tabHistory.length == 1 &&
            _tabHistory[0] == value) {
          // Clear history when switching to initial tab and it is the only entry in history.
          _tabHistory.clear();
        } else if (historyLength > 0) {
          _tabHistory.add(_index);
        }

        if (_tabHistory.length > historyLength) {
          _tabHistory.removeAt(1);
          if (_tabHistory.length > 1 && _tabHistory[0] == _tabHistory[1]) {
            _tabHistory.removeAt(1);
          }
        }
      }
    }
    _previousIndex = _index;
    _index = value;
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
