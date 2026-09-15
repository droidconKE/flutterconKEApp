# AI Agent Docs — FlutterCon KE App

This directory is written **for AI coding agents** (Claude Code, other LLM agents) working in this
repository, not for human onboarding — that's what the root `README.md` and `CLAUDE.md` are for.
Where `CLAUDE.md` gives the short, high-signal orientation, these files go deeper: full inventories,
exact data-flow traces, and file:line references, so an agent can act on a task without re-deriving
the whole codebase from scratch.

## How to keep this up to date

These docs describe the state of the code as of the date in each file's "Last verified" line. **Whenever
you (an agent) make a change that invalidates something described here — a new repository, a changed
data-flow pattern, a new feature module, a route added/removed, a CI workflow change — update the
relevant doc in the same PR**, and bump its "Last verified" line. Treat a stale doc as a bug: if you
notice one while working on something else, fix it opportunistically rather than leaving it.

Do not let this directory grow into a changelog. It describes **current structure and behavior only**.
Historical rationale ("we used to do X before switching to Y") belongs in commit messages and PR
descriptions, not here — unless the historical context is load-bearing for understanding a current
workaround (e.g. why a version is pinned).

## Index

| File | Covers |
|---|---|
| [architecture.md](architecture.md) | Layering, DI (`injectable`/`get_it`), state management (Cubits), the app bootstrap sequence |
| [data-layer.md](data-layer.md) | Isar vs Hive, every repository, the cache-first fetch pattern, model/codegen inventory |
| [features.md](features.md) | Per-feature-module breakdown (`lib/features/*`) — what each screen/cubit does |
| [routing.md](routing.md) | go_router route table, navigation entry points, the dashboard's non-router tab system |
| [auth.md](auth.md) | Google sign-in, ghost/anonymous sign-in, token storage, logout, the reviewer-bypass mechanism |
| [networking-and-config.md](networking-and-config.md) | `NetworkUtil`/Dio setup, `ApiRepository` endpoints, flavor config, error/`Failure` handling |
| [notifications.md](notifications.md) | `awesome_notifications` setup, what schedules a notification, the deep-link-back-to-feedback flow |
| [build-and-ci.md](build-and-ci.md) | Flavors, code generation, GitHub Actions workflows and exactly what triggers each one |
| [design/REBRAND-PLAN.md](design/REBRAND-PLAN.md) | The 2026 flutterconKE rebrand migration plan — phases, web-repo cross-references, current gap analysis |

## Fast orientation for a new task

1. Read `CLAUDE.md` at the repo root first — it has the handful of facts that change how you should
   approach almost any task here (CI targets `main` only, no auth guard on routing, cache-first fetch
   semantics, Gradle/AGP/Kotlin version coupling).
2. If the task touches a specific feature screen, go straight to [features.md](features.md) to find
   its cubit(s) and files, then [data-layer.md](data-layer.md) if it reads/writes cached data.
3. If the task touches CI or a release, read [build-and-ci.md](build-and-ci.md) first — the workflow
   triggers are easy to misread (see the `main`-only note above).
