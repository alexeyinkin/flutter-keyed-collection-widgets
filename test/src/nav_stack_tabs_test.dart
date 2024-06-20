// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// ignore: avoid_relative_lib_imports
import '../../example/lib/nav_stack_tabs.dart' as app;

const _screenSize = Size(3600, 2400);

// To generate all goldens, run:
// flutter test --name=UI --update-goldens
const _dir = 'nav_stack_tabs';
const _k_123_1 = '$_dir/k_123_1';
const _k_123_2 = '$_dir/k_123_2';
const _k_123_3 = '$_dir/k_123_3';
const _k_34_3 = '$_dir/k_34_3';
const _k_34_4 = '$_dir/k_34_4';
const _u_123_1 = '$_dir/u_123_1';
const _u_123_2 = '$_dir/u_123_2';
const _u_123_3 = '$_dir/u_123_3';
const _u_34_3 = '$_dir/u_34_3';
const _u_34_4 = '$_dir/u_34_4';

// As of writing, some tests fail if tests before them did not return
// to the original state. So there are redundant reversions to the original
// state in some tests. These have 'Return to the original state' comment.
// TODO(alexeyinkin): isolate and file the bug to Flutter.

void main() {
  group('KeyedBottomNavigationBar, KeyedStack, Tabs.', () {
    group('DefaultKeyedTabController.fromKeys.', () {
      testGoldens('Change tabs with UI', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await screenMatchesGolden(t, _k_123_1);

        // Switch to 'two' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_two')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_2);

        // Switch to 'three' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_3);

        // Switch to 'three-four' set, 'three' remains the current tab, 0th.
        await t.tap(find.byKey(const ValueKey('k_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_34_3);

        // Switch to 'one-two-three' set, 'three' remains the current tab, 2nd.
        await t.tap(find.byKey(const ValueKey('k_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_3);

        // Switch to 'three-four', then 'four', it becomes current.
        await t.tap(find.byKey(const ValueKey('k_three-four')));
        await t.pumpAndSettle();
        await t.tap(find.byKey(const ValueKey('k_four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_34_4);

        // Switch to 'one-two-three', 'one' becomes current.
        await t.tap(find.byKey(const ValueKey('k_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_1);
      });

      testGoldens('Change animation duration', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await screenMatchesGolden(t, _k_123_1);

        // Switch to 'two' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_two')));
        final pumps1 = await t.pumpAndSettle(const Duration(milliseconds: 100));
        expect(pumps1, 8);
        await screenMatchesGolden(t, _k_123_2);

        // Set longer animation
        await t.tap(find.byKey(const ValueKey('k_d2')));
        await t.pumpAndSettle();

        // Switch to 'three' tab, check that animation is longer.
        await t.tap(find.byKey(const ValueKey('k_three')));
        final pumps2 = await t.pumpAndSettle(const Duration(milliseconds: 100));
        expect(pumps2, 12);
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_3);
      });

      testGoldens('Change tabs with KeyedTabController.currentKey', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await screenMatchesGolden(t, _k_123_1);

        // Switch to 'three' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_set_three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_3);

        // Switch to 'four' tab, it is not in controller keys, throw exception.
        await t.tap(find.byKey(const ValueKey('k_set_four')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        await screenMatchesGolden(t, _k_123_3);

        // Switch to 'three-four' set, 'three' remains the current tab.
        await t.tap(find.byKey(const ValueKey('k_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_34_3);

        // Switch to 'one' tab, it is not in controller keys, throw error.
        await t.tap(find.byKey(const ValueKey('k_set_one')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        await screenMatchesGolden(t, _k_34_3);

        // Switch to 'four' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_set_four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_34_4);

        // Switch to 'one-two-three', 'one' becomes current.
        await t.tap(find.byKey(const ValueKey('k_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_1);
      });

      testGoldens('Change tabs with KeyedTabController.index', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await screenMatchesGolden(t, _k_123_1);

        // Switch to tab 2, it becomes current.
        await t.tap(find.byKey(const ValueKey('k_set_2')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_123_3);

        // Switch to tab 3, it is out of range, Flutter throws AssertionError.
        await t.tap(find.byKey(const ValueKey('k_set_3')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<AssertionError>());
        await screenMatchesGolden(t, _k_123_3);

        // Switch to 'three-four' set, 'three' tab is now 0th.
        await t.tap(find.byKey(const ValueKey('k_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _k_34_3);

        // Switch to tab 2, it is out of range, Flutter throws AssertionError.
        await t.tap(find.byKey(const ValueKey('k_set_2')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<AssertionError>());
        await screenMatchesGolden(t, _k_34_3);
      });
    });

    group('DefaultKeyedTabController.fromUnanimated', () {
      testGoldens('Change tabs with UI', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Switch to 'two' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_two')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_2);

        // Switch to 'three' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'three, four' set, 'three' remains the current tab, 0th.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_3);

        // Switch to 'one-two-three' set, 'three' remains the current tab, 2nd.
        await t.tap(find.byKey(const ValueKey('u_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'four' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        await t.tap(find.byKey(const ValueKey('u_four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_4);

        // Switch to 'one-two-three', 'one' becomes current.
        await t.tap(find.byKey(const ValueKey('u_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_1);
      });

      testGoldens('Change animation duration', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Switch to 'two' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_two')));
        final pumps1 = await t.pumpAndSettle(const Duration(milliseconds: 100));
        expect(pumps1, 8);
        await screenMatchesGolden(t, _u_123_2);

        // Set longer animation
        await t.tap(find.byKey(const ValueKey('u_d2')));
        await t.pumpAndSettle();

        // Switch to 'three' tab, check that animation is longer.
        await t.tap(find.byKey(const ValueKey('u_three')));
        final pumps2 = await t.pumpAndSettle(const Duration(milliseconds: 100));
        expect(pumps2, 12);
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_3);

        // Return to the original state.
        await t.tap(find.byKey(const ValueKey('u_one')));
        await t.tap(find.widgetWithText(InkResponse, 'fromKeys'));
        await t.pumpAndSettle();
      });

      testGoldens('Change tabs with UnanimatedKeyedTabController.currentKey',
          (t) async {
            t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Switch to 'three' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_u_three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'four' tab, it is not in controller keys, throw exception.
        await t.tap(find.byKey(const ValueKey('u_set_u_four')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'three-four' set, 'three' remains the current tab.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_3);

        // Switch to 'one' tab, it is not in controller keys, throw error.
        await t.tap(find.byKey(const ValueKey('u_set_u_one')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        await screenMatchesGolden(t, _u_34_3);

        // Switch to 'four' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_u_four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_4);

        // Switch to 'one-two-three', 'one' becomes current.
        await t.tap(find.byKey(const ValueKey('u_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_1);
      });

      testGoldens('Change tabs with KeyedTabController.currentKey', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Switch to 'three' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'four' tab, it is not in controller keys, throw exception.
        await t.tap(find.byKey(const ValueKey('u_set_four')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'three-four' set, 'three' remains the current tab.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_3);

        // Switch to 'one' tab, it is not in controller keys, throw error.
        await t.tap(find.byKey(const ValueKey('u_set_one')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<ArgumentError>());
        await screenMatchesGolden(t, _u_34_3);

        // Switch to 'four' tab, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_four')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_34_4);

        // Switch to 'one-two-three', 'one' becomes current.
        await t.tap(find.byKey(const ValueKey('u_one-two-three')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_1);
      });

      testGoldens('Change tabs with KeyedTabController.index', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Switch to tab 1, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_1')));
        await t.pumpAndSettle();
        expect(app.unanimatedController.currentKey, app.TabEnum.two);
        await screenMatchesGolden(t, _u_123_2);

        // Switch to tab 2, it becomes current.
        await t.tap(find.byKey(const ValueKey('u_set_2')));
        await t.pumpAndSettle();
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_123_3);

        // Switch to tab 3, it is out of range, Flutter throws AssertionError.
        await t.tap(find.byKey(const ValueKey('u_set_3')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<AssertionError>());
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_123_3);

        // Switch to 'three-four' set, 'three' tab is now 0th.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_34_3);

        // Switch to tab 2, it is out of range, Flutter throws AssertionError.
        await t.tap(find.byKey(const ValueKey('u_set_2')));
        await t.pumpAndSettle();
        expect(t.takeException(), isA<AssertionError>());
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_34_3);

        // Return to the original state.
        await t.tap(find.byKey(const ValueKey('u_one-two-three')));
        await t.tap(find.byKey(const ValueKey('u_set_0')));
        await t.tap(find.widgetWithText(InkResponse, 'fromKeys'));
        await t.pumpAndSettle();
      });

      testGoldens('Re-create UnanimatedKeyedTabController', (t) async {
        t.view.physicalSize = _screenSize;

        await t.pumpWidget(app.MyApp());
        await t.tap(find.widgetWithText(InkResponse, 'fromUnanimated'));
        await screenMatchesGolden(t, _u_123_1);

        // Set longer animation to later verify this is preserved.
        await t.tap(find.byKey(const ValueKey('u_d2')));
        await t.pumpAndSettle();

        // Switch to 'three-four' set, 'three' tab is now 0th.
        await t.tap(find.byKey(const ValueKey('u_three-four')));
        await t.pumpAndSettle();
        expect(app.unanimatedController.currentKey, app.TabEnum.three);
        await screenMatchesGolden(t, _u_34_3);

        // Re-create. This resets tabs to 'one-two-three' with 'one' as current.
        await t.tap(find.byKey(const ValueKey('u_re-create')));
        await t.pumpAndSettle();
        await screenMatchesGolden(t, _u_123_1);

        // Switch to 'three' tab, check that animation is longer.
        await t.tap(find.byKey(const ValueKey('u_set_u_three')));
        final pumps2 = await t.pumpAndSettle(const Duration(milliseconds: 100));
        expect(pumps2, 12);
        await screenMatchesGolden(t, _u_123_3);
      });
    });
  });
}
