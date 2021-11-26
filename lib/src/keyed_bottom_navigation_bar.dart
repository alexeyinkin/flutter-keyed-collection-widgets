import 'dart:math';

import 'package:flutter/material.dart';

class KeyedBottomNavigationBar<T> extends StatelessWidget {
  final T currentItemKey;
  final Map<T, BottomNavigationBarItem> items;
  final ValueChanged<T>? onTap;
  final double? elevation;
  final BottomNavigationBarType? type;
  final Color? fixedColor;
  final Color? backgroundColor;
  final double iconSize;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final double selectedFontSize;
  final double unselectedFontSize;
  final bool? showUnselectedLabels;
  final bool? showSelectedLabels;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  const KeyedBottomNavigationBar({
    Key? key,
    required this.items,
    this.onTap,
    required this.currentItemKey,
    this.elevation,
    this.type,
    this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: key,
      items: items.values.toList(growable: false),
      onTap: onTap == null ? null : _onTap,
      currentIndex: max(_indexByKey(currentItemKey), 0),
      elevation: elevation,
      type: type,
      fixedColor: fixedColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: unselectedIconTheme,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      landscapeLayout: landscapeLayout,
    );
  }

  int _indexByKey(T key) {
    return items.keys.toList(growable: false).indexOf(key);
  }

  void _onTap(int index) => onTap!(items.keys.toList(growable: false)[index]);
}
