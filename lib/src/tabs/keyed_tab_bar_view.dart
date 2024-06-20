import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../build_context.dart';
import 'keyed_tab_controller.dart';

/// A replacement to [TabBarView] that uses a map of children instead of a list.
///
/// Or you may instead just do
/// ```dart
/// TabBarView(
///   controller: controller,
///   children: controller.mapToList(childrenMap),
/// )
/// ```
class KeyedTabBarView<K> extends TabBarView {
  ///
  KeyedTabBarView({
    required Map<K, Widget> children,
    required KeyedTabController<K> controller,
    super.physics,
    super.dragStartBehavior,
    super.viewportFraction,
    super.clipBehavior,
  }) : super(
          key: ValueKey('${controller.keys}'), // Re-creates PageController.
          children: controller.mapToList(children),
          controller: controller,
        );

  /// Creates the widget that will look up its `controller` from the
  /// widget tree.
  static Widget withDefaultController<K extends Object>({
    Key? key,
    required Map<K, Widget> children,
    ScrollPhysics? physics,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    double viewportFraction = 1.0,
    Clip clipBehavior = Clip.hardEdge,
  }) =>
      _KeyedTabBarViewWithDefaultController<K>(
        key: key,
        children: children,
        physics: physics,
        dragStartBehavior: dragStartBehavior,
        viewportFraction: viewportFraction,
        clipBehavior: clipBehavior,
      );
}

class _KeyedTabBarViewWithDefaultController<K extends Object>
    extends StatelessWidget {
  const _KeyedTabBarViewWithDefaultController({
    super.key,
    required this.children,
    this.physics,
    required this.dragStartBehavior,
    required this.viewportFraction,
    required this.clipBehavior,
  });

  final Map<K, Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final controller = context.requireKeyedTabController<K>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => KeyedTabBarView<K>(
        children: children,
        controller: controller,
        physics: physics,
        dragStartBehavior: dragStartBehavior,
        viewportFraction: viewportFraction,
        clipBehavior: clipBehavior,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<K, Widget>>('children', children));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(
      EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior),
    );
    properties.add(DoubleProperty('viewportFraction', viewportFraction));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}
