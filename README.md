[![Pub Package](https://img.shields.io/pub/v/keyed_collection_widgets.svg)](https://pub.dev/packages/keyed_collection_widgets)
[![GitHub](https://img.shields.io/github/license/alexeyinkin/flutter-keyed-collection-widgets)](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/LICENSE)
[![CodeFactor](https://img.shields.io/codefactor/grade/github/alexeyinkin/flutter-keyed-collection-widgets?style=flat-square)](https://www.codefactor.io/repository/github/alexeyinkin/flutter-keyed-collection-widgets)
[![Support Chat](https://img.shields.io/badge/support%20chat-telegram-brightgreen)](https://ainkin.com/chat)

These are replacements to `BottomNavigationBar`, `IndexedStack`, and `TabController` that use
item keys instead if numeric indexes.

## Problem

With traditional widgets, you write something like
```dart
const tabFavorites = 0;
const tabSearch = 1;
// ...
if (tabIndex == tabFavorites) {
  // ...
}
```
If items in your bar can change, you get an error-prone conversion from indexes to meanings.
Also with a mature architecture you tend to use `enum` for your tabs, and even with constant bar items
you must write code to convert between `enum` and `int`.

## Solution

This package provides widgets to be used with any type instead of `int`. In most cases you will
use `enum`.

Some advantages of `enum` over indexes:
* No way for the value to fall out of range.
* Easier debugging with IDE tools.
* You will never use magic numbers for indexes.
* No need to synchronize the order of children between different widgets.

`String` is also a good type to use with these widgets if you have dynamic or potentially
unlimited tabs (like in a browser or a document editor) but still want meaningful keys
instead of indexes.

## KeyedBottomNavigationBar and KeyedStack

This example uses an `enum` for selectable navigation items:

![KeyedBottomNavigationBar, KeyedStack](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/nav_stack.gif)

This example is runnable. Download the repository and open the example project.
Then run [nav_stack.dart](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/lib/nav_stack.dart)

```dart
enum TabEnum { favorites, search }

class _MyScreenState extends State<MyScreen> {
  TabEnum _tab = TabEnum.favorites;

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<TabEnum>(
        itemKey: _tab,
        children: const {
          TabEnum.favorites: Center(
            key: ValueKey('favorites_pane'),
            child: Text('Favorites'),
          ),
          TabEnum.search: Center(
            key: ValueKey('search_pane'),
            child: Text('Search'),
          ),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<TabEnum>(
        currentItemKey: _tab,
        items: const {
          TabEnum.favorites: BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          TabEnum.search: BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        },
        onTap: (tab) => setState(() {
          _tab = tab;
        }),
      ),
    );
  }
}
```

`KeyedBottomNavigationBar` and `KeyedStack` support all the arguments of their
traditional counterparts.
The only difference is that current keys are required and do not default to first element.

## KeyedTabController, KeyedTabBar, KeyedTabBarView

### Minimal Example

This example uses `enum` for tabs:

![KeyedTabController, KeyedTabBar, KeyedTabBarView](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/tabs.gif)

This example is runnable. Download the repository and open the example project.
Then run [tabs.dart](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/lib/tabs.dart)

```dart
enum MyTab { one, two, three }

class _MyScreenState extends State<MyScreen> with TickerProviderStateMixin {
  late final _tabController = KeyedTabController<TabEnum>(
    initialKey: TabEnum.three,
    keys: [TabEnum.one, TabEnum.two, TabEnum.three],
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_tabController.currentKey}'),
        bottom: KeyedTabBar(
          tabs: {
            for (final key in _tabController.keys) key: Tab(text: '$key'),
          },
          controller: _tabController,
        ),
      ),
      body: KeyedTabBarView(
        children: {
          for (final key in _tabController.keys)
            key: Center(child: Text('$key content')),
        },
        controller: _tabController,
      ),
    );
  }
}
```

### Redundant Children

The ordinary `TabBar` and `TabBarView` must have exactly as many children as their controller
is set to. This means that if you need to hide some tabs, there must be three locations in your
code to know that:

1. The code that updates the controller.
2. The code that creates `TabBar` widget with tab headers.
3. The code that creates `TabBarView` widget with tab contents.

This is extremely error-prone.

With this package, `KeyedTabBar` and `KeyedTabBarView` have maps of children,
so they can contain more widgets than the controller wants to show.

This means that you can unconditionally pass all children for all possible tabs to them,
and the only location in your code that needs to know what tabs to show is the code that
updates the controller.

### Using KeyedTabController as TabController

`KeyedTabController` implements `TabController` and is immediately usable as one.
If you ever need to get the tab index or select a tab by index, do it as you normally would.

### UnanimatedKeyedTabController

With ordinary `TabController`, you need
[TickerProvider](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html)
to create it. And this limits the usage. You must create `TabController` in a widget.
If you want your BLoC or other business logic code to be aware of tabs or control them,
it may be tricky to pass the controller there.

This package provides `UnanimatedKeyedTabController` which has the logic core
for `KeyedTabController`, but not its animation. You can create this controller anywhere
and then add the animation in your widget.

Create it like this:

```dart
final unanimatedController = UnanimatedKeyedTabController<TabEnum>(
  keys: [TabEnum.one, TabEnum.two, TabEnum.three],
  initialKey: TabEnum.three,
);
```

Then create `KeyedTabController` in your widget:

```dart
class _MyScreenState extends State<MyScreen> with TickerProviderStateMixin {
  late final _tabController = KeyedTabController<TabEnum>.fromUnanimated(
    controller: unanimatedController,
    vsync: this,
  );
  // ...
```

This binds the two controllers. If you change the tab via `UnanimatedKeyedTabController`,
then `KeyedTabController` gets updated, and the tab change is animated in the UI.

And if the user changes the tab by interacting with it, both controllers get updated.

### Mutable Tabs and Animation Duration

Ordinary `TabController` has a fixed `length` and `animationDuration`. If you need to change them,
you must create a new controller and replace it everywhere.

`KeyedTabController` has these mutable.

You can change the tabs at any time by setting `KeyedTabController.keys`
property. If the currently selected tab also exists in the new set, its selection is preserved,
otherwise the first new tab gets selected.

This is possible because `KeyedTabController` does not extend but contains `TabController`
and so it can re-create its internal `TabController` with different parameters
without disturbing its own listeners.

### TickerProviderStateMixin vs SingleTickerProviderStateMixin

In Flutter's tab examples, you often see the widget's `State` created with
`SingleTickerProviderStateMixin`. This only allows one `TabController` to be created in it.
However, `KeyedTabController` re-creates its `TabController` if you change `keys`
or `animationDuration`, so it will break if created with `SingleTickerProviderStateMixin`.

You should use `TickerProviderStateMixin` for your widgets instead. It allows many `TabController`
objects to be created with it.

### DefaultKeyedTabController

Flutter provides
[DefaultTabController](https://api.flutter.dev/flutter/material/DefaultTabController-class.html)
widget which accepts the number of tabs, creates a `TabController` and provides it to
all tab-related widgets under it.

It has the following advantages:

1. It is declarative. You don't have to manage your `TabController` and dispose it.
2. It allows to change the number of tabs. You just change the length passed to this widget,
   and it re-creates the `TabController`,
   and all widgets under it are updated for the new number of tabs.

This is matched by `DefaultKeyedTabController`. Although tabs get mutable with this package,
the advantage #1 still stands.

This widget comes in two forms:

#### fromKeys

```dart
DefaultKeyedTabController.fromKeys(
  keys: [TabEnum.one, TabEnum.two],
  child: ...
),
```

Use this when you know the keys to show in your widget.

#### fromUnanimated

```dart
DefaultKeyedTabController.fromUnanimated(
  controller: unanimatedController,
  child: ...
),
```

Use this if you use `UnanimatedKeyedTabController`.

#### Creating Widgets for DefaultKeyedTabController

In Flutter, both `TabBar` and `TabBarView` widgets can be created without
the `controller` argument. In this case, they rely on `DefaultTabController` widget
present in the tree above them and break if it is missing.

This is error-prone because the `controller` argument may simply be forgotten,
and this cannot be detected at compile time.

In this package, the `controller` argument to `KeyedTabBar` and `KeyedTabBarView` is required.
To rely on the `DefaultKeyedTabController`, use `.withDefaultController` static methods
of those widgets instead of their default constructors.

There is still no check at compile time that the default controller is present in the tree,
but at least you must explicitly declare that you want it and not just have forgotten
to pass the `controller`.

#### When to use DefaultKeyedTabController

All things equal, prefer `DefaultKeyedTabController` over manual `KeyedTabController`
creation. This is because that widget will dispose the controller for you when it is not needed
anymore.

## Advanced Example

![KeyedBottomNavigationBar, KeyedStack, Tabs](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/img/nav_stack_tabs.png)

This example shows:

- Changing the set of tabs without re-creating a controller.
- Programmatically activating a tab by its key.
- Programmatically activating a tab by its index.
- Changing the animation duration without re-creating a controller.
- `DefaultKeyedTabController` widgets.
- `UnanimatedKeyedTabController`.
- Replacing the `UnanimatedKeyedTabController` that a `KeyedTabController` is linked to.

This example is runnable. Download the repository and open the example project.
Then run [nav_stack_tabs.dart](https://github.com/alexeyinkin/flutter-keyed-collection-widgets/blob/main/example/lib/nav_stack_tabs.dart)

## enum_map

Although `enum` enhances type safety for tabs, it is still not absolute.
In widgets, you may still forget to use all keys in `children` map and only know that at runtime.

You can make this compile-time safe by using [enum_map](https://pub.dev/packages/enum_map)
package that generates maps
that are guaranteed to have all keys at compile time (see that package's README for more info):

```dart
@unmodifiableEnumMap                                    // CHANGED
enum TabEnum { one, two, three }

class _MyScreenState extends State<MyScreen> with TickerProviderStateMixin {
  late final _tabController = KeyedTabController<TabEnum>(
    initialKey: TabEnum.three,
    keys: [TabEnum.one, TabEnum.two, TabEnum.three],
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_tabController.currentKey}'),
        bottom: KeyedTabBar(
          controller: _tabController,
          tabs: const UnmodifiableTabEnumMap(           // CHANGED
            one: Tab(text: 'One'),                      // CHANGED
            two: Tab(text: 'Two'),                      // CHANGED
            three: Tab(text: 'Three'),                  // CHANGED
          ),                                            // CHANGED
        ),
      ),
      body: KeyedTabBarView(
        controller: _tabController,
        children: const UnmodifiableTabEnumMap(         // CHANGED
          one: Center(child: Text('One content')),      // CHANGED
          two: Center(child: Text('Two content')),      // CHANGED
          three: Center(child: Text('Three content')),  // CHANGED
        ),                                              // CHANGED
      ),
    );
  }
}
```

## Support Chat

Do you have any questions? Feel free to ask in the [Telegram Support Chat](https://ainkin.com/chat).

Or even just join to say 'Hi!'. I like to hear from the users.
