import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget sheet) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      home: Scaffold(body: SizedBox(height: 600, child: sheet)),
    ),
  );

  testWidgets('renders title and child content', (tester) async {
    await pump(
      tester,
      const SldsBottomSheet(title: 'Title', child: Text('Body content')),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Body content'), findsOneWidget);
  });

  testWidgets('back chevron only renders when onBack is set, and invokes it', (
    tester,
  ) async {
    var backTapped = false;
    await pump(
      tester,
      SldsBottomSheet(
        title: 'Title',
        onBack: () => backTapped = true,
        child: const SizedBox(),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(backTapped, isTrue);
  });

  testWidgets(
    'back chevron reserves its space but is not tappable when onBack is null',
    (tester) async {
      await pump(
        tester,
        const SldsBottomSheet(title: 'Title', child: SizedBox()),
      );
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    },
  );

  testWidgets('close button only renders when onClose is set, and invokes it', (
    tester,
  ) async {
    var closeTapped = false;
    await pump(
      tester,
      SldsBottomSheet(
        title: 'Title',
        onClose: () => closeTapped = true,
        child: const SizedBox(),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    expect(closeTapped, isTrue);
  });

  testWidgets('no close button when onClose is null', (tester) async {
    await pump(
      tester,
      const SldsBottomSheet(title: 'Title', child: SizedBox()),
    );
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets(
    'show opens full-height via showModalBottomSheet and pops on close',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SldsTheme.light,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => SldsBottomSheet.show(
                    context,
                    title: 'Sheet Title',
                    child: const Text('Content'),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Sheet Title'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Sheet Title'), findsNothing);
    },
  );
}
