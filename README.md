# Hotel Explorer

A Flutter mobile app that authenticates with Google, downloads the supplied hotel feed, and presents list, detail, and interactive map views. State and dependency injection are managed with Riverpod.

## Features

- Google OAuth sign-in, lightweight session restoration, and sign-out
- Riverpod state management
- Typed hotel model with strict response validation
- Dio client with connection and receive timeouts
- Pull-to-refresh plus loading, empty, retry, and authentication error states
- Cached responsive images with graceful fallbacks
- Hotel detail screen with address, phone, description, and Hero transition
- Interactive OpenStreetMap view with a hotel marker and attribution
- Material 3 UI that adapts to phone/tablet width and text scaling

## Requirements

- Flutter 3.44.4 or newer stable release
- Dart 3.12.2 or newer
- Android Studio/Xcode and a configured device or simulator
- A Google Cloud/Firebase OAuth client for each target platform

## New-machine setup

1. Clone the repository and enter this directory.
2. Run `flutter doctor` and resolve platform toolchain warnings.
3. Run `flutter pub get`.
4. Configure Google Sign-In as described below.
5. Run `flutter test` and `flutter analyze`.
6. Start the app with `flutter run`.

## Google Sign-In configuration

Credentials are intentionally not committed.

### Android

1. Create an Android OAuth client for this app in Google Cloud Console or Firebase.
2. Register the Android package name from `android/app/build.gradle.kts` and the SHA-1/SHA-256 fingerprints of your signing certificate (`./gradlew signingReport` from `android`).
3. Download `google-services.json` to `android/app/` and complete the standard Firebase Google Services Gradle setup, or provide the matching web client ID using the platform configuration supported by `google_sign_in`.
4. Enable Google as a sign-in provider and add each developer/release signing fingerprint.

### iOS

1. Create an iOS OAuth client for the bundle identifier in Xcode.
2. Add the client ID and reversed client ID URL scheme to `ios/Runner/Info.plist` following the `google_sign_in_ios` setup instructions.
3. If using Firebase, place `GoogleService-Info.plist` in `ios/Runner` through Xcode so it is part of the Runner target.

Never commit production OAuth secrets or private signing keys. The application displays a useful configuration error on the login screen if credentials are missing.

## How to test

- Launch the app and verify the login screen appears.
- Tap **Continue with Google**, select a test account, and confirm no password is shown in any recording.
- Confirm the list shows image, title, and address for each hotel.
- Pull down to refresh.
- Tap a hotel and verify its large image, title, address, phone number, and description.
- Tap the map action in the app bar or **View on map** and verify the map centers on the supplied coordinates with a labelled marker.
- Open the account menu and sign out; verify the login screen returns.
- Disable networking to verify image placeholders and the retry state.

Automated checks:

```sh
flutter analyze
flutter test
flutter build apk --debug
```

## Architecture

Code is grouped by feature under `lib/features`. Authentication and hotels each isolate data/integration code from presentation code. Repositories are exposed through Riverpod providers, which allows tests to override Google authentication and HTTP data sources without changing widgets. Domain parsing is kept out of UI components.

## Assumptions

- The API's `status: 200` and `data` list define a successful response.
- Latitude and longitude strings are valid geographic coordinates and should be shown as supplied, even when they point to remote locations.
- Login remains restored when the Google SDK has a valid cached session.
- OpenStreetMap is acceptable for the map requirement and avoids distributing a second API key.

## Improvements made

- The feed references obsolete, insecure `http://lorempixel.com` images. The app first upgrades them to HTTPS and uses a deterministic per-hotel HTTPS fallback if the legacy service is unavailable.
- Added request timeouts, strict JSON parsing, friendly failures, retry, pull-to-refresh, cached images, and map attribution.
- Used current compatible package versions and Material 3 components.

## Recording note

Record from the initial login screen through Google's account chooser, list, detail, map, refresh, and sign-out. Use a prepared test account/account chooser and do not type or expose a password in the recording.
