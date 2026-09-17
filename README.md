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
4. Register the app in Firebase and configure Google Sign-In as described below.
5. Run `flutter test` and `flutter analyze`.
6. Start the app with `flutter run` on a configured emulator or device.

The Firebase registration is required for Google OAuth configuration. This
project does not use the Firebase Flutter SDK; it uses the `google_sign_in`
package directly. Firebase still supplies the platform OAuth clients and the
Android Google Services configuration file.

## Google Sign-In configuration

Credentials and platform configuration files are intentionally not committed.
Complete the Firebase registration before building a platform that needs
Google Sign-In.

### Android

1. In [Firebase Console](https://console.firebase.google.com/), create or select a Firebase project and add an **Android app**.
2. Register the package name `com.hotelexplorer.app`, which is the current `applicationId` in `android/app/build.gradle.kts`.
3. From the `android` directory, run `./gradlew signingReport` on macOS/Linux or `gradlew.bat signingReport` in PowerShell on Windows. Add the debug SHA-1 and SHA-256 fingerprints to the Firebase Android app. Add release fingerprints before testing a signed release build.
4. In Firebase Authentication, enable the **Google** provider and add the test accounts that are allowed to sign in.
5. Download `google-services.json` from Firebase and place it at `android/app/google-services.json`. Do not rename it or place it in the repository root. The Gradle Google Services plugin is already configured in `android/settings.gradle.kts` and `android/app/build.gradle.kts`.
6. Run `flutter clean` followed by `flutter pub get`, then launch the app again.

### iOS

1. In the same Firebase project, add an **iOS app** with bundle identifier `com.hotelexplorer.app`.
2. Download `GoogleService-Info.plist` and add it to `ios/Runner` through Xcode, ensuring it is included in the Runner target.
3. Copy `CLIENT_ID` and `REVERSED_CLIENT_ID` from that plist into the `GOOGLE_CLIENT_ID` and `GOOGLE_REVERSED_CLIENT_ID` build settings used by `ios/Runner/Info.plist`.
4. Run `cd ios && pod install`, return to the project root, and launch with `flutter run` on an iOS device or simulator.

Never commit private signing keys or production secrets. Treat the Firebase configuration files as environment-specific registration artifacts and check the repository ignore rules before committing them. The application displays a useful configuration error on the login screen if credentials are missing.

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

`flutter test` and `flutter analyze` can run before Firebase registration because
the current tests do not start the native Google Sign-In flow. The debug APK
build requires `android/app/google-services.json` because the Android Gradle
plugin processes that file.

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
