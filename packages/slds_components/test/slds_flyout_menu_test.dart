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
          entries: [
            SldsFlyoutMenuEntry(
              icon: Icons.security,
              label: 'Data Integrations',
            ),
          ],
        ),
      ],
    ),
    SldsFlyoutMenuItem(label: 'Navigation 02'),
  ];

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets('renders every top-level item, groups collapsed by default', (
    tester,
  ) async {
    await pump(tester, const SldsFlyoutMenu(items: items));

    expect(find.text('Navigation 01'), findsOneWidget);
    expect(find.text('Navigation 02'), findsOneWidget);
    expect(find.text('Tools for Trusted Data'), findsNothing);
    expect(find.text('Data Integrations'), findsNothing);
  });

  testWidgets('tapping an expandable item reveals its groups and entries', (
    tester,
  ) async {
    await pump(tester, const SldsFlyoutMenu(items: items));

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();

    expect(find.text('Tools for Trusted Data'), findsOneWidget);
    expect(find.text('Data Integrations'), findsOneWidget);
  });

  testWidgets('expanding one item collapses the previously expanded one', (
    tester,
  ) async {
    const twoExpandable = [
      SldsFlyoutMenuItem(
        label: 'Navigation 01',
        groups: [
          SldsFlyoutMenuGroup(
            header: 'Group A',
            entries: [SldsFlyoutMenuEntry(label: 'Entry A')],
          ),
        ],
      ),
      SldsFlyoutMenuItem(
        label: 'Navigation 02',
        groups: [
          SldsFlyoutMenuGroup(
            header: 'Group B',
            entries: [SldsFlyoutMenuEntry(label: 'Entry B')],
          ),
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

  testWidgets('tapping a non-expandable item fires its onTap directly', (
    tester,
  ) async {
    var tapped = false;
    await pump(
      tester,
      SldsFlyoutMenu(
        items: [
          SldsFlyoutMenuItem(label: 'Settings', onTap: () => tapped = true),
        ],
      ),
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
                entries: [
                  SldsFlyoutMenuEntry(
                    label: 'Entry',
                    onTap: () => tapped = true,
                  ),
                ],
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

  testWidgets('onClose null hides the close button, non-null shows it', (
    tester,
  ) async {
    await pump(tester, const SldsFlyoutMenu(items: items));
    expect(find.byIcon(Icons.close), findsNothing);

    await pump(tester, SldsFlyoutMenu(items: items, onClose: () {}));
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets(
    'showSldsFlyoutMenu opens and expands without a Material ancestor crash',
    (tester) async {
      // Regression: showGeneralDialog's pageBuilder (unlike showDialog) does
      // not provide a Material ancestor, and the rows' InkWells need one —
      // the widget must bring its own.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
          supportedLocales: SldsLocalizations.supportedLocales,
          theme: SldsTheme.light,
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
    },
  );

  testWidgets('rows hover with Surface/Hover and show no ripple', (
    tester,
  ) async {
    await pump(tester, const SldsFlyoutMenu(items: items));
    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();

    // Both top-level rows plus the revealed sub-entry.
    final rows = tester.widgetList<InkWell>(find.byType(InkWell));
    expect(rows, hasLength(3));
    for (final row in rows) {
      expect(row.splashFactory, NoSplash.splashFactory);
      expect(row.highlightColor, Colors.transparent);
      expect(row.hoverColor, SldsColorTokens.light().surfaceHover);
    }
  });

  // Figma Flyout Mobile (1018:33957): titles 18/500/28 #17171A; expanded
  // captions 12/400/18 #BCBCBC; expanded titles 16/400/26 #17171A.
  testWidgets('title, caption and entry typography match Figma (#187-#189)', (
    tester,
  ) async {
    await pump(tester, const SldsFlyoutMenu(items: items));
    var style = tester.widget<Text>(find.text('Navigation 02')).style!;
    expect(style.fontSize, 18);
    expect(style.fontWeight, FontWeight.w500);
    expect(style.fontSize! * style.height!, closeTo(28, 0.01));
    expect(style.color, const Color(0xFF17171A));

    await tester.tap(find.text('Navigation 01'));
    await tester.pumpAndSettle();

    final header = items.first.groups.first;
    style = tester.widget<Text>(find.text(header.header)).style!;
    expect(style.fontSize, 12);
    expect(style.fontSize! * style.height!, closeTo(18, 0.01));
    expect(style.color, const Color(0xFFBCBCBC));

    style = tester.widget<Text>(find.text(header.entries.first.label)).style!;
    expect(style.fontSize, 16);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.fontSize! * style.height!, closeTo(26, 0.01));
    expect(style.color, const Color(0xFF17171A));
  });
}
