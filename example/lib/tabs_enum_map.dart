import 'package:enum_map/annotations.dart';
import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

// This example show KeyedTabController, KeyedTabBar, and KeyedAppBarView
// in the most type-safe manner.

// Initially you see an error on this one:
part 'tabs_enum_map.g.dart';

// Run `dart run build_runner build` in the example directory
// to generate this missing file.

@unmodifiableEnumMap
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
          controller: _tabController,
          tabs: const UnmodifiableTabEnumMap(
            one: Tab(text: 'One'),
            two: Tab(text: 'Two'),
            three: Tab(text: 'Three'),
          ),
        ),
      ),
      body: KeyedTabBarView(
        controller: _tabController,
        children: const UnmodifiableTabEnumMap(
          one: Center(child: Text('One content')),
          two: Center(child: Text('Two content')),
          three: Center(child: Text('Three content')),
        ),
      ),
    );
  }
}
