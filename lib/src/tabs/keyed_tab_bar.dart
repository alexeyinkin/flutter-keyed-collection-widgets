import 'package:flutter/gestures.dart';
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
  KeyedTabBar({
    Key? key,
    required Map<K, Widget> tabs,
    required KeyedTabController<K> controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    bool automaticIndicatorColorAdjustment = true,
    double indicatorWeight = 2.0,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    MaterialStateProperty<Color?>? overlayColor,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    ValueChanged<K>? onTap,
    ScrollPhysics? physics,
  }) : super(
    key: key,
    tabs: controller.mapToList(tabs),
    controller: controller,
    isScrollable: isScrollable,
    padding: padding,
    indicatorColor: indicatorColor,
    automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
    indicatorWeight: indicatorWeight,
    indicatorPadding: indicatorPadding,
    indicator: indicator,
    indicatorSize: indicatorSize,
    labelColor: labelColor,
    labelStyle: labelStyle,
    labelPadding: labelPadding,
    unselectedLabelColor: unselectedLabelColor,
    unselectedLabelStyle: unselectedLabelStyle,
    dragStartBehavior: dragStartBehavior,
    overlayColor: overlayColor,
    mouseCursor: mouseCursor,
    enableFeedback: enableFeedback,
    onTap: onTap == null ? null : (index) => onTap(controller.keys[index]),
    physics: physics,
  );
}
