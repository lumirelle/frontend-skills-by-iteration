---
name: frontend-iteration
description: Use when starting or continuing a versioned frontend iteration (vX.Y.Z). Requires docs/technical-architecture.md and docs/vX.Y.Z/prd/origin/*.md. Orchestrates requirements, design, plan, implementation, testing, review, and release.
disable-model-invocation: true
---

# Frontend Iteration

## Goal

按版本迭代执行前端开发全流程。

## Scope

1. 需求理解 → `frontend-requirements`
2. 技术方案设计 → `frontend-design`
3. TDD 实施计划拆解 → `frontend-plan`
4. TDD 代码实现 → `frontend-implement`
5. 全量自测（单元 / 集成 / E2E）→ `frontend-test`
6. 代码审查 → `frontend-review`
7. 文档 / 变更记录 / 合并发布 → `frontend-release`

## Invocation

```
/frontend-iteration v1.2.0                  # fast（默认）：步骤 1–3 连续，步骤 4–7 逐步确认
/frontend-iteration v1.2.0 strict           # 每步均须确认
/frontend-iteration v1.2.0 fast             # 显式 fast
/frontend-iteration v1.2.0 step 3           # 从指定步骤继续（默认 fast）
/frontend-iteration v1.2.0 strict step 3    # 指定步骤 + strict
/frontend-iteration v1.2.0 resume           # 自动检测上次未完成步骤（默认 fast）
```

版本号格式：`vX.Y.Z`（如 `v1.2.0`）。所有路径使用 `docs/vX.Y.Z/`。

## Interaction Mode

未指定时默认 **`fast`**。从 invocation 解析：`strict` → strict；否则 → fast。

| 模式 | 步骤 1–3（文档类） | 步骤 4–7（实现 / 测试 / 审查 / 发布） |
|------|-------------------|----------------------------------------|
| **fast**（默认） | 连续执行，不在每步后等待确认；步骤 3 门禁通过后**一次性**展示 1–3 摘要，用户确认后再进入步骤 4 | 每步完成后展示摘要并**等待确认** |
| **strict** | 每步完成后展示摘要并**等待确认** | 同左 |

**fast 模式细则**

1. 步骤 1–3 产出保持 `DRAFT`，不在各 sub-skill 内单独等用户确认；门禁通过后自动进入下一步。
2. 步骤 3 全部完成后：汇总 summarized / design / plan 列表、open questions、门禁结果；**等待用户确认**；确认后将对应文档标为 `ACTIVE`，再进入步骤 4。
3. 步骤 4 仍遵循 `frontend-implement` 的 per-task 验证与可选 commit 询问；步骤 5–7 每步结束等待确认。
4. `STALE` / `BLOCKED`、门禁失败、open questions 阻塞实现 → **不论模式均停止**，不自动推进。
5. 用户可在任意确认点说 `strict`，后续改按 strict 执行。

**strict 模式**：等同原「一步一确认」，每步完成后等待用户说「继续」或指定下一步。

## Skill Path Resolution

读取本 workflow 的 skill 或 reference 时，按顺序尝试（命中即用）：

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
- `scripts/validate-iteration.ps1`

## Golden Path Examples

对某步产出格式、粒度或字段存疑时，先读 `<skill-root>/examples/README.md`，再打开对应步骤的成品文件（当前样例：`examples/feedback-form-v0.1.0/docs/`）。样例只作参照，不得复制进当前项目 `docs/`。

## Prerequisites (HARD GATE)

开始前必须满足：

| 文件 / 目录 | 必需 | 说明 |
|-------------|------|------|
| `docs/technical-architecture.md` | 是 | Bootstrap 可从内置模板自动创建；须填写项目事实 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 本迭代原始 PRD（唯一须用户自备的输入） |
| `docs/vX.Y.Z/progress.md` | 自动 | Bootstrap 从内置模板创建 |
| `docs/vX.Y.Z/ui/*`（任意常见图片格式） | 否 | 有则必须对照；无则标注「无 UI 稿」 |

缺失 `origin` PRD → **停止**，提示用户补齐，不进入任何步骤。

## Orchestration Rules

1. **顺序执行**：默认不得跳步；当前步骤未通过门禁不得进入下一步。用户显式指定起始步骤（如 bugfix `step 4`）时，须确认该步骤的上游产出已存在或不适用，并经用户确认。
2. **交互模式**：按 Interaction Mode 执行。默认 **fast**；用户指定 `strict` 时每步均须确认。fast 下步骤 1–3 连续执行，步骤 3 结束后批量确认一次；步骤 4–7 逐步确认。
3. **显式加载 sub-skill**：执行任一步骤前，必须先按 Skill Path Resolution 读取并遵循对应 sub-skill 的 `SKILL.md`。不得凭记忆执行；均不存在时提示 `npx skills add <repo> --skill <name>` 并停止。
4. **resume 逻辑**：优先读取 `docs/vX.Y.Z/progress.md` 判断当前步骤、task 状态与阻塞项；缺失或不可信时再按 `references/version-convention.md` 的目录扫描规则兜底。
5. **状态门禁**：任何输入文档标记为 `STALE` 或 `BLOCKED` 时，不得继续消费该文档；须回到对应上游步骤更新或等待确认。
6. **范围外请求**：用户要求跳步或改已完成步骤 → 说明影响，获确认后执行。
7. **产出校验**：每步结束前对照 `references/step-gates.md` 逐项核对，在 `docs/vX.Y.Z/progress.md` 记录结果，并向用户展示通过 / 未通过项。
8. **工作流所有权**：通过 `frontend-iteration` 调用时，本 workflow 拥有需求、设计、计划、实现、测试、审查、发布生命周期；除非用户显式要求，不再额外调用通用 planning / TDD / verification / review skill 来重复编排。fast 模式下步骤 1–3 的确认由编排器批量接管，sub-skill 内「等待确认」在步骤 1–3 间暂不触发。

## Sub-skill Loading

| Step | Sub-skill | 必须先读取 |
|------|-----------|------------|
| 1 | `frontend-requirements` | Skill Path Resolution → `frontend-requirements/SKILL.md` |
| 2 | `frontend-design` | Skill Path Resolution → `frontend-design/SKILL.md` |
| 3 | `frontend-plan` | Skill Path Resolution → `frontend-plan/SKILL.md` |
| 4 | `frontend-implement` | Skill Path Resolution → `frontend-implement/SKILL.md` |
| 5 | `frontend-test` | Skill Path Resolution → `frontend-test/SKILL.md` |
| 6 | `frontend-review` | Skill Path Resolution → `frontend-review/SKILL.md` |
| 7 | `frontend-release` | Skill Path Resolution → `frontend-release/SKILL.md` |

## Step Gates

| Step | Sub-skill | 产出 | 通过条件 |
|------|-----------|------|----------|
| 1 | `frontend-requirements` | `docs/vX.Y.Z/prd/summarized/*.md` | 每个 origin PRD 有对应 summarized；含验收标准 |
| 2 | `frontend-design` | `docs/vX.Y.Z/design/*.md` | 含模块划分、数据流、变更范围、测试策略 |
| 3 | `frontend-plan` | `docs/vX.Y.Z/plans/*.md` | 任务可独立执行，含 RED/GREEN/REFACTOR 与测试点 |
| 4 | `frontend-implement` | 代码变更 | 严格 TDD；仅改 plan 范围内文件；遵循 technical-architecture |
| 5 | `frontend-test` | `docs/vX.Y.Z/test-report.md` | 全量回归；单元 / 集成 / E2E 按 plan 覆盖；命令 exit 0 |
| 6 | `frontend-review` | `docs/vX.Y.Z/review/*.md` | 无 🔴 未解决项 |
| 7 | `frontend-release` | CHANGELOG + PR 描述 | 文档与代码一致；合并清单完成 |

## Execution Flow

```
读取版本号 → 解析模式（默认 fast）→ 校验 Prerequisites
    ↓
确定起始步骤（step N 或 resume；优先读取 progress.md）
    ↓
读取对应 sub-skill → 执行 → 更新产出与 progress.md
    ↓
fast 且步骤 1–3：门禁通过 → 自动下一步（步骤 3 完成后批量摘要 → 等待确认 → ACTIVE）
strict 或步骤 4–7：校验产出 → 摘要 → 等待确认
    ↓
下一步 / 结束
```

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 默认启动（fast） | 步骤 1→2→3 连续；步骤 3 后批量确认文档，再进入 4 |
| 需要每步把关 | invocation 加 `strict` |
| 新迭代，仅有 origin PRD | 从步骤 1 开始 |
| 设计已完成，要开始编码 | `step 4`，确认 plan 存在 |
| 中途改需求 | 回到步骤 1 或 2，将受影响 downstream 产出标记为 `STALE` |
| 无 UI 稿 | 步骤 1 标注 open questions；步骤 2 基于 PRD 或项目已有类似设计推断并列出假设 |
| 多页面迭代 | 每页独立 summarized / design / plan 文件，文件名与 origin 一致；`test-report.md` 单文件汇总，`review/` 按 plan 分文件 |
| Bugfix 小改 | 可从 `step 3` 生成 minimal plan，再进入 `step 4`；若已有精简 plan，确认有效后可从 `step 4` 继续 |
| 测试失败 | 停留步骤 5，修复后重跑，不进入 review |
| 审查有 🔴 | 回步骤 4 或 5 修复，重新 review |

## On Start

1. 确认版本号、**交互模式**（默认 fast）与起始步骤；解析本 skill 根目录（Skill Path Resolution）。
2. **Bootstrap**（缺失则自动创建，并告知用户）：
   - 无 `docs/technical-architecture.md` → 从 `<skill-root>/templates/docs/technical-architecture.md` 复制到 `docs/`。
   - 无 `docs/vX.Y.Z/` 或缺 `progress.md` → 从 `<skill-root>/templates/docs/version/` 复制到 `docs/vX.Y.Z/`，并将 `progress.md` 内 `vX.Y.Z` 替换为实际版本号。
3. 读取 `docs/technical-architecture.md`。
4. 列出 `docs/vX.Y.Z/prd/origin/*.md`（及 UI 图若有）。
5. 读取或修复 `docs/vX.Y.Z/progress.md`；若 resume，先按其中状态判断起点。
6. 报告 Bootstrap 结果、模式、Prerequisites 与 progress 状态。
7. 按 Skill Path Resolution 读取目标 step 的 sub-skill；对产出格式存疑时读取 [examples/README.md](examples/README.md) 中对应步骤成品。

## References

- 步骤门禁细则：[step-gates.md](references/step-gates.md)
- 版本与目录约定：[version-convention.md](references/version-convention.md)
- 进度记录约定：[progress-convention.md](references/progress-convention.md)
- 文档状态约定：[document-status.md](references/document-status.md)
- 黄金路径样例：[examples/README.md](examples/README.md)
