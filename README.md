# ReadSpeed

**Read Faster. Understand Better.**

A premium speed-reading and reading-productivity app built with Flutter + GetX.

## Stack

- Flutter (Web / iOS / Android)
- GetX — routing, state management
- fl_chart — statistics charts
- google_fonts — typography (Inter)
- Firebase (core/auth/firestore) — scaffolded for future backend integration

## Screens

1. Onboarding — brand hero, Get Started / Sign in
2. Home — daily goal, continue reading, quick metrics, quick start, recent books
3. Library — search, filters, book grid, Add Book modal, Book Details modal
4. Speed Reader — RSVP word-by-word reader, WPM controls, playback, session stats
5. Statistics — WPM trend, reading time, category breakdown, streak
6. Profile — account, reading goals, preferences, settings

## Run

```bash
flutter pub get
flutter run -d chrome   # or any connected device
```

## Design system

Dark, minimal, premium. Green (`#22E06F`) accents on a near-black background
(`#070A09`), used sparingly for CTAs, progress, and active states. See
`lib/core/theme/` for tokens and `lib/core/widgets/` for the shared component
library (buttons, cards, progress bars, modals, nav).
