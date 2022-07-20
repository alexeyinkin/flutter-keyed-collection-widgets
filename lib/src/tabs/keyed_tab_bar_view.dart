import 'package:flutter/material.dart';

import 'keyed_tab_controller.dart';

/// A replacement to [TabBarView] that uses a map of children instead of a list.
///
/// Or you may instead just do
/// ```
/// TabBarView(
///   controller: controller,
///   children: controller.mapToList(childrenMap),
/// )
/// ```
class KeyedTabBarView<K> extends TabBarView {
  ///
  KeyedTabBarView({
    super.key,
    required Map<K, Widget> children,
    required KeyedTabController<K> controller,
    super.physics,
    super.dragStartBehavior,
  }) : super(
          children: controller.mapToList(children),
          controller: controller,
        );
}
