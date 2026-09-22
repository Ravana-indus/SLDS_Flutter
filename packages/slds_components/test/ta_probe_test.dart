import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  testWidgets('render text area', (t) async {
    await t.binding.setSurfaceSize(const Size(393, 400));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(
        body: ListView(padding: const EdgeInsets.all(16), children: const [
          SldsTextArea(
            label: 'Description', isRequired: true,
            hintText: 'Description placeholder', helpText: 'Help Text',
          ),
        ]),
      ),
    ));
    await t.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('probe_textarea.png'));
  });
}
