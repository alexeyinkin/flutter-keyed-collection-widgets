import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

// This example shows KeyedBottomNavigationBar with KeyedStack.

enum TabEnum { one, two }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  TabEnum _tab = TabEnum.one;

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<TabEnum>(
        itemKey: _tab,
        children: {
          TabEnum.one: Center(
            child: Text('${TabEnum.one} content'),
          ),
          TabEnum.two: Center(
            child: Text('${TabEnum.two} content'),
          ),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<TabEnum>(
        currentItemKey: _tab,
        items: {
          TabEnum.one: BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            label: '${TabEnum.one}',
          ),
          TabEnum.two: BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: '${TabEnum.two}',
          ),
        },
        onTap: (tab) => setState(() {
          _tab = tab;
        }),
      ),
    );
  }
}
