import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../build_context.dart';
import 'keyed_tab_controller.dart';

// From /flutter/lib/src/material/tabs.dart
const _kTabHeight = 46.0;

/// A replacement to [TabBar] that uses a map of children instead of a list.
///
/// If you don't need [onTap] that works with keys, you may instead just do
/// ```
/// TabBar(
///   controller: controller,
///   tabs: controller.mapToList(tabMap),
/// )
/// ```
class KeyedTabBar<K extends Object> extends TabBar {
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
    super.splashFactory,
    super.splashBorderRadius,
  }) : super(
          tabs: controller.mapToList(tabs),
          controller: controller,
          onTap:
              onTap == null ? null : (index) => onTap(controller.keys[index]),
        );

  /// Creates the widget that will look up its `controller` from the
  /// widget tree.
  static PreferredSizeWidget withDefaultController<K extends Object>({
    Key? key,
    required Map<K, Widget> tabs,
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
    InteractiveInkFeatureFactory? splashFactory,
    BorderRadius? splashBorderRadius,
  }) =>
      _KeyedTabBarWithDefaultController<K>(
        key: key,
        tabs: tabs,
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
        onTap: onTap,
        physics: physics,
        splashFactory: splashFactory,
        splashBorderRadius: splashBorderRadius,
      );
}

class _KeyedTabBarWithDefaultController<K extends Object>
    extends StatelessWidget implements PreferredSizeWidget {
  const _KeyedTabBarWithDefaultController({
    super.key,
    required this.tabs,
    required this.isScrollable,
    this.padding,
    this.indicatorColor,
    required this.automaticIndicatorColorAdjustment,
    required this.indicatorWeight,
    required this.indicatorPadding,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
  });

  final Map<K, Widget> tabs;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final bool automaticIndicatorColorAdjustment;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? unselectedLabelColor;
  final TextStyle? unselectedLabelStyle;
  final DragStartBehavior dragStartBehavior;
  final MaterialStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<K>? onTap;
  final ScrollPhysics? physics;
  final InteractiveInkFeatureFactory? splashFactory;
  final BorderRadius? splashBorderRadius;

  @override
  Widget build(BuildContext context) {
    final controller = context.requireKeyedTabController<K>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => TabBar(
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
        labelPadding: labelPadding,
        unselectedLabelColor: unselectedLabelColor,
        unselectedLabelStyle: unselectedLabelStyle,
        dragStartBehavior: dragStartBehavior,
        overlayColor: overlayColor,
        mouseCursor: mouseCursor,
        enableFeedback: enableFeedback,
        onTap: onTap == null ? null : (index) => onTap!(controller.keys[index]),
        physics: physics,
        splashFactory: splashFactory,
        splashBorderRadius: splashBorderRadius,
      ),
    );
  }

  // Copied from Flutter's TabBar.
  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs.values) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<K, Widget>>('tabs', tabs));
    properties.add(DiagnosticsProperty<bool>('isScrollable', isScrollable));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding),
    );
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(
      DiagnosticsProperty<bool>(
        'automaticIndicatorColorAdjustment',
        automaticIndicatorColorAdjustment,
      ),
    );
    properties.add(DoubleProperty('indicatorWeight', indicatorWeight));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>(
        'indicatorPadding',
        indicatorPadding,
      ),
    );
    properties.add(DiagnosticsProperty<Decoration?>('indicator', indicator));
    properties.add(
      EnumProperty<TabBarIndicatorSize?>('indicatorSize', indicatorSize),
    );
    properties.add(ColorProperty('labelColor', labelColor));
    properties.add(DiagnosticsProperty<TextStyle?>('labelStyle', labelStyle));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry?>('labelPadding', labelPadding),
    );
    properties.add(ColorProperty('unselectedLabelColor', unselectedLabelColor));
    properties.add(
      DiagnosticsProperty<TextStyle?>(
        'unselectedLabelStyle',
        unselectedLabelStyle,
      ),
    );
    properties.add(
      EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior),
    );
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<Color?>?>(
        'overlayColor',
        overlayColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor),
    );
    properties.add(
      DiagnosticsProperty<bool?>('enableFeedback', enableFeedback),
    );
    properties.add(ObjectFlagProperty<ValueChanged<K>?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<ScrollPhysics?>('physics', physics));
    properties.add(
      DiagnosticsProperty<InteractiveInkFeatureFactory?>(
        'splashFactory',
        splashFactory,
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderRadius?>(
        'splashBorderRadius',
        splashBorderRadius,
      ),
    );
  }
}
