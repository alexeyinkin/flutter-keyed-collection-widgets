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
    required this.child,
    required this.keys,
    this.animationDuration,
    this.initialKey,
    this.onChanged,
  });

  /// See [DefaultTabController.animationDuration].
  final Duration? animationDuration;

  /// See [DefaultTabController.child].
  final Widget child;

  /// The key for the initially selected tab.
  final K? initialKey;

  /// The tab keys this [KeyedTabController].
  final List<K> keys;

  /// The callback to be called when the controller value changes
  /// or animation ticks.
  final ValueChanged<K?>? onChanged;

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
    properties.add(
      ObjectFlagProperty<ValueChanged<K?>?>.has('onChanged', onChanged),
    );
  }
}

class _DefaultKeyedTabControllerFromKeysState<K>
    extends State<DefaultKeyedTabControllerFromKeys<K>>
    with TickerProviderStateMixin {
  late final KeyedTabController<K> _controller;

  @override
  void initState() {
    super.initState();

    _controller = KeyedTabController<K>(
      vsync: this,
      keys: widget.keys,
      initialKey: widget.initialKey ?? widget.keys.first,
      animationDuration: widget.animationDuration,
    );
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
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

  void _onChanged() {
    widget.onChanged?.call(_controller.currentKey);
  }
}
