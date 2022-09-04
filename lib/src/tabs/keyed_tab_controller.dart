import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'unanimated_keyed_tab_controller.dart';

/// A drop-in replacement to [TabController] that can also use keys
/// instead of indexes.
class KeyedTabController<K> extends ChangeNotifier implements TabController {
  UnanimatedKeyedTabController<K>? _unanimated;
  List<K> _keys;

  final TickerProvider _vsync;
  TabController _indexedController;

  /// A holder for current [_indexedController]'s [TabController.animation].
  ///
  /// [TabBarView] listens directly to [TabController.animation]
  /// and not [TabController] itself.
  /// So we must give it a permanent object that will hold the animation
  /// of the current [_indexedController].
  final _proxyAnimation =
      ProxyAnimation(const AlwaysStoppedAnimation<double>(0));

  ///
  KeyedTabController({
    required K? initialKey,
    required List<K> keys,
    Duration? animationDuration,
    required TickerProvider vsync,
  })  : _keys = keys,
        _vsync = vsync,
        _unanimated = null,
        _indexedController = TabController(
          initialIndex: initialKey == null
              ? 0
              : max(keys.indexOf(initialKey), 0), // If not found: -1 -> 0.
          animationDuration: animationDuration,
          length: keys.length,
          vsync: vsync,
        ) {
    _proxyAnimation.parent = _indexedController.animation;
    _indexedController.addListener(_onControllerChanged);
  }

  /// Creates the controller from the given [UnanimatedKeyedTabController]
  /// [controller] and links the two.
  KeyedTabController.fromUnanimated({
    required UnanimatedKeyedTabController<K> controller,
    Duration? animationDuration,
    required TickerProvider vsync,
  })  : _keys = controller.keys,
        _vsync = vsync,
        _unanimated = controller,
        _indexedController = TabController(
          initialIndex: controller.currentKey == null
              ? 0
              : max(controller.keys.indexOf(controller.currentKey as K), 0),
          animationDuration: animationDuration,
          length: controller.keys.length,
          vsync: vsync,
        ) {
    _proxyAnimation.parent = _indexedController.animation;
    _unanimated!.addListener(_onUnanimatedChanged);
    _indexedController.addListener(_onControllerChanged);
  }

  void _onUnanimatedChanged() {
    setKeysAndCurrentKey(
      _unanimated!.keys,
      _unanimated!.currentKey,
    );
  }

  void _onControllerChanged() {
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    _unanimated?.setKeysAndCurrentKey(keys, currentKey);
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

  /// Keys of the tabs.
  List<K> get keys => _keys;

  set keys(List<K> keys) {
    final oldKey = _keys.isEmpty ? null : _keys[_indexedController.index];
    setKeysAndCurrentKey(keys, oldKey);
  }

  /// Sets [keys] and [currentKey] in one take to only notify listeners once.
  ///
  /// If [keys] did not change, it has the same effect as setting [currentKey].
  ///
  /// Tries to preserve the currently selected tab. If this key is gone,
  /// selects the first one.
  void setKeysAndCurrentKey(List<K> keys, K? currentKey) {
    if (const ListEquality().equals(keys, _keys)) {
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
        animationDuration: _indexedController.animationDuration,
        initialIndex: newIndex,
        length: keys.length,
        vsync: _vsync,
      );
      _proxyAnimation.parent = _indexedController.animation;
      _indexedController.addListener(_onControllerChanged);

      _keys = keys;
      notifyListeners();
    }
  }

  /// Returns the internal [TabController].
  TabController get indexedController => _indexedController;

  /// See [KeyedStaticTabController].
  @Deprecated('Use fromUnanimated constructor to automatically sync the two')
  void updateFromStatic(KeyedStaticTabController<K> staticController) {
    setKeysAndCurrentKey(
      staticController.keys,
      staticController.currentKey,
    );
  }

  /// The linked [UnanimatedKeyedTabController], if any.
  UnanimatedKeyedTabController<K>? get unanimated => _unanimated;

  set unanimated(UnanimatedKeyedTabController<K>? value) {
    if (value == _unanimated) return;
    _unanimated?.removeListener(_onUnanimatedChanged);

    if (value != null) {
      setKeysAndCurrentKey(
        value.keys,
        value.currentKey,
      );

      value.addListener(_onUnanimatedChanged);
      _unanimated = value;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _unanimated?.removeListener(_onUnanimatedChanged);
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
    if (value == null) {
      _indexedController.index = 0;
      return;
    }

    final index = _keys.indexOf(value);
    if (index == -1) {
      throw ArgumentError('Key $value is not among $_keys');
    }

    _indexedController.index = index;
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
  Animation<double>? get animation => _proxyAnimation;

  @override
  Duration get animationDuration => _indexedController.animationDuration;

  set animationDuration(Duration value) {
    if (value == _indexedController.animationDuration) return;

    _indexedController
      ..removeListener(_onControllerChanged)
      ..dispose();

    _indexedController = TabController(
      animationDuration: value,
      initialIndex: _indexedController.index,
      length: keys.length,
      vsync: _vsync,
    );
    _proxyAnimation.parent = _indexedController.animation;
    _indexedController.addListener(_onControllerChanged);

    notifyListeners();
  }

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
