---
name: e2e
description: Run and write Playwright E2E browser tests for WisTable. Tests are in tests/e2e/ with own Node 20 package.
---

# WisTable E2E Testing Skill

Use this skill when asked to run, write, or debug end-to-end browser tests for WisTable.

## Prerequisites

All 4 services must be running before tests:
- **Docker infra**: mysql, redis, rabbitmq, minio, databus-server
- **Java backend**: `backend/backend-server` (port 8081)
- **NestJS room-server**: `backend/room-server` (port 3333)
- **Next.js frontend**: `frontend/datasheet` (port 3000)

To start: `source scripts/dev-env.sh`, then `docker compose -f docker-compose.dev.yaml --env-file .env up -d`, then start the 3 app services.

## Running Tests

```bash
cd tests/e2e

# First time setup (use Node 20)
nvm use 20
npm install
npx playwright install chromium

# Run all tests
npx playwright test

# Run only core tests
npx playwright test --grep '@core'

# Run only auth tests
npx playwright test --grep '@auth'

# Run with browser visible (debug)
npx playwright test --headed

# View HTML report
npx playwright show-report
```

## Test Structure

```
tests/e2e/
├── package.json
├── playwright.config.ts       # Chromium, workers=1, baseURL localhost:3000
├── .nvmrc                     # Node 20
├── helpers/
│   ├── selectors.ts           # DOM selectors (DATASHEET_* IDs, data-test-id)
│   ├── auth.ts                # Login helpers (API + UI)
│   ├── navigation.ts          # Workbench/sidebar navigation
│   └── datasheet.ts           # CRUD operations (addField, addRecord, editCell)
├── specs/
│   ├── auth/login.spec.ts     # @auth — Login page, credential validation
│   ├── datasheet/crud.spec.ts # @core — Create/read/update datasheet content
│   ├── attachment/upload.spec.ts # @core — File upload to attachment cells
│   └── workspace/navigation.spec.ts # @core — Sidebar, catalog tree
└── .auth/                     # Cached auth state (gitignored)
```

## Writing New Tests

1. Create test file in `tests/e2e/specs/<module>/<name>.spec.ts`
2. Tag with `@core`, `@auth`, or module-specific tag in the JSDoc description
3. Import helpers from `../../helpers/`
4. Use `S` (selectors) for DOM element locators
5. Use `test.beforeEach` with API login for authenticated tests

### Selector usage

```typescript
import { S } from "../../helpers/selectors";

// S.DOM_CONTAINER → #DATASHEET_DOM_CONTAINER
// S.ADD_COLUMN_BTN → #DATASHEET_ADD_COLUMN_BTN
// S.ADD_RECORD_BTN → [data-test-id="addRecord"]
// S.CELL(0, 0)     → [data-test-id="cell-0-0"]
// S.SIDEBAR         → [data-test-id="workspace-sidebar"]
// S.TREE_NODE       → [data-test-id="treeNodeItem"]
```

### Existing data-test-id attributes (from codebase)

| Selector | Attribute |
|----------|-----------|
| `addRecord` | Add record button |
| `expandRecordButton` | Expand record toggle |
| `cell-{row}-{col}` | Grid cell |
| `workspace-sidebar` | Left sidebar panel |
| `sidebar-toggle-btn` | Sidebar collapse toggle |
| `treeNodeItem` | Catalog tree node |
| `viewTab` | View tab |
| `undo` / `redo` | Undo/redo buttons |
| `viewSearchInput` | View search field |

### Existing DATASHEET_* DOM IDs (from @apitable/core)

| Constant | DOM ID |
|----------|--------|
| `DOM_CONTAINER` | `DATASHEET_DOM_CONTAINER` |
| `ADD_COLUMN_BTN` | `DATASHEET_ADD_COLUMN_BTN` |
| `ADD_RECORD_BTN` | `DATASHEET_ADD_RECORD_BTN` |
| `VIEW_LIST_SHOW_BTN` | `DATASHEET_SHOW_VIEW_LIST_BTN` |
| `SIDE_RECORD_PANEL` | `DATASHEET_SIDE_RECORD_PANEL` |
| `VIEW_TAB_BAR` | `DATASHEET_VIEW_TAB_BAR` |
| `TOOL_BAR` | `DATASHEET_TOOL_BAR` |

### WORKBENCH_SIDE_* DOM IDs

| Constant | DOM ID |
|----------|--------|
| `ADD_NODE_BTN` | `WORKBENCH_SIDE_ADD_NODE_BTN` |

## Test Credentials

Default admin user (from `init-db/02_user.sql`):
- Email: `admin@qq.com`
- Password: `admin123`
- Space: `我的空间` (spcDefault01)

## Debugging

- Failed tests save screenshots to `tests/e2e/test-results/`
- Use `--headed` to watch the browser
- Use `page.pause()` in test code for interactive debugging
- Check services are running: `curl http://localhost:3000` and `curl http://localhost:8081/api/v1/`

## Constraints

- **Node 20 required** — the test package is outside the pnpm workspace
- **workers=1** — tests run serially (shared database)
- **No webServer** config — you must start services separately
- Tests assume a fresh or lightly-used dev database with the default admin user
