import { Page, BrowserContext } from "@playwright/test";
import path from "path";
import fs from "fs";

const AUTH_FILE = path.resolve(__dirname, "../.auth/state.json");

const CREDENTIALS = {
  email: "admin@qq.com",
  password: "admin123",
};

/**
 * Sign-in request body format matching backend ApiInterface.ISignIn.
 * The backend expects: { username, credential, type, mode }
 * See: packages/core/src/modules/user/api/api.auth.ts
 */
const SIGN_IN_BODY = {
  username: CREDENTIALS.email,
  credential: CREDENTIALS.password,
  type: "password",
  mode: "password",
};

/**
 * Log in via the backend API and save browser state.
 * Calls the signIn API through the Next.js proxy (localhost:3000/api/v1),
 * which routes to the Java backend. The response sets session cookies
 * that Playwright automatically stores for subsequent requests.
 */
export async function loginViaApi(page: Page, context: BrowserContext): Promise<void> {
  // Step 1: Call the login API through the Next.js proxy
  const response = await page.request.post("http://localhost:3000/api/v1/signIn", {
    data: SIGN_IN_BODY,
  });

  if (!response.ok()) {
    throw new Error(
      `API login failed: ${response.status()} ${await response.text()}`
    );
  }

  // Step 2: Verify we can reach the workbench
  await page.goto("/workbench");
  await page.waitForURL(/\/workbench/, { timeout: 15_000 });

  // Step 3: Save storage state for reuse
  await context.storageState({ path: AUTH_FILE });
}

/**
 * Ensure we have valid auth state — reuse cached state if available,
 * otherwise perform API login.
 */
export async function ensureAuthState(
  page: Page,
  context: BrowserContext
): Promise<void> {
  if (fs.existsSync(AUTH_FILE)) {
    // Check if cached state is still valid (not older than 24h)
    const stat = fs.statSync(AUTH_FILE);
    const hoursOld = (Date.now() - stat.mtimeMs) / (1000 * 60 * 60);
    if (hoursOld < 24) {
      return; // Cached state will be loaded by Playwright's storageState in config
    }
  }
  await loginViaApi(page, context);
}

/**
 * Login via the UI (for testing the login page itself).
 */
export async function loginViaUI(page: Page): Promise<void> {
  await page.goto("/login");
  await page.waitForSelector('input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]', {
    timeout: 10_000,
  });
  await page.fill(
    'input[type="email"], input[placeholder*="email"], input[placeholder*="邮箱"]',
    CREDENTIALS.email
  );
  await page.fill(
    'input[type="password"], input[placeholder*="password"], input[placeholder*="密码"]',
    CREDENTIALS.password
  );
  await page.click('button[type="submit"], button:has-text("登录"), button:has-text("Sign")');
  await page.waitForURL(/\/workbench/, { timeout: 15_000 });
}
