// Credential/PII handling in SldsSummaryList (§1).
//
// A summary row announces label and value as one phrase, which is right for
// an ordinary value and wrong for a credential: a review screen is where
// NICs, licence numbers and dates of birth cluster, and a screen reader
// routes to a speaker as readily as to an earpiece. `isSensitive` withholds
// the value until the citizen asks for it.

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

void main() {
  // Synthetic throughout — never a real NIC or licence number.
  const label = 'NIC number';
  const value = '000000000V';

  Future<void> pump(WidgetTester tester, {required bool sensitive}) {
    return tester.pumpWidget(
      wrap(
        SldsSummaryList(
          rows: [
            SldsSummaryRow(
              label: label,
              value: value,
              isSensitive: sensitive,
            ),
          ],
        ),
      ),
    );
  }

  /// The row's own semantics node — the container `SldsSummaryList` builds
  /// per row. `find.bySemanticsLabel` cannot be used here: what the label
  /// says is exactly what is under test.
  SemanticsNode rowNode(WidgetTester tester) {
    final root = tester.binding.rootElement!.renderObject!.debugSemantics!;
    SemanticsNode? found;
    void visit(SemanticsNode node) {
      if (node.label.contains(label)) found ??= node;
      node.visitChildren((child) {
        visit(child);
        return true;
      });
    }

    visit(root);
    return found!;
  }

  String rowLabel(WidgetTester tester) => rowNode(tester).label;

  group('an ordinary row is unchanged', () {
    testWidgets('shows and announces label with value', (tester) async {
      await pump(tester, sensitive: false);

      expect(find.text(value), findsOneWidget);
      expect(rowLabel(tester), contains(value));
    });
  });

  group('a sensitive row', () {
    testWidgets('masks the value on screen', (tester) async {
      await pump(tester, sensitive: true);

      expect(
        find.text(value),
        findsNothing,
        reason: 'a credential must not be rendered before it is revealed',
      );
      expect(find.text(label), findsOneWidget);
    });

    testWidgets('withholds the value from the announcement', (tester) async {
      await pump(tester, sensitive: true);

      final announced = rowLabel(tester);
      expect(
        announced,
        isNot(contains(value)),
        reason: 'a screen reader must not speak the credential aloud',
      );
      expect(announced, contains(label));
    });

    testWidgets('reveals the value on tap, and announces it', (tester) async {
      await pump(tester, sensitive: true);

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(find.text(value), findsOneWidget);
      expect(rowLabel(tester), contains(value));
    });

    testWidgets('hides it again on a second tap', (tester) async {
      await pump(tester, sensitive: true);

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(find.text(value), findsNothing);
      expect(rowLabel(tester), isNot(contains(value)));
    });

    testWidgets('is reachable as a button by assistive tech', (tester) async {
      await pump(tester, sensitive: true);

      final node = rowNode(tester);
      expect(node.flagsCollection.isButton, isTrue);
      expect(
        node.getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue,
      );
    });

    testWidgets('meets the 48px tap target at the 320dp floor', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await pump(tester, sensitive: true);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    });
  });
}
