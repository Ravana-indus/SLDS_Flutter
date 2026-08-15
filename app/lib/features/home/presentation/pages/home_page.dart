import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slds_components/slds_components.dart';

import '../bloc/theme_mode_cubit.dart';

/// Example screen showing how a feature composes SLDS components with a
/// bloc for state. Not a real feature — replace with your first one.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SLDS App')),
      // SldsPullToRefresh lays child out in a sliver, so it doesn't need to
      // be scrollable-height itself. Real features wire onRefresh to a use
      // case re-fetch; this demo has no data to fetch, so it just waits.
      body: SldsPullToRefresh(
        onRefresh: () =>
            Future<void>.delayed(const Duration(milliseconds: 600)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.slds.dimensions.space16),
            child: SldsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SLDS component library is wired up.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.slds.dimensions.space12),
                  BlocBuilder<ThemeModeCubit, ThemeMode>(
                    builder: (context, mode) {
                      return SldsButton(
                        label: mode == ThemeMode.light
                            ? 'Switch to dark'
                            : 'Switch to light',
                        onPressed: () =>
                            context.read<ThemeModeCubit>().toggle(),
                        variant: SldsButtonVariant.primary,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
