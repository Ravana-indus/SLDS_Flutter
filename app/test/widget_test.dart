import 'package:flutter_test/flutter_test.dart';

import 'package:slds_app/main.dart';

void main() {
  testWidgets('theme toggle button switches label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SldsApp());

    expect(find.text('Switch to dark'), findsOneWidget);

    await tester.tap(find.text('Switch to dark'));
    await tester.pump();

    expect(find.text('Switch to light'), findsOneWidget);
  });
}
