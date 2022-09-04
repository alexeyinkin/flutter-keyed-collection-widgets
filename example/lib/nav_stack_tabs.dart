import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

enum BottomTabEnum { fromKeys, fromUnanimated }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  BottomTabEnum _tab = BottomTabEnum.fromKeys;

  @override
  Widget build(BuildContext context) {
    // This is a simplified example: IndexedStack and KeyedStack are only
    // meaningful if they contain stateful widgets to preserve state
    // between switches.
    return Scaffold(
      body: KeyedStack<BottomTabEnum>(
        itemKey: _tab,
        children: const {
          BottomTabEnum.fromKeys: FromKeysWidget(),
          BottomTabEnum.fromUnanimated: FromUnanimatedWidget(),
        },
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<BottomTabEnum>(
        currentItemKey: _tab,
        items: const {
          BottomTabEnum.fromKeys: BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'fromKeys',
          ),
          BottomTabEnum.fromUnanimated: BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'fromUnanimated',
          ),
        },
        onTap: (tab) => setState(() {
          _tab = tab;
        }),
      ),
    );
  }
}

enum TabEnum {
  one(Color(0xffffd0d0)),
  two(Color(0xffffffd0)),
  three(Color(0xffd0ffd0)),
  four(Color(0xffd0d0ff)),
  ;

  final Color color; // For golden tests

  const TabEnum(
    this.color,
  );
}

const tabs1 = [
  TabEnum.one,
  TabEnum.two,
  TabEnum.three,
];

const tabs2 = [
  TabEnum.three,
  TabEnum.four,
];

const duration1 = Duration(milliseconds: 300);
const duration2 = Duration(milliseconds: 1000);

class FromKeysWidget extends StatefulWidget {
  const FromKeysWidget();

  @override
  State<FromKeysWidget> createState() => _FromKeysWidgetState();
}

class _FromKeysWidgetState extends State<FromKeysWidget>
    with SingleTickerProviderStateMixin<FromKeysWidget> {
  late KeyedTabController _keyedController;
  List<TabEnum> _keys = tabs1;
  Duration _animationDuration = duration1;

  @override
  Widget build(BuildContext context) {
    return DefaultKeyedTabController.fromKeys(
      keys: _keys,
      animationDuration: _animationDuration,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DefaultKeyedTabController.fromKeys'),
          bottom: KeyedTabBar.withDefaultController<TabEnum>(
            tabs: {
              for (final v in TabEnum.values)
                v: Tab(key: ValueKey('k_${v.name}'), text: v.name),
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: KeyedTabBarView.withDefaultController<TabEnum>(
                children: {
                  for (final v in TabEnum.values)
                    v: ColoredBox(
                      color: v.color,
                      child: Center(
                        child: Text(
                          v.name,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                },
              ),
            ),
            ControlPanel(
              keyPrefix: 'k',
              onTabsChanged: (v) => setState(() => _keys = v),
              setTabKey: (k) => _keyedController.currentKey = k,
              setTabIndex: (i) => _keyedController.index = i,
              onDurationChanged: (v) => setState(() => _animationDuration = v),
            ),
            Builder(
              builder: (context) {
                _keyedController = context.requireKeyedTabController<TabEnum>();
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

UnanimatedKeyedTabController<TabEnum> unanimatedController =
    UnanimatedKeyedTabController(
  keys: tabs1,
  initialKey: tabs1.first,
);

class FromUnanimatedWidget extends StatefulWidget {
  const FromUnanimatedWidget();

  @override
  State<FromUnanimatedWidget> createState() => _FromUnanimatedWidgetState();
}

class _FromUnanimatedWidgetState extends State<FromUnanimatedWidget> {
  late KeyedTabController _keyedController;
  Duration _animationDuration = duration1;

  @override
  Widget build(BuildContext context) {
    return DefaultKeyedTabController.fromUnanimated(
      controller: unanimatedController,
      animationDuration: _animationDuration,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DefaultKeyedTabController.fromUnanimated'),
          bottom: KeyedTabBar.withDefaultController<TabEnum>(
            tabs: {
              for (final v in TabEnum.values)
                v: Tab(key: ValueKey('u_${v.name}'), text: v.name),
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: KeyedTabBarView.withDefaultController<TabEnum>(
                children: {
                  for (final v in TabEnum.values)
                    v: ColoredBox(
                      color: v.color,
                      child: Center(
                        child: Text(
                          v.name,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                },
              ),
            ),
            ControlPanel(
              keyPrefix: 'u',
              onTabsChanged: (v) => unanimatedController.keys = v,
              setUnanimatedTabKey: (k) => unanimatedController.currentKey = k,
              setTabKey: (k) => _keyedController.currentKey = k,
              setTabIndex: (i) => _keyedController.index = i,
              onDurationChanged: (v) => setState(() => _animationDuration = v),
              extraWidgets: [
                ElevatedButton(
                  key: const ValueKey('u_re-create'),
                  onPressed: () => setState(() {
                    unanimatedController =
                        UnanimatedKeyedTabController<TabEnum>(
                      keys: tabs1,
                      initialKey: tabs1.first,
                    );
                  }),
                  child: const Text('Re-create UnanimatedKeyedTabController'),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                _keyedController = context.requireKeyedTabController<TabEnum>();
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    required this.keyPrefix,
    required this.onTabsChanged,
    required this.onDurationChanged,
    this.setUnanimatedTabKey,
    required this.setTabKey,
    required this.setTabIndex,
    this.extraWidgets = const [],
  });

  final String keyPrefix;
  final ValueChanged<List<TabEnum>> onTabsChanged;
  final ValueChanged<Duration> onDurationChanged;
  final ValueChanged<TabEnum>? setUnanimatedTabKey;
  final ValueChanged<TabEnum> setTabKey;
  final ValueChanged<int> setTabIndex;
  final List<Widget> extraWidgets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Tabs:'),
              const SizedBox(width: 10),
              ElevatedButton(
                key: ValueKey('${keyPrefix}_${_tabsToString(tabs1)}'),
                child: Text(_tabsToString(tabs1)),
                onPressed: () => onTabsChanged(tabs1),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                key: ValueKey('${keyPrefix}_${_tabsToString(tabs2)}'),
                child: Text(_tabsToString(tabs2)),
                onPressed: () => onTabsChanged(tabs2),
              ),
            ],
          ),
          if (setUnanimatedTabKey != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('UnanimatedKeyedTabController.currentKey:'),
                for (final key in TabEnum.values) ...[
                  const SizedBox(width: 10),
                  ElevatedButton(
                    key: ValueKey('${keyPrefix}_set_u_${key.name}'),
                    child: Text(key.name),
                    onPressed: () => setUnanimatedTabKey!(key),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('KeyedTabController.currentKey:'),
              for (final key in TabEnum.values) ...[
                const SizedBox(width: 10),
                ElevatedButton(
                  key: ValueKey('${keyPrefix}_set_${key.name}'),
                  child: Text(key.name),
                  onPressed: () => setTabKey(key),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('KeyedTabController.index:'),
              for (int i = 0; i < TabEnum.values.length; i++) ...[
                const SizedBox(width: 10),
                ElevatedButton(
                  key: ValueKey('${keyPrefix}_set_$i'),
                  child: Text('$i'),
                  onPressed: () => setTabIndex(i),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Animation duration:'),
              const SizedBox(width: 10),
              ElevatedButton(
                key: ValueKey('${keyPrefix}_d1'),
                child: Text('${duration1.inMilliseconds} ms'),
                onPressed: () => onDurationChanged(duration1),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                key: ValueKey('${keyPrefix}_d2'),
                child: Text('${duration2.inMilliseconds} ms'),
                onPressed: () => onDurationChanged(duration2),
              ),
            ],
          ),
          for (final widget in extraWidgets) ...[
            const SizedBox(height: 20),
            widget,
          ],
        ],
      ),
    );
  }

  String _tabsToString(Iterable<TabEnum> tabs) {
    return tabs.map((t) => t.name).join('-');
  }
}
