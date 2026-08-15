/// Raw design tokens for SLDS — Sri Lanka's government design system,
/// maintained by GovTech Sri Lanka.
///
/// This package holds values only, with no Flutter or `dart:ui` dependency, so
/// it can be consumed by codegen, web exports and design tooling as well as by
/// the Flutter widget library. Colours are 32-bit ARGB ints and text styles are
/// raw metrics; `slds_components` materialises both into `Color` and
/// `TextStyle`.
library;

export 'src/colors.dart';
export 'src/contrast.dart';
export 'src/dimensions.dart';
export 'src/motion.dart';
export 'src/opacities.dart';
export 'src/token_set.dart';
export 'src/typography.dart';
