import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: SldsLocalizations.localizationsDelegates,
      supportedLocales: SldsLocalizations.supportedLocales,
      theme: SldsTheme.light,
      home: Scaffold(body: field),
    ),
  );

  testWidgets('empty state shows label, required marker, and hint', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
      ),
    );

    expect(find.text('Upload'), findsWidgets); // label + affordance text
    expect(find.text('Upload*', findRichText: true), findsOneWidget);
    expect(find.text('PDF, JPEG or PNG less than 5MB'), findsOneWidget);
    expect(find.byIcon(Icons.file_upload_outlined), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(tester, const SldsUploadField(label: 'Upload', required: false));
    expect(find.text('Upload*', findRichText: true), findsNothing);
  });

  testWidgets('tapping empty state invokes onTap', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsUploadField(label: 'Upload', onTap: () => tapped = true),
    );

    await tester.tap(find.text('Upload').last);
    expect(tapped, isTrue);
  });

  testWidgets('uploading state shows the filename and a percent', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.uploading,
        fileName: 'Birth_certificate.pdf',
        progress: 0.72,
      ),
    );

    expect(find.text('Birth_certificate.pdf'), findsOneWidget);
    expect(find.text('72%'), findsOneWidget);
    // iOS-style spinner throughout — the percent is a text label, not an
    // arc drawn into the indicator (Cupertino has no determinate ring).
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets(
    'uploading state with null progress still shows the Cupertino spinner',
    (tester) async {
      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.uploading,
          fileName: 'Birth_certificate.pdf',
        ),
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    },
  );

  testWidgets('uploaded state shows a green check, filename, and "Uploaded"', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.uploaded,
        fileName: 'Birth_certificate.pdf',
      ),
    );

    expect(find.text('Birth_certificate.pdf'), findsOneWidget);
    expect(find.text('Uploaded'), findsOneWidget);
    final icon = tester.widget<Icon>(find.byIcon(Icons.check));
    expect(icon.color, SldsColorTokens.light().badgeSuccessText);
  });

  testWidgets('error state shows the error text and a close icon', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.error,
        fileName: 'Birth_certificate.pdf',
        errorText: 'File size is too big',
      ),
    );

    expect(find.text('File size is too big'), findsOneWidget);
    final theme = SldsTheme.light;
    final errorLabel = tester.widget<Text>(find.text('File size is too big'));
    expect(errorLabel.style?.color, SldsColorTokens.light().error);
    expect(theme, isNotNull); // sanity: theme still resolves
  });

  testWidgets('uploaded/error remove button calls onRemove', (tester) async {
    var removed = false;
    await pump(
      tester,
      SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.uploaded,
        fileName: 'Birth_certificate.pdf',
        onRemove: () => removed = true,
      ),
    );

    await tester.tap(find.byIcon(Icons.close));
    expect(removed, isTrue);
  });

  testWidgets('remove button is hidden when onRemove is null', (tester) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.uploaded,
        fileName: 'Birth_certificate.pdf',
      ),
    );
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('disabled field does not respond to taps', (tester) async {
    var tapped = false;
    await pump(
      tester,
      SldsUploadField(
        label: 'Upload',
        enabled: false,
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.text('Upload').last);
    expect(tapped, isFalse);
  });

  testWidgets(
    'custom emptyIcon and emptyWidget renders custom leading affordance',
    (tester) async {
      await pump(
        tester,
        const SldsUploadField(label: 'Upload', emptyIcon: Icons.cloud_upload),
      );
      expect(find.byIcon(Icons.cloud_upload), findsOneWidget);

      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          emptyWidget: Text('CUSTOM_EMPTY'),
        ),
      );
      expect(find.text('CUSTOM_EMPTY'), findsOneWidget);
    },
  );

  testWidgets(
    'custom uploadedIcon and uploadedWidget overrides uploaded status '
    'indicator',
    (tester) async {
      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.uploaded,
          fileName: 'Birth_certificate.pdf',
          uploadedIcon: Icons.check_circle_outline,
        ),
      );
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.uploaded,
          fileName: 'Birth_certificate.pdf',
          uploadedWidget: Text('CUSTOM_UPLOADED'),
        ),
      );
      expect(find.text('CUSTOM_UPLOADED'), findsOneWidget);
    },
  );

  testWidgets(
    'custom errorIcon and errorWidget overrides error status indicator',
    (tester) async {
      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.error,
          fileName: 'Birth_certificate.pdf',
          errorText: 'Invalid file',
          errorIcon: Icons.warning_amber,
        ),
      );
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);

      await pump(
        tester,
        const SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.error,
          fileName: 'Birth_certificate.pdf',
          errorText: 'Invalid file',
          errorWidget: Text('CUSTOM_ERROR'),
        ),
      );
      expect(find.text('CUSTOM_ERROR'), findsOneWidget);
    },
  );

  testWidgets(
    'custom removeIcon and removeWidget overrides remove action icon',
    (tester) async {
      await pump(
        tester,
        SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.uploaded,
          fileName: 'Birth_certificate.pdf',
          onRemove: () {},
          removeIcon: Icons.delete_outline,
        ),
      );
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await pump(
        tester,
        SldsUploadField(
          label: 'Upload',
          status: SldsUploadStatus.uploaded,
          fileName: 'Birth_certificate.pdf',
          onRemove: () {},
          removeWidget: const Text('REMOVE'),
        ),
      );
      expect(find.text('REMOVE'), findsOneWidget);
    },
  );

  testWidgets('empty state hint wraps instead of overflowing at 200%', (
    tester,
  ) async {
    // The empty row's text column lacked the Expanded its sibling rows have,
    // so at a doubled text scale the hint ran 88px past the field edge —
    // WCAG 1.4.4 requires it stay readable, not clip.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: SldsLocalizations.localizationsDelegates,
        supportedLocales: SldsLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: const Scaffold(
              body: SizedBox(
                width: 340,
                child: SldsUploadField(label: 'Proof of address'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  // Figma Upload (543:5715), all four states.
  testWidgets('text, icons and spacing match Figma (#171-#180)', (
    tester,
  ) async {
    Widget field(SldsUploadStatus status) => SldsUploadField(
      label: 'Upload',
      status: status,
      fileName: 'Birth_certificate.pdf',
      progress: 0.72,
      errorText: 'File size is too big',
      onTap: () {},
      onRemove: () {},
    );
    TextStyle style(String text) => tester.widget<Text>(find.text(text)).style!;
    Rect box() => tester.getRect(
      find
          .descendant(
            of: find.byType(SldsUploadField),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Container &&
                  w.decoration is BoxDecoration &&
                  (w.decoration! as BoxDecoration).border != null,
            ),
          )
          .first,
    );

    // Empty.
    await pump(tester, field(SldsUploadStatus.empty));
    expect(find.text('Upload*', findRichText: true), findsOneWidget); // #175
    final rich = tester.widget<RichText>(
      find.text('Upload*', findRichText: true),
    );
    // RichText wraps Text.rich's span in the ambient default style.
    final labelSpan = (rich.text as TextSpan).children!.first;
    expect(labelSpan.style!.color, const Color(0xFF17171A)); // #171
    final inner = style('Upload');
    expect(inner.color, const Color(0xFF676767)); // #172
    expect(inner.decoration, isNot(TextDecoration.underline));
    expect(
      style('PDF, JPEG or PNG less than 5MB').color,
      const Color(0xFF676767),
    ); // #173
    final helperTop = tester
        .getRect(find.text('PDF, JPEG or PNG less than 5MB'))
        .top;
    expect(helperTop - tester.getRect(find.text('Upload')).bottom, 6); // #174
    final uploadIcon = tester.getRect(find.byIcon(Icons.file_upload_outlined));
    expect(uploadIcon.size, const Size(24, 24));
    // The 48px icon button sits 8px inside the box's 1px border.
    expect(
      uploadIcon.center - box().topLeft,
      const Offset(1 + 8 + 24, 1 + 8 + 24),
    );

    // Uploading.
    await pump(tester, field(SldsUploadStatus.uploading));
    expect(
      style('Birth_certificate.pdf').color,
      const Color(0xFF17171A),
    ); // #176
    final spinner = find.byType(CupertinoActivityIndicator);
    expect(
      tester.widget<CupertinoActivityIndicator>(spinner).color,
      const Color(0xFF17171A),
    ); // #177
    expect(
      tester
              .getRect(
                find
                    .ancestor(of: spinner, matching: find.byType(SizedBox))
                    .first,
              )
              .topLeft -
          box().topLeft,
      const Offset(1 + 8, 1 + 8),
    );
    expect(style('72%').color, const Color(0xFF676767)); // #173

    // Uploaded.
    await pump(tester, field(SldsUploadStatus.uploaded));
    final check = tester.widget<Icon>(find.byIcon(Icons.check));
    expect(check.color, const Color(0xFF1FAA63)); // #178
    expect(check.size, 16);
    final badge = tester.getRect(
      find
          .ancestor(
            of: find.byIcon(Icons.check),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(badge.size, const Size(24, 24));
    expect(badge.topLeft - box().topLeft, const Offset(1 + 8, 1 + 8));
    expect(style('Uploaded').color, const Color(0xFF676767)); // #173
    final close = find.byType(IconButton);
    expect(
      tester.widget<IconButton>(close).color,
      const Color(0xFF898989),
    ); // #180

    // Error.
    await pump(tester, field(SldsUploadStatus.error));
    final cross = find.descendant(
      of: find
          .ancestor(
            of: find.text('Birth_certificate.pdf'),
            matching: find.byType(Row),
          )
          .last,
      matching: find.byIcon(Icons.close),
    );
    expect(tester.getSize(cross.first), const Size(16, 16)); // #179
    final errBadge = tester.getRect(
      find.ancestor(of: cross.first, matching: find.byType(Container)).first,
    );
    expect(errBadge.topLeft - box().topLeft, const Offset(1 + 8, 1 + 8));
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).color,
      const Color(0xFF898989),
    ); // #180
  });
}
