import 'package:flutter/material.dart';

/// Domain use case: decide the next [ThemeMode] when the user toggles it.
///
/// A single `if` doesn't need a repository or a data source — this is here
/// to show *where* real business rules (e.g. "load the saved preference
/// from a repository") would go once there's a persistence requirement.
class ToggleThemeMode {
  ThemeMode call(ThemeMode current) {
    return current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
