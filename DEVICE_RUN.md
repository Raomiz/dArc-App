# Run ō on a device

Judge the product on a phone or emulator. You do not need to read code.

This Cloud Agent environment has **no Android SDK**. It cannot install an APK or open an emulator. Joshua’s machine (Android Studio, or a phone with USB debugging) is the judge path.

## 1. Doctor

From the repo root, on a machine that has Flutter **and** the Android SDK:

```bash
flutter doctor
```

You want a check mark on **Flutter** and **Android toolchain**. If Android SDK is missing, install Android Studio, open it once so it installs the SDK, then:

```bash
flutter config --android-sdk "$HOME/Android/Sdk"
flutter doctor
```

## 2. Device

Start an emulator from Android Studio **or** plug in a phone and accept USB debugging.

```bash
flutter devices
```

You should see an Android emulator or a physical device.

## 3. Run

```bash
flutter pub get
flutter run -d android
```

First install takes a minute. Then ō opens on the vault ground (`#0c0712`), not a grey dark mode.

## 4. Tap path (what you should see)

1. **Name** — type a local name → **Enter ō locally**. No account. No server.
2. **Purpose** — **Load sample purposes** (or **Name a purpose**). Byzantine purple cards. Open **Get outside this week**.
3. **Commit intention** — open **Evening walk** → gold **Commit this intention** (burst + haptic). That is a threshold, not a bland submit.
4. **Sam wisp** — gold-soft glow in the chrome. Tap **Sam** for a brief map. Sam is not a chat.
5. **Stub ō** — **Coordinate with ō**. Replies are labeled **STUB**. Live chat will be Grok. Not OpenAI.

Words on screen: **Purpose**, **Intention**, **Commit**. Never “plan”.

## Sideload APK (when you have an Android SDK)

This environment cannot do this step. On Joshua’s machine, after `flutter doctor` shows the Android toolchain:

```bash
flutter build apk --debug
```

APK path:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Copy that file to a phone and install it (allow install from this source). Same tap path as above.

A release APK needs a signing key. Do not invent Play Billing or a store listing.

## If something is missing

| Symptom | Fix |
| --- | --- |
| `Unable to locate Android SDK` | Install Android Studio, then `flutter config --android-sdk` |
| `flutter devices` is empty | Start an emulator, or enable USB debugging and accept the prompt |
| `flutter: command not found` | Install Flutter stable 3.47.x / Dart 3.13 and add it to `PATH` |
