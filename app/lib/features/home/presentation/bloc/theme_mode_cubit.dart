import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/toggle_theme_mode.dart';

/// Presentation-layer state holder for the app's [ThemeMode].
///
/// A [Cubit] (not a full [Bloc]) because there's a single trigger with no
/// intermediate states — reach for `Bloc<Event, State>` when a feature has
/// multiple distinct events to react to.
class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(this._toggleThemeMode) : super(ThemeMode.light);

  final ToggleThemeMode _toggleThemeMode;

  void toggle() => emit(_toggleThemeMode(state));
}
