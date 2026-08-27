/**
 * 手动驱动 AI 智能导入 UI 流程（非 pytest，直接 node 跑）：
 * 登录 → 打开发票表格 → 工具栏 AI 图标 → 抽屉「智能导入」→ 拖入发票 → 校验预览 → 确认导入。
 * 全程保存截图到 /tmp/ai_ui/。
 */
const { chromium } = require('@playwright/test');
const fs = require('fs');

const BASE = 'http://localhost:3000';
const DST_ID = 'dstUZS9eELRwZEXfvc';
const INVOICE = '/home/du/Downloads/20241231180957_6dea41e3-867e-4b34-b141-cbd7a070d50c.png';
const OUT = '/tmp/ai_ui';
fs.mkdirSync(OUT, { recursive: true });

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

(async () => {
  let browser = null;
  for (const headless of [false, true]) {
    try {
      browser = await chromium.launch({ headless });
      console.log('browser launched, headless =', headless);
      break;
    } catch (e) {
      console.log('launch failed (headless=' + headless + '):', e.message.split('\n')[0]);
    }
  }
  if (!browser) throw new Error('无法启动浏览器');

  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  page.setDefaultTimeout(25000);

  // 1) 登录（走 Next.js 代理 /api/v1）
  const signIn = await page.request.post(BASE + '/api/v1/signIn', {
    data: { username: 'admin@qq.com', credential: 'admin123', type: 'password', mode: 'password' },
  });
  console.log('signIn status:', signIn.status(), 'body:', (await signIn.text()).slice(0, 200));

  // 2) 打开发票表格
  await page.goto(`${BASE}/workbench/${DST_ID}`, { waitUntil: 'domcontentloaded' });
  await page.waitForSelector('#DATASHEET_DOM_CONTAINER', { timeout: 45000 });
  await sleep(2500);
  await page.screenshot({ path: `${OUT}/1_datasheet.png` });
  console.log('datasheet loaded');

  // 3) 点工具栏 AI 图标
  const aiBtn = page.locator('#DATASHEET_COPILOT_BTN');
  await aiBtn.waitFor({ state: 'visible', timeout: 20000 });
  await aiBtn.click();
  await page.waitForSelector('.ant-drawer', { timeout: 10000 });
  await sleep(1000);
  await page.screenshot({ path: `${OUT}/2_drawer_open.png` });
  console.log('AI drawer opened');

  // 4) 上传发票（antd Dragger 的隐藏 file input）
  const fileInput = page.locator('.ant-drawer input[type="file"]').first();
  await fileInput.setInputFiles(INVOICE);
  console.log('invoice file set, waiting for parse…');

  // 5) 等预览表格 + 「确认导入」按钮（解析约 15~20s）
  const confirmBtn = page.locator('.ant-drawer button:has-text("确认导入")');
  await confirmBtn.waitFor({ state: 'visible', timeout: 180000 });
  await sleep(800);
  await page.screenshot({ path: `${OUT}/3_preview.png` });
  const drawerText = await page.locator('.ant-drawer').innerText();
  console.log('\n===== 抽屉预览内容 =====\n' + drawerText + '\n========================');

  // 6) 确认导入
  await confirmBtn.click();
  console.log('已点击「确认导入」，等待成功提示…');
  await page.waitForSelector('.ant-message', { timeout: 15000 }).catch(() => {});
  await sleep(1200);
  await page.screenshot({ path: `${OUT}/4_after_commit.png` });

  await browser.close();
  console.log('DONE — 截图在 /tmp/ai_ui/');
})().catch((e) => {
  console.error('FAILED:', e && e.message);
  process.exit(1);
});
