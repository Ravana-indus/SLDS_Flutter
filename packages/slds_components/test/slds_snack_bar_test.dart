import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pumpHost(
    WidgetTester tester,
    void Function(BuildContext) onPressed,
  ) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => onPressed(context),
              child: const Text('show'),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('shows title and message', (tester) async {
    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(
        context,
        title: 'Title Text',
        message: 'Enter the description text',
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump(); // start the entrance animation
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Title Text'), findsOneWidget);
    expect(find.text('Enter the description text'), findsOneWidget);
  });

  testWidgets('hides the message line when null', (tester) async {
    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(context, title: 'Title Text'),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Title Text'), findsOneWidget);
    expect(find.byType(SldsSnackBar), findsOneWidget);
  });

  testWidgets('action button renders and fires onAction', (tester) async {
    var tapped = false;
    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(
        context,
        title: 'Title Text',
        actionLabel: 'Button',
        onAction: () => tapped = true,
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('Button'), findsOneWidget);
    await tester.tap(find.text('Button'));
    expect(tapped, isTrue);
  });

  testWidgets('no action button when actionLabel is null', (tester) async {
    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(context, title: 'Title Text'),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.byType(SldsButton), findsNothing);
  });

  testWidgets('auto-dismisses after the default 4s duration', (tester) async {
    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(context, title: 'Title Text'),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    expect(find.text('Title Text'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Title Text'), findsNothing);
  });

  testWidgets('renders without crashing at a mobile viewport width', (
    tester,
  ) async {
    // SldsButton goes full-width below the mobile breakpoint via an
    // internal LayoutBuilder — safe here because it sits in a Row beside an
    // Expanded (unconstrained width slot), but worth pinning down since
    // AlertDialog/OverflowBar-style intrinsic queries crash that path.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpHost(
      tester,
      (context) => SldsSnackBar.show(
        context,
        title: 'Title Text',
        message: 'Enter the description text',
        actionLabel: 'Button',
        onAction: () {},
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(tester.takeException(), isNull);
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('is a live region so its arrival is announced', (tester) async {
    // Focus never moves to a snack bar, so without a live region a screen
    // reader user is never told it appeared (§5).
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: const Scaffold(body: SldsSnackBar(title: 'Saved')),
      ),
    );

    final data = tester
        .getSemantics(find.byType(SldsSnackBar))
        .getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
    handle.dispose();
  });
}
