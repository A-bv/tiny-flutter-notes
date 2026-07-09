# Field Notes — a tiny offline-first notes app, built test-first

A deliberately small Flutter app that does everything a real app does —
offline storage, background sync, networking, theming, accessibility,
the full test pyramid — and nothing it doesn't. Every line was written
**test-first**, one behavior per commit, so the git history reads as a
step-by-step build you can follow.

![CI](https://github.com/A-bv/field_notes/actions/workflows/ci.yaml/badge.svg)

## What it does

Write a note; it saves on the device instantly and uploads in the
background. Go offline, keep writing — changes queue and flush the moment
you reconnect. Delete a note and it disappears at once, reconciling with
the server later. Reinstall and your notes come back.

## Run it

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Out of the box the app uses an in-memory fake server, so it runs anywhere
with zero setup. Point it at a real backend with a build-time define:

```bash
flutter run --dart-define=API_URL=https://your-server
```

Nothing above the `NoteApi` seam changes — the fake and the real dio
client are interchangeable.

## Architecture

Two layers plus a shared domain, dependencies pointing inward (the
official Flutter guidance — MVVM):

```
  ui/      views + Riverpod view models   (what to show, how state changes)
   │
   ▼
  data/    repository + services          (the rules, the sources of truth)
   │        ├─ DatabaseService (Drift)    ← the source of truth
   │        ├─ NoteApi (Fake | Http/dio)  ← the sync seam
   │        └─ ConnectivityService
   ▼
  domain/  Note, SyncStatus               (pure Dart, no Flutter)
```

And the same layers as a runtime flow — how a note travels, offline-first:

```
   tap "Save"
       │
       ▼
   view model ──▶ repository ──┬──▶ Drift DB        saved at once as "pending";
                               │       │            the UI re-renders from the
                               │       └─▶ stream    database it watches
                               │
                               └──▶ NoteApi ──▶ server   in the background:
                                    (dio)                "pending" ➜ "synced"
                                    skipped offline, retried on reconnect
```

Three rules hold it together: the local database is the source of truth
(the UI only ever *watches* it, which is what makes the app work
offline); dependencies point one way (ui → data → domain); and widgets
hold no logic (a view decides *what* to show, a view model *how state
changes*, the repository *the rules*).

## How it was built with TDD

TDD means building in tiny steps, each the same three-part cycle. The
git history makes every step visible:

- 🔴 **`test:`** — write one small failing test for a behavior you don't
  have yet. Run it. It fails, because the code isn't there.
- 🟢 **`feat:`** — write the least code that makes it pass.
- 🔵 **`refactor:`** — clean up while the tests stay green.

Nothing is written unless a test asked for it. Infrastructure commits
(scaffold, CI, docs) are tagged `(non-TDD)` so the test-first spine is
unambiguous.

Here is one full cycle — *"a sync must do nothing while offline"*:

🔴 the failing test:

```dart
test('syncPending does nothing while offline', () async {
  connectivity.isOnline = false;
  final repo = makeRepository();
  await repo.createNote('Buy milk');

  await repo.syncPending();

  expect(api.uploaded, isEmpty);
  expect((await onlyNote()).syncStatus, SyncStatus.pending);
});
```

🟢 the code that makes it pass:

```dart
Future<void> _syncOnce() async {
  if (!_connectivity.isOnline) return; // ← added
  ...
}
```

Each collaborator (the note API, connectivity) enters the codebase only
in the cycle whose test first needs it — so the design is pulled into
existence by the tests, not sketched up front.

## Testing

The full pyramid, all runnable with `flutter test`:

| Level | Tool | What it covers |
|---|---|---|
| Unit | `flutter_test` + real in-memory Drift | domain, database, repository, DTO, view models |
| Widget | `WidgetTester` | every screen state, delete, banners, a11y live regions |
| Golden | Alchemist | the list item's look, per sync status |
| E2E | `integration_test` | create-a-note through the real app |

CI runs format → analyze → test, and **gates coverage at 85% on
hand-written source** (generated `*.g.dart` excluded).

## Trade-offs

- **Riverpod over Bloc** — less boilerplate at this scale, and it does DI
  *and* state in one tool. Bloc earns its place on a large team that
  wants explicit event rules.
- **Drift** for local storage — Isar is abandoned and Hive stalled; Drift
  is the maintenance-safe reactive database.
- **A fake backend as the default** — the app is the artifact, not a
  server. The real dio client is built and tested; `--dart-define`
  switches to it.
- **Last-write-wins** conflicts, additive pull — cross-device *deletion*
  needs server-side tombstones, out of scope here and documented in
  [decisions.md](docs/decisions.md).

## More

- [docs/build-log.md](docs/build-log.md) — every commit classified by layer, and which framework each introduced.
- [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md) — build this app from scratch, step by step.
- [docs/decisions.md](docs/decisions.md) — what was deliberately *not* built, and why.
- [docs/quality-checklist.md](docs/quality-checklist.md) — every element of a high-quality Flutter app, and where this one stands.
