# ReadSpeed — Architecture

## Overview

ReadSpeed is a Flutter app using **GetX** for routing and state management.
It targets Web, iOS, and Android from a single codebase, with a responsive
shell that swaps between a desktop sidebar and a mobile bottom nav.

## Folder structure

```
lib/
  core/
    theme/            App-wide design tokens (colors, text styles, ThemeData)
    widgets/           Shared, reusable UI components
  data/
    models/            Plain Dart models (Book, etc.)
    mock/               Mock/local data used until a real backend is wired up
  modules/
    onboarding/         Screen 1 — brand hero, Get Started / Sign in
    shell/              App shell: sidebar (desktop) / bottom nav (mobile)
    home/               Screen 2 — daily goal, continue reading, quick metrics
    library/            Screen 3 — search, filters, book grid
      widgets/          Add Book modal, Book Details modal
    reader/             Screen 4 — the Speed Reader (RSVP)
      widgets/          Reader Settings modal, Reading Complete modal
    statistics/         Screen 5 — charts and streak
    profile/            Screen 6 — account, goals, preferences, settings
  routes/               GetX route table (AppRoutes / AppPages)
  main.dart             Entry point, Firebase bootstrap, GetMaterialApp
```

Each screen module follows the same shape: a `*_controller.dart`
(`GetxController`, holds state and business logic) and a `*_view.dart`
(the widget tree, reads state via `Obx`/`GetBuilder`). Modals live in a
`widgets/` subfolder next to the screen that opens them, since they are
opened as bottom sheets rather than routed pages.

## State management

- `GetxController` + `.obs` reactive fields for anything that changes at
  runtime (WPM, playback position, filters, search text, active tab).
- `Get.put()` registers a controller once per screen; `ShellController`
  is the exception — it's shared across the whole shell to drive
  navigation from anywhere (e.g. "Start Reading" jumps to the Reader tab
  from Home or from a Book Details modal).
- No routed navigation is used *between* the six main screens — they are
  siblings in an `IndexedStack` inside `ShellView`, switched by
  `ShellController.tabIndex`. This keeps tab switches instant and
  preserves each screen's scroll position / state. Modals (`AppModal`,
  `showModalBottomSheet`) are the only overlay/routing mechanism.

## Design system

All colors, spacing, and typography come from `lib/core/theme/`. Do not
hardcode colors in a screen — add a token to `AppColors` /
`AppTextStyles` instead so the whole app stays consistent. Reusable
components (`AppCard`, `MetricCard`, `StatCard`, `BookCard`,
`PrimaryButton`, `SecondaryButton`, `AppModal`, `SettingsRow`, chart
wrappers) live in `lib/core/widgets/` — extend those rather than
building one-off UI in a screen file.

## Mock data → real backend

`lib/data/mock/mock_data.dart` is the single source of mock content
(books, WPM trend, category breakdown). When wiring up a real backend,
replace calls to `MockData.*` with repository/service calls behind the
same shapes (`Book`, etc.) so the UI layer doesn't need to change. See
`docs/FIREBASE_SETUP.md` for how the Firebase scaffold is meant to slot
in.
