import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

enum Tab {favorites, search}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

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
