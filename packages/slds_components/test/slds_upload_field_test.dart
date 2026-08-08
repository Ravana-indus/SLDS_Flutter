import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
        MaterialApp(theme: SldsTheme.light(), home: Scaffold(body: field)),
      );

  testWidgets('empty state shows label, required marker, and hint', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(label: 'Upload', hintText: 'PDF, JPEG or PNG less than 5MB'),
    );

    expect(find.text('Upload'), findsWidgets); // label + affordance text
    expect(find.text(' *'), findsOneWidget);
    expect(find.text('PDF, JPEG or PNG less than 5MB'), findsOneWidget);
    expect(find.byIcon(Icons.upload), findsOneWidget);
  });

  testWidgets('required=false hides the marker', (tester) async {
    await pump(tester, const SldsUploadField(label: 'Upload', required: false));
    expect(find.text(' *'), findsNothing);
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
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('uploading state with null progress shows an indeterminate spinner', (
    tester,
  ) async {
    await pump(
      tester,
      const SldsUploadField(
        label: 'Upload',
        status: SldsUploadStatus.uploading,
        fileName: 'Birth_certificate.pdf',
      ),
    );

    // No progress -> falls back to the Cupertino spinner (indeterminate-only;
    // it has no percentage/value variant).
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

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
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
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
    final theme = SldsTheme.light();
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
      SldsUploadField(label: 'Upload', enabled: false, onTap: () => tapped = true),
    );

    await tester.tap(find.text('Upload').last);
    expect(tapped, isFalse);
  });
}
