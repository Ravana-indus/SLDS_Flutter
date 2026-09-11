import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_app/features/gallery/presentation/pages/gallery_page.dart';
import 'package:slds_app/features/home/domain/toggle_theme_mode.dart';
import 'package:slds_app/features/home/presentation/bloc/theme_mode_cubit.dart';
import 'package:slds_components/slds_components.dart';

Widget _app() => BlocProvider(
  create: (_) => ThemeModeCubit(ToggleThemeMode()),
  child: MaterialApp(
    theme: SldsTheme.light,
    localizationsDelegates: SldsLocalizations.localizationsDelegates,
    supportedLocales: SldsLocalizations.supportedLocales,
    home: const GalleryPage(),
  ),
);

/// Scrolls the gallery's own ListView to [offset].
///
/// Not `tester.drag`: sections mount their own scrollables (search bar,
/// combo box, date picker), so a re-resolved `byType(Scrollable).first`
/// stops addressing the page list. Hold the state once and set the offset.
Future<void> _scrollTo(WidgetTester t, ScrollableState s, double offset) async {
  s.position.jumpTo(offset.clamp(0.0, s.position.maxScrollExtent));
  await t.pump(const Duration(milliseconds: 50));
}

void main() {
  // pumpAndSettle is unusable here: the loading SldsButton renders a
  // CupertinoActivityIndicator, which never stops animating.
  testWidgets('every gallery section builds without throwing', (t) async {
    await t.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => t.binding.setSurfaceSize(null));

    await t.pumpWidget(_app());
    await t.pump(const Duration(milliseconds: 300));
    expect(find.text('SldsButton'), findsOneWidget);

    // Walk the whole list. A section that throws on build fails the pump.
    final s = t.state<ScrollableState>(find.byType(Scrollable).first);
    for (var o = 0.0; o < s.position.maxScrollExtent + 500; o += 500) {
      await _scrollTo(t, s, o);
    }
    expect(find.text('SldsPullToRefresh'), findsOneWidget);
  });

  testWidgets('overlays open', (t) async {
    await t.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => t.binding.setSurfaceSize(null));

    await t.pumpWidget(_app());
    await t.pump(const Duration(milliseconds: 300));

    final s = t.state<ScrollableState>(find.byType(Scrollable).first);
    for (var o = 0.0; o < s.position.maxScrollExtent + 500; o += 400) {
      await _scrollTo(t, s, o);
      if (find.text('Dialog').evaluate().isNotEmpty) break;
    }
    expect(find.text('Dialog'), findsOneWidget);

    await t.tap(find.text('Dialog'));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('Confirm submission'), findsOneWidget);
  });
}
