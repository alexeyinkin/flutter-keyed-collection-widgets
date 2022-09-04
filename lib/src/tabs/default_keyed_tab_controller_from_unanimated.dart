// This is OK because the == operator is in the same class we extend.
// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'default_keyed_tab_controller.dart';
import 'keyed_tab_controller.dart';
import 'keyed_tab_controller_scope.dart';
import 'unanimated_keyed_tab_controller.dart';

/// Creates [KeyedTabController] from an [UnanimatedKeyedTabController]
/// [controller] and makes it available to descendants in the widget tree.
class DefaultKeyedTabControllerFromUnanimated<K> extends StatefulWidget
    implements DefaultKeyedTabController<K> {
  ///
  const DefaultKeyedTabControllerFromUnanimated({
    super.key,
    required this.controller,
    required this.child,
    this.animationDuration,
  });

  /// The [UnanimatedKeyedTabController] to derive the [KeyedTabController]
  /// from.
  final UnanimatedKeyedTabController<K> controller;

  /// See [DefaultTabController.child].
  final Widget child;

  /// See [DefaultTabController.animationDuration].
  final Duration? animationDuration;

  @override
  State<DefaultKeyedTabControllerFromUnanimated> createState() =>
      _DefaultKeyedTabControllerFromUnanimatedState<K>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Duration?>(
        'animationDuration',
        animationDuration,
      ),
    );
    properties.add(
      DiagnosticsProperty<UnanimatedKeyedTabController<K>>(
        'controller',
        controller,
      ),
    );
  }
}

class _DefaultKeyedTabControllerFromUnanimatedState<K>
    extends State<DefaultKeyedTabControllerFromUnanimated<K>>
    with TickerProviderStateMixin {
  late KeyedTabController<K> _controller;

  @override
  void initState() {
    super.initState();

    _controller = KeyedTabController.fromUnanimated(
      controller: widget.controller,
      animationDuration: widget.animationDuration,
      vsync: this,
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
  void didUpdateWidget(DefaultKeyedTabControllerFromUnanimated<K> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.unanimated = widget.controller;
    _controller.animationDuration =
        widget.animationDuration ?? kTabScrollDuration;
  }
}
