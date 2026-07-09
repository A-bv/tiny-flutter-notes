# Build this app from scratch — a follow-along guide

This walks you through building **Field Notes** in the same order the code
was actually written: test-first, one behavior at a time. The git history
is the real guide — every 🔴/🟢/🔵 commit is a step — and this document is
the map that goes with it.

You don't need to know Flutter deeply. You do need to have run a counter
app once and know what a `Widget` is.

## The big picture first

Hold this mental model before any code:

```
   You tap "save"                      Later, when online
        │                                    │
        ▼                                    ▼
   ┌─────────┐   writes    ┌────────────┐  uploads  ┌──────────┐
   │  View   │────────────▶│ Repository │──────────▶│ NoteApi  │
   │(widgets)│             │ (the brain)│           └──────────┘
   └─────────┘             └─────┬──────┘
        ▲                        │ saves + reads
        │  watches a stream      ▼
        │                  ┌────────────┐
        └──────────────────│  Database  │  ← the source of truth
                           │  (Drift)   │
                           └────────────┘
```

Three rules make this clean architecture, and everything serves them:

1. **The database is the source of truth.** The screen never reads the
   network directly — it *watches* the local database. That's what makes
   the app work offline.
2. **Dependencies point one way:** ui → data → domain. The UI never
   imports a service; the domain imports no Flutter.
3. **Widgets hold no logic.** A view decides *what* to show; a view model
   *how state changes*; the repository *the rules*.

## The rhythm

Every step is the same cycle, and each is its own commit:

- 🔴 **Red.** Write one failing test for a behavior you don't have.
- 🟢 **Green.** Write the least code to pass it.
- 🔵 **Refactor.** Tidy up while green.

A dependency is added to `pubspec.yaml` only in the cycle whose test
first needs it. Read the commits in order and you'll watch the app — and
its dependency list — grow one honest step at a time.

## The order it was built

1. **Foundation (non-TDD):** scaffold, `very_good_analysis` lints, a CI
   that runs format → analyze → test.
2. **Domain** (`domain/`): the `Note` value object — equality, then
   `copyWith`. Pure Dart, no Flutter.
3. **Database** (`data/services/database_service.dart`): a Drift table
   and the queries the app needs — watch newest-first, upsert, delete,
   read-by-status. Tested against a real in-memory database, not a mock.
4. **Repository** (`data/repositories/`): the offline-first brain. Create
   saves locally as pending; sync uploads when online; delete drops or
   tombstones; a pass pulls unknown server notes; passes are serialized;
   failures are reported; it reconnects and disposes cleanly. Each of
   those is one red/green pair — and `NoteApi` and `ConnectivityService`
   appear exactly when a test first needs them.
5. **Serialization** (`note_dto.dart`): JSON ↔ domain, kept out of both
   the domain and the repository.
6. **Networking** (`http_note_api.dart`): a real dio client behind the
   `NoteApi` seam — POST, GET (skipping malformed records), DELETE, and
   dio-error-to-`ApiException` mapping, then a 🔵 refactor extracting the
   mapper. Tested with a recording interceptor, no live server.
7. **State + DI** (`providers.dart`, view models): the Riverpod graph
   wires everything; view models expose the repository as `AsyncValue`.
8. **UI** (`ui/notes_list`, `ui/note_create`): the list (every state,
   delete, offline + sync-error live-region banners) and the create form
   (save, pop-on-success, error), driven by widget tests.
9. **Theme + wiring:** a Material 3 theme and `main.dart` as the
   composition root.
10. **Golden + E2E:** an Alchemist golden for the list item and an
    `integration_test` that creates a note through the real app.
11. **Robustness:** global error handlers so nothing fails silently.
12. **Docs (non-TDD):** this guide, the README, decisions, and the
    quality checklist — written last, describing what exists.

## How to follow along

```bash
git log --oneline --reverse
```

Start at the first 🔴, read the test, then read the 🟢 that answers it.
Check out any commit to see the app exactly as it was at that step. By the
last commit you'll have this repo — and understand *why* each piece
exists, because you watched a test ask for it.
