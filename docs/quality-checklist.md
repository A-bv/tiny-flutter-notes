# Flutter quality checklist

Every element that goes into a high-quality Flutter app: what it's for,
the current best practice, and whether this app covers it. Most ❌ are
normal for a two-screen showcase — the point is knowing they exist and
which tier they sit in.

Legend: ✅ covered · ⚠️ partial · ❌ not covered.

## Architecture & code

| Element | Best practice | Here |
|---|---|---|
| Layered architecture | MVVM, `ui` / `data` / `domain`, deps inward | ✅ |
| State management | Riverpod 3 (`Notifier`, `AsyncValue`) | ✅ |
| Dependency injection | Riverpod providers + `overrides` | ✅ |
| Immutable models | `@immutable` + `copyWith` | ✅ |
| Static analysis + format | `very_good_analysis` + `dart format` in CI | ✅ |
| Commit conventions | Conventional commits (here: red/green/blue) | ✅ |
| Modularization | pub workspaces at scale | ❌ (one package, by scope) |

## Data

| Element | Best practice | Here |
|---|---|---|
| Local persistence | **Drift** (Isar abandoned, Hive stalled) | ✅ |
| Network client | `dio` for mid/large apps | ✅ full round trip (POST/GET/DELETE), fake stays the zero-setup default |
| Serialization (DTO) | `json_serializable`; hand-written fine for one type | ✅ |
| Typed errors | Sealed failures / typed exceptions | ⚠️ (`ApiException` + `AsyncValue`) |
| Offline-first | DB as source of truth + sync worker + tombstones | ✅ |
| DB migrations | Versioned, generated migration tests | ⚠️ (schema v1, migration seam present) |

## UI / UX

| Element | Best practice | Here |
|---|---|---|
| Theming | `ColorScheme.fromSeed` (M3), no hard-coded colours | ✅ |
| All screen states | Never a bare spinner | ✅ (loading / data / empty / error) |
| Navigation | `go_router` at scale | ⚠️ (basic `Navigator`, fine at two screens) |
| Accessibility | Semantics, live regions, text not colour-alone | ✅ baseline, tested (see [decisions.md](decisions.md)) |
| Font scaling | Respect `MediaQuery.textScaler` | ✅ |
| i18n | `gen-l10n` + `.arb` | ❌ (structure-ready) |
| Responsive | window size classes | ❌ (portrait-locked, by scope) |

## Tests

| Element | Best practice | Here |
|---|---|---|
| Unit | real in-memory DB beats mocks | ✅ |
| Widget | `WidgetTester` pumps real frames | ✅ |
| Golden | **Alchemist** (golden_toolkit archived) | ✅ |
| Integration/E2E | `integration_test` | ✅ |
| Coverage gate | floor in CI | ✅ (85% on hand-written source) |

## Build & delivery

| Element | Best practice | Here |
|---|---|---|
| CI | format → analyze → test, pinned Flutter | ✅ |
| CD / release | fastlane / Codemagic | ❌ |
| Flavors | `--flavor` per environment | ❌ |
| Config & secrets | `--dart-define` (+ `envied`) | ⚠️ (`API_URL` via dart-define) |
| Codegen | `build_runner` (Dart macros cancelled) | ✅ |

## Observability & robustness

| Element | Best practice | Here |
|---|---|---|
| Logging | `talker` / `dart:developer` | ⚠️ (`dart:developer`, no remote sink) |
| Global error handling | `FlutterError.onError` + `PlatformDispatcher.onError` | ✅ (both installed, tested) |
| Crash reporting | Crashlytics / Sentry | ❌ |
| Perf practices | `const`, `ListView.builder`, targeted rebuilds | ✅ |

## Security & platform

| Element | Best practice | Here |
|---|---|---|
| Auth | Firebase Auth / OAuth | ❌ (no accounts) |
| Secure storage | `flutter_secure_storage` | ❌ |
| Cert pinning | pinning via dio | ❌ |
| Push | `firebase_messaging` | ❌ |
| Background work | `workmanager` | ❌ (sync runs while open) |

---

## Priority map — what actually matters

A tech lead's job is knowing which tier each element sits in and
activating it at the right time — not stacking all of them into a
two-screen app.

**🔴 Essential — missing one is a red flag.** Layered architecture, state
management, DI, immutable models, async + error handling, designed screen
states, persistence, theming + dark mode, unit + widget tests, static
analysis, CI, a README that explains. **→ All ✅ here.**

**🟡 Important — good apps usually have these.** Real networking ✅,
serialization ✅, offline-first ✅, accessibility ✅ (baseline), golden ✅,
E2E ✅, global error handling ✅, DB migration seam ✅; navigation ⚠️,
logging ⚠️; auth/secure storage ❌ (only with accounts), i18n ❌,
responsive ❌.

**⚪ Secondary — bonuses / ops maturity.** CD, flavors, feature flags,
analytics, perf monitoring, push, background work, deep linking, cert
pinning, formal design system, modularization — all ❌ here, all
documented rather than built.
