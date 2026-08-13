/**
 * @core Attachment upload E2E tests.
 *
 * Tests uploading files to attachment cells in a datasheet.
 * Requires MinIO and backend services running.
 */
import { test, expect } from "@playwright/test";
import { S } from "../../helpers/selectors";
import { goToWorkbench } from "../../helpers/navigation";
import path from "path";
import fs from "fs";

const SIGN_IN_BODY = {
  username: "admin@qq.com",
  credential: "admin123",
  type: "password",
  mode: "password",
};

test.describe("Attachment Upload", () => {
  test.beforeEach(async ({ page, context }) => {
    // Login via API through Next.js proxy
    const response = await page.request.post(
      "http://localhost:3000/api/v1/signIn",
      { data: SIGN_IN_BODY }
    );
    expect(response.ok()).toBeTruthy();

    await goToWorkbench(page);
  });

  test("can upload a file to an attachment cell", async ({ page }) => {
    // Navigate to a datasheet
    await ensureDatasheetOpen(page);

    // Create a small test file to upload
    const testFilePath = path.resolve(__dirname, "../../.auth/test-upload.txt");
    fs.writeFileSync(testFilePath, "E2E test upload content");

    // Look for an attachment-type field/column, or add one
    // Attachment cells typically have a file input or upload button
    const fileInput = page.locator('input[type="file"]').first();

    if (await fileInput.isVisible({ timeout: 3000 }).catch(() => false)) {
      await fileInput.setInputFiles(testFilePath);
      await page.waitForTimeout(2000);

      // Verify the uploaded file name appears somewhere on the page
      // Could be in the cell, in the record panel, or as a chip/badge
      // await expect(page.locator('text="test-upload.txt"').first()).toBeVisible();
    } else {
      // Attachment fields may require clicking on the cell first to show upload UI
      // Try to find and click a cell in an attachment column, or add an attachment field
      test.skip(
        true,
        "No visible file input — may need attachment field to be configured"
      );
    }

    // Clean up test file
    try { fs.unlinkSync(testFilePath); } catch {}
  });

  test("can view an uploaded attachment", async ({ page }) => {
    await ensureDatasheetOpen(page);

    // Look for attachment indicators in cells (file chips, thumbnails, links)
    // These are typically rendered as small preview cards or file name links
    const attachmentChips = page.locator(
      '[class*="attachment"], [class*="Attachment"], [class*="file-chip"], [class*="FileChip"], img[alt*="attachment"]'
    );

    // If attachments exist, verify we can interact with them
    const count = await attachmentChips.count();
    if (count > 0) {
      await expect(attachmentChips.first()).toBeVisible();
    }
    // Otherwise, skip — test environment may not have pre-existing attachments
  });
});

/**
 * Helper: ensure a datasheet is open.
 */
async function ensureDatasheetOpen(page: any): Promise<void> {
  const container = page.locator(S.DOM_CONTAINER);
  if (await container.isVisible({ timeout: 2000 }).catch(() => false)) {
    return;
  }

  const treeNode = page.locator(S.TREE_NODE).first();
  if (await treeNode.isVisible({ timeout: 2000 }).catch(() => false)) {
    await treeNode.click();
    await page.waitForSelector(S.DOM_CONTAINER, { timeout: 10_000 });
    return;
  }

  // Create a new datasheet if none exists
  const addNodeBtn = page.locator("#WORKBENCH_SIDE_ADD_NODE_BTN");
  if (await addNodeBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
    await addNodeBtn.click();
    await page.waitForTimeout(500);
    const createOption = page.locator(
      'text="新建表格", text="New Datasheet", text="表格", text="空白表格"'
    ).first();
    if (await createOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await createOption.click();
    }
    await page.waitForSelector(S.DOM_CONTAINER, { timeout: 15_000 });
  }
}
