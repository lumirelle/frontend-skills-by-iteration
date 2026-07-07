---
name: frontend-iteration
description: Use when starting, resuming, or continuing a versioned frontend iteration with docs/vX.Y.Z/ inputs.
disable-model-invocation: true
---

# 前端迭代

## 目标

按版本推进的步骤：1 需求 → 2 设计 → 3 TDD 计划 → 4 实现 → 5 测试 → 6 审查 → 7 发布

本工作流接管同迭代内计划、实现、验证、审查、发布门禁

如果用户安装了 Superpowers skill：忽略同职责的 Superpowers skill；测试失败可用 `systematic-debugging`；人工 review 反馈可用 `receiving-code-review`

## 步骤与子 skill 对应

| 步骤 | 子 Skill |
|------|-------|
| 1 | `frontend-requirements` |
| 2 | `frontend-design` |
| 3 | `frontend-plan` |
| 4 | `frontend-implement` |
| 5 | `frontend-test` |
| 6 | `frontend-review` |
| 7 | `frontend-release` |

## 调用方式

```
/frontend-iteration v1.2.0                  # fast（默认）：1–3 连续，4–7 逐步确认
/frontend-iteration v1.2.0 strict           # 每步确认
/frontend-iteration v1.2.0 fast
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 strict step 3
/frontend-iteration v1.2.0 resume
```

版本号 `vX.Y.Z`；产物在 `docs/vX.Y.Z/`

## 编排规则

1. **显式加载**：步骤执行前重读子 skill，不凭记忆执行
2. **顺序门禁**：不跳步，当前步骤未过 [step-gates.md](references/step-gates.md) 不进下一步
3. **状态权威**：基于文档状态 [document-status.md](references/document-status.md) 编排步骤，编排契约见 [orchestrated-invocation.md](references/orchestrated-invocation.md)
4. **进度权威**：`progress.md` 为 resume 事实源，每步按 [progress-convention.md](references/progress-convention.md) → **每步最小落盘** 落盘
5. **resume**：先读 `progress.md`，缺/不可信则按 [version-convention.md](references/version-convention.md) → 恢复检测 修复
6. **跳步/返工**：先说明影响，用户确认后执行；遗留 `DRAFT` 先批量确认转 `ACTIVE`，否则停
7. **用户输出**：对用户摘要、门禁、阻塞项、确认询问遵守 [agent-communication-style.md](references/agent-communication-style.md)

## 执行流程

```
解析版本、模式、起始 step
    ↓
初始化缺 docs → 校验架构与输入
    ↓
读 progress.md → 起点 / 阻塞项 / 草稿批次
    ↓
读子 skill → 执行 → 门禁 → progress.md
    ↓
fast 模式步骤 1–3 自动；步骤 3 后批量确认
strict 模式或步骤 4–7 逐步确认
    ↓
下一步 / 结束
```

## 启动检查

1. 确认版本、模式（默认 fast）、起始 step / resume
2. 初始化（缺则建，告知用户）：
   - 无 `docs/technical-architecture.md` → 从 `<skill-root>/templates/docs/technical-architecture.md` 复制
   - 无 `docs/vX.Y.Z/` 或缺 `progress.md` → 从 `<skill-root>/templates/docs/version/` 复制；`progress.md` 内版本号替换
3. 若本次执行了步骤 2 初始化 → 停，提示补 `technical-architecture` 与 `prd/origin/*.md`
4. `technical-architecture` 可在用户确认后修改；`prd/origin/*.md` 须用户提供，缺则停
5. 读 `technical-architecture.md`，仍模板或缺技术栈/命令/目录/测试 → 停
6. 列 `prd/origin/*.md`、`ui/*`
7. 读/修 `progress.md`，报起点、阻塞项、草稿批次状态
8. 读目标子 skill，格式疑义参考 [examples/README.md](examples/README.md)

## 模式

| 模式 | 说明 |
| -- | -- |
| `fast` | 默认，步骤 1–3 连续输出，统一确认；步骤 4–7 逐步确认 |
| `strict` | 逐步确认 |

## 文件路径解析

读 skill / reference 按序尝试（命中即用）：

| 资源 | 路径 1（`npx skills add`） | 路径 2（源码） |
|------|------------------------------|----------------|
| 本 `SKILL.md` 目录 | `.agents/skills/frontend-iteration/` | `skills/frontend-iteration/` |
| 子 skill | `.agents/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` |
| 编排 references | `.agents/skills/frontend-iteration/references/<file>` | `skills/frontend-iteration/references/<file>` |
| 其他 references | `.agents/skills/<name>/references/<file>` | `skills/<name>/references/<file>` |
| 样例 | `.agents/skills/frontend-iteration/examples/` | `skills/frontend-iteration/examples/` |

## 前置条件

| 文件 / 目录 | 必需 | 说明 |
|-------------|------|------|
| `docs/technical-architecture.md` | 若不存在则自动 | 须填项目事实 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 原始 PRD |
| `docs/vX.Y.Z/progress.md` | 自动 | 自动建 |
| `docs/vX.Y.Z/ui/*` | 否 | 有则对照；无则标「无 UI 稿」 |

前置条件不满足 → 停止

## 参考

- 步骤门禁：[step-gates.md](references/step-gates.md)
- 用户输出风格：[agent-communication-style.md](references/agent-communication-style.md)
- 代码风格防遗忘：[code-style-enforcement.md](references/code-style-enforcement.md)
- 接口联调：[api-integration-guide.md](references/api-integration-guide.md)
- 版本目录：[version-convention.md](references/version-convention.md)
- 进度：[progress-convention.md](references/progress-convention.md)
- 文档状态：[document-status.md](references/document-status.md)
- 编排契约：[orchestrated-invocation.md](references/orchestrated-invocation.md)
- 样例：[examples/README.md](examples/README.md)
