import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  testWidgets('test button text contrast alone', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SldsTheme.light,
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SldsButton(
              label: 'Cancel',
              onPressed: () {},
              variant: SldsButtonVariant.secondary,
              size: SldsButtonSize.small,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });
}
