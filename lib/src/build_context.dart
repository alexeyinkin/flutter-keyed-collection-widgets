import 'package:flutter/widgets.dart';

import 'tabs/default_keyed_tab_controller.dart';
import 'tabs/keyed_tab_controller.dart';
import 'tabs/keyed_tab_controller_scope.dart';

///
extension KeyedTabControllerScopeBuildContext on BuildContext {
  /// Returns [KeyedTabController] created by [DefaultKeyedTabController]
  /// widget, if any.
  KeyedTabController<K>? getKeyedTabController<K extends Object>() {
    return dependOnInheritedWidgetOfExactType<KeyedTabControllerScope<K>>()
        ?.controller;
  }

  /// Returns [KeyedTabController] created by [DefaultKeyedTabController]
  /// widget. Throws if none is found.
  KeyedTabController<K> requireKeyedTabController<K extends Object>() {
    return dependOnInheritedWidgetOfExactType<KeyedTabControllerScope<K>>()
            ?.controller ??
        (throw Exception(
          'DefaultKeyedTabController not found in the widget tree. '
          'Either pass the controller manually or add '
          'DefaultKeyedTabController widget.',
        ));
  }
}
