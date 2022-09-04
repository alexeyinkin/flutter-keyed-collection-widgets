import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'keyed_tab_controller.dart';

/// Makes [controller] accessible to descendants.
class KeyedTabControllerScope<K> extends InheritedWidget {
  ///
  const KeyedTabControllerScope({
    super.key,
    required this.controller,
    required this.enabled,
    required super.child,
  });

  /// The controller to be made available to descendants.
  final KeyedTabController<K> controller;

  /// Whether to notify children on update.
  final bool enabled;

  @override
  bool updateShouldNotify(KeyedTabControllerScope oldWidget) {
    return enabled != oldWidget.enabled || controller != oldWidget.controller;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<KeyedTabController<K>>('controller', controller),
    );
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}
