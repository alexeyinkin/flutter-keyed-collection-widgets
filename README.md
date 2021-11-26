These are replacements to `BottomNavigationBar` and `IndexedStack` that use
item keys instead if numeric indexes.

## Problem ##

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

## Usage ##

With this package you can use your `enum` directly with collection widgets.
See the full runnable example in the `example` folder.

```dart
enum Tab {favorites, search}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Tab _tab = Tab.favorites;

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<Tab>(
        itemKey: _tab,
        children: const {
          Tab.favorites: Center(child: Text('Favorites')),
          Tab.search: Center(child: Text('Search')),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<Tab>(
        currentItemKey: _tab,
        items: const {
          Tab.favorites: BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          Tab.search: BottomNavigationBarItem(
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

Some more advantages of `enum` over indexes:
* No way for the value to fall out of range.
* Easier debugging with IDE tools.
* You will never use magic numbers for indexes.

`KeyedBottomNavigationBar` and `KeyedStack` support all the arguments of their traditional counterparts.
The only difference is that current keys are required and do not default to first element.
