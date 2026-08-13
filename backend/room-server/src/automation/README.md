# Automation 自动化模块

自动化引擎支持 **触发器（Trigger）→ 动作（Action）** 的流程编排，当触发条件满足时自动执行动作。

## 架构

自动化代码分布在三个层级：

| 层级 | 路径 | 职责 |
|------|------|------|
| 前端 UI | `frontend/datasheet/src/pc/components/robot/` | 自动化配置面板、表单组件 |
| Room-server | `backend/room-server/src/automation/` | 实时触发（WebSocket 事件）、激活/停用校验、任务调度 |
| Backend-server | `backend/backend-server/.../automation/` | CRUD、定时调度、执行历史 |
| 数据库 | `init-db/05_automation.sql` | 触发器类型和动作类型种子数据 |

## 数据格式

自动化表单数据使用 **Expression/Operand** 格式存储：

```json
{
  "type": "Expression",
  "value": {
    "operator": "newObject",
    "operands": [
      "url", {"type": "Literal", "value": "https://example.com"},
      "method", {"type": "Literal", "value": "POST"},
      "headers", {"type": "Expression", "value": {"operator": "newArray", "operands": [...]}},
      "body", {"type": "Expression", "value": {"operator": "newObject", "operands": [...]}}
    ]
  }
}
```

核心转换函数在 `packages/core/src/automation_manager/`：

- `utils.ts` — operand 类型判断、属性读取
- `validate.ts` — `validateMagicForm` 表单校验

## 激活流程

```text
前端点击启用
  → POST /nest/v1/automation/robots/:robotId/active
    → Room-server RobotController.activeRobot()
      → AutomationService.activeRobot()
        1. 获取 robot 详情（触发器 + 动作 + 类型定义）
        2. 对每个触发器 input 调用 validateMagicForm(schema, input)
        3. 对每个动作 input 调用 validateMagicForm(schema, input)
        4. 全部通过 → 更新 isActive = true，返回 { ok: true }
        5. 任一失败 → 返回 { ok: false, errorsByNodeId }
      → 前端收到 false → 弹出"请检查自动化中的触发条件和动作配置是否完整"
```

## 固定表单组件

部分动作类型使用专门的固定表单组件，而非动态生成的 JSON Schema 表单。通过 `endpoint` 名称路由：

```typescript
// frontend/datasheet/src/pc/components/robot/robot_detail/action/robot_action.tsx
const actionFormMap: Record<string, React.FC<any>> = {
  sendRequest: SendWebhookForm,   // Webhook 请求
  sendMail: SendMailForm,         // 发送邮件
};
```

表单组件位于 `frontend/datasheet/src/pc/components/robot/robot_detail/action/forms/`。

## 常见问题

### 自动化无法启用（"触发条件和动作配置不完整"）

根因是表单中有默认值的下拉框字段（如 Webhook 的 `method: "POST"`），默认值仅作为 UI 回退显示（`??` 操作符），不会自动写入 Expression formData。用户没主动操作下拉框 → 该字段在 operands 中缺失 → `validateMagicForm` 判定 required 字段为 null → 校验失败。

**修复方式**：在固定表单组件中通过 `useEffect` 初始化 required 字段的默认值为 Literal operand。

**临时解决**：重新点选一次下拉框字段，触发 onChange 写入 formData，再保存。

### 调试技巧

- Room-server 日志包含 `validateMagicForm` 的校验详情：`trigger is valid: true/false`、`no errors: true/false`
- 数据库 `apitable_automation_action.input` 字段存储实际的 Expression JSON，可直接查看缺失了哪些字段
- 自动化执行历史在 `apitable_automation_run_history` 表中
