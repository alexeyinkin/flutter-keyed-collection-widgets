import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'keyed_static_tab_controller.dart';

/// A drop-in replacement to [TabController] that can also use keys
/// instead of indexes.
class KeyedTabController<K> extends ChangeNotifier implements TabController {
  List<K> _keys;

  final TickerProvider _vsync;
  TabController _indexedController;

  ///
  KeyedTabController({
    required K? initialKey,
    required List<K> keys,
    Duration? animationDuration,
    required TickerProvider vsync,
  })  : _keys = keys,
        _vsync = vsync,
        _indexedController = TabController(
          initialIndex: initialKey == null
              ? 0
              : max(keys.indexOf(initialKey), 0), // If not found: -1 -> 0.
          animationDuration: animationDuration,
          length: keys.length,
          vsync: vsync,
        ) {
    _indexedController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    notifyListeners();
  }

  /// Keyed equivalent to [TabController.animateTo].
  void animateToKey(
    K key, {
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) {
    _indexedController.animateTo(
      max(_keys.indexOf(key), 0),
      duration: kTabScrollDuration,
      curve: curve,
    );
  }

  set keys(List<K> keys) {
    final oldKey = _keys.isEmpty ? null : _keys[_indexedController.index];
    setKeysAndCurrentKey(keys, oldKey);
  }

  /// Keys of the tabs.
  List<K> get keys => _keys;

  /// Sets [keys] and [currentKey] in one take to only notify listeners once.
  ///
  /// If [keys] did not change, it has the same effect as setting [currentKey].
  ///
  /// Tries to preserve the currently selected tab. If this key is gone,
  /// selects the first one.
  void setKeysAndCurrentKey(List<K> keys, K? currentKey) {
    if (listEquals(keys, _keys)) {
      this.currentKey = currentKey;
      return;
    }

    final newIndex = currentKey == null ? 0 : max(keys.indexOf(currentKey), 0);

    if (_keys.length == keys.length) {
      _keys = keys;
      _indexedController.index = newIndex;
    } else {
      _indexedController
        ..removeListener(_onControllerChanged)
        ..dispose();

      _indexedController = TabController(
        initialIndex: newIndex,
        length: keys.length,
        vsync: _vsync,
      );
      _indexedController.addListener(_onControllerChanged);

      _keys = keys;
      notifyListeners();
    }
  }

  /// Returns the internal [TabController].
  TabController get indexedController => _indexedController;

  /// See [KeyedStaticTabController].
  void updateFromStatic(KeyedStaticTabController<K> staticController) {
    setKeysAndCurrentKey(
      staticController.keys,
      staticController.currentKey,
    );
  }

  @override
  void dispose() {
    _indexedController
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  @override
  set index(int value) => _indexedController.index = value;

  @override
  int get index => _indexedController.index;

  @override
  set offset(double value) => _indexedController.offset = value;

  @override
  double get offset => _indexedController.offset;

  set currentKey(K? value) {
    _indexedController.index = value == null ? 0 : max(_keys.indexOf(value), 0);
  }

  /// The key of the currently selected tab.
  K? get currentKey {
    final index = this.index;
    return index >= 0 && index < _keys.length ? _keys[index] : null;
  }

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    _indexedController.animateTo(value, duration: duration, curve: curve);
  }

  @override
  Animation<double>? get animation => _indexedController.animation;

  @override
  Duration get animationDuration => _indexedController.animationDuration;

  @override
  bool get indexIsChanging => _indexedController.indexIsChanging;

  @override
  int get length => _indexedController.length;

  @override
  int get previousIndex => _indexedController.previousIndex;

  /// Returns a list picked from [map] using [keys] in the keys order.
  ///
  /// Use this when constructing [TabBar] and [TabBarView] widgets
  /// when having a map of widgets.
  List<V> mapToList<V>(Map<K, V> map) {
    final result = <V>[];

    for (final key in keys) {
      result.add(map[key] ?? (throw Exception('Item not found by key: $key')));
    }

    return result;
  }
}
