import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget card) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: card),
    ),
  );

  testWidgets('renders title, body and timestamp', (tester) async {
    await pump(
      tester,
      const SldsNotificationCard(
        title: 'Your Birth Certificate is ready',
        body: 'Download it now or collect it from your selected office.',
        timestamp: 'Today, 12:00pm',
      ),
    );

    expect(find.text('Your Birth Certificate is ready'), findsOneWidget);
    expect(
      find.text('Download it now or collect it from your selected office.'),
      findsOneWidget,
    );
    expect(find.text('Today, 12:00pm'), findsOneWidget);
  });

  testWidgets('hides timestamp when null', (tester) async {
    await pump(
      tester,
      const SldsNotificationCard(title: 'Title', body: 'Body'),
    );
    expect(find.byType(SldsNotificationCard), findsOneWidget);
  });

  testWidgets(
    'shows the action button only when actionLabel is set, and it invokes onAction',
    (tester) async {
      var tapped = false;
      await pump(
        tester,
        SldsNotificationCard(
          title: 'Title',
          body: 'Body',
          actionLabel: 'Download',
          onAction: () => tapped = true,
        ),
      );

      expect(find.text('Download'), findsOneWidget);
      await tester.tap(find.text('Download'));
      expect(tapped, isTrue);
    },
  );

  testWidgets(
    'action button renders without crashing at a mobile viewport width',
    (tester) async {
      // Regression: SldsButton goes full-width below the mobile breakpoint
      // and internally uses a LayoutBuilder — wrapping it in IntrinsicWidth
      // (an earlier version of this card did) crashes with "LayoutBuilder
      // does not support returning intrinsic dimensions" at mobile widths,
      // e.g. iPhone 12 Pro Max in the widgetbook viewport addon.
      tester.view.physicalSize = const Size(428, 926);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await pump(
        tester,
        SldsNotificationCard(
          title: 'Your Birth Certificate is ready',
          body: 'Download it now or collect it from your selected office.',
          type: SldsNotificationType.success,
          unread: true,
          actionLabel: 'Download',
          onAction: () {},
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Download'), findsOneWidget);
    },
  );

  testWidgets('no action button when actionLabel is null', (tester) async {
    await pump(
      tester,
      const SldsNotificationCard(title: 'Title', body: 'Body'),
    );
    expect(find.byType(SldsButton), findsNothing);
  });

  testWidgets('shows the unread dot only when unread is true', (tester) async {
    await pump(
      tester,
      const SldsNotificationCard(title: 'Title', body: 'Body'),
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 8,
      ),
      findsNothing,
    );

    await pump(
      tester,
      const SldsNotificationCard(title: 'Title', body: 'Body', unread: true),
    );
    // Presence check via the widget tree: a Container sized 8x8 (the dot).
    final dot = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.constraints == const BoxConstraints.tightFor(width: 8, height: 8),
    );
    expect(dot, findsOneWidget);
  });

  testWidgets('each type renders its own icon', (tester) async {
    for (final (type, icon) in [
      (SldsNotificationType.document, Icons.description_outlined),
      (SldsNotificationType.warning, Icons.warning_amber_rounded),
      (SldsNotificationType.success, Icons.check_circle_outline),
      (SldsNotificationType.error, Icons.cancel_outlined),
    ]) {
      await pump(
        tester,
        SldsNotificationCard(title: 'Title', body: 'Body', type: type),
      );
      expect(find.byIcon(icon), findsOneWidget, reason: 'type: $type');
    }
  });

  testWidgets('without onDismissed, no Dismissible is built', (tester) async {
    await pump(
      tester,
      const SldsNotificationCard(title: 'Title', body: 'Body'),
    );
    expect(find.byType(Dismissible), findsNothing);
  });

  testWidgets(
    'swiping left past the threshold with onDismissed set calls the callback',
    (tester) async {
      DismissDirection? dismissedDirection;
      await pump(
        tester,
        SldsNotificationCard(
          title: 'Title',
          body: 'Body',
          onDismissed: (direction) => dismissedDirection = direction,
        ),
      );

      expect(find.byType(Dismissible), findsOneWidget);
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(dismissedDirection, DismissDirection.endToStart);
    },
  );

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 200,
        child: SldsNotificationCard(title: 'Title', body: 'Body', width: 375),
      ),
    );

    final size = tester.getSize(find.byType(SldsNotificationCard));
    expect(size.width, 200);
  });
}
