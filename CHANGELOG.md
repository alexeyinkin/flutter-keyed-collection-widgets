## 0.4.0

* **BREAKING:** Setting `currentKey` to anything not in `keys` now throws `ArgumentError`.
  Before it was setting the key to the first valid one.
* **BREAKING:** Nullable types are disallowed for tabs key type parameter.
* **BREAKING:** `UnanimatedKeyedTabController` changed the constructor argument `currentKey`
  to `initialKey` to align with `KeyedTabController` and `TabController`.
* Renamed `KeyedStaticTabController` to `KeyedUnanimatedTabController` to reduce confusion.
  A deprecated `typedef` was added for backward compatibility.
* Added `DefaultKeyedTabController`.
* Added `KeyedTabController.fromUnanimated` to link the controller with
  `UnanimatedKeyedTabController`, and `unanimated` getter and setter.
* Added `KeyedTabController.animationDuration` setter to change the animation
  duration on an existing controller.
* Deprecated `KeyedTabController.updateFromStatic()` and
  `UnanimatedKeyedTabController.updateFromAnimated()`.
* Expanded the examples.
* Expanded the README.
* Added tests.

## 0.3.3

* Suggested [enum_map](https://pub.dev/packages/enum_map) in README.

## 0.3.2

* Remove an accidentally published temp file.

## 0.3.1

* Re-licensed under MIT No Attribution.

## 0.3.0

* **BREAKING:** Require Flutter 3.
* **BREAKING:** Require `children` in `KeyedStack`.
* Use `total_lints`, fixed linter issues.
* `KeyedBottomNavigationBar` extends `BottomNavigationBar` instead of composition to avoid duplicating properties.
* `KeyedStack` extends `IndexedStack` instead of composition to avoid duplicating properties.
* Fixed formatting.
* Improved docs.

## 0.2.0

* **BREAKING:** Updated `KeyedTabController` to Flutter 2.10 API, require Flutter 2.10.

## 0.1.2

* Allow not found keys in `KeyedTabController` for consistency with `KeyedStaticTabController`.

## 0.1.1

* Added `KeyedTabController`, `KeyedStaticTabController`, `KeyedTabBar`, `KeyedTabBarView`.

## 0.1.0

* Initial release.
