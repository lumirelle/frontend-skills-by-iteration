---
name: frontend-iteration
description: Use when starting, resuming, or continuing a versioned frontend iteration with docs/vX.Y.Z/ inputs.
disable-model-invocation: true
---

# Frontend Iteration

## Goal

按版本推进前端迭代：需求 → 设计 → TDD 计划 → 实现 → 测试 → 审查 → 发布材料。

本工作流接管同一迭代内的计划、实现、验证、审查与发布门禁；不要再叠加同职责的通用 Superpowers skill。测试失败或阻塞排查可用 `systematic-debugging`；外部人工 review 反馈可用 `receiving-code-review`。

## Scope

| Step | Skill | Output |
|------|-------|--------|
| 1 | `frontend-requirements` | `prd/summarized/*.md` |
| 2 | `frontend-design` | `design/*.md` |
| 3 | `frontend-plan` | `plans/*.md` |
| 4 | `frontend-implement` | 代码与测试变更 |
| 5 | `frontend-test` | `test-report.md` |
| 6 | `frontend-review` | `review/*.md` |
| 7 | `frontend-release` | `release/changelog-entry.md`、`release/pr-description.md` |

## Invocation

```
/frontend-iteration v1.2.0                  # fast（默认）：步骤 1–3 连续，步骤 4–7 逐步确认
/frontend-iteration v1.2.0 strict           # 每步均须确认
/frontend-iteration v1.2.0 fast             # 显式 fast
/frontend-iteration v1.2.0 step 3           # 从指定步骤继续（默认 fast）
/frontend-iteration v1.2.0 strict step 3    # 指定步骤 + strict
/frontend-iteration v1.2.0 resume           # 自动检测上次未完成步骤（默认 fast）
/frontend-iteration v1.2.0 init             # 仅 Bootstrap 脚手架后停止，不进入任何步骤
```

版本号必须为 `vX.Y.Z`，所有迭代产物位于 `docs/vX.Y.Z/`。常规迭代从 step 1 开始并要求 `prd/origin/*.md`；进入实现前必须有 `ACTIVE` plan。

## Mode

默认 `fast`：step 1–3 连续产出 `DRAFT`，step 3 后由编排器批量确认并转 `ACTIVE`，再进入 step 4。step 4–7 始终逐步确认。

`strict`：每步完成后都等待用户确认。

任何 `STALE` / `BLOCKED`、门禁失败、阻塞 open question 均停止，不自动推进。`DRAFT` 消费例外的唯一权威定义见 [orchestrated-invocation.md](references/orchestrated-invocation.md)。

## Skill Path Resolution

读取本工作流的 skill 或 reference 时，按顺序尝试（命中即用）：

| 资源 | 路径 1（`npx skills add`） | 路径 2（源码仓库） |
|------|------------------------------|---------------------|
| 本 skill 根 | `.agents/skills/frontend-iteration/` | `skills/frontend-iteration/` |
| sub-skill `<name>` | `.agents/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` |
| 编排器 references | `.agents/skills/frontend-iteration/references/<file>` | `skills/frontend-iteration/references/<file>` |
| 其他 sub-skill references | `.agents/skills/<name>/references/<file>` | `skills/<name>/references/<file>` |
| 黄金路径样例 | `.agents/skills/frontend-iteration/examples/` | `skills/frontend-iteration/examples/` |

**本 skill 根目录** = 本 `SKILL.md` 所在目录。内置资源均相对该目录：

- `templates/docs/technical-architecture.md`
- `templates/docs/version/`（复制为 `docs/vX.Y.Z/`）
- `examples/`（黄金路径成品样例，只读参照，不复制到项目 `docs/`）

## Prerequisites (HARD GATE)

开始前必须满足：

| 文件 / 目录 | 必需 | 说明 |
|-------------|------|------|
| `docs/technical-architecture.md` | 是 | Bootstrap 可从内置模板自动创建；须填写项目事实 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 原始 PRD |
| `docs/vX.Y.Z/progress.md` | 自动 | Bootstrap 从内置模板创建 |
| `docs/vX.Y.Z/ui/*`（任意常见图片格式） | 否 | 有则必须对照；无则标注「无 UI 稿」 |

缺失 `origin` PRD 时停止。

## Orchestration Rules

1. **顺序门禁**：默认不得跳步；当前 step 未通过 [step-gates.md](references/step-gates.md) 不得进入下一步。
2. **显式加载**：执行任一步前，必须按 Skill Path Resolution 读取对应 sub-skill；不得凭记忆执行。
3. **状态权威**：文档生命周期见 [document-status.md](references/document-status.md)；编排 / standalone 差异见 [orchestrated-invocation.md](references/orchestrated-invocation.md)。
4. **进度权威**：`docs/vX.Y.Z/progress.md` 是 resume 事实源；每步结束按 [progress-convention.md](references/progress-convention.md) 的 Per-Step Minimal Update 落盘。
5. **resume**：优先读 `progress.md`；缺失或不可信时按 [version-convention.md](references/version-convention.md) 的 Resume Detection 修复。
6. **跳步或返工**：先说明影响，获用户确认后执行；若遇遗留 `DRAFT`，先批量确认并转 `ACTIVE`，否则停止。

## Execution Flow

```
解析版本号、模式、起始 step
    ↓
Bootstrap 缺失 docs → 校验 technical-architecture 与输入
    ↓
读取 progress.md → 确定起点 / blocker / Draft Batch
    ↓
读取目标 sub-skill → 执行 → step gate → progress.md
    ↓
fast step 1–3 自动推进；step 3 后批量确认
strict 或 step 4–7 等待逐步确认
    ↓
下一步 / 结束
```

## Start Checklist

1. 确认版本号、模式（默认 fast）、起始 step / resume / init。
2. **Bootstrap**（缺失则自动创建，并告知用户）：
   - 无 `docs/technical-architecture.md` → 从 `<skill-root>/templates/docs/technical-architecture.md` 复制到 `docs/`。
   - 无 `docs/vX.Y.Z/` 或缺 `progress.md` → 从 `<skill-root>/templates/docs/version/` 复制到 `docs/vX.Y.Z/`，并将 `progress.md` 内 `vX.Y.Z` 替换为实际版本号。
3. `init` 模式完成 Bootstrap 后停止，提示补齐 `technical-architecture` 与 `prd/origin/*.md`。
4. 读取 `technical-architecture.md`；若仍是模板或缺少技术栈、命令、目录、测试配置，停止。
5. 列出 `prd/origin/*.md` 与 `ui/*`。
6. 读取或修复 `progress.md`，报告起点、blocker、Draft Batch 状态。
7. 读取目标 sub-skill；产出格式存疑时参考 [examples/README.md](examples/README.md) 与黄金路径样例。

## References

- 步骤门禁细则：[step-gates.md](references/step-gates.md)
- 代码风格防遗忘：[code-style-enforcement.md](references/code-style-enforcement.md)
- 接口联调全流程：[api-integration-guide.md](references/api-integration-guide.md)
- 版本与目录约定：[version-convention.md](references/version-convention.md)
- 进度记录约定：[progress-convention.md](references/progress-convention.md)
- 文档状态约定：[document-status.md](references/document-status.md)
- 编排调用契约（sub-skill 共用）：[orchestrated-invocation.md](references/orchestrated-invocation.md)
- 黄金路径样例：[examples/README.md](examples/README.md)
