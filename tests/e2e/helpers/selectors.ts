/**
 * DOM selectors for WisTable E2E tests.
 * Derived from @apitable/core DATASHEET_ID constants and component data-test-id attributes.
 * All DOM IDs are prefixed with "DATASHEET_" (from PREFIX constant in packages/core).
 */

export const S = {
  // Datasheet DOM container (grid/gallery/kanban view)
  DOM_CONTAINER: "#DATASHEET_DOM_CONTAINER",

  // Toolbar
  TOOL_BAR: "#DATASHEET_TOOL_BAR",

  // Column/field operations
  // NOTE: DATASHEET_ADD_COLUMN_BTN is defined in @apitable/core but is NOT rendered
  // as a DOM element in the canvas-based grid. Use toolbar/menu-based approaches instead.
  ADD_COLUMN_BTN: "#DATASHEET_ADD_COLUMN_BTN",

  // Record operations
  ADD_RECORD_BTN: '[data-test-id="addRecord"]',
  EXPAND_RECORD_BTN: '[data-test-id="expandRecordButton"]',
  SIDE_RECORD_PANEL: "#DATASHEET_SIDE_RECORD_PANEL",

  // Cell
  CELL: (row: number, col: number) => `[data-test-id="cell-${row}-${col}"]`,

  // View switching
  VIEW_TAB_BAR: "#DATASHEET_VIEW_TAB_BAR",
  VIEW_LIST_SHOW_BTN: '[data-test-id="DATASHEET_SHOW_VIEW_LIST_BTN"]',
  ADD_VIEW_BTN: '[data-test-id="DATASHEET_ADD_VIEW_BTN"]',

  // View creation in view list dropdown
  VIEW_LIST_CREATE_GRID: '[data-test-id="DATASHEET_CREATE_GRID_IN_VIEW_LIST"]',
  VIEW_LIST_CREATE_KANBAN: '[data-test-id="DATASHEET_CREATE_KANBAN_IN_VIEW_LIST"]',
  VIEW_LIST_CREATE_GALLERY: '[data-test-id="DATASHEET_CREATE_GALLERY_IN_VIEW_LIST"]',
  VIEW_LIST_CREATE_GANTT: '[data-test-id="DATASHEET_CREATE_GANTT_IN_VIEW_LIST"]',
  VIEW_LIST_CREATE_CALENDAR: '[data-test-id="DATASHEET_CREATE_CALENDAR_IN_VIEW_LIST"]',

  // Workspace sidebar
  SIDEBAR: '[data-test-id="workspace-sidebar"]',
  SIDEBAR_TOGGLE: '[data-test-id="sidebar-toggle-btn"]',
  TREE_NODE: '[data-test-id="treeNodeItem"]',

  // View tabs
  VIEW_TAB: '[data-test-id="viewTab"]',

  // Undo/Redo
  UNDO: '[data-test-id="undo"]',
  REDO: '[data-test-id="redo"]',

  // View search
  VIEW_SEARCH: '[data-test-id="viewSearchInput"]',

  // Modal confirm button
  MODAL_CONFIRM: '[data-test-id="DATASHEET_MODAL_FOOTER_BTN_CONFIRM"]',
} as const;
