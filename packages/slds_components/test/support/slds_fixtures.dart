// The component fixture list, shared by every suite that needs to build one
// of each component.
//
// This list is the repository's answer to "every public component": the
// golden coverage suite renders each entry, and the device-floor suite lays
// each one out at the declared 320dp/200% floor. Keeping one list means a new
// component cannot be added to the library and silently skip either check —
// `slds_fixture_coverage_test.dart` fails when an export has no fixture here.

import 'package:flutter/material.dart';
import 'package:slds_components/slds_components.dart';

/// A component under coverage: its golden name and how to build it.
///
/// `width` bounds the widget where it would otherwise take all the space the
/// test surface offers, so the image frames the component rather than a
/// full-bleed rectangle.
typedef SldsFixture = ({String name, Widget Function() build, double? width});

/// Builds the fixture list.
///
/// A function rather than a `const` list because several fixtures need
/// callbacks and controllers, which cannot be const.
List<SldsFixture> sldsFixtures() => <SldsFixture>[
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
    build: () => const SldsFieldset(
      legend: 'Contact details',
      helperText: 'We only use these to contact you about this application.',
      children: [
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
  (
    name: 'bottom_nav',
    width: 340,
    build: () => SldsBottomNav(
      currentIndex: 0,
      onTap: (_) {},
      items: const [
        SldsBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
        SldsBottomNavItem(
          icon: Icons.notifications_outlined,
          label: 'Alerts',
          badgeCount: 3,
        ),
        SldsBottomNavItem(icon: Icons.person_outline, label: 'Profile'),
      ],
    ),
  ),
  (
    name: 'button',
    width: null,
    build: () => SldsButton(label: 'Continue', onPressed: () {}),
  ),
  (
    name: 'card',
    width: 340,
    build: () => const SldsCard(
      child: Text('Renew your revenue licence online to avoid a queue.'),
    ),
  ),
  (
    name: 'error_state',
    width: 340,
    build: () => SldsErrorState.forKind(
      SldsErrorKind.notFound,
      actionLabel: 'Go back',
      onAction: () {},
    ),
  ),
  (
    name: 'fab',
    width: null,
    build: () => SldsFab(icon: Icons.add, onPressed: () {}),
  ),
  (
    name: 'focus',
    width: 200,
    build: () => const SldsFocusRing(
      focused: true,
      child: SldsCard(child: Text('Focused')),
    ),
  ),
  (
    name: 'icon_card',
    width: 340,
    build: () => SldsIconCard(
      title: 'Vehicle services',
      icon: const Icon(Icons.directions_car_outlined),
      description: 'Licence renewal, transfers and registration.',
      onTap: () {},
    ),
  ),
  (
    name: 'pull_to_refresh',
    width: 340,
    build: () => SldsPullToRefresh(
      onRefresh: () async {},
      child: ListView(
        shrinkWrap: true,
        children: const [
          SldsCard(child: Text('Pull down to refresh')),
        ],
      ),
    ),
  ),
  (
    name: 'text_field',
    width: 340,
    build: () => const SldsTextField(
      label: 'Licence number',
      helpText: 'As printed on the top right of your licence',
    ),
  ),
  (
    name: 'time_picker',
    width: 340,
    build: () => const SldsTimePicker(label: 'Appointment time'),
  ),
  (
    name: 'toggle',
    width: null,
    build: () => SldsToggle(
      value: true,
      onChanged: (_) {},
      semanticLabel: 'Email notifications',
    ),
  ),
];
