import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'keyed_tab_controller.dart';

/// A replacement to [TabBarView] that uses map of children instead of a list.
///
/// Or you may instead just do
/// ```
/// TabBarView(
///   controller: controller,
///   children: controller.mapToList(childrenMap),
/// )
/// ```
class KeyedTabBarView<K> extends TabBarView {
  KeyedTabBarView({
    Key? key,
    required Map<K, Widget> children,
    required KeyedTabController<K> controller,
    ScrollPhysics? physics,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) : super(
    key: key,
    children: controller.mapToList(children),
    controller: controller,
    physics: physics,
    dragStartBehavior: dragStartBehavior,
  );
}
