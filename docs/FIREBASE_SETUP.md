# Firebase Setup

ReadSpeed uses Firebase as its backend infrastructure for authentication, user data, reading activity, and application persistence.

The Firebase integration is designed around a user-scoped Firestore architecture, ensuring that each user's profile, library, reading progress, and reading sessions remain isolated and securely accessible.

## 1. Firebase Project

Create a Firebase project from the [Firebase Console](https://console.firebase.google.com/) and configure the following services:

* Firebase Authentication
* Cloud Firestore

The project should have the following platform applications configured:

* Web
* iOS
* Android

## 2. FlutterFire Configuration

Install the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Configure the Flutter project:

```bash
flutterfire configure
```

Select the ReadSpeed Firebase project and configure the supported platforms.

This generates:

```text
lib/firebase_options.dart
```

The generated configuration contains Firebase client identifiers and is safe to include in the application repository. Firebase security is enforced through Authentication and Firestore Security Rules rather than by hiding client configuration.

Initialize Firebase before starting the application:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 3. Authentication

ReadSpeed uses Firebase Authentication to manage user identity and application access.

The initial authentication flow supports:

* Account registration
* Email/password sign-in
* Sign-out
* Persistent authentication state
* Authentication state restoration

The application protects authenticated routes and prevents unauthenticated users from accessing private application data.

Authentication state is managed through Firebase Auth and integrated with the existing GetX navigation architecture.

## 4. Firestore Architecture

ReadSpeed uses a user-scoped Firestore structure:

```text
users/{uid}
├── books/{bookId}
└── sessions/{sessionId}
```

### User Profile

```text
users/{uid}
```

Stores account and reading preferences:

```text
uid
displayName
email
dailyGoalMinutes
dailyWpmTarget
defaultWpm
premium
createdAt
updatedAt
```

### Books

```text
users/{uid}/books/{bookId}
```

Stores the user's personal reading library:

```text
title
author
type
progress
coverColor
category
pages
rating
description
lastPosition
updatedAt
```

### Reading Sessions

```text
users/{uid}/sessions/{sessionId}
```

Stores completed reading sessions:

```text
bookId
wpm
accuracy
durationSeconds
wordsRead
createdAt
```

## 5. Reading Progress

Reading progress is persisted per user and per book.

The application stores the latest reading position and progress so users can continue reading from their previous session.

Progress updates are associated with the authenticated user's UID and are isolated from other users.

## 6. Statistics

Reading statistics are derived from persisted reading sessions rather than static application data.

The Statistics module can calculate:

* Average WPM
* Reading time
* Words read
* Reading streak
* WPM trends
* Reading-time trends
* Category distribution
* Daily and weekly reading activity

This allows statistics to reflect the user's actual reading history.

## 7. Security

Firestore data is protected using Firebase Authentication and Firestore Security Rules.

Users should only be able to access documents belonging to their own UID.

Conceptually:

```text
Authenticated user
        ↓
Firebase Authentication
        ↓
UID
        ↓
users/{uid}/...
        ↓
User-specific data
```

Firestore rules should reject unauthorized access to another user's profile, books, or reading sessions.

Never use unrestricted rules such as:

```text
allow read, write: if true;
```

## 8. Application Architecture

Firebase access is kept separate from the presentation layer.

The application follows a layered approach:

```text
UI
 ↓
GetX Controllers
 ↓
Repositories
 ↓
Firebase Services
 ↓
Firebase Authentication / Cloud Firestore
```

This separation keeps Firebase-specific implementation details out of the UI and makes the application easier to maintain and extend.

## 9. Environment Configuration

Firebase client configuration is generated through FlutterFire and maintained per supported platform.

Do not hard-code private credentials, service-account keys, or administrative Firebase credentials inside the Flutter application.

Sensitive server-side credentials must never be included in the client application.

## 10. Local Development

Install project dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For Web:

```bash
flutter run -d chrome
```

For a connected mobile device or simulator:

```bash
flutter devices
flutter run -d <device-id>
```

## 11. Firestore Data Principles

The backend follows several core principles:

* User data is scoped by authenticated UID.
* Reading activity is persisted as individual sessions.
* Book progress is stored independently from reading sessions.
* Statistics are derived from historical reading activity.
* Authentication controls access to private data.
* Firestore Security Rules enforce data ownership.

## 12. Future Extensions

The Firebase architecture is designed to support future ReadSpeed features including:

* Social sign-in providers
* Cloud Functions
* AI-powered reading insights
* Personalized recommendations
* Subscription and premium features
* Cross-device synchronization
* Advanced reading analytics
