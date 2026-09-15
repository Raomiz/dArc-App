# ō

**ō** is an Android-first native social app centred on **action**.

ō is also the **AI companion** inside the app — the coordinator that helps people lock a time, gather others, and actually move. Joshua (founder) is a user of that companion later; ō is not a private atlas.

This repository is the mobile product. It is **not** the d’ Arc private atlas, and it is **not** d-arc.io.

## Product truth

| This repo | Not this repo |
| --- | --- |
| ō — Flutter, Android-first | Private atlas / founder monitor: [Raomiz/d-Arc](https://github.com/Raomiz/d-Arc) and [d-arc.io](https://d-arc.io) |
| Social + action. Purpose and Intention you do with other people | A Field watch on an atlas table |
| ō the app **and** ō the coordinator (live chat: Grok) | Raz (equal house product, separate repo) |

A TanStack / Grok atlas export landed here by mistake. That tree is gone. Do not rebuild it. PR #1 (seat ō as a Field watch) was the wrong product direction and is superseded.

## What this scaffold ships

A thin vertical slice, not a social network:

1. **Local session** — a name on this device. No accounts, no auth backend. No fake cast.
2. **Purpose** — the stage (**New Purpose**, Byzantine purple). Selected Purpose expands at centre and holds its work inside. Unselected Purposes are satellites.
3. **Intention** — follows from that north star (jade), inside the expanded Purpose. What you commit to do. Never “plan”.
4. **Commit** — gold threshold (`#c9a227`), burst + haptic. Not a bland submit.
5. **ō** — ambient gold-soft wisp navigator and coordinator. Not a game creature. Not Raz. Not a chat destination. Not named Sam on screen.
6. **ō coordinator** — `OCompanion` interface with `StubOCompanion`. Replies are mock and labeled **STUB**. When live, in-app chat is **Grok**. No API keys. No OpenAI / GPT.

Package / application id: `io.darc.o`  
Dart package name: `darc_o`  
UI copy uses **ō**.

Locked colour (Dennis — Day 2 field is living wash, not a vault):

| Token | Hex | Use |
| --- | --- | --- |
| Field jade | `#2f6f5e` | Living wash start |
| Field blue | `#A8D4E8` | Soft baby blue wash |
| Field air | `#F7FBFD` | Near-white air |
| Surface | `#ffffff` | Light airy cards on the field |
| Purpose | `#702963` / `#3a1540` | Byzantine / deep — accent, north star |
| Intention | `#2f6f5e` / `#7dba9a` | Jade / lit — lives inside the Purpose |
| Commit | `#c9a227` / `#e6d08a` | Gold threshold / soft |

iOS project files exist because Flutter generates them. **Android is the ship target.**

## Requirements

- Flutter stable (this tree targets **3.47.x** / Dart **3.13**)
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

Shortest judge path (doctor → device → tap): **[DEVICE_RUN.md](DEVICE_RUN.md)**.

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

First launch: enter a local name → **New Purpose** (the land, one sheet) → the Purpose expands at centre → **Commit an intention** (inside that Purpose, one sheet) → gold **Commit this intention**. **Coordinate with ō** and the **ō** wisp stay within three taps. Other Purposes sit as satellites. Nobody else is invented. The ō panel is a stub. That is honest.

Dennis lock: Purpose is the stage. Intention follows inside it. Everything useful is **2–3 paces**. A fourth pace fails.

Release / Play / payments are out of scope. Do not invent a store backend here.

## Next slice

After this scaffold:

1. Live ō behind `OCompanion`, user-initiated, labeled until it is real. Provider is **Grok**.
2. Shared people / real yeses — still no auth server unless accounts are the ask.

Not next: atlas Field watches, Raz / Unreal, Play Billing, pocket-demo-of-atlas.

## Layout

```text
lib/                 app, theme, models, local state, ō interface
android/             applicationId io.darc.o
ios/                 generated; not the ship target
test/                companion stub, local state, gate → purpose → intention → ō
AGENTS.md            law for agents: this repo is ō, atlas lives elsewhere
docs/ATLAS.md        why the web atlas was removed
DEVICE_RUN.md        shortest path to judge ō on a phone
```

## House

ō and Raz are equal house products. This repository is only ō.
