import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget list) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: list),
    ),
  );

  const steps = [
    SldsProcessStep(
      title: 'Prepare documents',
      description: 'Gather all required identification and supporting files',
      status: SldsProcessStepStatus.done,
    ),
    SldsProcessStep(
      title: 'Verification in progress',
      description: 'Our team reviews your documents',
      status: SldsProcessStepStatus.current,
    ),
    SldsProcessStep(
      title: 'Receive approval',
      description: 'Notification sent via email and SMS',
    ),
  ];

  testWidgets('renders every step title, description and 1-based number', (
    tester,
  ) async {
    await pump(tester, const SldsProcessList(steps: steps));

    expect(find.text('Prepare documents'), findsOneWidget);
    expect(
      find.text('Gather all required identification and supporting files'),
      findsOneWidget,
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('done/current/upcoming badges use distinct colors', (
    tester,
  ) async {
    await pump(tester, const SldsProcessList(steps: steps));

    final colors = SldsColorTokens.light();

    Color badgeColorFor(String number) {
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text(number), matching: find.byType(Container))
            .first,
      );
      return (container.decoration! as BoxDecoration).color!;
    }

    expect(badgeColorFor('1'), colors.badgeApprovedBackground); // done
    expect(badgeColorFor('2'), colors.badgePendingBackground); // current
    // Upcoming reads the neutral badge pair, not the disabled pair: an
    // upcoming step is information the citizen needs to read, not an inert
    // control, so WCAG's exemption for disabled elements does not apply.
    // disabledForeground on disabledBackground measured 1.40:1.
    expect(badgeColorFor('3'), colors.badgeNeutralBackground); // upcoming
  });

  testWidgets('draws a divider between steps but not before the first', (
    tester,
  ) async {
    await pump(tester, const SldsProcessList(steps: steps));

    expect(find.byType(Divider), findsNWidgets(steps.length - 1));
  });

  testWidgets('width clamps to the available parent width', (tester) async {
    await pump(
      tester,
      const SizedBox(
        width: 200,
        child: SingleChildScrollView(
          child: SldsProcessList(steps: steps, width: 480),
        ),
      ),
    );

    final size = tester.getSize(find.byType(SldsProcessList));
    expect(size.width, 200);
  });

  testWidgets(
    'exposes step number, title and description as combined semantics',
    (tester) async {
      await pump(tester, const SldsProcessList(steps: steps));

      expect(
        find.bySemanticsLabel(
          'Step 1: Prepare documents. Gather all required identification '
          'and supporting files',
        ),
        findsOneWidget,
      );
    },
  );

  // Figma Process List (533:3256): titles Text/Primary #17171A, descriptions
  // Text/Secondary #676767 (#210).
  testWidgets('title and subtext colours match Figma (#210)', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));
    expect(
      tester.widget<Text>(find.text('Prepare documents')).style!.color,
      const Color(0xFF17171A),
    );
    expect(
      tester
          .widget<Text>(
            find.text(
              'Gather all required identification and supporting files',
            ),
          )
          .style!
          .color,
      const Color(0xFF676767),
    );
  });

  // Figma Process List slots: Mobile/Title 1 18/500/24 — success #1FAA63,
  // pending #503D00, upcoming Badge/Neutral #676767 (#211-#213).
  testWidgets('slot numbers match Figma (#211-#213)', (tester) async {
    await pump(tester, const SldsProcessList(steps: steps));
    final expected = {
      SldsProcessStepStatus.done: const Color(0xFF1FAA63),
      SldsProcessStepStatus.current: const Color(0xFF503D00),
      SldsProcessStepStatus.upcoming: const Color(0xFF676767),
    };
    for (var i = 0; i < steps.length; i++) {
      final style = tester.widget<Text>(find.text('${i + 1}')).style!;
      expect(style.fontSize, 18, reason: 'slot ${i + 1}');
      expect(style.fontWeight, FontWeight.w500, reason: 'slot ${i + 1}');
      expect(style.color, expected[steps[i].status], reason: 'slot ${i + 1}');
    }
  });
}
