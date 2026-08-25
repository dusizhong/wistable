# 小组件 (Widgets)

小组件来源于 apitable 官方， 全部 10 个小组件源码，已本地化。可定制修改后重新编译部署。详细开发指南见 `widget-dev-guide.md`。

## 目录

| 目录 | 小组件 | packageId | 类型 |
|------|--------|-----------|------|
| `widget-chart` | 图表 Chart | wpkCKtqGTjzM7 | 核心 |
| `widget-summary` | 统计与指标 Summary | wpkY6DKgb3iVk | 核心 |
| `widget-pivot-table` | 透视表 Pivot Table | wpkgMavSIOOR9 | 核心 |
| `widget-funnel-chart` | 漏斗图 Funnel Chart | wpkZV0RkAD90t | 核心 |
| `widget-script` | 脚本 Script | wpkPUIDr5rxh9 | 工具 |
| `widget-airtable-import` | Airtable 导入 | wpk098vuAfpQa | 工具 |
| `widget-hello-world-typescript` | Hello World TS | wpk2jJ7qZS0VG | 模板 |
| `widget-hello-world-javascript` | Hello World JS | wpkyVrnMm6ymP | 模板 |
| `widget-developer-template` | SDK 示例 | wpkSybhcxsmGM | 模板 |
| `widget-todo-list-template` | Todo MVC | wpkP54M0LMh9U | 模板 |

## 关联模块

- **`../widget-sdk/`** — 小组件运行时 SDK（hooks、消息协议、store），被所有小组件依赖

## 前置条件

```bash
source scripts/dev-env.sh
npm install -g @apitable/widget-cli --registry=https://registry.npmmirror.com
pip install boto3                                          # MinIO 上传依赖
```

## 开发调试（热更新）

```bash
source scripts/dev-env.sh
cd frontend/widgets/widget-chart
widget-cli start
```

浏览器打开对应 datasheet，点击小组件面板即可看到热更新效果。

## 编译部署（所有小组件）

```bash
source scripts/dev-env.sh
bash frontend/widgets/build-and-deploy.sh
```

脚本依次：编译源码 → 上传 JS 包 + 配图到 MinIO → 自动更新数据库（release 代码路径 + package 图片 token）。重启 backend-server 后刷新浏览器生效。每个版本独立保存，改坏了可一键回滚旧版本。

## 故障排查

1. **小组件加载报错** → 检查 MinIO 中对应路径文件是否存在
2. **白屏无报错** → 打开浏览器 DevTools Console 查看 JS 错误
3. **PackageId 不匹配** → 确认 `widget.config.json` 中 `packageId` 与数据库 `apitable_widget_package.package_id` 一致
4. **依赖报错** → 检查 webpack externals 对应的全局变量是否由主应用正确注入
5. **修改后不生效** → 重启 backend-server 清除缓存
6. **编译部署脚本报错** → 确认 Node 版本为 16（`node -v`），且 `pip install boto3` 已安装
7. **MinIO bucket policy 报错** → 确认 AWS 凭证和 endpoint 正确（`source scripts/dev-env.sh` 已处理）

## 技术说明

- 基于 React + TypeScript，通过 `widget-cli` 的 webpack 编译为 UMD 包
- `react`、`react-dom`、`@apitable/components`、`@apitable/core`、`@apitable/widget-sdk`、`@apitable/icons` 作为 webpack externals，由 widget-stage 页面在运行时注入 `window` 全局变量
- 入口文件必须调用 `initializeWidget(Component, packageId)`，packageId 需与数据库 `apitable_widget_package.package_id` 一致
- 每个小组件在独立的 iframe（`/widget-stage`）中运行，通过 postMessage 与主应用通信

## 参考资料

- https://help.aitable.ai/docs/guide/manual/widget/