import 'dart:math';

import 'package:flutter/material.dart';

/// An equivalent to [BottomNavigationBar] that uses keys instead of indexes.
class KeyedBottomNavigationBar<T> extends BottomNavigationBar {
  ///
  KeyedBottomNavigationBar({
    super.key,
    required Map<T, BottomNavigationBarItem> items,
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
          items: items.values.toList(growable: false),
          currentIndex: max(
            items.keys.toList(growable: false).indexOf(currentItemKey),
            0,
          ),
          onTap: (index) =>
              onTap?.call(items.keys.toList(growable: false)[index]),
        );
}
