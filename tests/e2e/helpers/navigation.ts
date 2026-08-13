import { Page } from "@playwright/test";
import { S } from "./selectors";

/**
 * Navigate to the workbench (main workspace page).
 */
export async function goToWorkbench(page: Page): Promise<void> {
  await page.goto("/workbench");
  await page.waitForSelector(S.SIDEBAR, { timeout: 15_000 });
}

/**
 * Click a node in the left catalog tree by its name text.
 */
export async function clickCatalogNode(
  page: Page,
  name: string
): Promise<void> {
  const node = page.locator(S.TREE_NODE, { hasText: name }).first();
  await node.click();
  // Wait for the datasheet container to appear
  await page.waitForSelector(S.DOM_CONTAINER, { timeout: 10_000 });
}

/**
 * Toggle the sidebar collapse/expand.
 */
export async function toggleSidebar(page: Page): Promise<void> {
  await page.click(S.SIDEBAR_TOGGLE);
}
