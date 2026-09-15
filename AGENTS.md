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
Do **not** seat ō as a Field watch. That was the wrong product (see GitHub PR #1, superseded).  
Do **not** treat this repo as d-arc.io.

A misplaced atlas export was removed from this tree. Git history still has it. Leave it in history; do not resurrect it as the product.

## House products

- **ō** — this repo. Native social + coordinator.
- **Raz** — equal house product, different repo. Do not grind Unreal here.

Joshua (founder) uses ō later as a person in the app, not as atlas-owner chrome.

## Language

- User-facing words: **Purpose**, **Intention**, **Commit**. Never “plan”.
- **ō** is the in-app navigator (ambient gold-soft wisp) and the coordinator. Not a game creature, not Raz, not a person on an intention unless the user types that name. Never show **Sam** as chrome.
- In-app chat is **Grok**. Do not wire OpenAI / GPT.
- Visuals when you touch UI — Dennis locks, do not invent a grey dark mode:
  - Field (living wash): jade `#2f6f5e` → baby blue `#A8D4E8` → near-white `#F7FBFD`
  - Not an obsidian vault. Never `#050505`, `#0c0712`, or flat dark-mode grey
  - Surfaces/cards: light and airy on that field
  - Purpose: Byzantine `#702963` / deep `#3a1540` — quiet north star, accent only
  - Intention: jade `#2f6f5e` / lit `#7dba9a` — the main stage
  - Commit: gold threshold `#c9a227` / soft `#e6d08a` — burst + haptic, not a bland submit
  - ō: ambient gold-soft wisp, not a chat destination. User-facing presence is **ō**, not Sam.
  - Type: system UI sans for chrome; whisper tracked labels; big contrast on Commit
  - No placeholder humans / fake cast. Empty or the local session name until real presence exists.
  - **2–3 paces from main:** Intention is the stage. Purpose, Commit, ō, and feed evidence must be reachable in at most three taps. Secondary is one sheet out. A fourth pace fails. No deeper stacks. No buried settings for primary actions.

## Stack

- Flutter, Android ship target (`applicationId` / namespace `io.darc.o`)
- Dart package name `darc_o`
- Local session + local purposes / intentions only in this slice
- Companion: `lib/data/o_companion.dart` — `OCompanion` interface, `StubOCompanion` implementation

## Do not

- Invent payment backends, Play Billing, or store listings
- Commit live AI API keys or pretend stub replies are a model
- Add auth servers, Google sign-in, or world-writable shared databases unless the ask is explicitly accounts
- Port the atlas Cycle / Site / Field table into Flutter

## When you extend ō

Keep the thesis: **people acting together**. A feed of private thinking belongs on the atlas, not here. A live coordinator must stay behind `OCompanion`, remain user-initiated, stay on Grok, and stay clearly labeled until it is real.
