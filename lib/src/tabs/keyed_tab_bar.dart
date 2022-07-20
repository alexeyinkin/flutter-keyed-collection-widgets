import 'package:flutter/material.dart';

import 'keyed_tab_controller.dart';

/// A replacement to [TabBar] that uses map of children instead of a list.
///
/// If you don't need [onTap] that works with keys, you may instead just do
/// ```
/// TabBar(
///   controller: controller,
///   tabs: controller.mapToList(tabMap),
/// )
/// ```
class KeyedTabBar<K> extends TabBar {
  ///
  KeyedTabBar({
    super.key,
    required Map<K, Widget> tabs,
    required KeyedTabController<K> controller,
    super.isScrollable,
    super.padding,
    super.indicatorColor,
    super.automaticIndicatorColorAdjustment,
    super.indicatorWeight,
    super.indicatorPadding,
    super.indicator,
    super.indicatorSize,
    super.labelColor,
    super.labelStyle,
    super.labelPadding,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.dragStartBehavior,
    super.overlayColor,
    super.mouseCursor,
    super.enableFeedback,
    ValueChanged<K>? onTap,
    super.physics,
  }) : super(
          tabs: controller.mapToList(tabs),
          controller: controller,
          onTap:
              onTap == null ? null : (index) => onTap(controller.keys[index]),
        );
}
