# ReadSpeed

**Read Faster. Understand Better.**

<img width="1254" height="1254" alt="4D6FADEE-9EC6-46D3-8BAE-7D0B33137E38" src="https://github.com/user-attachments/assets/8e878761-b024-4937-8fab-26d32d3a5056" />  

---

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

## Documentation

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — folder structure, state
  management approach, how screens/modals/routing fit together
- [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md) — turning the Firebase
  scaffold into a real backend (project setup, Firestore schema, auth wiring)
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — dev setup, pre-PR checklist, coding
  conventions

## Screenshots 

<img width="1536" height="1024" alt="FC5EB062-132B-4C7F-9273-C5D116BB75B6" src="https://github.com/user-attachments/assets/5201fc22-4ae0-4515-a4c7-fcd796507064" /> 

<img width="1536" height="1024" alt="A67FC194-2B36-47C4-B813-B732E8AAEE19" src="https://github.com/user-attachments/assets/101ab828-eab4-4163-8bf9-57be8bf8435c" />

<img width="1536" height="1024" alt="39DD9BBC-3F2C-4CB3-AF34-995C4860574B" src="https://github.com/user-attachments/assets/0a23bce6-6b12-4726-8c35-c73d187b1f0b" />



## License

MIT — see [`LICENSE`](LICENSE).
