import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const illustration = Icon(Icons.folder_open);

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: child)),
      );

  testWidgets('renders illustration, title and description', (tester) async {
    await pump(
      tester,
      const SldsEmptyState(
        illustration: illustration,
        title: 'No documents added yet',
        description: 'Your uploaded documents will appear here once added.',
      ),
    );

    expect(find.byIcon(Icons.folder_open), findsOneWidget);
    expect(find.text('No documents added yet'), findsOneWidget);
    expect(find.text('Your uploaded documents will appear here once added.'), findsOneWidget);
  });

  testWidgets('hides description when null', (tester) async {
    await pump(tester, const SldsEmptyState(illustration: illustration, title: 'Title'));
    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('shows the action button only when both label and callback are set', (tester) async {
    await pump(tester, const SldsEmptyState(illustration: illustration, title: 'Title'));
    expect(find.byType(SldsButton), findsNothing);

    await pump(
      tester,
      const SldsEmptyState(illustration: illustration, title: 'Title', actionLabel: 'Add Document'),
    );
    expect(find.byType(SldsButton), findsNothing); // no onAction

    var tapped = false;
    await pump(
      tester,
      SldsEmptyState(
        illustration: illustration,
        title: 'Title',
        actionLabel: 'Add Document',
        onAction: () => tapped = true,
      ),
    );
    expect(find.text('Add Document'), findsOneWidget);
    await tester.tap(find.text('Add Document'));
    expect(tapped, isTrue);
  });
}
