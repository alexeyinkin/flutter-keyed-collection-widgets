import 'dart:math';

import 'package:flutter/widgets.dart';

/// An equivalent to [IndexedStack] that uses keys instead of indexes.
class KeyedStack<T> extends IndexedStack {
  ///
  KeyedStack({
    super.key,
    super.alignment,
    super.textDirection,
    super.sizing,
    required T itemKey,
    required Map<T, Widget> children,
  }) : super(
          index: max(children.keys.toList(growable: false).indexOf(itemKey), 0),
          children: children.values.toList(growable: false),
        );
}
