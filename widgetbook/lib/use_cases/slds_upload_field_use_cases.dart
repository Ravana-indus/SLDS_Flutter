import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Playground',
  type: SldsUploadField,
  path: '[Forms & Inputs]',
)
Widget buildSldsUploadFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Upload');
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final useCustomIcons = context.knobs.boolean(
    label: 'Custom Icons',
    initialValue: false,
  );
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: SldsUploadStatus.values,
    labelBuilder: (s) => s.name,
    initialOption: SldsUploadStatus.empty,
  );
  final progress = context.knobs.double.slider(
    label: 'Progress',
    initialValue: 0.72,
    min: 0,
    max: 1,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: SldsUploadField(
      label: label,
      required: isRequired,
      enabled: isEnabled,
      status: status,
      fileName: 'Birth_certificate.pdf',
      progress: progress,
      errorText: 'File size is too big',
      emptyIcon: useCustomIcons ? Icons.cloud_upload : null,
      uploadedIcon: useCustomIcons ? Icons.verified : null,
      errorIcon: useCustomIcons ? Icons.error_outline : null,
      removeIcon: useCustomIcons ? Icons.delete_outline : null,
      onTap: () {},
      onRemove: () {},
    ),
  );
}
