import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slds_components/slds_components.dart';

import 'features/home/domain/toggle_theme_mode.dart';
import 'features/home/presentation/bloc/theme_mode_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const SldsApp());
}

class SldsApp extends StatelessWidget {
  const SldsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Plain constructor injection — reach for get_it/provider-based DI once
    // there are enough features/dependencies that wiring them by hand here
    // gets unwieldy.
    return BlocProvider(
      create: (_) => ThemeModeCubit(ToggleThemeMode()),
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            title: 'SLDS App',
            theme: SldsTheme.light(),
            darkTheme: SldsTheme.dark(),
            themeMode: mode,
            localizationsDelegates: SldsLocalizations.localizationsDelegates,
            supportedLocales: SldsLocalizations.supportedLocales,
            builder: (context, child) => SldsResponsiveText(child: child!),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
