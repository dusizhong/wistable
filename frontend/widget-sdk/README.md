# WisTable Widget SDK

小组件运行时 SDK，npm 包 `@apitable/widget-sdk`。被 `frontend/widgets/` 下所有小组件项目依赖。

## 核心职责

- **Hooks** — `useRecords`、`useFields`、`useMeta`、`useCloudStorage`、`useSettingsButton`、`useViewsMeta` 等，供小组件组件获取 datasheet 数据和状态
- **消息通信** — `widgetMessage`（主应用 ↔ iframe）、`eventMessage`（跨小组件），基于 postMessage 协议
- **Store** — 小组件 iframe 内独立的 Redux store，通过 `initWidgetStore()` 从主应用同步状态
- **Widget 加载** — `loadWidget(url, packageId)` 动态加载 JS 包，`initializeWidget(Component, packageId)` 注册组件

## 构建

```bash
pnpm build          # tsc 编译 → dist/
```

作为 `build:dst:pre` 的一部分，必须在 `datasheet` 之前构建。

## 关联

| 模块 | 关系 |
|------|------|
| `frontend/widgets/` | 10 个小组件项目，依赖本 SDK |
| `frontend/datasheet/src/widget-stage/` | iframe 宿主页，调用 `initWidgetStore`、暴露 externals |
| `packages/core/` | shared datasheet logic，被 SDK 和主应用共同依赖 |
