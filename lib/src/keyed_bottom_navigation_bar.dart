import 'dart:math';

import 'package:flutter/material.dart';

/// An equivalent to [BottomNavigationBar] that uses keys instead of indexes.
class KeyedBottomNavigationBar<T> extends BottomNavigationBar {
  /// Constructs the bar.
  ///
  /// If [keyOrder] is non-null, only the given keys will be picked
  /// from the [items] map.
  KeyedBottomNavigationBar({
    super.key,
    required Map<T, BottomNavigationBarItem> items,
    List<T>? keyOrder,
    ValueChanged<T>? onTap,
    required T currentItemKey,
    super.elevation,
    super.type,
    super.fixedColor,
    super.backgroundColor,
    super.iconSize,
    super.selectedItemColor,
    super.unselectedItemColor,
    super.selectedIconTheme,
    super.unselectedIconTheme,
    super.selectedFontSize,
    super.unselectedFontSize,
    super.selectedLabelStyle,
    super.unselectedLabelStyle,
    super.showSelectedLabels,
    super.showUnselectedLabels,
    super.mouseCursor,
    super.enableFeedback,
    super.landscapeLayout,
  }) : super(
          items: keyOrder == null
              ? items.values.toList(growable: false)
              : keyOrder.map((key) => items[key]!).toList(growable: false),
          currentIndex: max(
            (keyOrder ?? items.keys.toList(growable: false))
                .indexOf(currentItemKey),
            0,
          ),
          onTap: (index) => onTap
              ?.call((keyOrder ?? items.keys.toList(growable: false))[index]),
        );
}
