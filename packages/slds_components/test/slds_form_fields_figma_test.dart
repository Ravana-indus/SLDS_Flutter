import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

/// Form fields checked against the live Figma Input page (#70-#86).
void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light,
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: SizedBox(width: 361, child: field)),
      ),
    ),
  );

  TextStyle painted(WidgetTester tester, String text) =>
      tester.renderObject<RenderParagraph>(find.text(text)).text.style!;

  BoxDecoration fieldBox(WidgetTester tester, Type field) => tester
      .widgetList<Container>(
        find.descendant(
          of: find.byType(field),
          matching: find.byType(Container),
        ),
      )
      .map((c) => c.decoration)
      .whereType<BoxDecoration>()
      .firstWhere((d) => d.border != null);

  /// The effective style of [text] inside a painted paragraph, merging the
  /// styles down the span tree (Text.rich puts the label in a child span).
  TextStyle spanStyle(WidgetTester tester, String text) {
    final root = tester
        .renderObject<RenderParagraph>(
          find
              .descendant(
                of: find.textContaining(text).first,
                matching: find.byType(RichText),
              )
              .first,
        )
        .text;
    TextStyle? found;
    void visit(InlineSpan span, TextStyle inherited) {
      final style = inherited.merge(span.style);
      if (span is TextSpan) {
        if (span.text == text) found = style;
        span.children?.forEach((c) => visit(c, style));
      }
    }

    visit(root, const TextStyle());
    return found!;
  }

  const label = Color(0xFF17171A); // Figma label, Mobile/Body 2
  const help = Color(0xFF676767); // Figma Help Text, Mobile/Caption 1
  const white = Color(0xFFFFFFFF);

  testWidgets('labels are 14/18 #17171A and help text #676767 '
      '(#75, #76, #78, #79, #81, #84)', (tester) async {
    final fields = <Widget>[
      const SldsInputMask(label: 'Mask', helperText: 'Help Mask'),
      const SldsMobileNumberInput(label: 'Mobile', helperText: 'Help Mobile'),
      const SldsTextArea(label: 'Area', helpText: 'Help Area'),
      const SldsTextField(label: 'Field', helpText: 'Help Field'),
      const SldsInput(label: 'Input', helperText: 'Help Input'),
    ];
    final names = ['Mask', 'Mobile', 'Area', 'Field', 'Input'];
    for (var i = 0; i < fields.length; i++) {
      await pump(tester, fields[i]);
      final style = spanStyle(tester, names[i]);
      expect(style.fontSize, 14, reason: '${names[i]} label size');
      // Every label renders on the same 18px line box, so the label-to-field
      // spacing is consistent (#81).
      expect(
        tester.getSize(find.textContaining(names[i]).first).height,
        18,
        reason: '${names[i]} label line height',
      );
      expect(style.color, label, reason: '${names[i]} label colour');
      expect(
        painted(tester, 'Help ${names[i]}').color,
        help,
        reason: '${names[i]} help text',
      );
    }
  });

  testWidgets('disabled fields stay white (#70, #73, #80)', (tester) async {
    await pump(tester, const SldsInput(label: 'Input', enabled: false));
    expect(fieldBox(tester, SldsInput).color, white);
    await pump(tester, const SldsInputMask(label: 'Mask', enabled: false));
    expect(fieldBox(tester, SldsInputMask).color, white);
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile', enabled: false),
    );
    expect(fieldBox(tester, SldsMobileNumberInput).color, white);
  });

  testWidgets('input mask: 12px radius and full-height dividers (#71, #72)', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsInputMask(
        label: 'Mask',
        prefixText: 'http://',
        suffixText: '.com',
      ),
    );
    final box = fieldBox(tester, SldsInputMask);
    expect(box.borderRadius, BorderRadius.circular(12));
    // The prefix cell (and its divider) spans the field's inner height:
    // the 52px field less its 1px top and bottom border.
    final cell = tester.getRect(
      find
          .ancestor(of: find.text('http://'), matching: find.byType(Container))
          .first,
    );
    expect(cell.height, 50);
  });

  testWidgets('value lines up with the prefix (#74, #77)', (tester) async {
    await pump(
      tester,
      SldsInputMask(
        label: 'Mask',
        prefixText: 'http://',
        controller: TextEditingController(text: 'slds'),
      ),
    );
    expect(
      tester.getRect(find.byType(EditableText)).center.dy,
      tester.getRect(find.text('http://')).center.dy,
    );
    await pump(
      tester,
      SldsMobileNumberInput(
        label: 'Mobile',
        controller: TextEditingController(text: '712345678'),
      ),
    );
    expect(
      tester.getRect(find.byType(EditableText)).center.dy,
      tester.getRect(find.text('+94')).center.dy,
    );
    // Figma: 10px gap + 8px padding between the prefix and the value.
    expect(
      tester.getRect(find.byType(EditableText)).left -
          tester.getRect(find.byIcon(Icons.keyboard_arrow_down)).right,
      closeTo(18 + 2, 0.5), // + the 16px caret's 2px inset in its 20px box
    );
  });

  testWidgets('mobile number error shows the red XCircle (#82)', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsMobileNumberInput(label: 'Mobile', errorText: 'Error Text'),
    );
    expect(find.text('Error Text'), findsOneWidget);
    final icon = tester.widget<Icon>(find.byIcon(Icons.cancel));
    expect(icon.color, const Color(0xFFD32F2F));
    expect(icon.size, 20);
  });

  testWidgets('text area: 128px box, Figma placeholder, counter inside '
      '(#83, #85, #86)', (tester) async {
    await pump(
      tester,
      const SldsTextArea(label: 'Description', hintText: 'Placeholder'),
    );
    final box = tester.getRect(
      find
          .descendant(
            of: find.byType(SldsTextArea),
            matching: find.byType(Stack),
          )
          .first,
    );
    expect(box.height, 128);
    final hint = painted(tester, 'Placeholder');
    expect(hint.fontSize, 16);
    expect(hint.color, const Color(0xFFBCBCBC));
    final counter = tester.getRect(find.text('0/300'));
    expect(
      box.contains(counter.topLeft) && box.contains(counter.bottomRight),
      isTrue,
    );
  });

  testWidgets('input value sits 22px from its prefix and suffix (#67)', (
    tester,
  ) async {
    await pump(
      tester,
      SldsInput(
        label: 'Input',
        prefixText: 'LKR',
        suffixText: 'KG',
        controller: TextEditingController(text: '1250'),
      ),
    );
    final value = tester.getRect(find.byType(EditableText));
    // Figma: the affix's 4px pad + 10px gap + the value's 8px pad.
    expect(value.left - tester.getRect(find.text('LKR')).right, 22);
    expect(tester.getRect(find.text('KG')).left - value.right, 22);
    expect(value.center.dy, tester.getRect(find.text('LKR')).center.dy);
  });

  testWidgets('required marker sits right after the label, as Figma', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsTextArea(label: 'Description', isRequired: true),
    );
    expect(find.text('Description*'), findsOneWidget);
    await pump(tester, const SldsTextField(label: 'Email', isRequired: true));
    expect(find.text('Email*'), findsOneWidget);
  });

  testWidgets('mobile number clear button: Figma grey X that empties the '
      'field', (tester) async {
    final controller = TextEditingController(text: '712345678');
    var cleared = false;
    await pump(
      tester,
      SldsMobileNumberInput(
        label: 'Mobile',
        controller: controller,
        onClear: () => cleared = true,
      ),
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.close));
    expect(icon.color, const Color(0xFF898989));
    expect(icon.size, 20);
    expect(find.bySemanticsLabel('Clear'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    expect(controller.text, isEmpty);
    expect(cleared, isTrue);

    await pump(
      tester,
      SldsMobileNumberInput(label: 'Mobile', enabled: false, onClear: () {}),
    );
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('input mask, dropdown and combo box share the 12px radius '
      '(#89)', (tester) async {
    final fields = <Type, Widget>{
      SldsInputMask: const SldsInputMask(label: 'Mask'),
      SldsDropdown<String>: SldsDropdown<String>(
        label: 'Dropdown',
        items: const ['Colombo'],
        itemLabel: (v) => v,
        onChanged: (_) {},
      ),
      SldsComboBox: SldsComboBox(
        label: 'Combo',
        placeholder: 'Select',
        options: const ['Colombo'],
        selectedValues: const [],
        onSelectionChanged: (_) {},
      ),
    };
    for (final entry in fields.entries) {
      await pump(tester, entry.value);
      expect(
        fieldBox(tester, entry.key).borderRadius,
        BorderRadius.circular(12),
        reason: '${entry.key} field radius (Figma radius-2xl)',
      );
    }
  });

  testWidgets('help text sits 6px below every field (#91)', (tester) async {
    final fields = <Type, Widget>{
      SldsInput: const SldsInput(label: 'L', helperText: 'Help'),
      SldsInputMask: const SldsInputMask(label: 'L', helperText: 'Help'),
      SldsMobileNumberInput: const SldsMobileNumberInput(
        label: 'L',
        helperText: 'Help',
      ),
      SldsDropdown<String>: SldsDropdown<String>(
        label: 'L',
        helpText: 'Help',
        items: const ['Colombo'],
        itemLabel: (v) => v,
        onChanged: (_) {},
      ),
      SldsComboBox: SldsComboBox(
        label: 'L',
        helperText: 'Help',
        placeholder: 'Select',
        options: const ['Colombo'],
        selectedValues: const [],
        onSelectionChanged: (_) {},
      ),
    };
    for (final entry in fields.entries) {
      await pump(tester, entry.value);
      // The bordered field box is the widest Container with a border.
      final field = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(entry.key),
              matching: find.byType(Container),
            ),
          )
          .where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration! as BoxDecoration).border != null,
          )
          .first;
      final fieldBottom = tester.getRect(find.byWidget(field)).bottom;
      expect(
        tester.getRect(find.text('Help')).top - fieldBottom,
        6,
        reason: '${entry.key} field-to-help gap',
      );
    }
  });

  testWidgets('combo box chips sit 12px in and 10px apart (#90)', (
    tester,
  ) async {
    await pump(
      tester,
      SldsComboBox(
        label: 'District',
        placeholder: 'Select',
        options: const ['Colombo', 'Jaffna'],
        selectedValues: const ['Colombo', 'Jaffna'],
        multiple: true,
        onSelectionChanged: (_) {},
      ),
    );
    Rect chip(String value) => tester.getRect(
      find
          .ancestor(of: find.text(value), matching: find.byType(Container))
          .first,
    );
    final field = fieldBox(tester, SldsComboBox);
    expect(field.borderRadius, BorderRadius.circular(12));
    final fieldRect = tester.getRect(
      find
          .descendant(
            of: find.byType(SldsComboBox),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Container &&
                  w.decoration is BoxDecoration &&
                  (w.decoration! as BoxDecoration).border != null,
            ),
          )
          .first,
    );
    // Figma: 4px content padding + 8px chip-row padding, inside the 1px
    // border (Flutter insets content by its border; Figma's inside stroke
    // overlaps the padding) — the same inset as the placeholder text.
    expect(chip('Colombo').left - fieldRect.left, 1 + 4 + 8);
    expect(chip('Jaffna').left - chip('Colombo').right, 10);
  });

  testWidgets('combo box open state matches Figma (#92-#98, #100)', (
    tester,
  ) async {
    await pump(
      tester,
      SldsComboBox(
        label: 'District',
        helperText: 'Help Combo',
        placeholder: 'Select district',
        options: const ['Batticaloa', 'Colombo'],
        selectedValues: const ['Colombo'],
        multiple: true,
        visualState: SldsComboBoxState.filling,
        onSelectionChanged: (_) {},
      ),
    );
    // #93, #94: Mobile/Body 2 #17171A label, #676767 help text.
    final labelStyle = spanStyle(tester, 'District');
    expect(labelStyle.fontSize, 14);
    expect(labelStyle.color, label);
    expect(painted(tester, 'Help Combo').color, help);

    // #95: the field keeps its default 1px #BCBCBC border, no focus glow.
    final field = fieldBox(tester, SldsComboBox);
    expect(field.border!.top.color, const Color(0xFFBCBCBC));
    expect(field.border!.top.width, 1);
    expect(field.boxShadow, isNull);

    // #92: a grey CaretDown even while open.
    final caret = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_down));
    expect(caret.color, const Color(0xFF898989));
    expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

    // #100: panel #F7F7F7, #DDDDDD 1px, radius 16, Elevation/3 shadow.
    final panel = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((d) => d.borderRadius == BorderRadius.circular(16));
    expect(panel.color, const Color(0xFFF7F7F7));
    expect(panel.border!.top.color, const Color(0xFFDDDDDD));
    expect(panel.border!.top.width, 1);
    final shadow = panel.boxShadow!.single;
    expect(shadow.offset, const Offset(0, 10));
    expect(shadow.blurRadius, 15);
    expect(shadow.spreadRadius, -3);

    // #96: search bar 44px, #DDDDDD 1.5px, icon and text on one centre line.
    final search = tester.getRect(
      find
          .ancestor(
            of: find.byIcon(Icons.search),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(search.height, 44);
    expect(
      tester.getRect(find.byType(EditableText)).center.dy,
      closeTo(tester.getRect(find.byIcon(Icons.search)).center.dy, 0.5),
    );

    // #97, #98: 16px box 8px from Desktop/Body 2 #17171A text.
    final rowText = find.text('Batticaloa');
    final checkbox = find.descendant(
      of: find.ancestor(of: rowText, matching: find.byType(InkWell)),
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 16,
      ),
    );
    expect(tester.getSize(checkbox), const Size(16, 16));
    expect(
      tester.getRect(rowText).left - tester.getRect(checkbox).right,
      8,
    );
    final rowStyle = painted(tester, 'Batticaloa');
    expect(rowStyle.fontSize, 14);
    expect(rowStyle.fontSize! * rowStyle.height!, closeTo(22, 0.01));
    expect(rowStyle.color, label);
  });
}
