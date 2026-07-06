---
name: frontend-iteration
description: Use when starting, resuming, or continuing a versioned frontend iteration with docs/vX.Y.Z/ inputs.
disable-model-invocation: true
---

# 前端迭代

## 目标

按版本推进：需求 → 设计 → TDD 计划 → 实现 → 测试 → 审查 → 发布。

本工作流接管同迭代内计划、实现、验证、审查、发布门禁。勿叠同职责 Superpowers skill。测试失败用 `systematic-debugging`；人工 review 反馈用 `receiving-code-review`。

## 范围

| Step | Skill | Output |
|------|-------|--------|
| 1 | `frontend-requirements` | `prd/summarized/*.md` |
| 2 | `frontend-design` | `design/*.md` |
| 3 | `frontend-plan` | `plans/*.md` |
| 4 | `frontend-implement` | 代码与测试 |
| 5 | `frontend-test` | `test-report.md` |
| 6 | `frontend-review` | `review/*.md` |
| 7 | `frontend-release` | `release/changelog-entry.md`、`release/pr-description.md` |

## 调用方式

```
/frontend-iteration v1.2.0                  # fast（默认）：1–3 连续，4–7 逐步确认
/frontend-iteration v1.2.0 strict           # 每步确认
/frontend-iteration v1.2.0 fast
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 strict step 3
/frontend-iteration v1.2.0 resume
/frontend-iteration v1.2.0 init             # 仅 Bootstrap，不进步骤
```

版本号 `vX.Y.Z`；产物在 `docs/vX.Y.Z/`。常规从 step 1 起，须 `prd/origin/*.md`；进实现前须有 `ACTIVE` plan。

## 模式

默认 `fast`：step 1–3 连续出 `DRAFT`；step 3 后批量确认转 `ACTIVE`，再进 step 4。step 4–7 逐步确认。

`strict`：每步完等待确认。

`STALE` / `BLOCKED`、门禁失败、阻塞待确认问题 → 停止。`DRAFT` 消费见 [orchestrated-invocation.md](references/orchestrated-invocation.md)。

## 技能路径解析

读 skill / reference 按序尝试（命中即用）：

| 资源 | 路径 1（`npx skills add`） | 路径 2（源码） |
|------|------------------------------|----------------|
| 本 skill 根 | `.agents/skills/frontend-iteration/` | `skills/frontend-iteration/` |
| sub-skill | `.agents/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` |
| 编排 references | `.agents/skills/frontend-iteration/references/<file>` | `skills/frontend-iteration/references/<file>` |
| 其他 references | `.agents/skills/<name>/references/<file>` | `skills/<name>/references/<file>` |
| 样例 | `.agents/skills/frontend-iteration/examples/` | `skills/frontend-iteration/examples/` |

**skill 根** = 本 `SKILL.md` 目录。内置资源：

- `templates/docs/technical-architecture.md`
- `templates/docs/version/` → `docs/vX.Y.Z/`
- `examples/`（只读，不复制到项目）

## 前置条件（硬门禁）

| 文件 / 目录 | 必需 | 说明 |
|-------------|------|------|
| `docs/technical-architecture.md` | 是 | Bootstrap 可自动建；须填项目事实 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 原始 PRD |
| `docs/vX.Y.Z/progress.md` | 自动 | Bootstrap 建 |
| `docs/vX.Y.Z/ui/*` | 否 | 有则对照；无则标「无 UI 稿」 |

缺 `origin` PRD → 停止。

## 编排规则

1. **顺序门禁**：默认不跳步；当前 step 未过 [step-gates.md](references/step-gates.md) 不进下一步。
2. **显式加载**：每步前按 Path Resolution 读 sub-skill；不凭记忆执行。
3. **状态权威**：生命周期见 [document-status.md](references/document-status.md)；编排差异见 [orchestrated-invocation.md](references/orchestrated-invocation.md)。
4. **进度权威**：`progress.md` 为 resume 事实源；每步按 [progress-convention.md](references/progress-convention.md) → **每步最小落盘** 落盘。
5. **resume**：先读 `progress.md`；缺/不可信则按 [version-convention.md](references/version-convention.md) → Resume Detection 修复。
6. **跳步/返工**：先说明影响，用户确认后执行；遗留 `DRAFT` 先批量确认转 `ACTIVE`，否则停。
7. **用户输出**：对用户摘要、gate、blocker、确认询问遵守 [agent-communication-style.md](references/agent-communication-style.md)。

## 执行流程

```
解析版本、模式、起始 step
    ↓
Bootstrap 缺 docs → 校验 architecture 与输入
    ↓
读 progress.md → 起点 / 阻塞项 / 草稿批次
    ↓
读 sub-skill → 执行 → gate → progress.md
    ↓
fast 1–3 自动；3 后批量确认
strict 或 4–7 逐步确认
    ↓
下一步 / 结束
```

## 启动检查

1. 确认版本、模式（默认 fast）、起始 step / resume / init。
2. **Bootstrap**（缺则建，告知用户）：
   - 无 `docs/technical-architecture.md` → 从 `<skill-root>/templates/docs/technical-architecture.md` 复制。
   - 无 `docs/vX.Y.Z/` 或缺 `progress.md` → 从 `<skill-root>/templates/docs/version/` 复制；`progress.md` 内版本号替换。
3. `init` 完 Bootstrap 后停；提示补 `technical-architecture` 与 `prd/origin/*.md`。
4. 读 `technical-architecture.md`；仍模板或缺技术栈/命令/目录/测试 → 停。
5. 列 `prd/origin/*.md`、`ui/*`。
6. 读/修 `progress.md`；报起点、阻塞项、草稿批次状态。
7. 读目标 sub-skill；格式疑义参考 [examples/README.md](examples/README.md)。

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
