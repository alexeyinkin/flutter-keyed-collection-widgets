import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

// This example show KeyedTabController, KeyedTabBar, and KeyedAppBarView.

enum TabEnum { one, two, three }

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
