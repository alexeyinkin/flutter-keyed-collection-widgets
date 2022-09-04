import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'keyed_tab_controller.dart';

/// This controller has no animation so it can be used in business logic code.
///
/// In your widgets, create [KeyedTabController] with animation
/// and make it listen to this controller's changes.
class UnanimatedKeyedTabController<T> extends ChangeNotifier {
  List<T> _keys;
  T? _currentKey;

  ///
  UnanimatedKeyedTabController({
    required List<T> keys,
    required T? initialKey,
  })  : _keys = keys,
        _currentKey = initialKey;

  /// The key for the currently selected tab.
  T? get currentKey => _currentKey;

  set currentKey(T? value) {
    value ??= _keys.first; // ignore: parameter_assignments
    if (_currentKey == value) return;

    if (!_keys.contains(value)) {
      throw ArgumentError('Key $value is not among $_keys');
    }

    _currentKey = value;
    notifyListeners();
  }

  /// The keys for all tabs.
  List<T> get keys => _keys;

  set keys(List<T> keys) {
    if (const ListEquality().equals(keys, _keys)) return;
    _keys = keys;

    if (!_keys.contains(_currentKey)) {
      _currentKey = _keys.firstOrNull;
    }

    notifyListeners();
  }

  /// Sets both [keys] and [currentKey] notifying listeners only once.
  void setKeysAndCurrentKey(List<T> keys, T? currentKey) {
    if (const ListEquality().equals(keys, _keys) && currentKey == _currentKey) {
      return;
    }

    _keys = keys;
    _currentKey = currentKey;
    notifyListeners();
  }

  /// Updates [currentKey] when it is changed by user.
  ///
  /// When the user taps tab headers or swipes through tab contents,
  /// [KeyedTabController] gets updated, but not this controller.
  /// Add a call to this method with `addListener` on your [KeyedTabController]
  /// to sync the two.
  @Deprecated('Use KeyedTabController.fromUnanimated that links the two')
  void updateFromAnimated(KeyedTabController<T> animatedController) {
    setKeysAndCurrentKey(
      animatedController.keys,
      animatedController.currentKey,
    );
  }
}

/// This controller has no animation so it can be used in business logic code.
///
/// In your widgets, create [KeyedTabController] with animation
/// and make it listen to this controller's changes.
@Deprecated('Renamed to UnanimatedKeyedTabController in v0.3.4')
typedef KeyedStaticTabController<T> = UnanimatedKeyedTabController<T>;
