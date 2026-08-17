# Firebase Setup

The app already depends on `firebase_core`, `firebase_auth`, and
`cloud_firestore` (see `pubspec.yaml`), and `main.dart` calls
`Firebase.initializeApp()` inside a `try/catch` so the app runs fine on
mock data even with no Firebase project configured. This doc covers
turning that scaffold into a real backend.

## 1. Create a Firebase project

1. Go to the [Firebase console](https://console.firebase.google.com/)
   and create a project (e.g. `readspeed-app`).
2. Enable **Authentication** (Email/Password and/or Google Sign-In —
   matches the "Sign in" button on the Onboarding screen).
3. Enable **Cloud Firestore** in production mode.

## 2. Install the FlutterFire CLI and configure

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and registers the
web/iOS/Android apps in your Firebase project. It's gitignored-free by
default — commit it, it contains public client config, not secrets.

Then update `main.dart`:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 3. Suggested Firestore schema

```
users/{uid}
  displayName, email, dailyGoalMinutes, dailyWpmTarget, defaultWpm,
  premium: bool

users/{uid}/books/{bookId}
  title, author, type, progress, coverColor, category, pages, rating,
  description, updatedAt

users/{uid}/sessions/{sessionId}
  bookId, wpm, accuracy, durationSeconds, wordsRead, createdAt
```

Statistics (`lib/modules/statistics`) can then be computed from
`users/{uid}/sessions` instead of `MockData.wpmTrend` /
`MockData.readingTimeTrend`.

## 4. Auth wiring

Replace the `Get Started` / `Sign in` handlers in
`lib/modules/onboarding/onboarding_view.dart` with real
`FirebaseAuth.instance` calls, and gate `AppRoutes.shell` behind an
auth-state listener (e.g. a `StreamBuilder` on
`FirebaseAuth.instance.authStateChanges()` in `main.dart`, or a
`GetMiddleware` on the shell route).

## 5. Local dev without a live project

You don't need any of the above to run the app — `flutter run` works
today against `MockData`. Treat Firebase as additive: wire up one
collection at a time (start with `users/{uid}/books`) and fall back to
mock data if a read fails, so the UI never breaks mid-migration.
