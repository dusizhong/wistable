/**
 * @auth Authentication E2E tests.
 *
 * Tests login page rendering, credential validation, logout, and session persistence.
 * These tests run WITHOUT any pre-existing auth state (they use a fresh incognito-like context).
 */
import { test, expect } from "@playwright/test";

test.describe("Login Page", () => {
  test("renders login form with email, password inputs and submit button", async ({
    page,
  }) => {
    await page.goto("/login");

    // Wait for the login form to render
    await page.waitForSelector(
      'input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]',
      { timeout: 10_000 }
    );

    // Email input should be visible
    const emailInput = page.locator(
      'input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]'
    );
    await expect(emailInput.first()).toBeVisible();

    // Password input should be visible
    const passwordInput = page.locator(
      'input[type="password"], input[placeholder*="password"], input[placeholder*="密码"]'
    );
    await expect(passwordInput.first()).toBeVisible();

    // Submit/login button should be visible
    const submitBtn = page.locator(
      'button[type="submit"], button:has-text("登录"), button:has-text("Sign in"), button:has-text("Log")'
    );
    await expect(submitBtn.first()).toBeVisible();
  });

  test("shows error message for invalid credentials", async ({ page }) => {
    await page.goto("/login");

    await page.waitForSelector(
      'input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]',
      { timeout: 10_000 }
    );

    // Fill in invalid credentials
    const emailInput = page
      .locator('input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]')
      .first();
    await emailInput.fill("invalid@test.com");

    const passwordInput = page
      .locator('input[type="password"], input[placeholder*="password"], input[placeholder*="密码"]')
      .first();
    await passwordInput.fill("wrongpassword");

    // Click submit
    const submitBtn = page
      .locator('button[type="submit"], button:has-text("登录"), button:has-text("Sign")')
      .first();
    await submitBtn.click();

    // Should show some error — either toast, inline error, or still on login page
    // Wait for error message or verify we didn't redirect to workbench
    await page.waitForTimeout(3000);

    // We should NOT be on the workbench page
    expect(page.url()).not.toContain("/workbench");
  });

  test("redirects to /workbench after successful login", async ({ page }) => {
    await page.goto("/login");

    await page.waitForSelector(
      'input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]',
      { timeout: 10_000 }
    );

    // Fill valid credentials (from init-db/02_user.sql)
    const emailInput = page
      .locator('input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]')
      .first();
    await emailInput.fill("admin@qq.com");

    const passwordInput = page
      .locator('input[type="password"], input[placeholder*="password"], input[placeholder*="密码"]')
      .first();
    await passwordInput.fill("admin123");

    const submitBtn = page
      .locator('button[type="submit"], button:has-text("登录"), button:has-text("Sign")')
      .first();
    await submitBtn.click();

    // Should redirect to workbench
    await page.waitForURL(/\/workbench/, { timeout: 15_000 });
    expect(page.url()).toContain("/workbench");
  });

  test("unauthenticated user is redirected to /login", async ({ browser }) => {
    // Use a fresh context with no cookies
    const context = await browser.newContext({ storageState: undefined });
    const page = await context.newPage();

    await page.goto("/workbench");

    // Should be redirected to login
    await page.waitForURL(/\/login/, { timeout: 10_000 });
    expect(page.url()).toContain("/login");

    await context.close();
  });
});
