// Screen-reader labels are localized (§5, §6).
//
// A Sinhala or Tamil speaker running TalkBack should hear their own
// language. These assert the label that actually reaches the semantics tree,
// so a hardcoded English string fails rather than passing quietly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

void main() {
  group('navigation labels', () {
    testWidgets('SldsTopNavBar back and menu announce in Sinhala', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsTopNavBar(title: 'Vehicles', onBack: () {}, onMenu: () {}),
          locale: const Locale('si'),
        ),
      );

      expect(find.bySemanticsLabel('ආපසු'), findsOneWidget);
      expect(find.bySemanticsLabel('මෙනුව'), findsOneWidget);
      expect(find.bySemanticsLabel('Back'), findsNothing);
      expect(find.bySemanticsLabel('Menu'), findsNothing);
      handle.dispose();
    });

    testWidgets('SldsTopNavBar announces in Tamil', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsTopNavBar(title: 'Vehicles', onBack: () {}, onMenu: () {}),
          locale: const Locale('ta'),
        ),
      );

      expect(find.bySemanticsLabel('பின்செல்'), findsOneWidget);
      expect(find.bySemanticsLabel('பட்டி'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('English remains the default', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsTopNavBar(title: 'Vehicles', onBack: () {}, onMenu: () {})),
      );

      expect(find.bySemanticsLabel('Back'), findsOneWidget);
      expect(find.bySemanticsLabel('Menu'), findsOneWidget);
      handle.dispose();
    });
  });

  group('interpolated labels', () {
    testWidgets('a chip names what removing it would remove', (tester) async {
      // "Remove" alone does not say remove what; the chip's own text has to
      // be part of the announcement.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(SldsChip(label: 'Colombo', onDeleted: () {})),
      );

      // The chip's own text merges into the button node, so the label reads
      // "Colombo\nRemove Colombo" — assert the part that carries meaning.
      expect(find.bySemanticsLabel(RegExp('Remove Colombo')), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the chip removal label is localized, not concatenated', (
      tester,
    ) async {
      // Sinhala puts the verb after the noun, so a hardcoded
      // "Remove $label" would be wrong even with a translated verb.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          SldsChip(label: 'Colombo', onDeleted: () {}),
          locale: const Locale('si'),
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp('Colombo ඉවත් කරන්න')),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('progress', () {
    testWidgets('announces its role in the active locale', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          const SldsProgressBar(value: 0.5),
          locale: const Locale('ta'),
        ),
      );

      expect(find.bySemanticsLabel('முன்னேற்றம்'), findsOneWidget);
      handle.dispose();
    });
  });

  group('missing delegate', () {
    testWidgets('fails with an actionable message, not a null check', (
      tester,
    ) async {
      // A host app that forgets the delegates previously got "Null check
      // operator used on a null value" from inside a build method, which
      // says nothing about the cause.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SldsProgressBar(value: 0.5))),
      );

      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(
        error.toString(),
        contains('No SldsLocalizations found'),
      );
      expect(
        error.toString(),
        contains('localizationsDelegates'),
        reason: 'the message must name the fix, not just the symptom',
      );
    });
  });

  group('catalog copy', () {
    testWidgets('error-state preset copy is localized, not baked in', (
      tester,
    ) async {
      // forKind's copy used to be hardcoded English in a factory, which has
      // no BuildContext; it now resolves at build time.
      Future<List<String>> copyIn(Locale locale) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: SldsLocalizations.localizationsDelegates,
            supportedLocales: SldsLocalizations.supportedLocales,
            home: Scaffold(
              body: SldsErrorState.forKind(
                SldsErrorKind.notFound,
                onAction: () {},
              ),
            ),
          ),
        );
        return tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data)
            .whereType<String>()
            .toList();
      }

      final english = await copyIn(const Locale('en'));
      final tamil = await copyIn(const Locale('ta'));

      expect(english, contains('Page not found'));
      expect(english, contains('Go to Home'));
      // The numeric code is not language-specific and must not change.
      expect(tamil, contains('404'));
      expect(tamil, isNot(contains('Page not found')));
    });

    testWidgets('the time picker AM/PM marker is localized', (tester) async {
      Future<String> formattedIn(Locale locale) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: SldsLocalizations.localizationsDelegates,
            supportedLocales: SldsLocalizations.supportedLocales,
            home: const Scaffold(
              body: SldsTimePicker(
                label: 'Time',
                initialTime: TimeOfDay(hour: 14, minute: 5),
              ),
            ),
          ),
        );
        return tester
                .widget<TextField>(find.byType(TextField).first)
                .controller
                ?.text ??
            '';
      }

      expect(await formattedIn(const Locale('en')), '2:05 PM');
      // The digits stay Latin; only the marker is translated.
      expect(await formattedIn(const Locale('ta')), startsWith('2:05 '));
      expect(await formattedIn(const Locale('ta')), isNot(endsWith('PM')));
    });
  });
}
