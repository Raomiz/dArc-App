# ō

This repository is the **ō** mobile app.

ō is an **Android-first native social app centred on action**.  
ō is also the **AI** that helps users coordinate inside the app.

Read this before writing code.

## Not the atlas

The d’ Arc private atlas (purposes, intentions, founder monitor) is a **separate** surface:

- House store: `Raomiz/d-Arc`
- Public door: `d-arc.io`

Do **not** rebuild a TanStack / Grok atlas here.  
Do **not** seat ō as a Field watch. That was the wrong product (see GitHub PR #1).  
Do **not** treat this repo as d-arc.io.

A misplaced atlas export was removed from this tree. Git history still has it. Leave it in history; do not resurrect it as the product.

## House products

- **ō** — this repo. Native social + coordinator.
- **Raz** — equal house product, different repo. Do not grind Unreal here.

Joshua (founder) uses ō later as a person in the app, not as atlas-owner chrome.

## Stack

- Flutter, Android ship target (`applicationId` / namespace `io.darc.o`)
- Dart package name `darc_o`
- Local session + local actions only in this slice
- Companion: `lib/data/o_companion.dart` — `OCompanion` interface, `StubOCompanion` implementation

## Do not

- Invent payment backends, Play Billing, or store listings
- Commit live AI API keys or pretend stub replies are a model
- Add auth servers, Google sign-in, or world-writable shared databases unless the ask is explicitly accounts
- Port the atlas Cycle / Site / Field table into Flutter

## When you extend ō

Keep the thesis: **people acting together**. A feed of private thinking belongs on the atlas, not here. A live coordinator must stay behind `OCompanion`, remain user-initiated, and stay clearly labeled until it is real.
