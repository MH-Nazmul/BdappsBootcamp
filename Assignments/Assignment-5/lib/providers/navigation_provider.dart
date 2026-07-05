import 'package:flutter/foundation.dart';

/// Tracks which tab of the BottomNavigationBar is selected.
///
/// Kept in a provider (instead of setState) so the whole app stays state-free
/// of setState — the scaffold just watches this value.
class NavigationProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }
}
