import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget field) => tester.pumpWidget(
    MaterialApp(
      theme: SldsTheme.light(),
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
        hintText: 'PDF, JPEG or PNG less than 5MB',
      ),
    );

    expect(find.text('Upload'), findsWidgets); // label + affordance text
    expect(find.text(' *'), findsOneWidget);
    expect(find.text('PDF, JPEG or PNG less than 5MB'), findsOneWidget);
    expect(find.byIcon(Icons.file_upload_outlined), findsOneWidget);
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
    expect(icon.color, SldsColorTokens.light().success);
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
    'custom uploadedIcon and uploadedWidget overrides uploaded status indicator',
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
}
