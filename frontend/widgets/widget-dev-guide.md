# WisTable 小组件（Widget）开发指南

## 概述

小组件是 WisTable 的扩展应用，可实现数据可视化、数据传输、数据清洗等功能。基于 React + TypeScript，通过 `@apitable/widget-sdk` 与主应用通信，在独立的 iframe 沙箱中运行。

## 目录结构

```
frontend/widgets/
├── widget-chart/              # 图表（柱状图、折线图、饼图、散点图）
├── widget-summary/            # 统计与指标
├── widget-pivot-table/        # 透视表
├── widget-funnel-chart/       # 漏斗图
├── widget-script/             # 脚本小组件
├── widget-airtable-import/    # Airtable 数据导入
├── widget-hello-world-typescript/  # Hello World 模板 (TS)
├── widget-hello-world-javascript/  # Hello World 模板 (JS)
├── widget-developer-template/      # SDK 功能示例
├── widget-todo-list-template/      # Todo MVC 示例
├── build-and-deploy.sh        # 一键编译部署脚本
└── README.md
```

## 快速开始

### 1. 安装工具链

```bash
source scripts/dev-env.sh                          # 激活 Node16 + JDK17 + 环境变量
npm install -g @apitable/widget-cli --registry=https://registry.npmmirror.com
```

### 2. 开发调试（热更新）

```bash
cd widgets/widget-chart
widget-cli start
```

浏览器打开对应 datasheet，点击小组件面板中的 Chart，即可看到热更新效果。修改 `src/` 下源码后自动刷新。

### 3. 编译部署

```bash
source scripts/dev-env.sh
bash widgets/build-and-deploy.sh
```

脚本会依次：安装依赖 → webpack 编译 → 上传 MinIO → 输出新 hash。拿到 hash 后更新数据库：

```sql
UPDATE apitable_widget_package_release
SET release_code_bundle = 'space/2026/XX/XX/<hash>'
WHERE package_id = '<packageId>';
```

重启 backend-server 生效。

## 小组件项目结构

```
widget-xxx/
├── src/
│   ├── index.ts(x)        # 入口文件，必须调用 initializeWidget()
│   ├── *.ts(x)            # 组件、工具函数
│   └── i18n.ts            # 国际化字符串
├── widget.config.json     # 构建配置（packageId + entry）
├── package.json           # 依赖声明
├── settings.json          # 运行时设置
├── cover.png              # 封面图
├── package_icon.png       # 图标
└── author_icon.png        # 作者头像
```

## 核心 API

### 初始化注册

```typescript
import { initializeWidget } from '@apitable/widget-sdk/initialize_widget';

// 入口文件必须调用，packageId 需与数据库一致
initializeWidget(MyComponent, 'wpkCKtqGTjzM7');
```

### 常用 Hooks

```typescript
import {
  useRecords,          // 获取所有记录
  useFields,           // 获取所有字段
  useMeta,             // 获取小组件元信息（datasheetId 等）
  useCloudStorage,     // 持久化存储（类似 useState + localStorage）
  useSettingsButton,   // 设置按钮状态
  useViewsMeta,        // 获取视图列表
} from '@apitable/widget-sdk';

function MyWidget() {
  const records = useRecords();        // IRecord[]
  const fields = useFields();          // IField[]
  const { datasheetId } = useMeta();   // 当前关联的 datasheet
  const [config, setConfig] = useCloudStorage('myKey', defaultValue);
  // ...
}
```

### 消息通信

```typescript
import { widgetMessage, eventMessage } from '@apitable/widget-sdk';

// 监听主应用消息
widgetMessage.onRefreshWidget(() => { /* 刷新组件 */ });

// 跨小组件通信
eventMessage.onRefreshWidget(otherWidgetId, () => { /* ... */ });
```

## webpack externals（由主应用提供，无需打包）

| 模块 | 全局变量 |
|------|---------|
| `react` | `window._React` |
| `react-dom` | `window._ReactDom` |
| `@apitable/components` | `window['_@apitable/components']` |
| `@apitable/core` | `window['_@apitable/core']` |
| `@apitable/widget-sdk` | `window['_@apitable/widget-sdk']` |
| `@apitable/icons` | `window['_@apitable/icons']` |

## 运行时架构

```
┌─ 主应用 (Next.js) ─────────────────────────────────┐
│                                                     │
│  ┌─ WidgetPanel ──────────────────────────────┐     │
│  │  <iframe src="/widget-stage?widgetId=..."> │     │
│  │  ┌──────────────────────────────────────┐  │     │
│  │  │  widget-stage (独立页面)              │  │     │
│  │  │  1. postMessage 接收 widget 数据      │  │     │
│  │  │  2. loadjs() 加载 releaseCodeBundle   │  │     │
│  │  │  3. 渲染 WidgetComponent              │  │     │
│  │  └──────────────────────────────────────┘  │     │
│  └────────────────────────────────────────────┘     │
│                                                     │
│  Redux ──→ postMessage ──→ widget 数据同步          │
│  middleware (widget_sync_data)                      │
└─────────────────────────────────────────────────────┘
```

## 数据流

```
DB (apitable_widget_package_release.release_code_bundle)
  → Backend API (/widget/get) → ImageSerializer 拼接完整 URL
  → Frontend Redux → postMessage → iframe
  → loadWidget(url, packageId) → loadjs 动态加载 JS 包
  → initializeWidget(Component, packageId) 注册组件
  → WidgetComponent 渲染
```

## 新建小组件

1. 创建目录 `widgets/my-widget/`
2. 编写 `src/index.tsx`，调用 `initializeWidget()`
3. 创建 `widget.config.json`：

```json
{
  "packageId": "wpkXXXXXXXXXX",
  "entry": "src/index.tsx"
}
```

4. `widget-cli start` 调试
5. `widget-cli release --host=http://127.0.0.1:8081 --token=<API_TOKEN>` 发布

## 常用命令

```bash
# 安装依赖
cd widgets/<name> && npm install --legacy-peer-deps

# 开发模式（热更新）
widget-cli start

# 发布到平台
widget-cli release --host=http://127.0.0.1:8081 --token=<API_TOKEN>

# 查看已发布版本
widget-cli list-release --host=http://127.0.0.1:8081 --token=<API_TOKEN>
```

## 故障排查

1. **小组件加载报错** → 检查 MinIO 中 `releaseCodeBundle` 路径文件是否存在
2. **白屏无报错** → 打开浏览器 DevTools Console 查看 JS 错误
3. **PackageId 不匹配** → 确认 `widget.config.json` 中 `packageId` 与数据库一致
4. **依赖报错** → 检查 webpack externals 对应的全局变量是否由主应用正确注入
5. **backend 改完不生效** → 重启 backend-server 清除缓存
