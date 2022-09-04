// This is OK because the == operator is in the same class we extend.
// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'default_keyed_tab_controller.dart';
import 'keyed_tab_controller.dart';
import 'keyed_tab_controller_scope.dart';

/// Creates [KeyedTabController] from [keys] and makes it available
/// to descendants in the widget tree.
class DefaultKeyedTabControllerFromKeys<K> extends StatefulWidget
    implements DefaultKeyedTabController<K> {
  ///
  const DefaultKeyedTabControllerFromKeys({
    super.key,
    required this.keys,
    this.initialKey,
    required this.child,
    this.animationDuration,
  });

  /// The tab keys this [KeyedTabController].
  final List<K> keys;

  /// The key for the initially selected tab.
  final K? initialKey;

  /// See [DefaultTabController.child].
  final Widget child;

  /// See [DefaultTabController.animationDuration].
  final Duration? animationDuration;

  @override
  State<DefaultKeyedTabControllerFromKeys> createState() =>
      _DefaultKeyedTabControllerFromKeysState<K>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Duration?>(
        'animationDuration',
        animationDuration,
      ),
    );
    properties.add(DiagnosticsProperty<K?>('initialKey', initialKey));
    properties.add(IterableProperty<K>('keys', keys));
  }
}

class _DefaultKeyedTabControllerFromKeysState<K>
    extends State<DefaultKeyedTabControllerFromKeys<K>>
    with TickerProviderStateMixin {
  late KeyedTabController<K> _controller;

  @override
  void initState() {
    super.initState();

    _controller = KeyedTabController<K>(
      vsync: this,
      keys: widget.keys,
      initialKey: widget.initialKey ?? widget.keys.first,
      animationDuration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedTabControllerScope<K>(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(DefaultKeyedTabControllerFromKeys<K> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.keys = widget.keys;
    _controller.animationDuration =
        widget.animationDuration ?? kTabScrollDuration;
  }
}
