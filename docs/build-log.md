# Build log — how this app was built, commit by commit

Field Notes was built **test-first (TDD)**, from the inside out. This file
is the map: every feature, the layer it belongs to, and — where it
matters — the popular Flutter framework it introduced.

If you only read one doc to judge *how* this was made, read this one.

> Commit names below are a snapshot of the history as of **2026-07-10**.
> They describe the intent of each step; if the branch is ever rebased,
> read them as the story, not as exact hashes.

---

## The commit rhythm

Features arrive in pairs, never in one lump:

| Commit | Adds |
|---|---|
| 🔴 `test: …` | a check that fails because the feature doesn't exist yet |
| 🟢 `feat: …` | the least code that makes that check pass |
| 🔵 `refactor: …` | tidies code while the tests stay green |
| `chore/ci/docs:` | setup, plumbing, documentation (non-TDD) |

So a feature is always **🔴 describe it as a test → 🟢 make it real.** Read the
history and you can watch each behaviour be specified, then satisfied.

## The build order (inside out)

Nothing is built until something above it needs it, so each layer only
depends on the ones below:

```
① The Note        the basic shape of a note
② Persistence     save notes on the phone            (Drift)
③ The brain       offline-first rules
④ Serialization   notes ↔ JSON
⑤ Networking      the real HTTP client               (dio)
⑥ Wiring          connect the pieces                 (Riverpod)
⑦ Screens         what you tap and see
⑧ A11y + theming  banners, colours, dark mode
⑨ Safety nets     golden test, end-to-end test, crash-catchers
```

The riskiest logic — the offline-first brain — is built and proven early,
before any screen sits on top of it.

---

## Every feature, by layer

### 🏗️ Setup — *non-TDD*
- `chore: scaffold the Flutter app` → the empty project
- `chore: strict lints and a clean slate` → **very_good_analysis** rules; demo removed
- `ci: format, analyze, and test on every push` → CI re-runs everything on each change

### ① The Note
- 🔴🟢 `add the Note value object` → the note's shape (id, text, date, status) + value equality
- 🔴🟢 `add Note.copyWith` → make a modified copy (flip a note's sync status)

### ② 💾 Persistence — Drift database
> **Framework: Drift** — a local, reactive SQL database. Goal: keep notes on
> the device and *stream* changes so the UI updates itself.
- 🔴🟢 `persist notes in a Drift database` → the on-device database
- 🔴🟢 `upsert notes with insert-or-replace` → save a note / update it in place
- 🔴🟢 `order watched notes newest first` → newest note on top
- 🔴🟢 `delete a note by id` → remove one note
- 🔴🟢 `query pending rows and all rows` → the queues the sync engine reads
- `chore: satisfy the linter in the database tests` → *(non-TDD tidy)*

### ③ 🧠 The brain — offline-first logic
> The rules that coordinate phone and server. The biggest, most important
> chunk — and it depends on no UI.
- 🔴🟢 `create notes offline-first` → save to the phone instantly
- 🔴🟢 `guard the empty-note invariant` → refuse blank notes
- 🔴🟢 `upload pending notes through the NoteApi seam` → push a note to the server
- 🔴🟢 `skip syncing while offline` → don't try with no internet
- 🔴🟢 `sync in the background after a create` → auto-sync when you write
- 🔴🟢 `delete a never-synced note locally` → an unsynced note just vanishes
- 🔴🟢 `tombstone synced deletions and hide them` → hide now, mark for server removal
- 🔴🟢 `flush tombstoned deletions during sync` → actually delete it on the server
- 🔴🟢 `pull unknown server notes during sync` → download notes the phone hasn't seen
- 🔴🟢 `serialize sync passes so nothing runs twice` → never do the same work twice
- 🔴🟢 `report sync failures instead of swallowing them` → surface errors, don't hide them
- 🔴🟢 `sync on reconnect and at startup, dispose cleanly` → auto-catch-up + clean shutdown

### ④ 📦 Serialization
- 🔴🟢 `serialize notes to JSON with a DTO` → note → the JSON the server speaks
- 🔴🟢 `parse server JSON into domain notes` → JSON → note (marked synced)

### ⑤ 🌐 Networking — dio
> **Framework: dio** — the standard HTTP client. Goal: talk to the server.
> Built against a recording interceptor, so no live server is needed to test.
- 🔴🟢 `POST notes with a dio HTTP client` → send a note over real HTTP
- 🔴🟢 `GET and map the server's notes` → fetch notes from the server
- 🔴🟢 `skip malformed records when pulling` → one bad note can't break a sync
- 🔴🟢 `DELETE notes on the server` → remove a note remotely
- 🔴🟢 `translate dio failures into ApiExceptions` → crashes → friendly messages
- 🔵 `refactor: extract the dio error mapper and a guard` → *(cleanup, no behaviour change)*

### ⑥ 🔌 Wiring — Riverpod
> **Framework: Riverpod** — the leading modern state-management + dependency-
> injection framework (chosen over Bloc / Provider / GetX). Goal: hold app
> state, rebuild the UI reactively, and wire dependencies so tests can swap
> any of them.
- 🔴🟢 `wire the app with a Riverpod DI graph` → the wiring diagram of the app
- 🔴🟢 `stream notes through the list view model` → the list screen's data feed
- 🔴🟢 `delete notes from the list view model` → the list's delete action
- 🔴🟢 `start the create view model idle` → the create screen's starting state
- 🔴🟢 `save notes through the create view model` → the Save action
- 🔴🟢 `ignore a save already in flight` → no accidental double-save

### ⑦ 📱 Screens
> Built with **flutter_test**'s widget tester — real frames, real taps.
- 🔴🟢 `render a note as a list item` → a note row (text + Pending/Synced)
- 🔴🟢 `show the notes list and empty state` → the list + "No notes yet"
- 🔴🟢 `show an error state instead of a stuck spinner` → a real error message
- 🔴🟢 `add the create-note screen` → the type-and-Save screen
- 🔴🟢 `pop on save, warn on failure` → returns to the list, warns if it fails
- 🔴🟢 `open the create screen from the list` → the **+** button
- 🔴🟢 `delete a note from the list` → the 🗑️ button

### ⑧ ♿ Accessibility + 🎨 theming
- 🔴🟢 `announce an offline banner` → a screen-reader-friendly offline banner
- 🔴🟢 `warn on a failed background sync` → a screen-reader-friendly error banner
- 🟢 `theme the app and wire it together` → colours + dark mode + the app assembled
  *(green-only: theming is visual, so there is no unit-test red)*

### ⑨ ✅ Safety nets & proof
> Two more testing frameworks close the loop.
- 🔴🟢 `pin the list item with an Alchemist golden` → **Alchemist**: a saved
  "photo" of the row that catches accidental visual changes
- 🔴🟢 `verify the create flow end to end` → **integration_test**: drives the
  whole app like a user (type → save → see it appear)
- 🔴🟢 `catch every uncaught error and lock portrait` → crash-catchers + portrait lock

### 📚 Finishing — *non-TDD*
- `ci: gate coverage at 85% on hand-written source` → tests must cover 85%+ or CI fails
- `docs: README, build guide, decisions, and checklist` → the written docs
- `chore: apply dart format` → final formatting pass

---

## Frameworks at a glance

| Framework | Category | Introduced in | Goal |
|---|---|---|---|
| **Riverpod** | State management + DI | ⑥ `Riverpod DI graph` | App state, reactive UI, swappable dependencies |
| **Drift** | Local database | ② `persist notes in a Drift database` | Save notes on the device, stream changes |
| **dio** | HTTP networking | ⑤ `POST notes with a dio HTTP client` | Talk to the server (POST/GET/DELETE) |
| **build_runner** | Code generation | behind every `.g.dart` | Generate boilerplate for Drift + Riverpod |
| **Alchemist** | Golden testing | ⑨ `Alchemist golden` | Catch accidental visual changes |
| **integration_test** | End-to-end testing | ⑨ `create flow end to end` | Drive the whole app like a user |
| **flutter_test** | Unit + widget testing | every 🔴 `test:` | The checks that make TDD possible |
| **very_good_analysis** | Linting | `chore: strict lints` | Enforce code quality on every commit |

## Totals

| Type | Count | Meaning |
|---|---|---|
| 🔴 + 🟢 pairs | ~44 | a test, then the code that satisfies it |
| 🟢 solo | 1 | theming (visual, not unit-tested) |
| 🔵 refactor | 1 | cleanup, behaviour unchanged |
| setup / ci / docs / chore | ~7 | non-TDD plumbing & writing |

**The whole app is ~44 "describe it as a test → build it" pairs, stacked from
the Note at the bottom up to the screens and safety nets at the top.**
