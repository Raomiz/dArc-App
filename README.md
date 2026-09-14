# ō

**ō** is an Android-first native social app centred on **action**.

ō is also the **AI companion** inside the app — the coordinator that helps people lock a time, gather others, and actually move. Joshua (founder) is a user of that companion later; ō is not a private atlas.

This repository is the mobile product. It is **not** the d’ Arc private atlas, and it is **not** d-arc.io.

## Product truth

| This repo | Not this repo |
| --- | --- |
| ō — Flutter, Android-first | Private atlas / founder monitor: [Raomiz/d-Arc](https://github.com/Raomiz/d-Arc) and [d-arc.io](https://d-arc.io) |
| Social + action. Intents you do with other people | A Field watch on an atlas table |
| ō the app **and** ō the coordinator | Raz (equal house product, separate repo) |

A TanStack / Grok atlas export landed here by mistake. That tree is gone. Do not rebuild it. PR #1 (seat ō as a Field watch) is the wrong product direction.

## What this scaffold ships

A thin vertical slice, not a social network:

1. **Placeholder session** — a local name on device. No accounts, no auth backend.
2. **Home for actions / intents** — empty state, sample actions, compose.
3. **ō coordinator** — `OCompanion` interface with `StubOCompanion`. Replies are mock and labeled **STUB**. No API keys. No live model.

Package / application id: `io.darc.o`  
Dart package name: `darc_o`  
UI copy uses **ō**.

iOS project files exist because Flutter generates them. **Android is the ship target.**

## Requirements

- Flutter stable (this tree was created on **3.47.x** / Dart **3.13**)
- Android SDK + an emulator or a device (USB debugging)

```bash
flutter doctor
```

## Verify

From the repo root:

```bash
flutter pub get
flutter analyze
flutter test
```

All three should be clean.

## Run on Android

1. Start an emulator from Android Studio **or** plug in a device and accept debugging.
2. Confirm Flutter can see it:

   ```bash
   flutter devices
   ```

3. Install and run:

   ```bash
   flutter run
   ```

   Or target Android explicitly:

   ```bash
   flutter run -d android
   ```

First launch: enter a local name → empty home → **Start an action** or **Load sample actions** → open one → **Coordinate with ō**. The panel is a stub. That is honest.

Release / Play / payments are out of scope. Do not invent a store backend here.

## Layout

```text
lib/                 app, theme, models, local state, ō interface
android/             applicationId io.darc.o
ios/                 generated; not the ship target
test/                companion stub, local state, gate → action → ō path
AGENTS.md            law for agents: this repo is ō, atlas lives elsewhere
docs/ATLAS.md        why the web atlas was removed
```

## House

ō and Raz are equal house products. This repository is only ō.
