// Golden coverage for the components outside the deep matrix (§8).
//
// `slds_goldens_test.dart` holds the full per-variant, per-theme, per-scale
// matrix for the five components that carry the most visual surface. §8 also
// treats "a component without goldens" as unreviewed, which left the other 47
// exported components with no image at all.
//
// This file closes that gap at a deliberately shallower depth: one image per
// component per theme (light, dark, high contrast), plus a 200% text-scale
// image in light. That is enough to catch the regressions goldens actually
// catch here — a token that stopped resolving, a surface that went
// transparent in dark, a control that clips when the user doubles their text
// size — without multiplying 47 components by every variant they own.
//
// Deepen a component's coverage by moving it into the matrix file when its
// variants start carrying real visual meaning, not by widening this one.
//
// Regenerate with `flutter test --update-goldens` and inspect every changed
// image before committing — a golden diff is a visual change, which §3 makes
// a minor version bump at minimum.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slds_components/slds_components.dart';

import 'support/slds_test_harness.dart';

/// Themes every component is captured against, matching the matrix file.
const _themes = <String>['light', 'dark', 'hc'];

/// A component under coverage: its golden name and how to build it.
///
/// [width] bounds the widget where it would otherwise take all the space the
/// test surface offers, so the image frames the component rather than a
/// full-bleed rectangle.
typedef _Fixture = ({String name, Widget Function() build, double? width});

/// Builds the fixture list.
///
/// A function rather than a `const` list because several fixtures need
/// callbacks and controllers, which cannot be const.
List<_Fixture> _fixtures() => <_Fixture>[
  (
    name: 'accordion',
    width: 340,
    build: () => const SldsAccordion(
      items: [
        SldsAccordionItem(
          title: 'What documents do I need?',
          body: Text('A valid identity document and proof of address.'),
        ),
        SldsAccordionItem(
          title: 'How long does it take?',
          body: Text('Most applications are processed within five days.'),
        ),
      ],
    ),
  ),
  (
    name: 'avatar',
    width: null,
    build: () => const SldsAvatar(
      initials: 'LK',
      size: SldsAvatarSize.large,
      semanticLabel: 'Lakmal Perera',
    ),
  ),
  (
    name: 'badge',
    width: null,
    build: () => SldsBadge.status(SldsBadgeStatus.inReview),
  ),
  (
    name: 'bottom_sheet',
    width: 340,
    build: () => const SldsBottomSheet(
      title: 'Choose a district',
      child: Text('Sheet body'),
    ),
  ),
  (
    name: 'check_button',
    width: null,
    build: () => SldsCheckButton(
      label: 'I agree to the terms',
      selected: true,
      onChanged: (_) {},
    ),
  ),
  (
    name: 'checkbox',
    width: null,
    build: () => SldsCheckbox(
      value: true,
      onChanged: (_) {},
      semanticLabel: 'Subscribe to updates',
    ),
  ),
  (
    name: 'chip',
    width: null,
    build: () => SldsChip(label: 'Colombo', onDeleted: () {}),
  ),
  (
    name: 'combo_box',
    width: 340,
    build: () => SldsComboBox(
      label: 'District',
      placeholder: 'Select a district',
      options: const ['Colombo', 'Kandy', 'Galle'],
      selectedValues: const ['Colombo'],
      multiple: true,
      onSelectionChanged: (_) {},
    ),
  ),
  (
    name: 'date_picker',
    width: 340,
    build: () => SldsDatePicker(
      initialDate: DateTime(2026, 3, 14),
      mode: SldsDatePickerMode.single,
      onDateSelected: (_) {},
    ),
  ),
  (
    name: 'dialog',
    width: 340,
    build: () => SldsDialog(
      title: 'Discard this application?',
      message: 'Your answers will not be saved.',
      cancelLabel: 'Keep editing',
      confirmLabel: 'Discard',
      onCancel: () {},
      onConfirm: () {},
    ),
  ),
  (
    name: 'divider',
    width: 280,
    build: () => const SldsDivider(child: Text('or')),
  ),
  (
    name: 'dropdown',
    width: 340,
    build: () => SldsDropdown<String>(
      label: 'Province',
      items: const ['Western', 'Central', 'Southern'],
      itemLabel: (item) => item,
      value: 'Western',
      onChanged: (_) {},
    ),
  ),
  (
    name: 'empty_state',
    width: 340,
    build: () => SldsEmptyState(
      illustration: const Icon(Icons.inbox_outlined, size: 48),
      title: 'No documents yet',
      description: 'Documents you upload will appear here.',
      actionLabel: 'Upload a document',
      onAction: () {},
    ),
  ),
  (
    name: 'error_summary',
    width: 340,
    build: () => SldsErrorSummary(
      errors: [
        SldsErrorSummaryItem('Enter your full name', onTap: () {}),
        SldsErrorSummaryItem('Enter a valid date of birth', onTap: () {}),
      ],
    ),
  ),
  (
    name: 'fieldset',
    width: 340,
    build: () => SldsFieldset(
      legend: 'Contact details',
      helperText: 'We only use these to contact you about this application.',
      children: const [
        SldsTextField(label: 'Email'),
        SldsTextField(label: 'Phone'),
      ],
    ),
  ),
  (
    name: 'filter_button',
    width: null,
    build: () => SldsFilterButton(label: 'Filters', count: 2, onTap: () {}),
  ),
  (
    name: 'filter_dropdown',
    width: 320,
    build: () => SldsFilterDropdown(
      options: const ['Approved', 'Pending', 'Rejected'],
      selectedValues: const ['Pending'],
      onSelectionChanged: (_) {},
    ),
  ),
  (
    name: 'flyout_menu',
    width: 320,
    build: () => SldsFlyoutMenu(
      items: const [
        SldsFlyoutMenuItem(label: 'Home'),
        SldsFlyoutMenuItem(
          label: 'Services',
          groups: [
            SldsFlyoutMenuGroup(
              header: 'Popular',
              entries: [
                SldsFlyoutMenuEntry(label: 'Licence renewal'),
                SldsFlyoutMenuEntry(label: 'Pay a fine'),
              ],
            ),
          ],
        ),
      ],
      onClose: () {},
    ),
  ),
  (
    name: 'icon_button',
    width: null,
    build: () => SldsIconButton(
      icon: Icons.share,
      tooltip: 'Share',
      onPressed: () {},
    ),
  ),
  (
    name: 'input',
    width: 340,
    build: () => SldsInput(
      label: 'Full name',
      hintText: 'As it appears on your ID',
      onChanged: (_) {},
    ),
  ),
  (
    name: 'input_mask',
    width: 340,
    build: () =>
        const SldsInputMask(label: 'Date of birth', hintText: 'DD/MM/YYYY'),
  ),
  (
    name: 'link_button',
    width: null,
    build: () => SldsLinkButton(label: 'Read the guidance', onPressed: () {}),
  ),
  (
    name: 'mobile_menu_block',
    width: 340,
    build: () => SldsMobileMenuBlock(
      title: 'My requests',
      subtitle: 'Track applications you have submitted',
      leadingIcon: Icons.assignment_outlined,
      count: '3',
      onTap: () {},
    ),
  ),
  (
    name: 'mobile_number_input',
    width: 340,
    build: () => SldsMobileNumberInput(
      label: 'Mobile number',
      onChanged: (_) {},
    ),
  ),
  (
    name: 'notification_card',
    width: 340,
    build: () => SldsNotificationCard(
      title: 'Application approved',
      body: 'Your licence renewal has been approved.',
      timestamp: 'Today, 12:00pm',
      type: SldsNotificationType.success,
      unread: true,
      actionLabel: 'Download',
      onAction: () {},
    ),
  ),
  (
    name: 'otp_input',
    width: 340,
    build: () => SldsOtpInput(length: 4, onChanged: (_) {}),
  ),
  (
    name: 'password_field',
    width: 340,
    build: () => SldsPasswordField(label: 'Password', onChanged: (_) {}),
  ),
  (
    name: 'process_list',
    width: 340,
    build: () => const SldsProcessList(
      steps: [
        SldsProcessStep(
          title: 'Application received',
          description: 'We have your submission.',
          status: SldsProcessStepStatus.done,
        ),
        SldsProcessStep(
          title: 'Under review',
          description: 'An officer is checking your documents.',
          status: SldsProcessStepStatus.current,
        ),
        SldsProcessStep(
          title: 'Decision',
          description: 'You will be notified by SMS.',
          status: SldsProcessStepStatus.upcoming,
        ),
      ],
    ),
  ),
  (
    name: 'progress_bar',
    width: 280,
    build: () => const SldsProgressBar(value: 0.4),
  ),
  (
    name: 'radio',
    width: null,
    build: () => SldsRadio<String>(
      value: 'yes',
      groupValue: 'yes',
      onChanged: (_) {},
      semanticLabel: 'Yes',
    ),
  ),
  (
    name: 'range_slider',
    width: 280,
    build: () => SldsRangeSlider(
      value: 40,
      onChanged: (_) {},
      semanticLabel: 'Maximum fee',
    ),
  ),
  (
    name: 'search_bar',
    width: 340,
    build: () => SldsSearchBar(hintText: 'Search services', onChanged: (_) {}),
  ),
  (
    name: 'service_card',
    width: 340,
    build: () => SldsServiceCard(
      icon: const Icon(Icons.description_outlined),
      title: 'Licence renewal',
      description: 'Renew online in minutes',
      badgeText: 'Popular',
      onTap: () {},
    ),
  ),
  (
    name: 'snack_bar',
    width: 340,
    build: () => SldsSnackBar(
      title: 'Draft saved',
      message: 'You can finish this later.',
      actionLabel: 'Undo',
      onAction: () {},
    ),
  ),
  (
    name: 'step_indicator',
    width: 280,
    build: () => const SldsStepIndicator(totalSteps: 4, currentStep: 2),
  ),
  (
    name: 'summary_list',
    width: 340,
    build: () => const SldsSummaryList(
      rows: [
        SldsSummaryRow(label: 'Application ID', value: 'APP-2026-0143'),
        SldsSummaryRow(label: 'Submitted', value: '14 March 2026'),
        SldsSummaryRow(
          label: 'Status',
          value: 'In Review',
          badgeStatus: SldsSummaryBadgeStatus.inReview,
        ),
      ],
    ),
  ),
  (
    name: 'tab_strip',
    width: 340,
    build: () => SldsTabStrip(
      items: const [
        SldsTabStripItem(label: 'All'),
        SldsTabStripItem(label: 'Open', count: 3),
        SldsTabStripItem(label: 'Closed'),
      ],
      currentIndex: 1,
      onTap: (_) {},
    ),
  ),
  (
    name: 'text_area',
    width: 340,
    build: () => SldsTextArea(
      label: 'Tell us more',
      hintText: 'Describe your request',
      onChanged: (_) {},
    ),
  ),
  (
    name: 'time_picker_dialog',
    width: 340,
    build: () => SldsTimePickerDialog(onTimeChanged: (_) {}),
  ),
  (
    name: 'tooltip',
    width: 300,
    build: () => SldsTooltip(
      title: 'Where do I find this?',
      description: 'Your reference number is on the top of your letter.',
      stepLabel: '1 of 3',
      actionLabel: 'Next',
      onAction: () {},
    ),
  ),
  (
    name: 'top_nav_bar',
    width: 340,
    build: () => SldsTopNavBar(
      title: 'Renew licence',
      onBack: () {},
      onMenu: () {},
    ),
  ),
  (
    name: 'upload_field',
    width: 340,
    build: () => SldsUploadField(
      label: 'Proof of address',
      hintText: 'PDF, JPEG or PNG less than 5MB',
      onTap: () {},
    ),
  ),
];

void main() {
  for (final fixture in _fixtures()) {
    group(fixture.name, () {
      for (final theme in _themes) {
        testWidgets('$theme x1.0', (tester) async {
          await tester.pumpWidget(
            wrap(
              _bounded(fixture),
              theme: sldsThemeNamed(theme),
              highContrast: theme == 'hc',
            ),
          );
          await expectGolden(
            find.byType(_Frame),
            '${fixture.name}_${theme}_x1.0',
          );
        }, skip: goldenSkipReason != null);
      }

      // 200% is where a fixed-height control clips its own text, which is the
      // failure this shallow matrix is most likely to catch (§8).
      testWidgets('light x2.0', (tester) async {
        await tester.pumpWidget(wrap(_bounded(fixture), textScale: 2));
        await expectGolden(
          find.byType(_Frame),
          '${fixture.name}_light_x2.0',
        );
      }, skip: goldenSkipReason != null);
    });
  }
}

/// Wraps a fixture in the [_Frame] the golden is captured against.
///
/// Capturing a shared marker type rather than each component's own type keeps
/// one code path here; capturing the component directly would miss the width
/// bound that frames it.
Widget _bounded(_Fixture fixture) => _Frame(
  child: fixture.width == null
      ? fixture.build()
      : SizedBox(width: fixture.width, child: fixture.build()),
);

/// Marker widget giving every coverage golden the same capture boundary.
class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
