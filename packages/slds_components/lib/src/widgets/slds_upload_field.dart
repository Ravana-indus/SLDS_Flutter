import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/slds_tokens.dart';

/// Visual states for [SldsUploadField].
enum SldsUploadStatus {
  /// No file selected yet — shows the upload affordance and hint text.
  empty,

  /// A file is mid-transfer — shows the filename and [SldsUploadField.progress].
  uploading,

  /// The file finished uploading successfully.
  uploaded,

  /// The upload failed or was rejected — [SldsUploadField.errorText] explains why.
  error,
}

/// SLDS file-upload field — label (with required marker), and one of four
/// states driven entirely by the caller: [SldsUploadStatus.empty] (tap to
/// pick a file), [SldsUploadStatus.uploading] (filename + progress percent),
/// [SldsUploadStatus.uploaded] (filename + remove button), or
/// [SldsUploadStatus.error] (filename + reason + remove button).
///
/// This package has no file-picker or upload-transport dependency — wire
/// [onTap] to whatever picks a file in your app (`file_picker`, platform
/// channel, etc.) and drive [status]/[progress]/[errorText] yourself as the
/// transfer proceeds:
///
/// ```dart
/// SldsUploadField(
///   label: 'Upload',
///   status: myStatus,           // empty / uploading / uploaded / error
///   fileName: myFileName,
///   progress: myProgress,       // 0.0–1.0, only read while uploading
///   errorText: myError,
///   onTap: myStatus == SldsUploadStatus.empty ? pickFile : null,
///   onRemove: myStatus != SldsUploadStatus.empty ? clearFile : null,
/// )
/// ```
class SldsUploadField extends StatelessWidget {
  const SldsUploadField({
    super.key,
    required this.label,
    this.status = SldsUploadStatus.empty,
    this.required = true,
    this.hintText = 'PDF, JPEG or PNG less than 5MB',
    this.fileName,
    this.progress,
    this.errorText,
    this.onTap,
    this.onRemove,
    this.enabled = true,
    this.emptyIcon,
    this.emptyWidget,
    this.uploadedIcon,
    this.uploadedWidget,
    this.errorIcon,
    this.errorWidget,
    this.removeIcon,
    this.removeWidget,
  });

  /// Visible field label.
  final String label;

  /// Which of the four states to render.
  final SldsUploadStatus status;

  /// Whether to show the required marker beside [label].
  final bool required;

  /// Constraint hint shown under the "Upload" affordance while [status] is
  /// [SldsUploadStatus.empty] (e.g. accepted types/size limit).
  final String hintText;

  /// The selected file's display name — required for every status except
  /// [SldsUploadStatus.empty].
  final String? fileName;

  /// Upload progress in `[0.0, 1.0]`, shown as a percent while [status] is
  /// [SldsUploadStatus.uploading]. Null renders an indeterminate spinner.
  final double? progress;

  /// Failure reason shown while [status] is [SldsUploadStatus.error].
  final String? errorText;

  /// Invoked when the empty-state affordance is tapped — hook up your file
  /// picker here. Null (or [enabled] false) disables the tap.
  final VoidCallback? onTap;

  /// Invoked when the trailing × is tapped in the uploaded/error states.
  /// Null hides the button.
  final VoidCallback? onRemove;

  final bool enabled;

  /// Custom icon data for empty state.
  final IconData? emptyIcon;

  /// Custom widget override for empty state leading affordance.
  final Widget? emptyWidget;

  /// Custom icon data for uploaded badge.
  final IconData? uploadedIcon;

  /// Custom widget override for uploaded badge inside circular background.
  final Widget? uploadedWidget;

  /// Custom icon data for error badge.
  final IconData? errorIcon;

  /// Custom widget override for error badge inside circular background.
  final Widget? errorWidget;

  /// Custom icon data for remove button.
  final IconData? removeIcon;

  /// Custom widget override for remove button inside IconButton.
  final Widget? removeWidget;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final dimensions = tokens.dimensions;
    final interactive =
        enabled && status == SldsUploadStatus.empty && onTap != null;

    final leadingUploaded =
        uploadedWidget ??
        Icon(uploadedIcon ?? Icons.check, color: colors.success, size: 16);

    final leadingError =
        errorWidget ??
        Icon(errorIcon ?? Icons.close, color: colors.error, size: 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: tokens.typography.fieldLabel.copyWith(
                color: colors.inputLabel,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: tokens.typography.fieldLabel.copyWith(
                  color: colors.inputBorderError,
                ),
              ),
          ],
        ),
        SizedBox(height: dimensions.space4),
        InkWell(
          onTap: interactive ? onTap : null,
          borderRadius: BorderRadius.circular(dimensions.radius2xl),
          child: Container(
            constraints: BoxConstraints(
              minHeight: dimensions.buttonHeightExtraLarge,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.space12,
              vertical: dimensions.space12,
            ),
            decoration: BoxDecoration(
              color: enabled ? colors.surfaceCard : colors.disabledBackground,
              border: Border.all(color: colors.borderDefault),
              borderRadius: BorderRadius.circular(dimensions.radius2xl),
            ),
            child: switch (status) {
              SldsUploadStatus.empty => _EmptyRow(
                hintText: hintText,
                enabled: enabled,
                icon: emptyIcon,
                customWidget: emptyWidget,
              ),
              SldsUploadStatus.uploading => _UploadingRow(
                fileName: fileName ?? '',
                progress: progress,
              ),
              SldsUploadStatus.uploaded => _ResultRow(
                fileName: fileName ?? '',
                leading: leadingUploaded,
                leadingBackground: colors.badgeSuccessBackground,
                caption: 'Uploaded',
                captionColor: colors.inputHelper,
                onRemove: onRemove,
                removeIcon: removeIcon,
                removeWidget: removeWidget,
              ),
              SldsUploadStatus.error => _ResultRow(
                fileName: fileName ?? '',
                leading: leadingError,
                leadingBackground: colors.badgeErrorBackground,
                caption: errorText,
                captionColor: colors.error,
                onRemove: onRemove,
                removeIcon: removeIcon,
                removeWidget: removeWidget,
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({
    required this.hintText,
    required this.enabled,
    this.icon,
    this.customWidget,
  });

  final String hintText;
  final bool enabled;
  final IconData? icon;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;
    final iconColor = enabled ? colors.textPrimary : colors.disabledForeground;

    final leadingChild =
        customWidget ??
        Icon(
          icon ?? Icons.file_upload_outlined,
          size: tokens.dimensions.avatarIconMedium,
          color: iconColor,
        );

    return Row(
      children: [
        Container(
          width: tokens.dimensions.avatarSize40,
          height: tokens.dimensions.avatarSize40,
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderDefault),
            borderRadius: BorderRadius.circular(tokens.dimensions.radiusLg),
          ),
          child: Center(child: leadingChild),
        ),
        SizedBox(width: tokens.dimensions.space12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload',
              style: tokens.typography.body1.copyWith(
                color: iconColor,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              hintText,
              style: tokens.typography.caption1.copyWith(
                color: colors.inputHelper,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UploadingRow extends StatelessWidget {
  const _UploadingRow({required this.fileName, required this.progress});

  final String fileName;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    return Row(
      children: [
        SizedBox(
          width: tokens.dimensions.avatarSize40,
          height: tokens.dimensions.avatarSize40,
          // iOS-style spinner throughout — Cupertino has no determinate/
          // percentage ring, so the percent is shown as text below instead
          // of drawn into the indicator itself (matches the design: the
          // ring never actually renders "72%" as an arc, only as a label).
          child: Center(
            child: CupertinoActivityIndicator(color: colors.inputBorderFocused),
          ),
        ),
        SizedBox(width: tokens.dimensions.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.body1.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                progress != null
                    ? '${(progress! * 100).round()}%'
                    : 'Uploading…',
                style: tokens.typography.caption1.copyWith(
                  color: colors.inputHelper,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.fileName,
    required this.leading,
    required this.leadingBackground,
    required this.caption,
    required this.captionColor,
    required this.onRemove,
    this.removeIcon,
    this.removeWidget,
  });

  final String fileName;
  final Widget leading;
  final Color leadingBackground;
  final String? caption;
  final Color captionColor;
  final VoidCallback? onRemove;
  final IconData? removeIcon;
  final Widget? removeWidget;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    final colors = tokens.colors;

    final trailingWidget = removeWidget ?? Icon(removeIcon ?? Icons.close);

    return Row(
      children: [
        Container(
          width: tokens.dimensions.avatarSize40,
          height: tokens.dimensions.avatarSize40,
          decoration: BoxDecoration(
            color: leadingBackground,
            shape: BoxShape.circle,
          ),
          child: Center(child: leading),
        ),
        SizedBox(width: tokens.dimensions.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.body1.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (caption != null)
                Text(
                  caption!,
                  style: tokens.typography.caption1.copyWith(
                    color: captionColor,
                  ),
                ),
            ],
          ),
        ),
        if (onRemove != null) ...[
          SizedBox(width: tokens.dimensions.space8),
          IconButton(
            onPressed: onRemove,
            icon: trailingWidget,
            iconSize: tokens.dimensions.avatarIconMedium,
            color: colors.inputIcon,
            constraints: BoxConstraints.tightFor(
              width: tokens.dimensions.iconButtonMedium,
              height: tokens.dimensions.iconButtonMedium,
            ),
            style: IconButton.styleFrom(
              side: BorderSide(color: colors.borderDefault),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.dimensions.radiusLg),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
