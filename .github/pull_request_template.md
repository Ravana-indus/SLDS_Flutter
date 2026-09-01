## What changed

<!-- One or two sentences. Link the issue this closes. -->

## Definition of Done (§11)

Tick what applies, strike through what genuinely does not, and say why. An
omission is a documented decision, not a gap to be found later.

- [ ] Values resolve from tokens or theme — no literals
- [ ] Renders correctly in light, dark **and high contrast**
- [ ] Semantics labels present, free of PII, colour is never the only signal
- [ ] Works at 200% text scale; RTL-safe insets; 48×48 minimum targets;
      honours reduced motion and OS bold text
- [ ] Strings localized in si, ta and en through the library delegate; dates,
      numbers and currency go through `SldsFormat`, not string interpolation
- [ ] Applicable states from §7 implemented (default, focus, hover, pressed,
      disabled, loading, empty, error, offline, stale) — omissions noted below
- [ ] Golden tests for every variant, theme and both text scales;
      text-bearing components also cover si and ta at 200%
- [ ] Widget tests for behaviour and semantics, including `meetsGuideline`
- [ ] Dartdoc on all public members, theme-neutral wording
- [ ] Widgetbook use case covering every variant
- [ ] CHANGELOG entry, with before/after images if a golden changed
- [ ] Zero analyzer warnings, CI green
- [ ] Manual TalkBack / VoiceOver pass (required once per release for every
      component that shipped or changed). Generate the checklist with
      `dart run tool/build_screen_reader_packet.dart` and attach the result

**States deliberately omitted, and why:**

<!-- e.g. "No loading state: this is a static label." Leave blank if none. -->

## Visual changes

<!-- Any change that alters a golden is a minor version bump at minimum (§3).
     Paste before/after images here, not just the file names. -->

## Credential and privacy (§1)

- [ ] Not applicable — this component does not render identity or credential data
- [ ] Semantics labels describe the field, never speak the value
- [ ] Test and demo fixtures use obviously synthetic data — no realistic NIC,
      licence or vehicle numbers, including in golden images

## Notes for the reviewer

<!-- Anything that would otherwise cost the reviewer ten minutes to work out. -->
