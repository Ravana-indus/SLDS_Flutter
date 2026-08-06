import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

final _lightTheme = WidgetbookTheme(name: 'Light', data: SldsTheme.light());
final _darkTheme = WidgetbookTheme(name: 'Dark', data: SldsTheme.dark());

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [_lightTheme, _darkTheme],
          initialTheme: _lightTheme, // Widgetbook defaults to light, not dark
        ),
        LocalizationAddon(
          locales: SldsLocalizations.supportedLocales,
          localizationsDelegates: SldsLocalizations.localizationsDelegates,
        ),
      ],
    );
  }
}
