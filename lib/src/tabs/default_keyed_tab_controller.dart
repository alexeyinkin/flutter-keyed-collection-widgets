import 'package:flutter/material.dart';

import 'default_keyed_tab_controller_from_keys.dart';
import 'default_keyed_tab_controller_from_unanimated.dart';
import 'keyed_tab_controller.dart';
import 'unanimated_keyed_tab_controller.dart';

/// The [KeyedTabController] for descendant widgets that don't specify one
/// explicitly.
///
/// Unlike the standard Flutter's [DefaultTabController],
/// this widget does not re-create the controller when its properties change,
/// but only updates it.
/// The controller is thus safe to cache and will not be disposed
/// until this widget is disposed.
///
/// This is possible because [KeyedTabController] allows changing keys and
/// the animation duration without re-creation.
abstract class DefaultKeyedTabController<K> extends Widget {
  /// Provides [KeyedTabController] that is created from [keys]
  /// and [initialKey].
  ///
  /// If on sequential builds [keys] or [animationDuration] will change,
  /// the existing controller will be preserved and updated.
  const factory DefaultKeyedTabController.fromKeys({
    Key? key,
    required List<K> keys,
    K? initialKey,
    required Widget child,
    Duration? animationDuration,
  }) = DefaultKeyedTabControllerFromKeys<K>;

  /// Provides [KeyedTabController] that is linked to a given
  /// [KeyedUnanimatedTabController] [controller].
  ///
  /// If on sequential builds another [controller] is passed,
  /// the existing [KeyedTabController] will be preserved and linked
  /// to the new [controller].
  const factory DefaultKeyedTabController.fromUnanimated({
    Key? key,
    required UnanimatedKeyedTabController<K> controller,
    required Widget child,
    Duration? animationDuration,
  }) = DefaultKeyedTabControllerFromUnanimated<K>;
}
