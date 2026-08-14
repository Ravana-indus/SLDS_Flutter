import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: SizedBox(height: 400, child: field)),
    ),
  );

  testWidgets('renders child content', (tester) async {
    await pump(
      tester,
      SldsPullToRefresh(onRefresh: () async {}, child: const Text('Content')),
    );

    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('pulling down reveals the loading bar text', (tester) async {
    await pump(
      tester,
      SldsPullToRefresh(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 50)),
        child: const Text('Content'),
      ),
    );

    expect(find.text('Loading…'), findsNothing);

    // A held drag, not a one-shot tester.drag — matches the "releasing past
    // the trigger threshold" test below; a single drag+pump call can land
    // before CupertinoSliverRefreshControl's internal state updates for the
    // new pulledExtent.
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CustomScrollView)),
    );
    await gesture.moveBy(const Offset(0, 150));
    await tester.pump();

    expect(find.text('Loading…'), findsOneWidget);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('releasing past the trigger threshold invokes onRefresh', (
    tester,
  ) async {
    var refreshed = false;
    await pump(
      tester,
      SldsPullToRefresh(
        onRefresh: () async => refreshed = true,
        child: const Text('Content'),
      ),
    );

    // A held drag (not a fling) so the sliver settles into `armed` before
    // release — matches how CupertinoSliverRefreshControl expects to be
    // exercised in tests (a fling's momentum can overshoot past the trigger
    // and retract before the framework ever registers `armed`).
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CustomScrollView)),
    );
    await gesture.moveBy(const Offset(0, 150));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(refreshed, isTrue);
  });

  testWidgets('custom loadingText is shown while pulling', (tester) async {
    await pump(
      tester,
      SldsPullToRefresh(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 50)),
        loadingText: 'Refreshing…',
        child: const Text('Content'),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CustomScrollView)),
    );
    await gesture.moveBy(const Offset(0, 150));
    await tester.pump();

    expect(find.text('Refreshing…'), findsOneWidget);
    expect(find.text('Loading…'), findsNothing);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('dark style renders without throwing while pulling', (
    tester,
  ) async {
    await pump(
      tester,
      SldsPullToRefresh(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 50)),
        style: SldsPullToRefreshStyle.dark,
        child: const Text('Content'),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CustomScrollView)),
    );
    await gesture.moveBy(const Offset(0, 150));
    await tester.pump();

    expect(find.text('Loading…'), findsOneWidget);
    await gesture.up();
    await tester.pumpAndSettle();
  });
}
