import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_tokens/slds_tokens.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget block, {
    ThemeData? theme,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: theme ?? SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(body: SizedBox(width: 345, child: block)),
    ),
  );

  testWidgets('renders the title, subtitle and leading icon', (tester) async {
    await pump(
      tester,
      const SldsMobileMenuBlock(
        title: 'My Account',
        subtitle: 'Name . Preferences',
        leadingIcon: Icons.account_circle_outlined,
      ),
    );

    expect(find.text('My Account'), findsOneWidget);
    expect(find.text('Name . Preferences'), findsOneWidget);
    expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);
  });

  testWidgets('subtitle is optional', (tester) async {
    await pump(tester, const SldsMobileMenuBlock(title: 'My Account'));
    expect(find.text('My Account'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('title and subtitle use the Figma type scale', (tester) async {
    // Figma: title Body 2 (14px), supporting line Overline (10px).
    const t = SldsRawTypographyTokens.standard;
    await pump(
      tester,
      const SldsMobileMenuBlock(title: 'My Account', subtitle: 'Name'),
    );

    expect(
      tester.widget<Text>(find.text('My Account')).style?.fontSize,
      t.body2.fontSize,
    );
    expect(
      tester.widget<Text>(find.text('Name')).style?.fontSize,
      t.overline.fontSize,
    );
  });

  testWidgets('the row is at least 64px tall', (tester) async {
    await pump(
      tester,
      const SldsMobileMenuBlock(
        title: 'My Account',
        subtitle: 'Name . Preferences',
        leadingIcon: Icons.account_circle_outlined,
      ),
    );

    expect(
      tester.getSize(find.byType(SldsMobileMenuBlock)).height,
      greaterThanOrEqualTo(64),
    );
  });

  testWidgets('tapping an interactive row invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsMobileMenuBlock(title: 'My Account', onTap: () => tapped = true),
    );

    await tester.tap(find.text('My Account'));
    expect(tapped, isTrue);
  });

  testWidgets('a row without onTap is not a button', (tester) async {
    await pump(tester, const SldsMobileMenuBlock(title: 'My Account'));
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('disabled rows do not respond to taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsMobileMenuBlock(
        title: 'My Account',
        enabled: false,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.text('My Account'), warnIfMissed: false);
    expect(tapped, isFalse);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('the whole row reads as one semantics node', (tester) async {
    // Title and subtitle are one phrase — a screen reader should not stop
    // twice inside a single row.
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      SldsMobileMenuBlock(
        title: 'My Account',
        subtitle: 'Name . Preferences',
        onTap: () {},
      ),
    );

    expect(
      find.bySemanticsLabel('My Account, Name . Preferences'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('each trailing affordance renders, and only one at a time', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsMobileMenuBlock(
        title: 'Row',
        trailing: SldsMobileMenuTrailing.navigate(),
      ),
    );
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.byType(SldsBadge), findsNothing);

    await pump(
      tester,
      const SldsMobileMenuBlock(
        title: 'Row',
        trailing: SldsMobileMenuTrailing.badge(label: 'Accepted'),
      ),
    );
    expect(find.byType(SldsBadge), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);

    await pump(
      tester,
      const SldsMobileMenuBlock(
        title: 'Row',
        trailing: SldsMobileMenuTrailing.validated(),
      ),
    );
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('a control affordance is rendered as given', (tester) async {
    await pump(
      tester,
      SldsMobileMenuBlock(
        title: 'Notifications',
        trailing: SldsMobileMenuTrailing.control(
          SldsToggle(value: true, onChanged: (_) {}),
        ),
      ),
    );

    expect(find.byType(SldsToggle), findsOneWidget);
  });

  testWidgets('an interactive trailing control keeps its own semantics', (
    tester,
  ) async {
    // The row merges its own text into one node; merging the whole row
    // instead would swallow this control and make it unreachable.
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      SldsMobileMenuBlock(
        title: 'Notifications',
        trailing: SldsMobileMenuTrailing.control(
          SldsToggle(
            value: true,
            onChanged: (_) {},
            semanticLabel: 'Notify me',
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Notify me'), findsOneWidget);
    expect(find.bySemanticsLabel('Notifications'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the count bubble renders its label verbatim', (tester) async {
    await pump(
      tester,
      const SldsMobileMenuBlock(title: 'Messages', count: '99+'),
    );
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('the divider can be suppressed on the last row', (tester) async {
    await pump(tester, const SldsMobileMenuBlock(title: 'Row'));
    expect(find.byType(Divider), findsOneWidget);

    await pump(
      tester,
      const SldsMobileMenuBlock(title: 'Row', showDivider: false),
    );
    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('colours follow the ambient theme into dark mode', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsMobileMenuBlock(title: 'My Account'),
      theme: SldsTheme.dark,
    );

    expect(
      tester.widget<Text>(find.text('My Account')).style?.color,
      SldsColorTokens.dark().textPrimary,
    );
  });
}
