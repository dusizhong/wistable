# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo overview

WisTable is a fork of APITable — a collaborative spreadsheet/database platform. It is a polyglot monorepo: a TypeScript/React/NestJS pnpm workspace plus a Java/Gradle Spring Boot backend, orchestrated for production with Docker Compose.

## Toolchain

- Node **16.15.0** (`.nvmrc`), pnpm **8** (`packageManager: pnpm@8.6.12`). The `preinstall` script blocks npm/yarn — always use `pnpm`.
- Java **17** (Corretto) for `backend-server`.
- Many builds need large heap; scripts set `NODE_OPTIONS=--max-old-space-size` — preserve that when editing build scripts.

## Common commands (run from repo root)

- Install: `pnpm install`
- Web dev: `pnpm sd` (shortcut for datasheet dev server)
- Room server dev: `pnpm start:room-server`
- Backend dev: `cd backend/backend-server && ./gradlew bootRun`
- Lint single package: `nx check:lint @apitable/datasheet` or `nx lint <project>`
- Test all: `pnpm test:core`, `pnpm test:datasheet`, or `nx test <project>`
- Test single file: `nx test @apitable/core -- path/to/file.test.ts`
- **Core tests require timezone**: always run with `TZ=Asia/Shanghai` (set in package scripts)

## Build order

`@apitable/core` and other libs must be built before `datasheet`/`room-server`:
- Web: `pnpm build:dst:pre && pnpm build:dst`
- Room server: `pnpm build:sr`
- Nx enforces this via `"build": {"dependsOn": ["^build"]}` — building any package builds its deps first.

## Code conventions

- ESLint config is root `.eslintrc`; Prettier: single quotes, semis, 2 spaces, `printWidth: 150`, `trailingComma: es5`.
- Do not hand-edit generated code: `@apitable/api-client` (OpenAPI), room-server gRPC types (`pnpm --filter @apitable/room-server grpc:build`), `@apitable/databus-wasm*` (Rust WASM).

## Service architecture (production)

```
Browser :3000 → gateway (nginx :80) → web-server (Next.js, static + SSR)
                                     → room-server (NestJS :3333, REST + WebSocket)
                                     → backend-server (Java :8081, REST API)
                                     → databus-server (Rust, :8625, binary data engine)
Infra: MySQL :3306, Redis :6379, RabbitMQ :5672, MinIO :9000
```

- **gateway** — nginx reverse proxy. Routes `/api/v1/` → backend-server, `/room/` → room-server, `/socket/` → room-server WebSocket, `/assets/` → MinIO, everything else → web-server. Config lives in [gateway/conf.d/](gateway/conf.d/).
- **backend-server** — primary REST API (auth, spaces, datasheets, records, widgets, automation CRUD). Java Spring Boot with Gradle multi-module. Packages under `com.apitable`: `admin`, `asset`, `auth`, `automation`, `base`, `client`, `control` (permissions), `internal`, `organization`, `player`, `space`, `template`, `user`, `widget`, `workspace`.
- **room-server** — real-time collaboration server. Handles WebSocket connections for live editing, OT (Operational Transform) merge, and the socket gRPC endpoint. Also serves Fusion API (`/fusion/v1/`) for third-party integrations. Modules: `automation`, `database`, `developer`, `embed`, `fusion`, `grpc`, `node`, `socket`, `unit`, `user`, `workdoc`, `ai`, `actuator`.
- **databus-server** — Rust binary (prebuilt, source not in this repo). Handles formula calculation, cell value resolution, and large data computation. Loaded from `docker/databus-server.tar`.
- **web-server** — Next.js app (`@apitable/datasheet`). Serves the SPA, SSR for embed views, and the widget runtime sandbox.

## Development mode: how native code connects to Docker infra

In dev mode, only infrastructure runs in Docker (mysql, redis, rabbitmq, minio, init-db, databus-server). The three app services run natively:

```bash
source scripts/dev-env.sh    # activates Node 16 + JDK 17 + rewrites hosts to 127.0.0.1
docker compose -f docker-compose.dev.yaml --env-file .env up -d   # infra only
cd backend/backend-server && ./gradlew bootRun    # port 8081
cd backend/room-server && pnpm start:dev          # port 3333
cd frontend/datasheet && pnpm dev                 # port 3000 (Next.js dev server)
```

The key insight: `scripts/dev-env.sh` rewrites `MYSQL_HOST`, `REDIS_HOST`, `RABBITMQ_HOST`, `AWS_ENDPOINT`, etc. to `127.0.0.1` so native processes connect to Docker-exposed ports. The `.env` file is shared between both modes — `dev-env.sh` sources it then overrides the hosts.

## Build dependency graph

```
@apitable/i18n-lang ──┐
@apitable/core ───────┤ (shared datasheet logic, Redux store, OT engine, formula_parser)
@apitable/icons ──────┤
@apitable/components ─┤
@apitable/widget-sdk ─┘
        │
        ├──→ @apitable/datasheet (Next.js frontend — must build the above first)
        │
@apitable/i18n-lang ──┐
@apitable/core ───────┼──→ @apitable/room-server (NestJS — cjs build of core)
        │
backend-server (Java/Gradle — independent, no JS deps)
```

Nx enforces this: `"build": {"dependsOn": ["^build"]}` means building any package builds its dependencies first.

## @apitable/core — the shared engine

This is the heart of the application, consumed by both frontend and room-server. Key subsystems under [packages/core/src/](packages/core/src/):

| Directory | Role |
|-----------|------|
| `model/` | Data model types (datasheet, field, record, view, widget) |
| `command_manager/` | Command execution engine — all mutations go through commands |
| `commands/` | Individual command implementations (insert record, set field, etc.) |
| `commands_actions/` | Higher-order composed actions built from commands |
| `engine/` | Core datasheet operations engine |
| `formula_parser/` | Formula expression parser and evaluator |
| `compute_manager/` | Computation orchestration, delegates to databus-server |
| `event_manager/` | Internal event bus |
| `cache_manager/` | Client-side caching layer |
| `automation_manager/` | Automation trigger/action definitions |
| `link_integrity_checker/` | Referential integrity for linked records |
| `io/` | I/O operations |

Both the frontend and room-server import `@apitable/core` — the frontend uses its Redux store and UI helpers, while room-server uses its OT merge logic, command validation, and automation execution.

## Widget system architecture

Widgets are third-party/extensible mini-apps that run in sandboxed iframes. The loading chain:

1. DB stores `apitable_widget_package_release.release_code_bundle` as a MinIO path
2. Backend API serves the JS bundle URL via `ImageSerializer`
3. Frontend Redux middleware (`widget_sync_data`) pushes data via `postMessage` into the iframe
4. The iframe loads `/widget-stage` (a separate Next.js page), which uses `loadjs()` to fetch and execute the bundle
5. The bundle calls `initializeWidget(Component, packageId)` to register itself
6. React/mobx/emotion are provided as webpack externals by the main app (not bundled)

Widget sources live in [frontend/widgets/](frontend/widgets/). Each widget has a `widget.config.json` with its `packageId` (must match database). Build and deploy with `bash frontend/widgets/build-and-deploy.sh`.

## Automation system

The automation (robot) system spans both frontend and backend:

- **Frontend** — [frontend/datasheet/src/pc/components/robot/](frontend/datasheet/src/pc/components/robot/) — UI for configuring triggers and actions, the robot panel, and node form components
- **Backend (Java)** — `backend-server/.../automation/` — automation CRUD, scheduling, execution
- **Backend (NestJS)** — `room-server/src/automation/` — real-time automation triggers (record changes via socket events)
- **Database** — [init-db/05_automation.sql](init-db/05_automation.sql) seeds trigger + action definitions

Automation flows: trigger definition → condition filter → action definition. Triggers include record created/modified, time scheduled, webhook received. Actions include sending notifications, modifying records, calling webhooks.

## gRPC communication

gRPC is used for internal service-to-service calls:

- `.proto` definitions in [scripts/protos/](scripts/protos/)
- Code generation: `bash scripts/compile.proto.sh`
- **room-server** runs a gRPC server on port 3334 (`ROOM_GRPC_URL`) and a socket gRPC on port 3007 (`SOCKET_GRPC_URL`)
- Generated types in [backend/room-server/src/grpc/](backend/room-server/src/grpc/)
- The generated `api-client` package must not be hand-edited

## Database conventions

- All tables prefixed `apitable_` (set by `DATABASE_TABLE_PREFIX` in `.env`)
- SQL seed data in [init-db/](init-db/): schema → user → template → widget → automation, applied in numbered order
- `mysql2` has a patched dependency ([patches/mysql2@3.9.7.patch](patches/mysql2@3.9.7.patch)) for utf8mb3 compatibility

## Key environment variables for dev

During development, `scripts/dev-env.sh` sources `.env` then overrides hosts to `127.0.0.1`. The variables that change behavior between dev and prod:

| Variable | Prod value | Dev override |
|----------|-----------|--------------|
| `MYSQL_HOST` | `mysql` | `127.0.0.1` |
| `REDIS_HOST` | `redis` | `127.0.0.1` |
| `RABBITMQ_HOST` | `rabbitmq` | `127.0.0.1` |
| `AWS_ENDPOINT` | `http://minio:9000` | `http://127.0.0.1:9000` |
| `BACKEND_BASE_URL` | `http://backend-server:8081/api/v1/` | `http://127.0.0.1:8081/api/v1/` |
| `API_PROXY` | `http://backend-server:8081` | (empty — Next.js proxies directly) |

## Patches

- [patches/mysql2@3.9.7.patch](patches/mysql2@3.9.7.patch) — fixes utf8mb3 charset handling in MySQL 8.0
