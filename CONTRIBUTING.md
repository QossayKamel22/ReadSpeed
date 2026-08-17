# Contributing to ReadSpeed

## Requirements

- Flutter 3.24+ (stable channel)
- Dart 3.5+

## Getting started

```bash
git clone https://github.com/QossayKamel22/ReadSpeed.git
cd ReadSpeed
flutter pub get
flutter run -d chrome     # or: flutter run -d <device-id>
```

## Before opening a PR

```bash
flutter analyze
flutter test
flutter build web --release   # sanity check the web target builds
```

## Conventions

- **Commits**: small, meaningful, imperative mood, prefixed with
  `feat:`, `fix:`, `chore:`, `docs:` (see `git log` for examples).
- **Design tokens**: never hardcode a color/font size in a screen — add
  it to `lib/core/theme/app_colors.dart` or `app_text_styles.dart`.
- **Components before duplication**: if you're about to copy a card /
  button / row layout into a second screen, move it to
  `lib/core/widgets/` first.
- **State**: one `GetxController` per screen module; shared
  cross-screen state (like which tab is active) belongs on
  `ShellController`, not duplicated per screen.
- **No new pages for overlays**: dialogs, sheets, and confirmations are
  `AppModal`s (bottom sheets), not new routes — see
  `lib/core/widgets/app_modal.dart` and any file under a screen's
  `widgets/` subfolder for the pattern.

See `docs/ARCHITECTURE.md` for the full folder-by-folder breakdown and
`docs/FIREBASE_SETUP.md` for wiring up a real backend.
