# Firebase Setup

ReadSpeed is backed by a real Firebase project — **`readspeed-app`** — with
Firebase Authentication (Email/Password) and Cloud Firestore (Native mode)
enabled and in active use. This is not a scaffold: every screen except the
RSVP reading text itself (see [Known limitation](#known-limitation) below)
reads and writes real Firestore data behind real authentication.

## 1. Firebase project

Project ID: `readspeed-app`. Services enabled in the
[Firebase Console](https://console.firebase.google.com/project/readspeed-app):

* Authentication → Email/Password sign-in provider
* Cloud Firestore → Native mode, default database

## 2. FlutterFire configuration

Configuration was generated with:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=readspeed-app --platforms=android,ios,web
```

This produced, and committed to the repo (these are client identifiers, not
secrets — see [Environment configuration](#7-environment-configuration)):

* `lib/firebase_options.dart`
* `android/app/google-services.json`
* `ios/Runner/GoogleService-Info.plist`
* `firebase.json` / `firestore.rules` / `firestore.indexes.json`

`lib/main.dart` initializes Firebase before anything else runs:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 3. Authentication

Implemented in `lib/data/services/auth_service.dart` (a permanent `GetxService`
registered in `main()`) and `lib/modules/auth/`:

* **Sign up** — `AuthService.signUp()` creates the Firebase Auth user, sets
  `displayName`, then creates the `users/{uid}` Firestore document.
* **Sign in** — `AuthService.signIn()`, with a safety net that creates the
  Firestore profile if it's somehow missing (e.g. an account created directly
  in the console).
* **Sign out** — `AuthService.signOut()`.
* **Persistence** — Firebase's own web/mobile persistence keeps the session
  across restarts; `AuthGateView` (the app's initial route) waits for the
  first `authStateChanges()` emission, then routes to the shell (signed in)
  or onboarding (signed out).
* **Route protection** — `AuthGuard` (a `GetMiddleware` on the shell route)
  redirects to onboarding if `AuthService.isSignedIn` is false.
* **Errors** — `AuthService.friendlyError()` maps `FirebaseAuthException`
  codes (`wrong-password`, `email-already-in-use`, `weak-password`,
  `network-request-failed`, etc.) to short user-facing copy shown inline on
  the sign-in/sign-up forms; raw exceptions are never shown to the user.

Flow: **Onboarding → Get Started/Sign in → Firebase Auth → Home**, exactly as
specified — there is no path from onboarding straight to the app shell
anymore.

## 4. Firestore structure

```text
users/{uid}                    — profile + settings
users/{uid}/books/{bookId}     — the user's library
users/{uid}/sessions/{sessionId} — completed reading sessions
```

### `users/{uid}` — `lib/data/models/user_profile.dart`

```text
uid, displayName, email, dailyGoalMinutes, dailyWpmTarget,
defaultWpm, premium, createdAt, updatedAt
```

Created by `UserRepository.ensureProfile()` right after sign-up (and, as a
fallback, on sign-in if missing). Read/written by `HomeController`,
`ProfileController` — the Profile screen's Daily Goal / WPM Target /
Default WPM rows edit these fields directly and persist immediately.

### `users/{uid}/books/{bookId}` — `lib/data/models/book.dart`

```text
title, author, type, progress, coverStyleKey, category, pages, rating,
description, lastPositionIndex, createdAt, updatedAt
```

`coverStyleKey` replaces the old raw `Color`/`IconData` fields — Firestore
can't store an `IconData`, and free-form icons would break Flutter's icon
tree-shaking, so covers are assigned from a small fixed palette
(`BookCoverStyle.palette` in `book.dart`) and only the key is persisted.

`BookRepository` (`lib/data/repositories/book_repository.dart`) provides
`addBook`, `updateBook`, `deleteBook`, and `updateProgress`. The Library
screen's Add Book modal, book details modal (delete), and the Reader
(progress updates) all go through this repository — none of it touches
`MockData` anymore.

### `users/{uid}/sessions/{sessionId}` — `lib/data/models/reading_session.dart`

```text
bookId, wpm, accuracy, durationSeconds, wordsRead, createdAt
```

Written once by `ReaderController._finishSession()` when a reading session
completes (word index reaches the end). The same call also updates the
book's `progress` and `lastPositionIndex` via `BookRepository.updateProgress`.

## 5. Reading progress

`ReaderController.loadBook()` resumes from `book.lastPositionIndex`. Every
time playback is paused or a session finishes, `_persistProgress()` writes
the current `progress` (0..1) and `lastPositionIndex` back to
`users/{uid}/books/{bookId}`, so reopening a book from the Library resumes
where the user left off.

## 6. Statistics

`StatisticsController` (`lib/modules/statistics/statistics_controller.dart`)
streams `users/{uid}/sessions` and computes everything client-side — no
separate aggregate documents:

* Avg WPM, total minutes, words read, session count (all period-filtered:
  7/30/90 days or all time)
* WPM trend (last up to 7 sessions) and reading-time trend (last 7 calendar
  days) feed the existing `fl_chart` line/bar charts
* Category breakdown joins sessions back to their book's `category`
* Current streak and best streak, computed from distinct session days

The Statistics screen has real loading/empty states — "No reading sessions
yet" until the user finishes one in the Reader.

## 7. Environment configuration

`firebase_options.dart`, `google-services.json`, and
`GoogleService-Info.plist` all contain **client identifiers** (API keys
scoped to this Firebase project, app IDs, sender IDs) — these are meant to
ship inside the compiled app and are safe to commit; see
[Firebase's own guidance](https://firebase.google.com/docs/projects/api-keys).
Actual access control lives entirely in Firestore Security Rules and
Authentication, not in hiding these values.

Nothing else — no service-account keys, no Firebase Admin SDK credentials —
is present in this repository, and none should ever be added to the client
app.

## 8. Security rules

`firestore.rules` (deployed with `firebase deploy --only firestore:rules
--project readspeed-app`):

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;

      match /books/{bookId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }

      match /sessions/{sessionId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }
    }
  }
}
```

Everything not explicitly matched is denied by default — there is no
`allow read, write: if true` anywhere. Verified directly against the live
project via the Firestore REST API using a real user's ID token: reading
that user's own `users/{uid}` document succeeds; reading a *different*
user's document, or making any request with no auth token at all, returns
`403 PERMISSION_DENIED`.

## 9. Local development

```bash
flutter pub get
flutter run -d chrome        # or: flutter devices / flutter run -d <id>
```

Every developer using this repo talks to the same `readspeed-app` project —
there's no per-developer Firebase project or emulator suite configured. If
you need an isolated backend for local testing, run the
[Firestore emulator](https://firebase.google.com/docs/emulator-suite) and
point `FirebaseFirestore.instance.useFirestoreEmulator(...)` at it in
`main()`; this isn't currently wired up.

## 10. Architecture

```text
UI (modules/*/*.dart)
  ↓
GetX Controllers (modules/*/**_controller.dart)
  ↓
Repositories (data/repositories/*.dart)
  ↓
Firebase Auth / Cloud Firestore
```

`AuthService` is the one piece registered as a permanent `GetxService`
(everything else is scoped to its screen via `Get.put()` in the view, same
pattern as before Firebase). Repositories are plain classes with no GetX
dependency — they just wrap `FirebaseAuth`/`FirebaseFirestore` calls, so
they're trivial to unit test or swap out later.

## Known limitation

The Speed Reader doesn't ingest real book content — there's no PDF/EPUB
import yet, so every book (regardless of title) is read against the same
built-in sample paragraph (`MockData.sampleParagraph`). Progress, WPM, and
sessions are all real and per-book; only the *text being read* is shared
placeholder content until a content-import feature exists.

## Future extensions

* Real book content import (PDF/EPUB/text paste)
* Social sign-in providers (Google, Apple)
* Cloud Functions for server-side stats rollups at scale
* Firestore composite indexes if statistics queries grow beyond simple
  single-field ordering
* Cross-device sync is already implicit (same `users/{uid}` doc everywhere)
  — no further work needed there
