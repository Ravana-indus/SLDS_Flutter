import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tokens/slds_colors.dart';
import '../tokens/slds_spacing.dart';
import 'slds_text_field.dart';

/// SLDS phone number input — a country-code prefix (🇱🇰 +94 by default)
/// ahead of a live-formatted 9-digit mobile number (`77 123 4567`), a
/// clear button, and the same label/required/help/error/disabled chrome
/// as [SldsTextField]. This package ships no country *picker* — for a
/// different country, override the prefix:
///
/// ```dart
/// // Your own app's asset, declared in *your* pubspec.yaml's `assets:`:
/// SldsPhoneField(
///   countryFlag: '🇮🇳',                        // emoji fallback
///   countryFlagAsset: 'assets/flags/india.png', // svg or raster (png/jpg/webp)
///   countryFlagAssetIsPackaged: false,          // it's your app's asset, not this package's
///   countryCode: '+91',
/// )
/// ```
class SldsPhoneField extends StatefulWidget {
  const SldsPhoneField({
    super.key,
    this.label = 'Mobile Number',
    this.controller,
    this.isRequired = false,
    this.helpText,
    this.errorText,
    this.showValid = false,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.color,
    this.countryFlag = '🇱🇰',
    this.countryFlagAsset = 'assets/flags/sri_lanka.svg',
    this.countryFlagAssetIsPackaged = true,
    this.countryCode = '+94',
  });

  final String label;
  final TextEditingController? controller;
  final bool isRequired;
  final String? helpText;
  final String? errorText;

  /// Shows a green checkmark trailing icon instead of the clear button —
  /// set once the caller has validated the number (e.g. after OTP verify).
  final bool showValid;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  /// Overrides the token-driven focus/accent color for this instance only.
  final Color? color;

  /// Flag emoji shown before the dial code, used as a fallback while
  /// [countryFlagAsset] is unset or fails to load. Defaults to Sri Lanka.
  final String countryFlag;

  /// Asset path to a flag icon (SVG or raster — PNG/JPG/WebP), rendered
  /// instead of the [countryFlag] emoji for a platform-consistent look.
  /// Defaults to the flag bundled inside `slds_components`; pass your own
  /// app's asset path (declared in *your* `pubspec.yaml`, not this
  /// package's) for a different country, or null to use the emoji.
  final String? countryFlagAsset;

  /// Whether [countryFlagAsset] lives in this package's own asset bundle
  /// (the default Sri Lanka flag) rather than the consuming app's. Set to
  /// false when pointing [countryFlagAsset] at an asset your own app
  /// declared.
  final bool countryFlagAssetIsPackaged;

  /// Dial code shown after the flag, e.g. `+94`. Defaults to Sri Lanka.
  /// If you need a country *picker*, build one in your app and drive this
  /// field's [controller]/formatting yourself — this component only
  /// renders a fixed prefix.
  final String countryCode;

  @override
  State<SldsPhoneField> createState() => _SldsPhoneFieldState();
}

class _SldsPhoneFieldState extends State<SldsPhoneField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final bool _ownsController = widget.controller == null;

  @override
  void initState() {
    super.initState();
    // Rebuild so the clear (×) icon appears/disappears as the user types —
    // TextFormField manages its own keystrokes internally otherwise.
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SldsTextField(
      label: widget.label,
      controller: _controller,
      isRequired: widget.isRequired,
      helpText: widget.helpText,
      errorText: widget.errorText,
      hintText: '77 123 4567',
      enabled: widget.enabled,
      keyboardType: TextInputType.phone,
      onChanged: widget.onChanged,
      validator: widget.validator,
      color: widget.color,
      leadingWidget: _CountryCodePrefix(
        flag: widget.countryFlag,
        code: widget.countryCode,
        flagAsset: widget.countryFlagAsset,
        flagAssetPackage: widget.countryFlagAssetIsPackaged
            ? 'slds_components'
            : null,
        hasError: _hasError,
        enabled: widget.enabled,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
        const _SriLankaMobileFormatter(),
      ],
      trailingIcon: widget.enabled
          ? (widget.showValid
                ? Icons.check_circle
                : (_controller.text.isNotEmpty ? Icons.close : null))
          : null,
      trailingIconColor: widget.showValid
          ? Colors.green
          : (_hasError ? scheme.error : scheme.onSurface),
      onTrailingIconPressed: widget.showValid
          ? null
          : () {
              _controller.clear(); // triggers _onTextChanged to rebuild
              widget.onChanged?.call('');
            },
    );
  }
}

class _CountryCodePrefix extends StatelessWidget {
  const _CountryCodePrefix({
    required this.flag,
    required this.code,
    this.flagAsset,
    this.flagAssetPackage,
    this.hasError = false,
    this.enabled = true,
  });

  final String flag;
  final String? flagAsset;

  /// Passed as [SvgPicture.asset]/[Image.asset]'s `package:` — set only
  /// when [flagAsset] lives inside `slds_components`'s own bundle; leave
  /// null for an asset the consuming app declared in its own pubspec.
  final String? flagAssetPackage;
  final String code;
  final bool hasError;
  final bool enabled;

  Widget _buildFlag() {
    final fallback = Text(flag, style: const TextStyle(fontSize: 16));
    final path = flagAsset;
    if (path == null) return fallback;

    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        package: flagAssetPackage,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return Image.asset(
      path,
      package: flagAssetPackage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color contentColor;
    if (!enabled) {
      contentColor = scheme.onSurface.withValues(
        alpha: SldsColors.disabledOpacity,
      );
    } else if (hasError) {
      contentColor = scheme.error;
    } else {
      contentColor = scheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.only(right: SldsSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 21×15 matches the bundled SVG's native viewBox exactly so
          // BoxFit.contain has nothing to crop/stretch — ClipRRect keeps
          // corners clean without distorting the flag's own aspect ratio.
          Opacity(
            opacity: enabled ? 1 : SldsColors.disabledOpacity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(width: 21, height: 15, child: _buildFlag()),
            ),
          ),
          const SizedBox(width: SldsSpacing.xs),
          Text(
            code,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: contentColor),
          ),
          const SizedBox(width: 2),
          // Decorative only — this package has no country picker (see class
          // doc); it just matches the reference design's affordance.
          Icon(Icons.keyboard_arrow_down, size: 18, color: contentColor),
        ],
      ),
    );
  }
}

/// Groups a 9-digit Sri Lankan mobile number as `77 123 4567` while typing.
class _SriLankaMobileFormatter extends TextInputFormatter {
  const _SriLankaMobileFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
