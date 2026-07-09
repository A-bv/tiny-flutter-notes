# Design decisions & deferred scope

The README is the shop window: the curated story. This file is the back
office — the fuller reasoning and the things left out on purpose. Kept
separate so the README stays clean.

The through-line of this project is **restraint**: every file must earn
its place. So "not built" is a design decision as much as "built", and it
belongs on the record.

---

## Accessibility — baseline shipped, hardening deferred

**What the app does today:**
- Every icon-only button has a spoken tooltip (new-note and delete).
- Sync status is **text** ("Synced" / "Pending sync"), never colour or an
  icon alone; a golden test pins both states.
- The offline and sync-failed banners are **live regions**: screen
  readers announce them the moment they appear (locked in by a widget
  test that asserts the `isLiveRegion` semantics flag).
- System font scaling is respected (nothing overrides the text scaler).

**What a full pass would add:** `SemanticsRole` annotations, a real
VoiceOver/TalkBack walkthrough, a contrast audit, and tap-target
measurements — polish on a working baseline, scheduled with real users,
not a skipped topic.

## Internationalization (i18n) — structure-ready, not implemented

What exists: all user-facing strings live in the widgets, one place each,
no concatenation — ready to be lifted into `.arb` files.

**Why deferred:** full i18n turns every label into `l10n.someKey` and adds
generated files and indirection everywhere. That machinery would hurt the
follow-along-readability goal for zero functional gain at this scope.

> In one line: *"Structure is ready, i18n isn't implemented — I don't add
> complexity the scope doesn't justify."*

---

## Patterns deliberately NOT used

These come up in most "Clean Architecture" tutorials. Known, and left out
on purpose:

- **Use-cases / interactors.** The official Flutter guide adds them only
  when logic merges several repositories, is very complex, or is reused
  across view models. None is true here; a `GetSortedNotesUseCase` for one
  `orderBy` would be pure boilerplate.
- **Abstract repository + `Impl` pair.** Dart gives every class an
  implicit interface — tests fake collaborators against the concrete
  class already. The abstract/Impl split earns its place when a *second*
  real implementation exists, not before. (The `NoteApi` seam *does* have
  two implementations — fake and HTTP — so there it is a real interface.)
- **get_it / injectable.** A runtime service locator can fail at runtime
  if mis-wired; Riverpod resolves the graph at compile time and does DI
  *and* state. One tool instead of two.
- **Either / fpdart / dartz.** Dart 3 sealed classes and a typed
  `ApiException`, plus `AsyncValue` for action state, cover failures
  natively. dartz is abandoned; fpdart's v2 is stalled.
- **A mocking framework (mockito).** Hand-written fakes (`FakeNoteApi`, a
  recording dio interceptor) are shorter and have no generated magic at
  this scale — the same choice the reference project made with its
  `URLProtocolStub`.

## Sync scope — last-write-wins, additive pull

A sync pass pushes pending notes, flushes tombstoned deletions, then
pulls any server notes the device hasn't seen. The pull is **additive**:
a deletion made on another device does not propagate here, because that
needs server-side tombstones or version vectors. Conflicts are
**last-write-wins** — the newest save of a row replaces the old one. Both
are honest limits for a two-screen showcase, and both are stated in the
README rather than hidden.

## Already covered in the README

The headline trade-offs (Riverpod over Bloc, why Drift, why a fake
backend, last-write-wins) live in the [README](../README.md) because they
are part of the pitch, not the back office.
