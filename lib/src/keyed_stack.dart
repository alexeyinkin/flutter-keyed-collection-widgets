import 'dart:math';

import 'package:flutter/widgets.dart';

class KeyedStack<T> extends StatelessWidget {
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final T itemKey;
  final Map<T, Widget>? children;

  const KeyedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    required this.itemKey,
    this.children,
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      key: key,
      alignment: alignment,
      textDirection: textDirection,
      sizing: sizing,
      index: max(_indexByKey(itemKey), 0),
      children: children == null ? [] : children!.values.toList(growable: false),
    );
  }

  int _indexByKey(T key) {
    // indexOf also returns -1 if not found.
    if (children == null) return -1;

    return children!.keys.toList(growable: false).indexOf(key);
  }
}
