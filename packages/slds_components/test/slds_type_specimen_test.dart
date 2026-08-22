// Type specimen golden (§8).
//
// Renders the SLDS type scale as a specimen sheet laid out like the Figma
// "Text Styles" page (Foundation Documentation, node 1193:10717): one row per
// style, previewed in English, Tamil and Sinhala, with the metrics printed
// alongside. `tokens_test.dart` in slds_tokens already pins the numbers; this
// is the visual counterpart — it catches what a metric assertion cannot, such
// as a weight that fails to resolve to the bundled face, or Sinhala and Tamil
// glyphs clipping their line box.
//
// Compare the committed image against the Figma page when either changes.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';
import 'package:slds_tokens/slds_tokens.dart';

/// The three scripts SLDS ships, matching the Figma preview columns.
const _english = 'Hello';
const _tamil = 'வணக்கம்';
const _sinhala = 'ආයුබෝවන්';

/// A specimen row: the Dart token, the Figma style it mirrors, and its style.
typedef _Specimen = ({String name, String figma, SldsTextStyleToken token});

List<_Specimen> _specimens() {
  const t = SldsRawTypographyTokens.standard;
  return <_Specimen>[
    (name: 'display2', figma: 'Desktop/Display 2', token: t.display2),
    (
      name: 'desktopHeading2',
      figma: 'Desktop/Heading 2',
      token: t.desktopHeading2,
    ),
    (name: 'heading4', figma: 'Desktop/Heading 4', token: t.heading4),
    (name: 'desktopTitle1', figma: 'Desktop/Title 1', token: t.desktopTitle1),
    (name: 'body2', figma: 'Desktop/Body 2', token: t.body2),
    (
      name: 'bottomNavigationLabel',
      figma: 'Desktop/Caption 1',
      token: t.bottomNavigationLabel,
    ),
    (name: 'caption2', figma: 'Desktop/Caption 2', token: t.caption2),
    (
      name: 'mobileDisplay1',
      figma: 'Mobile/Display 1',
      token: t.mobileDisplay1,
    ),
    (name: 'heading1', figma: 'Mobile/Heading 1', token: t.heading1),
    (name: 'heading2', figma: 'Mobile/Heading 2', token: t.heading2),
    (name: 'heading3', figma: 'Mobile/Heading 3', token: t.heading3),
    (name: 'title1', figma: 'Mobile/Title 1', token: t.title1),
    (name: 'body1', figma: 'Mobile/Body 1', token: t.body1),
    (name: 'caption1', figma: 'Mobile/Caption 1', token: t.caption1),
    (
      name: 'mobileCaption2',
      figma: 'Mobile/Caption 2',
      token: t.mobileCaption2,
    ),
  ];
}

/// Figma prints e.g. `Google Sans Bold · 44px · LH 56px · LS -0.3px`.
String _properties(SldsTextStyleToken s) {
  final weight = switch (s.fontWeight) {
    700 => 'Bold',
    500 => 'Medium',
    _ => 'Regular',
  };
  String px(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  return 'Google Sans $weight · ${px(s.fontSize)}px · '
      'LH ${px(s.lineHeight)}px · LS ${s.letterSpacing.toStringAsFixed(1)}px';
}

Widget _sheet() {
  const label = TextStyle(
    fontFamily: 'Google Sans',
    package: 'slds_components',
    fontSize: 12,
    height: 16 / 12,
    color: Color(0xff222222),
  );
  final meta = label.copyWith(color: const Color(0xff898989));

  // `softWrap: false`: a specimen row must show the glyphs at their designed
  // size on one line. Letting the largest styles wrap would turn a legitimate
  // render into an apparent layout bug.
  Widget cell(String text, TextStyle style, double width) => SizedBox(
    width: width,
    child: Text(text, style: style, softWrap: false),
  );

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: SldsTheme.light,
    home: Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Text Styles',
              style: label.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('Previews shown in English, Tamil & Sinhala', style: meta),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                cell('Style name', meta, 200),
                cell('English', meta, 260),
                cell('Tamil', meta, 300),
                cell('Sinhala', meta, 300),
                cell('Properties', meta, 280),
              ],
            ),
            const SizedBox(height: 10),
            for (final s in _specimens())
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(s.figma, style: label),
                          Text(s.name, style: meta.copyWith(fontSize: 10)),
                        ],
                      ),
                    ),
                    cell(_english, s.token.toTextStyle('Google Sans'), 260),
                    cell(_tamil, s.token.toTextStyle('Google Sans'), 300),
                    cell(_sinhala, s.token.toTextStyle('Google Sans'), 300),
                    cell(_properties(s.token), meta, 280),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('type specimen sheet', (tester) async {
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_sheet());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/type_specimen.png'),
    );
  });
}
