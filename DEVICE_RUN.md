# Run ō on a device

Judge the product on a phone or emulator. You do not need to read code.

This Cloud Agent environment has **no Android SDK**. It cannot install an APK or open an emulator. Joshua’s machine (Android Studio, or a phone with USB debugging) is the judge path.

CI on a green PR uploads artifact **`o-debug-apk`** (`app-debug.apk`) for sideload.

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

First install takes a minute. Then ō opens on the living wash — jade `#2f6f5e` → baby blue `#A8D4E8` → near-white `#F7FBFD`. Not a vault. Not grey dark mode.

## 4. Tap path (what you should see)

Dennis lock: **2–3 paces from the Intention stage**. A fourth tap fails.

1. **Name** — type a local name → **Enter ō locally**. No account. No server. No fake people.
2. **Open field** — empty and personal. **Name a purpose** (one sheet). Quiet Byzantine north star. Nobody else is here. No “Load sample purposes.”
3. **Intention stage** — **Commit an intention** (one sheet) → gold **Commit this intention**. You land back on the stage, already committed. Purpose stays above as the north star.
4. **On the card** — status, statement, your name only. Gold Commit if you only Held. **Coordinate with ō** is on the card (one tap). The **ō** wisp is in the chrome (one tap). `More` is optional, not required to act.
5. **ō wisp** — gold-soft glow. Tap **ō** for a brief map. ō is not a chat destination. Not named Sam.
6. **Stub ō** — replies are labeled **STUB**. Live chat will be Grok. Not OpenAI.

Words on screen: **Purpose**, **Intention**, **Commit**. Never “plan”.

## Sideload APK (when you have an Android SDK)

Prefer the CI artifact **`o-debug-apk`** from the PR run. On Joshua’s machine, after `flutter doctor` shows the Android toolchain you can also:

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
