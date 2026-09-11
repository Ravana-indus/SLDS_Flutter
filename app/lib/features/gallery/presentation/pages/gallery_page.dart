import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slds_components/slds_components.dart';

import '../../../home/presentation/bloc/theme_mode_cubit.dart';

/// Manual test gallery — every exported SLDS component on a device.
///
/// Widgetbook already covers knob-driven inspection on desktop; this exists
/// so the same components can be poked on a real phone (touch targets,
/// keyboards, overlays, screen readers). One entry per component, each
/// rendered live in a scrollable section.
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final space = context.slds.dimensions.space16;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLDS Gallery'),
        actions: [
          BlocBuilder<ThemeModeCubit, ThemeMode>(
            builder: (context, mode) => IconButton(
              tooltip: mode == ThemeMode.light ? 'Dark theme' : 'Light theme',
              icon: Icon(
                mode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              onPressed: () => context.read<ThemeModeCubit>().toggle(),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(space),
        children: [
          for (final entry in _sections)
            Padding(
              padding: EdgeInsets.only(bottom: space),
              child: _Section(title: entry.$1, child: entry.$2),
            ),
        ],
      ),
    );
  }
}

/// One labelled component block.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.slds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: tokens.dimensions.space8),
        child,
        SizedBox(height: tokens.dimensions.space8),
        const SldsDivider(),
      ],
    );
  }
}

/// Wraps a stateless demo that needs local state (selection, text, toggles).
class _Stateful extends StatefulWidget {
  const _Stateful(this.builder);

  final Widget Function(BuildContext, void Function(VoidCallback)) builder;

  @override
  State<_Stateful> createState() => _StatefulState();
}

class _StatefulState extends State<_Stateful> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}

// Mutable demo state, kept module-level so the list below stays declarative.
// ponytail: shared across page instances; lift into a Cubit if the gallery
// ever needs more than one live copy.
var _checked = false;
var _toggled = true;
var _radio = 'a';
var _range = 40.0;
var _tab = 0;
var _nav = 0;
var _chips = <String>['Colombo'];
var _filters = <String>['Open'];
String? _dropdown;

final _sections = <(String, Widget)>[
  (
    'SldsButton',
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final v in SldsButtonVariant.values)
          SldsButton(label: v.name, variant: v, onPressed: () {}),
        const SldsButton(label: 'Disabled', onPressed: null),
        SldsButton(label: 'Loading', isLoading: true, onPressed: () {}),
      ],
    ),
  ),
  (
    'SldsLinkButton',
    Wrap(
      spacing: 16,
      children: [
        for (final v in SldsLinkButtonVariant.values)
          SldsLinkButton(label: v.name, variant: v, onPressed: () {}),
      ],
    ),
  ),
  (
    'SldsIconButton',
    Wrap(
      spacing: 8,
      children: [
        for (final v in SldsButtonVariant.values)
          SldsIconButton(icon: Icons.add, variant: v, onPressed: () {}),
      ],
    ),
  ),
  (
    'SldsFab',
    Wrap(
      spacing: 12,
      children: [
        SldsFab(icon: Icons.add, onPressed: () {}),
        SldsFab(icon: Icons.edit, badgeCount: 3, onPressed: () {}),
      ],
    ),
  ),
  (
    'SldsCheckButton',
    _Stateful(
      (context, setState) => SldsCheckButton(
        label: 'I agree to the terms',
        selected: _checked,
        onChanged: (v) => setState(() => _checked = v),
      ),
    ),
  ),
  (
    'SldsFilterButton',
    Wrap(
      spacing: 8,
      children: [
        SldsFilterButton(label: 'Filter', onTap: () {}),
        SldsFilterButton(label: 'Status', count: 2, onTap: () {}),
      ],
    ),
  ),
  (
    'SldsCheckbox',
    _Stateful(
      (context, setState) => Row(
        children: [
          SldsCheckbox(
            value: _checked,
            semanticLabel: 'Demo checkbox',
            onChanged: (v) => setState(() => _checked = v ?? false),
          ),
          const SizedBox(width: 8),
          const Text('Checkbox'),
        ],
      ),
    ),
  ),
  (
    'SldsRadio',
    _Stateful(
      (context, setState) => Row(
        children: [
          for (final v in ['a', 'b'])
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SldsRadio<String>(
                    value: v,
                    groupValue: _radio,
                    semanticLabel: 'Option $v',
                    onChanged: (n) => setState(() => _radio = n),
                  ),
                  const SizedBox(width: 8),
                  Text('Option $v'),
                ],
              ),
            ),
        ],
      ),
    ),
  ),
  (
    'SldsToggle',
    _Stateful(
      (context, setState) => SldsToggle(
        value: _toggled,
        semanticLabel: 'Demo toggle',
        onChanged: (v) => setState(() => _toggled = v),
      ),
    ),
  ),
  (
    'SldsRangeSlider',
    _Stateful(
      (context, setState) => SldsRangeSlider(
        value: _range,
        semanticLabel: 'Demo slider',
        onChanged: (v) => setState(() => _range = v),
      ),
    ),
  ),
  ('SldsTextField', const SldsTextField(label: 'Full name', hintText: 'Name')),
  (
    'SldsTextArea',
    const SldsTextArea(label: 'Comments', hintText: 'Tell us more'),
  ),
  ('SldsPasswordField', const SldsPasswordField(label: 'Password')),
  ('SldsInput', const SldsInput(label: 'Amount', prefixText: 'LKR')),
  (
    'SldsInputMask',
    const SldsInputMask(label: 'NIC', hintText: '000000000V'),
  ),
  ('SldsMobileNumberInput', const SldsMobileNumberInput(label: 'Mobile')),
  ('SldsOtpInput', const SldsOtpInput()),
  (
    'SldsUploadField',
    Column(
      children: [
        const SldsUploadField(label: 'Empty', hintText: 'PDF up to 5MB'),
        const SizedBox(height: 12),
        const SldsUploadField(
          label: 'Uploading',
          status: SldsUploadStatus.uploading,
          fileName: 'nic-scan.pdf',
          progress: 0.6,
        ),
        const SizedBox(height: 12),
        const SldsUploadField(
          label: 'Uploaded',
          status: SldsUploadStatus.uploaded,
          fileName: 'nic-scan.pdf',
        ),
      ],
    ),
  ),
  (
    'SldsDropdown',
    _Stateful(
      (context, setState) => SldsDropdown<String>(
        label: 'District',
        items: const ['Colombo', 'Kandy', 'Galle'],
        itemLabel: (v) => v,
        value: _dropdown,
        onChanged: (v) => setState(() => _dropdown = v),
      ),
    ),
  ),
  (
    'SldsComboBox',
    _Stateful(
      (context, setState) => SldsComboBox(
        label: 'Districts',
        placeholder: 'Select',
        multiple: true,
        options: const ['Colombo', 'Kandy', 'Galle', 'Jaffna'],
        selectedValues: _chips,
        onSelectionChanged: (v) => setState(() => _chips = v),
      ),
    ),
  ),
  (
    'SldsFilterDropdown',
    _Stateful(
      (context, setState) => SldsFilterDropdown(
        options: const ['Open', 'Closed', 'Pending'],
        selectedValues: _filters,
        onSelectionChanged: (v) => setState(() => _filters = v),
      ),
    ),
  ),
  ('SldsSearchBar', const SldsSearchBar(hintText: 'Search services')),
  (
    'SldsDatePicker',
    const SldsDatePicker(mode: SldsDatePickerMode.single),
  ),
  ('SldsTimePicker', const SldsTimePicker(label: 'Appointment time')),
  (
    'SldsFieldset',
    const SldsFieldset(
      legend: 'Contact details',
      description: 'How we reach you',
      children: [SldsTextField(label: 'Email')],
    ),
  ),
  (
    'SldsErrorSummary',
    SldsErrorSummary(
      errors: [
        SldsErrorSummaryItem('Enter your full name', onTap: () {}),
        SldsErrorSummaryItem('Enter a valid NIC', onTap: () {}),
      ],
    ),
  ),
  ('SldsCard', const SldsCard(child: Text('Card content'))),
  (
    'SldsIconCard',
    // featuredServices has no fixed height (it grows with content), so its
    // internal Stack needs a bounded box from us — a bare Wrap child gives
    // it unbounded height and the layout asserts.
    Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final v in SldsIconCardVariant.values)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SldsIconCard(
              title: v.name,
              icon: const Icon(Icons.description_outlined),
              description: 'Supporting line',
              variant: v,
              onTap: () {},
            ),
          ),
      ],
    ),
  ),
  (
    'SldsServiceCard',
    SldsServiceCard(
      icon: const Icon(Icons.badge_outlined),
      title: 'Renew NIC',
      description: 'Department for Registration of Persons',
      badgeText: 'NEW',
      onTap: () {},
    ),
  ),
  (
    'SldsNotificationCard',
    SldsNotificationCard(
      title: 'Application approved',
      body: 'Your NIC renewal has been approved.',
      timestamp: 'Today, 12:00pm',
      type: SldsNotificationType.success,
      unread: true,
      actionLabel: 'View',
      onAction: () {},
    ),
  ),
  (
    'SldsNotificationIcon',
    Wrap(
      spacing: 12,
      children: [
        for (final t in SldsNotificationType.values)
          SldsNotificationIcon(type: t, semanticLabel: t.name),
      ],
    ),
  ),
  (
    'SldsMobileMenuBlock',
    const Column(
      children: [
        SldsMobileMenuBlock(
          title: 'My applications',
          subtitle: 'Track submitted requests',
          leadingIcon: Icons.folder_outlined,
          count: '4',
          trailing: SldsMobileMenuNavigate(),
        ),
        SldsMobileMenuBlock(
          title: 'Verified identity',
          leadingIcon: Icons.verified_user_outlined,
          trailing: SldsMobileMenuValidated(),
        ),
      ],
    ),
  ),
  (
    'SldsAccordion',
    const SldsAccordion(
      items: [
        SldsAccordionItem(
          title: 'What documents do I need?',
          body: Text('Your NIC and a recent photograph.'),
        ),
        SldsAccordionItem(
          title: 'How long does it take?',
          body: Text('Around 14 working days.'),
        ),
      ],
    ),
  ),
  (
    'SldsFlyoutMenu',
    SldsFlyoutMenu(
      items: [
        SldsFlyoutMenuItem(
          label: 'Services',
          groups: [
            SldsFlyoutMenuGroup(
              header: 'Popular',
              entries: [
                SldsFlyoutMenuEntry(
                  label: 'Renew NIC',
                  icon: Icons.badge_outlined,
                  onTap: () {},
                ),
                SldsFlyoutMenuEntry(label: 'Pay taxes', onTap: () {}),
              ],
            ),
          ],
        ),
        SldsFlyoutMenuItem(label: 'Contact', onTap: () {}),
      ],
    ),
  ),
  (
    'SldsSummaryList',
    const SldsSummaryList(
      rows: [
        SldsSummaryRow(label: 'Application ID', value: 'APP-2024-001'),
        SldsSummaryRow(
          label: 'NIC',
          value: '199012345678',
          isSensitive: true,
        ),
        SldsSummaryRow(
          label: 'Status',
          value: 'Approved',
          badgeStatus: SldsSummaryBadgeStatus.approved,
        ),
      ],
    ),
  ),
  (
    'SldsProcessList',
    const SldsProcessList(
      steps: [
        SldsProcessStep(
          title: 'Submit',
          description: 'Send your application',
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: 'Review',
          description: 'We verify your documents',
          status: SldsProcessStepStatus.current,
        ),
        SldsProcessStep(title: 'Collect', description: 'Pick up your NIC'),
      ],
    ),
  ),
  (
    'SldsTabStrip',
    _Stateful(
      (context, setState) => SldsTabStrip(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          SldsTabStripItem(label: 'All'),
          SldsTabStripItem(label: 'Open', count: 3),
          SldsTabStripItem(label: 'Closed'),
        ],
      ),
    ),
  ),
  (
    'SldsBottomNav',
    _Stateful(
      (context, setState) => SldsBottomNav(
        currentIndex: _nav,
        onTap: (i) => setState(() => _nav = i),
        items: const [
          SldsBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          SldsBottomNavItem(
            icon: Icons.notifications_outlined,
            label: 'Alerts',
            badgeCount: 2,
          ),
          SldsBottomNavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    ),
  ),
  (
    'SldsTopNavBar',
    Column(
      children: [
        SldsTopNavBar(title: 'Page title', onBack: () {}, onMenu: () {}),
        const SizedBox(height: 12),
        SldsTopNavBar.progress(totalSteps: 4, currentStep: 2, onBack: () {}),
      ],
    ),
  ),
  ('SldsStepIndicator', const SldsStepIndicator(totalSteps: 4, currentStep: 2)),
  ('SldsProgressBar', const SldsProgressBar(value: 0.4)),
  (
    'SldsBadge',
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in SldsBadgeStatus.values)
          SldsBadge(label: s.name, status: s),
      ],
    ),
  ),
  (
    'SldsChip',
    Wrap(
      spacing: 8,
      children: [
        SldsChip(label: 'Colombo', onDeleted: () {}),
        const SldsChip(label: 'Info', icon: Icons.info_outline),
        const SldsChip(
          label: 'With avatar',
          avatar: SldsAvatar(initials: 'LK', size: SldsAvatarSize.small),
        ),
      ],
    ),
  ),
  (
    'SldsAvatar',
    Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final s in SldsAvatarSize.values)
          SldsAvatar(initials: 'LK', size: s, semanticLabel: 'Demo user'),
      ],
    ),
  ),
  (
    'SldsBanner',
    Column(
      children: [
        for (final s in SldsBannerSeverity.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SldsBanner(
              message: '${s.name} banner message',
              severity: s,
              actionLabel: 'Action',
              onAction: () {},
              onDismiss: () {},
            ),
          ),
      ],
    ),
  ),
  (
    'SldsTooltip',
    const SldsTooltip(
      title: 'Tooltip title',
      description: 'Extra guidance for this field.',
      stepLabel: '1 of 3',
      actionLabel: 'Next',
    ),
  ),
  // Both are full-screen states — SldsErrorState sizes itself to
  // constraints.maxHeight, which is infinite inside a ListView. Give them a
  // fixed viewport here; a real app hands them the whole body.
  (
    'SldsEmptyState',
    SizedBox(
      height: 320,
      child: SldsEmptyState(
        illustration: const Icon(Icons.inbox_outlined, size: 64),
        title: 'No applications yet',
        description: 'Once you apply, your requests appear here.',
        actionLabel: 'Start an application',
        onAction: () {},
      ),
    ),
  ),
  (
    'SldsErrorState',
    SizedBox(
      height: 420,
      child: SldsErrorState.forKind(SldsErrorKind.notFound, onAction: () {}),
    ),
  ),
  (
    'Overlays (tap to open)',
    _Stateful(
      (context, setState) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SldsButton(
            label: 'Dialog',
            variant: SldsButtonVariant.secondary,
            onPressed: () => SldsDialog.show(
              context,
              title: 'Confirm submission',
              message: 'You cannot edit after submitting.',
              cancelLabel: 'Cancel',
              confirmLabel: 'Submit',
              onConfirm: () => Navigator.of(context).pop(),
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
          SldsButton(
            label: 'Bottom sheet',
            variant: SldsButtonVariant.secondary,
            onPressed: () => SldsBottomSheet.show(
              context,
              title: 'Sheet title',
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Sheet content'),
              ),
            ),
          ),
          SldsButton(
            label: 'Snack bar',
            variant: SldsButtonVariant.secondary,
            onPressed: () => SldsSnackBar.show(
              context,
              title: 'Saved',
              message: 'Your draft has been saved.',
              actionLabel: 'Undo',
              onAction: () {},
            ),
          ),
        ],
      ),
    ),
  ),
  (
    'SldsPullToRefresh',
    const SizedBox(
      height: 120,
      child: SldsPullToRefresh(
        onRefresh: _demoRefresh,
        child: Center(child: Text('Pull down to refresh')),
      ),
    ),
  ),
];

Future<void> _demoRefresh() =>
    Future<void>.delayed(const Duration(milliseconds: 600));
