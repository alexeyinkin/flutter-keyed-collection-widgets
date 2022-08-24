These are replacements to `BottomNavigationBar`, `IndexedStack`, and `TabController` that use
item keys instead if numeric indexes.

## Problem

With traditional widgets you write something like
```dart
const tabFavorites = 0;
const tabSearch = 1;
// ...
if (tabIndex == tabFavorites) {
  // ...
}
```
If items in your bar can change, you get an error-prone conversion from indexes to meanings.
Also with mature architecture you tend to use `enum` for your tabs, and even with constant bar items
you must write code to convert between `enum` and `int`.

## Usage

With this package you can use your `enum` directly with collection widgets.
See the full runnable example in the `example` folder.

### KeyedBottomNavigationBar and KeyedStack

```dart
enum MyTab {favorites, search}

class _MyHomeScreenState extends State<MyHomeScreen> {
  MyTab _tab = MyTab.favorites;

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<MyTab>(
        itemKey: _tab,
        children: const {
          MyTab.favorites: Center(child: Text('Favorites')),
          MyTab.search: Center(child: Text('Search')),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<MyTab>(
        currentItemKey: _tab,
        items: const {
          MyTab.favorites: BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          MyTab.search: BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        },
        onTap: (tab) => setState((){ _tab = tab; }),
      ),
    );
  }
}
```

### KeyedTabController, KeyedTabBar, KeyedTabBarView

```dart
enum MyTab {one, two, three}

class _MyHomeScreenState extends State<MyHomeScreen> with TickerProviderStateMixin {
  late final KeyedTabController<MyTab> _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = KeyedTabController<MyTab>(
      initialKey: MyTab.three,
      keys: [MyTab.one, MyTab.two, MyTab.three],
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyedTabBar(
          tabs: {
            for (final key in _tabController.keys)
              key: Tab(child: Text(key.toString())),
          },
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: KeyedTabBarView(
            children: {
              for (final key in _tabController.keys)
                key: Text("$key content"),
            },
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}
```

Some more advantages of `enum` over indexes:
* No way for the value to fall out of range.
* Easier debugging with IDE tools.
* You will never use magic numbers for indexes.

`KeyedBottomNavigationBar` and `KeyedStack` support all the arguments of their traditional counterparts.
The only difference is that current keys are required and do not default to first element.

## `enum_map`

Although `enum` enhances type safety for tabs, it is still not absolute.
In widgets, you may still forget to use all keys in `children` map and only know that at runtime.

You can make this compile-time safe by using [enum_map](https://pub.dev/packages/enum_map)
package that generates maps
that are guaranteed to have all keys at compile time (see that package's README for more info):

```dart
@unmodifiableEnumMap                                            // CHANGED
enum MyTab {one, two, three}

class _MyHomeScreenState extends State<MyHomeScreen> with TickerProviderStateMixin {
  late final KeyedTabController<MyTab> _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = KeyedTabController<MyTab>(
      initialKey: MyTab.three,
      keys: [MyTab.one, MyTab.two, MyTab.three],
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyedTabBar(
          tabs: const UnmodifiableMyTabMap(                     // CHANGED
            one: Tab(child: Text('one')),                       // CHANGED
            two: Tab(child: Text('two')),                       // CHANGED
            three: Tab(child: Text('three')),                   // CHANGED
          ),                                                    // CHANGED
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: KeyedTabBarView(
            children: const UnmodifiableMyTabMap(               // CHANGED
              one: Text('one content'),                         // CHANGED
              two: Text('two content'),                         // CHANGED
              three: Text('three content'),                     // CHANGED
            ),                                                  // CHANGED
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}
```
