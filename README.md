# NovaPay

A fictional wallet-app simulator, built as a Flutter app, for entertainment
and education. **It is not a real payment app**, does not move real money,
and is not affiliated with or modeled to impersonate any real bank or
payment provider.

## Why it looks the way it does

Every screen carries:
- A solid red "DEMO — NOT REAL MONEY" banner at the top and bottom
- A tiled, rotated watermark with the same text across the whole screen

Both are drawn as part of the actual widget tree (not added on top of a
screenshot afterward), so they are baked into anything exported from the
app — there is no "clean" version of any screen to crop or screenshot
around. The receipt screen specifically captures itself, banners and
watermark included, when you tap **Share Demo Receipt**.

The app also does **not** save anything between runs. Every time you close
and reopen it, you start back at the disclaimer screen and set up a fresh
demo profile. That's intentional — it keeps this a one-off toy rather than
something that persists a reusable "balance" or set of fake receipts.

## What it does

1. **Disclaimer** — explains what the app is and isn't, requires an explicit
   checkbox before continuing
2. **Setup** — pick a display name, a starting *demo* balance, and a demo PIN
3. **PIN entry** — mirrors a real wallet app's lock screen (checked only
   against the PIN you just set, nothing real behind it)
4. **Home** — shows the demo balance, with a button to send a demo transfer
5. **Transfer** — enter a recipient name, amount (capped at your demo
   balance) and an optional note
6. **Receipt** — shows the completed demo transfer and lets you share it as
   a watermarked image via the system share sheet

## Folder structure

```
novapay/
├── pubspec.yaml
├── analysis_options.yaml
├── test/
│   └── formatters_test.dart
└── lib/
    ├── main.dart
    ├── state/
    │   └── wallet_state.dart       In-memory only, never persisted to disk
    ├── screens/
    │   ├── disclaimer_screen.dart
    │   ├── setup_screen.dart
    │   ├── pin_lock_screen.dart
    │   ├── home_screen.dart
    │   ├── transfer_screen.dart
    │   └── receipt_screen.dart     Captures + shares the watermarked receipt
    ├── widgets/
    │   ├── demo_banner.dart        Solid red banner
    │   ├── watermark_overlay.dart  Tiled rotated watermark painter
    │   ├── demo_frame.dart         Combines banner + watermark around a screen
    │   ├── app_button.dart
    │   └── responsive_center.dart
    ├── theme/
    │   ├── app_theme.dart          Material 3 purple light/dark theme
    │   └── theme_controller.dart
    └── utils/
        ├── constants.dart
        └── formatters.dart
```

## Setup

**Requirements:** Flutter 3.38 or newer (Dart 3.11+).

```bash
flutter create novapay
cd novapay
```

Copy over from this package, replacing what's there:
- `lib/` (replace the whole folder)
- `pubspec.yaml`, `analysis_options.yaml`
- `test/formatters_test.dart` (delete the generated `test/widget_test.dart`)

```bash
flutter pub get
```

No Firebase and no account setup needed — this app has no backend at all.

### Platform notes

- **Android**: if the build complains, set `minSdk = 23` in
  `android/app/build.gradle(.kts)`
- **iOS**: set `platform :ios, '15.0'` in `ios/Podfile`, then run
  `pod install` inside `ios/`

### Run it

```bash
flutter run
```

### Build an installable Android APK

```bash
flutter build apk --release
```

The file appears at `build/app/outputs/flutter-apk/app-release.apk`. Send
that file to an Android phone and open it there to install (the phone will
ask you to allow installing from that source).

### Run the tests

```bash
flutter test
```

## If you want to change anything

Please keep the disclaimer, the banners, and the watermark intact and
legible — removing or weakening them turns this back into the kind of tool
that can deceive someone, which is exactly what this build was made to
avoid.
