import 'package:flutter/foundation.dart';

import 'keyed_tab_controller.dart';

/// This controller has no animation so it can be used in business logic code.
///
/// In your widgets, create [KeyedTabsController] with animation
/// and make it listen to this controller's changes.
class KeyedStaticTabController<T> extends ChangeNotifier {
  List<T> _keys;
  T? _currentKey;

  KeyedStaticTabController({
    required List<T> keys,
    required T? currentKey,
  }) :
      _keys = keys,
      _currentKey = currentKey
  ;

  /// The key for the currently selected tab.
  set currentKey(T? value) {
    if (_currentKey == value) return;
    _currentKey = value;
    notifyListeners();
  }
  T? get currentKey => _currentKey;

  /// The keys for all tabs.
  set keys(List<T> keys) {
    if (listEquals(keys, _keys)) return;
    _keys = keys;
    notifyListeners();
  }
  List<T> get keys => _keys;

  /// Sets both [keys] and [currentKey] notifying listeners only once.
  void setKeysAndCurrentKey(List<T> keys, T? currentKey) {
    if (listEquals(keys, _keys) && currentKey == _currentKey) return;
    _keys = keys;
    _currentKey = currentKey;
    notifyListeners();
  }

  /// Updates [currentKey] when it is changed by user.
  ///
  /// When the user taps tab headers or swipes through tab contents,
  /// this updates [KeyedTabController] but not this controller.
  /// Add a call to this method with [KeyedTabController.addListener]
  /// to sync the two.
  void updateFromAnimated(KeyedTabController<T> animatedController) {
    currentKey = animatedController.currentKey;
  }
}
