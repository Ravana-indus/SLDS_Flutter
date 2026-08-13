import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  const items = [
    SldsFlyoutMenuItem(
      label: 'Navigation 01',
      groups: [
        SldsFlyoutMenuGroup(
          header: 'Tools for Trusted Data',
          entries: [SldsFlyoutMenuEntry(icon: Icons.security, label: 'Data Integrations')],
        ),
      ],
    ),
    SldsFlyoutMenuItem(label: 'Navigation 02'),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: SingleChildScrollView(child: child))),
      );

  testWidgets('renders every top-level item, groups collapsed by default', (tester) async {
    await pump(tester, const SldsFlyoutMenu(items: items));

    expect(find.text('Navigation 01'), findsOneWidget);
    expect(find.text('Navigation 02'), findsOneWidget);
    expect(find.text('Tools for Trusted Data'), findsNothing);
    expect(find.text('Data Integrations'), findsNothing);
  });

  testWidgets('tapping an expandable item reveals its groups and entries', (tester) async {
    await pump(tester, const SldsFlyoutMenu(items: items));

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();

    expect(find.text('Tools for Trusted Data'), findsOneWidget);
    expect(find.text('Data Integrations'), findsOneWidget);
  });

  testWidgets('expanding one item collapses the previously expanded one', (tester) async {
    const twoExpandable = [
      SldsFlyoutMenuItem(
        label: 'Navigation 01',
        groups: [
          SldsFlyoutMenuGroup(header: 'Group A', entries: [SldsFlyoutMenuEntry(label: 'Entry A')]),
        ],
      ),
      SldsFlyoutMenuItem(
        label: 'Navigation 02',
        groups: [
          SldsFlyoutMenuGroup(header: 'Group B', entries: [SldsFlyoutMenuEntry(label: 'Entry B')]),
        ],
      ),
    ];
    await pump(tester, const SldsFlyoutMenu(items: twoExpandable));

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();
    expect(find.text('Entry A'), findsOneWidget);

    await tester.tap(find.text('Navigation 02'));
    await tester.pumpAndSettle();
    expect(find.text('Entry A'), findsNothing);
    expect(find.text('Entry B'), findsOneWidget);
  });

  testWidgets('tapping a non-expandable item fires its onTap directly', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFlyoutMenu(items: [SldsFlyoutMenuItem(label: 'Settings', onTap: () => tapped = true)]),
    );

    await tester.tap(find.text('Settings'));
    expect(tapped, isTrue);
  });

  testWidgets('tapping a sub-entry fires its own onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsFlyoutMenu(
        items: [
          SldsFlyoutMenuItem(
            label: 'Navigation 01',
            groups: [
              SldsFlyoutMenuGroup(
                header: 'Group',
                entries: [SldsFlyoutMenuEntry(label: 'Entry', onTap: () => tapped = true)],
              ),
            ],
          ),
        ],
      ),
    );

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entry'));
    expect(tapped, isTrue);
  });

  testWidgets('onClose null hides the close button, non-null shows it', (tester) async {
    await pump(tester, const SldsFlyoutMenu(items: items));
    expect(find.byIcon(Icons.close), findsNothing);

    await pump(tester, SldsFlyoutMenu(items: items, onClose: () {}));
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('showSldsFlyoutMenu opens and expands without a Material ancestor crash', (
    tester,
  ) async {
    // Regression: showGeneralDialog's pageBuilder (unlike showDialog) does
    // not provide a Material ancestor, and the rows' InkWells need one —
    // the widget must bring its own.
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showSldsFlyoutMenu(context, items: items),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Data Integrations'), findsOneWidget);
  });
}
