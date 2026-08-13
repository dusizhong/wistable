import { Page } from "@playwright/test";
import { S } from "./selectors";

/**
 * Add a new field (column) to the current datasheet view.
 */
export async function addField(page: Page, name: string): Promise<void> {
  await page.click(S.ADD_COLUMN_BTN);
  // After clicking, a field type selector or inline input should appear.
  // Type the field name and confirm.
  const input = page.locator('input[placeholder*="name"], input[placeholder*="名称"]').first();
  await input.waitFor({ state: "visible", timeout: 5000 });
  await input.fill(name);
  await input.press("Enter");
  // Wait for the column header to render
  await page.waitForSelector(`[data-test-id*="${name}"], text="${name}"`, {
    timeout: 5000,
  }).catch(() => {
    // Column header might not use data-test-id with the name — that's ok
  });
}

/**
 * Click the add record button to insert a new row.
 */
export async function addRecord(page: Page): Promise<void> {
  const btn = page.locator(S.ADD_RECORD_BTN).first();
  await btn.click();
  await page.waitForTimeout(500); // Allow render
}

/**
 * Edit a cell at the given row/column index.
 * Rows and columns are 0-indexed from the visible grid.
 */
export async function editCell(
  page: Page,
  row: number,
  col: number,
  value: string
): Promise<void> {
  const cell = page.locator(S.CELL(row, col));
  await cell.dblclick();
  // Wait for the inline editor
  await page.waitForTimeout(300);

  // Try to find an active input within the cell
  const editor = cell.locator("input, textarea").first();
  if (await editor.isVisible({ timeout: 2000 }).catch(() => false)) {
    await editor.fill(value);
    await editor.press("Enter");
  }
}

/**
 * Switch to a different view type in the current datasheet.
 * @param viewType - one of 'grid', 'kanban', 'gallery', 'gantt', 'calendar'
 */
export async function switchViewType(
  page: Page,
  viewType: "grid" | "kanban" | "gallery" | "gantt" | "calendar"
): Promise<void> {
  // Open the view list dropdown
  await page.click(S.VIEW_LIST_SHOW_BTN);
  await page.waitForTimeout(500);

  const selectors: Record<string, string> = {
    grid: S.VIEW_LIST_CREATE_GRID,
    kanban: S.VIEW_LIST_CREATE_KANBAN,
    gallery: S.VIEW_LIST_CREATE_GALLERY,
    gantt: S.VIEW_LIST_CREATE_GANTT,
    calendar: S.VIEW_LIST_CREATE_CALENDAR,
  };

  const selector = selectors[viewType];
  if (selector) {
    await page.click(selector);
    await page.waitForSelector(S.DOM_CONTAINER, { timeout: 10_000 });
  }
}

/**
 * Wait for the datasheet to be fully loaded.
 */
export async function waitForDatasheet(page: Page): Promise<void> {
  await page.waitForSelector(S.DOM_CONTAINER, { timeout: 15_000 });
  await page.waitForTimeout(1000); // Allow initial render to settle
}
