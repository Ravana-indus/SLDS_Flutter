import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const illustration = Icon(Icons.error_outline);

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders code, title and description', (tester) async {
    await pump(
      tester,
      const SldsErrorState(
        illustration: illustration,
        code: '404',
        title: 'Page not found',
        description: 'Sorry we were unable to find that page',
      ),
    );

    expect(find.text('404'), findsOneWidget);
    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('Sorry we were unable to find that page'), findsOneWidget);
  });

  testWidgets('hides the code when null (maintenance variant)', (tester) async {
    await pump(
      tester,
      const SldsErrorState(
        illustration: illustration,
        title: 'System is down for Maintenance',
      ),
    );
    expect(find.text('System is down for Maintenance'), findsOneWidget);
  });

  testWidgets('forKind fills in the preset copy per kind', (tester) async {
    await pump(
      tester,
      SldsErrorState.forKind(
        SldsErrorKind.notFound,
        illustration: illustration,
      ),
    );
    expect(find.text('404'), findsOneWidget);
    expect(find.text('Page not found'), findsOneWidget);
  });

  testWidgets(
    'forKind default actionLabel only renders a button once onAction is set',
    (tester) async {
      await pump(
        tester,
        SldsErrorState.forKind(
          SldsErrorKind.notFound,
          illustration: illustration,
        ),
      );
      expect(find.byType(SldsButton), findsNothing);

      var tapped = false;
      await pump(
        tester,
        SldsErrorState.forKind(
          SldsErrorKind.notFound,
          illustration: illustration,
          onAction: () => tapped = true,
        ),
      );
      expect(find.byType(SldsButton), findsOneWidget);
      await tester.tap(find.text('Go to Home'));
      expect(tapped, isTrue);
    },
  );

  testWidgets('forKind lets individual fields be overridden', (tester) async {
    await pump(
      tester,
      SldsErrorState.forKind(
        SldsErrorKind.serverError,
        illustration: illustration,
        title: 'Custom title',
      ),
    );
    expect(find.text('500'), findsOneWidget);
    expect(find.text('Custom title'), findsOneWidget);
  });

  testWidgets('forKind renders a built-in illustration when none is passed', (
    tester,
  ) async {
    await pump(tester, SldsErrorState.forKind(SldsErrorKind.notFound));

    expect(find.text('404'), findsOneWidget);
    expect(
      find.byIcon(Icons.error_outline),
      findsNothing,
    ); // no leftover placeholder
    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('each kind gets a distinct built-in illustration', (
    tester,
  ) async {
    for (final (kind, badgeIcon) in [
      (SldsErrorKind.notFound, Icons.search),
      (SldsErrorKind.serverError, Icons.dns_outlined),
      (SldsErrorKind.unauthorized, Icons.lock_outline),
    ]) {
      await pump(tester, SldsErrorState.forKind(kind));
      expect(find.byIcon(badgeIcon), findsOneWidget, reason: 'kind: $kind');
    }
  });

  testWidgets('an explicit illustration still overrides the built-in one', (
    tester,
  ) async {
    await pump(
      tester,
      SldsErrorState.forKind(
        SldsErrorKind.notFound,
        illustration: illustration,
      ),
    );

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byIcon(Icons.search), findsNothing);
  });
}
