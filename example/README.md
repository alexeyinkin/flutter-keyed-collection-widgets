# example

All examples here are runnable.
Download this repository to your computer and open it in your editor.
In Android Studio, you can run examples like this:

![Running Examples](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/run-me.gif)


## 1. nav_stack.dart

This example shows `KeyedBottomNavigationBar` and `KeyedStack` widgets:

![KeyedBottomNavigationBar, KeyedStack](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/nav_stack.gif)


## 2. tabs.dart

This example shows `KeyedTabController` and widgets `KeyedTabBar` and `KeyedTabBarView`:

![KeyedTabController, KeyedTabBar, KeyedTabBarView](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/tabs.gif)


## 3. tabs_enum_map.dart

This is a variation of `tabs.dart` that uses [enum_map](https://pub.dev/packages/enum_map)
for compile-time type safety with tabs.


## 4. unanimated_keyed_tab_controller.dart

This is a variation of `tabs.dart` that uses `UnanimatedKeyedTabController.


## 5. nav_stack_tabs.dart

This is the ultimate advanced example that shows:

- Changing the set of tabs without re-creating a controller.
- Programmatically activating a tab by its key.
- Programmatically activating a tab by its index.
- Changing the animation duration without re-creating a controller.
- `DefaultKeyedTabController` widgets.
- `UnanimatedKeyedTabController`.
- Replacing `UnanimatedKeyedTabController` that `KeyedTabController` is linked to.

![KeyedBottomNavigationBar, KeyedStack, Tabs](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/nav_stack_tabs.png)
