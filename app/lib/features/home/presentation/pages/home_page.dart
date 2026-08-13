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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(SldsSpacing.lg),
          child: SldsCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SLDS component library is wired up.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SldsSpacing.md),
                BlocBuilder<ThemeModeCubit, ThemeMode>(
                  builder: (context, mode) {
                    return SldsButton(
                      label: mode == ThemeMode.light
                          ? 'Switch to dark'
                          : 'Switch to light',
                      onPressed: () => context.read<ThemeModeCubit>().toggle(),
                      variant: SldsButtonVariant.primary,
                      
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
