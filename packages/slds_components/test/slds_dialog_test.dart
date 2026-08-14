import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Widget host(Widget Function(BuildContext) buttonBuilder) => MaterialApp(
    theme: SldsTheme.light(),
    home: Scaffold(
      body: Center(child: Builder(builder: buttonBuilder)),
    ),
  );

  testWidgets('renders title and message', (tester) async {
    await tester.pumpWidget(
      host(
        (context) => ElevatedButton(
          onPressed: () => SldsDialog.show(
            context,
            title: 'Basic dialog title',
            message: 'A dialog is a modal window',
          ),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Basic dialog title'), findsOneWidget);
    expect(find.text('A dialog is a modal window'), findsOneWidget);
  });

  testWidgets('hides message when null', (tester) async {
    await tester.pumpWidget(
      host(
        (context) => ElevatedButton(
          onPressed: () => SldsDialog.show(context, title: 'Title'),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(SldsDialog), findsOneWidget);
  });

  testWidgets(
    'cancel and confirm buttons only render when their label is set, and fire callbacks',
    (tester) async {
      var cancelled = false;
      var confirmed = false;
      await tester.pumpWidget(
        host(
          (context) => ElevatedButton(
            onPressed: () => SldsDialog.show(
              context,
              title: 'Title',
              cancelLabel: 'Cancel',
              onCancel: () => cancelled = true,
              confirmLabel: 'Continue',
              onConfirm: () => confirmed = true,
            ),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);

      await tester.tap(find.text('Continue'));
      expect(confirmed, isTrue);
    },
  );

  testWidgets('no actions render when both labels are null', (tester) async {
    await tester.pumpWidget(
      host(
        (context) => ElevatedButton(
          onPressed: () => SldsDialog.show(context, title: 'Title'),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(SldsButton), findsNothing);
  });

  testWidgets('renders without crashing at a mobile viewport width', (
    tester,
  ) async {
    // Regression class: SldsButton goes full-width below the mobile
    // breakpoint using an internal LayoutBuilder — anything that queries
    // its intrinsic size (rather than giving it loose/unbounded width like
    // AlertDialog's OverflowBar does) would crash here, as happened with
    // SldsNotificationCard's IntrinsicWidth-wrapped action button.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        (context) => ElevatedButton(
          onPressed: () => SldsDialog.show(
            context,
            title: 'Basic dialog title',
            message: 'A dialog is a modal window',
            cancelLabel: 'Cancel',
            confirmLabel: 'Continue',
          ),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('barrierDismissible false blocks tapping outside', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        (context) => ElevatedButton(
          onPressed: () => SldsDialog.show(
            context,
            title: 'Title',
            barrierDismissible: false,
          ),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Title'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Title'), findsOneWidget); // still open
  });
}
