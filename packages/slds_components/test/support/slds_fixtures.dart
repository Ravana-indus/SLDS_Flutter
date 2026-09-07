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
///
/// `buildLocalized` is set only for fixtures with visible label text — the
/// §6/§8 si/ta clipping risk does not apply to a component whose only text
/// is a semantics label. Where set, it swaps the English label for
/// [_localizedText] so the golden actually exercises taller Sinhala/Tamil
/// glyphs rather than re-rendering the same English string under a
/// different [Locale].
typedef SldsFixture = ({
  String name,
  Widget Function() build,
  Widget Function(Locale)? buildLocalized,
  double? width,
});

/// Generic synthetic label used to localize fixtures for the si/ta x2.0
/// goldens (§6, §8). Not a semantic match for each component — these two
/// strings exist purely to exercise glyph height and clipping, same as the
/// pair already used for SldsButton/SldsTextField in slds_goldens_test.dart.
/// Machine-drafted, not reviewed by a speaker (see CLAUDE.md).
const _localizedText = <String, String>{
  'si': 'ඉදිරියට',
  'ta': 'தொடரவும்',
};

/// Looks up [_localizedText] for [locale], falling back to the si string.
/// A plain function (rather than repeating the map index inline) keeps each
/// builder's repeated lookups from tripping the analyzer's
/// unnecessary_null_checks info on the second identical expression.
String _text(Locale locale) =>
    _localizedText[locale.languageCode] ?? _localizedText['si']!;

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
    buildLocalized: (locale) => SldsAccordion(
      items: [
        SldsAccordionItem(
          title: _text(locale),
          body: Text(_text(locale)),
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
    buildLocalized: null, // initials only; no visible sentence text
  ),
  (
    name: 'badge',
    width: null,
    build: () => SldsBadge.status(SldsBadgeStatus.inReview),
    buildLocalized: null, // label is localized internally, not caller text
  ),
  (
    name: 'banner',
    width: 452,
    build: () => SldsBanner(
      message: 'Your changes have been saved successfully.',
      severity: SldsBannerSeverity.success,
      actionLabel: 'View details',
      onAction: () {},
      onDismiss: () {},
    ),
    buildLocalized: (locale) => SldsBanner(
      message: _text(locale),
      severity: SldsBannerSeverity.success,
      actionLabel: _text(locale),
      onAction: () {},
      onDismiss: () {},
    ),
  ),
  (
    name: 'bottom_sheet',
    width: 340,
    build: () => Builder(
      builder: (context) => SldsBottomSheet(
        title: 'Choose a district',
        // Coloured from the theme and top-aligned, as a consuming app would
        // write it. The sheet puts its child in an Expanded, so a bare Text
        // becomes a full-height node of mostly empty surface — which the
        // contrast matcher then averages, reporting a failure for the
        // fixture rather than for the component.
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            'Sheet body',
            style: TextStyle(color: context.slds.colors.textPrimary),
          ),
        ),
      ),
    ),
    buildLocalized: (locale) => Builder(
      builder: (context) => SldsBottomSheet(
        title: _text(locale),
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            _text(locale),
            style: TextStyle(color: context.slds.colors.textPrimary),
          ),
        ),
      ),
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
    buildLocalized: (locale) => SldsCheckButton(
      label: _text(locale),
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
    buildLocalized: null, // semanticLabel only; no visible text
  ),
  (
    name: 'chip',
    width: null,
    build: () => SldsChip(label: 'Colombo', onDeleted: () {}),
    buildLocalized: (locale) => SldsChip(
      label: _text(locale),
      onDeleted: () {},
    ),
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
    buildLocalized: (locale) => SldsComboBox(
      label: _text(locale),
      placeholder: _text(locale),
      options: [_text(locale)],
      selectedValues: [_text(locale)],
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
    buildLocalized: null, // dates format through intl, not a caller label
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
    buildLocalized: (locale) => SldsDialog(
      title: _text(locale),
      message: _text(locale),
      cancelLabel: _text(locale),
      confirmLabel: _text(locale),
      onCancel: () {},
      onConfirm: () {},
    ),
  ),
  (
    name: 'divider',
    width: 280,
    build: () => const SldsDivider(child: Text('or')),
    buildLocalized: (locale) => SldsDivider(child: Text(_text(locale))),
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
    buildLocalized: (locale) => SldsDropdown<String>(
      label: _text(locale),
      items: [_text(locale)],
      itemLabel: (item) => item,
      value: _text(locale),
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
    buildLocalized: (locale) => SldsEmptyState(
      illustration: const Icon(Icons.inbox_outlined, size: 48),
      title: _text(locale),
      description: _text(locale),
      actionLabel: _text(locale),
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
    buildLocalized: (locale) => SldsErrorSummary(
      errors: [
        SldsErrorSummaryItem(
          _text(locale),
          onTap: () {},
        ),
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
    buildLocalized: (locale) => SldsFieldset(
      legend: _text(locale),
      helperText: _text(locale),
      children: [SldsTextField(label: _text(locale))],
    ),
  ),
  (
    name: 'filter_button',
    width: null,
    build: () => SldsFilterButton(label: 'Filters', count: 2, onTap: () {}),
    buildLocalized: (locale) => SldsFilterButton(
      label: _text(locale),
      count: 2,
      onTap: () {},
    ),
  ),
  (
    name: 'filter_dropdown',
    width: 320,
    build: () => SldsFilterDropdown(
      options: const ['Approved', 'Pending', 'Rejected'],
      selectedValues: const ['Pending'],
      onSelectionChanged: (_) {},
    ),
    buildLocalized: (locale) => SldsFilterDropdown(
      options: [_text(locale)],
      selectedValues: [_text(locale)],
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
    buildLocalized: (locale) => SldsFlyoutMenu(
      items: [
        SldsFlyoutMenuItem(
          label: _text(locale),
          groups: [
            SldsFlyoutMenuGroup(
              header: _text(locale),
              entries: [
                SldsFlyoutMenuEntry(
                  label: _text(locale),
                ),
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
    buildLocalized: null, // tooltip only, no rendered-visible label
  ),
  (
    name: 'input',
    width: 340,
    build: () => SldsInput(
      label: 'Full name',
      hintText: 'As it appears on your ID',
      onChanged: (_) {},
    ),
    buildLocalized: (locale) => SldsInput(
      label: _text(locale),
      hintText: _text(locale),
      onChanged: (_) {},
    ),
  ),
  (
    name: 'input_mask',
    width: 340,
    build: () =>
        const SldsInputMask(label: 'Date of birth', hintText: 'DD/MM/YYYY'),
    buildLocalized: (locale) => SldsInputMask(
      label: _text(locale),
      hintText: 'DD/MM/YYYY',
    ),
  ),
  (
    name: 'link_button',
    width: null,
    build: () => SldsLinkButton(label: 'Read the guidance', onPressed: () {}),
    buildLocalized: (locale) => SldsLinkButton(
      label: _text(locale),
      onPressed: () {},
    ),
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
    buildLocalized: (locale) => SldsMobileMenuBlock(
      title: _text(locale),
      subtitle: _text(locale),
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
    buildLocalized: (locale) => SldsMobileNumberInput(
      label: _text(locale),
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
    buildLocalized: (locale) => SldsNotificationCard(
      title: _text(locale),
      body: _text(locale),
      timestamp: 'Today, 12:00pm',
      type: SldsNotificationType.success,
      unread: true,
      actionLabel: _text(locale),
      onAction: () {},
    ),
  ),
  (
    name: 'notification_icon',
    width: 340,
    build: () => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final type in SldsNotificationType.values)
          SldsNotificationIcon(type: type),
      ],
    ),
    buildLocalized: null, // icon only, no visible text
  ),
  (
    name: 'otp_input',
    width: 340,
    build: () => SldsOtpInput(length: 4, onChanged: (_) {}),
    buildLocalized: null, // digit cells only, no visible label text
  ),
  (
    name: 'password_field',
    width: 340,
    build: () => SldsPasswordField(label: 'Password', onChanged: (_) {}),
    buildLocalized: (locale) => SldsPasswordField(
      label: _text(locale),
      onChanged: (_) {},
    ),
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
    buildLocalized: (locale) => SldsProcessList(
      steps: [
        SldsProcessStep(
          title: _text(locale),
          description: _text(locale),
          status: SldsProcessStepStatus.current,
        ),
      ],
    ),
  ),
  (
    name: 'progress_bar',
    width: 280,
    build: () => const SldsProgressBar(value: 0.4),
    buildLocalized: null, // numeric percentage only, no label text
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
    buildLocalized: null, // semanticLabel only; no visible text
  ),
  (
    name: 'range_slider',
    width: 280,
    build: () => SldsRangeSlider(
      value: 40,
      onChanged: (_) {},
      semanticLabel: 'Maximum fee',
    ),
    buildLocalized: null, // semanticLabel only; no visible text
  ),
  (
    name: 'search_bar',
    width: 340,
    build: () => SldsSearchBar(hintText: 'Search services', onChanged: (_) {}),
    buildLocalized: (locale) => SldsSearchBar(
      hintText: _text(locale),
      onChanged: (_) {},
    ),
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
    buildLocalized: (locale) => SldsServiceCard(
      icon: const Icon(Icons.description_outlined),
      title: _text(locale),
      description: _text(locale),
      badgeText: _text(locale),
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
    buildLocalized: (locale) => SldsSnackBar(
      title: _text(locale),
      message: _text(locale),
      actionLabel: _text(locale),
      onAction: () {},
    ),
  ),
  (
    name: 'step_indicator',
    width: 280,
    build: () => const SldsStepIndicator(totalSteps: 4, currentStep: 2),
    buildLocalized: null, // step dots only, no label text
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
    buildLocalized: (locale) => SldsSummaryList(
      rows: [
        SldsSummaryRow(
          label: _text(locale),
          value: _text(locale),
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
    buildLocalized: (locale) => SldsTabStrip(
      items: [
        SldsTabStripItem(label: _text(locale)),
        SldsTabStripItem(label: _text(locale), count: 3),
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
    buildLocalized: (locale) => SldsTextArea(
      label: _text(locale),
      hintText: _text(locale),
      onChanged: (_) {},
    ),
  ),
  (
    name: 'time_picker_dialog',
    width: 340,
    build: () => SldsTimePickerDialog(onTimeChanged: (_) {}),
    buildLocalized: null, // time digits only, formatted through intl
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
    buildLocalized: (locale) => SldsTooltip(
      title: _text(locale),
      description: _text(locale),
      stepLabel: '1 of 3',
      actionLabel: _text(locale),
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
    buildLocalized: (locale) => SldsTopNavBar(
      title: _text(locale),
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
    buildLocalized: (locale) => SldsUploadField(
      label: _text(locale),
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
    buildLocalized: (locale) => SldsBottomNav(
      currentIndex: 0,
      onTap: (_) {},
      items: [
        SldsBottomNavItem(
          icon: Icons.home_outlined,
          label: _text(locale),
        ),
        SldsBottomNavItem(
          icon: Icons.notifications_outlined,
          label: _text(locale),
          badgeCount: 3,
        ),
      ],
    ),
  ),
  (
    name: 'button',
    width: null,
    build: () => SldsButton(label: 'Continue', onPressed: () {}),
    buildLocalized: (locale) => SldsButton(
      label: _text(locale),
      onPressed: () {},
    ),
  ),
  (
    name: 'card',
    width: 340,
    build: () => const SldsCard(
      child: Text('Renew your revenue licence online to avoid a queue.'),
    ),
    buildLocalized: (locale) => SldsCard(child: Text(_text(locale))),
  ),
  (
    name: 'error_state',
    width: 340,
    build: () => SldsErrorState.forKind(
      SldsErrorKind.notFound,
      actionLabel: 'Go back',
      onAction: () {},
    ),
    buildLocalized: (locale) => SldsErrorState.forKind(
      SldsErrorKind.notFound,
      actionLabel: _text(locale),
      onAction: () {},
    ),
  ),
  (
    name: 'fab',
    width: null,
    build: () => SldsFab(icon: Icons.add, tooltip: 'Add', onPressed: () {}),
    buildLocalized: null, // tooltip only, no rendered-visible label
  ),
  (
    name: 'focus',
    width: 200,
    build: () => const SldsFocusRing(
      focused: true,
      child: SldsCard(child: Text('Focused')),
    ),
    buildLocalized: (locale) => SldsFocusRing(
      focused: true,
      child: SldsCard(child: Text(_text(locale))),
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
    buildLocalized: (locale) => SldsIconCard(
      title: _text(locale),
      icon: const Icon(Icons.directions_car_outlined),
      description: _text(locale),
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
    buildLocalized: (locale) => SldsPullToRefresh(
      onRefresh: () async {},
      child: ListView(
        shrinkWrap: true,
        children: [
          SldsCard(child: Text(_text(locale))),
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
    buildLocalized: (locale) => SldsTextField(
      label: _text(locale),
      helpText: _text(locale),
    ),
  ),
  (
    name: 'time_picker',
    width: 340,
    build: () => const SldsTimePicker(label: 'Appointment time'),
    buildLocalized: (locale) => SldsTimePicker(label: _text(locale)),
  ),
  (
    name: 'toggle',
    width: null,
    build: () => SldsToggle(
      value: true,
      onChanged: (_) {},
      semanticLabel: 'Email notifications',
    ),
    buildLocalized: null, // semanticLabel only; no visible text
  ),
];
