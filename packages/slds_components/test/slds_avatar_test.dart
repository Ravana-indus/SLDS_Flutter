import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('renders initials when given', (tester) async {
    await pump(tester, const SldsAvatar(initials: 'LK'));
    expect(find.text('LK'), findsOneWidget);
  });

  testWidgets('truncates initials to 2 characters', (tester) async {
    await pump(tester, const SldsAvatar(initials: 'ABCD'));
    expect(find.text('AB'), findsOneWidget);
  });

  testWidgets('falls back to the person icon when initials is null', (
    tester,
  ) async {
    await pump(tester, const SldsAvatar());
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('falls back to the person icon when initials is empty', (
    tester,
  ) async {
    await pump(tester, const SldsAvatar(initials: ''));
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('each size renders at its token diameter', (tester) async {
    const expected = {
      SldsAvatarSize.small: 24.0,
      SldsAvatarSize.medium: 32.0,
      SldsAvatarSize.large: 40.0,
      SldsAvatarSize.extraLarge: 48.0,
      SldsAvatarSize.huge: 56.0,
    };

    for (final entry in expected.entries) {
      await pump(tester, SldsAvatar(initials: 'LK', size: entry.key));
      expect(tester.getSize(find.byType(SldsAvatar)), Size.square(entry.value));
    }
  });
}
