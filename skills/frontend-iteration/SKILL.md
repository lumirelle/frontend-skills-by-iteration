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
3. 实施计划拆解 → `frontend-plan`
4. 代码实现 → `frontend-implement`
5. 自测（单元 / 集成 / E2E）→ `frontend-test`
6. 代码审查 → `frontend-review`
7. 文档 / 变更记录 / 合并发布 → `frontend-release`

## Invocation

```
/frontend-iteration v1.2.0           # 从步骤 1 开始
/frontend-iteration v1.2.0 step 3    # 从指定步骤继续
/frontend-iteration v1.2.0 resume    # 自动检测上次未完成步骤
```

版本号格式：`vX.Y.Z`（如 `v1.2.0`）。所有路径使用 `docs/vX.Y.Z/`。

## Prerequisites (HARD GATE)

开始前必须满足：

| 文件 / 目录 | 必需 | 说明 |
|-------------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、环境、目标平台、项目约定 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 本迭代原始 PRD |
| `docs/vX.Y.Z/ui/*`（任意常见图片格式） | 否 | 有则必须对照；无则标注「无 UI 稿」 |

缺失必需项 → **停止**，提示用户补齐，不进入任何步骤。

## Orchestration Rules

1. **顺序执行**：默认不得跳步；当前步骤未通过门禁不得进入下一步。用户显式指定起始步骤（如 bugfix `step 4`）时，须确认该步骤的上游产出已存在或不适用，并经用户确认。
2. **一步一确认**：每步产出完成后，向用户展示摘要并等待确认（用户说「继续」或指定下一步）。
3. **resume 逻辑**：扫描 `docs/vX.Y.Z/` 各步骤产出目录，从第一个缺失产出的步骤继续。
4. **范围外请求**：用户要求跳步或改已完成步骤 → 说明影响，获确认后执行。
5. **子 Skill 未安装**：提示 `npx skills add <repo> --skill <name>`，停止。
6. **产出校验**：每步结束前对照 references/step-gates.md 逐项核对，在向用户展示的摘要中列出核对结果（通过 / 未通过项）。

## Step Gates

| Step | Sub-skill | 产出 | 通过条件 |
|------|-----------|------|----------|
| 1 | `frontend-requirements` | `docs/vX.Y.Z/prd/summarized/*.md` | 每个 origin PRD 有对应 summarized；含验收标准 |
| 2 | `frontend-design` | `docs/vX.Y.Z/design/*.md` | 含模块划分、数据流、变更范围、测试策略 |
| 3 | `frontend-plan` | `docs/vX.Y.Z/plans/*.md` | 任务可独立执行，含文件路径与测试点 |
| 4 | `frontend-implement` | 代码变更 | 仅改 plan 范围内文件；遵循 technical-architecture |
| 5 | `frontend-test` | 测试 + `docs/vX.Y.Z/test-report.md` | 单元 / 集成 / E2E 按 plan 覆盖；命令 exit 0 |
| 6 | `frontend-review` | `docs/vX.Y.Z/review/*.md` | 无 🔴 未解决项 |
| 7 | `frontend-release` | CHANGELOG + PR 描述 | 文档与代码一致；合并清单完成 |

## Execution Flow

```
读取版本号 → 校验 Prerequisites
    ↓
确定起始步骤（step N 或 resume）
    ↓
加载对应 sub-skill → 执行 → 产出文件
    ↓
校验产出 → 向用户摘要 → 等待确认
    ↓
下一步 / 结束
```

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 新迭代，仅有 origin PRD | 从步骤 1 开始 |
| 设计已完成，要开始编码 | `step 4`，确认 plan 存在 |
| 中途改需求 | 回到步骤 1 或 2，标记受影响 downstream 产出待更新 |
| 无 UI 稿 | 步骤 1 标注 open questions；步骤 2 基于 PRD 或项目已有类似设计推断并列出假设 |
| 多页面迭代 | 每页独立 summarized / design / plan 文件，文件名与 origin 一致；`test-report.md` 单文件汇总，`review/` 按 plan 分文件 |
| Bugfix 小改 | 可 `step 4` 起，但须有一份精简 plan（范围 + 回归测试），缺则先补 `step 3` |
| 测试失败 | 停留步骤 5，修复后重跑，不进入 review |
| 审查有 🔴 | 回步骤 4 或 5 修复，重新 review |

## On Start

1. 确认版本号与起始步骤。
2. 读取 `docs/technical-architecture.md`。
3. 列出 `docs/vX.Y.Z/prd/origin/*.md`（及 UI 图若有）。
4. 报告 Prerequisites 状态。
5. 进入第一步或用户指定步骤。

## References

- 步骤门禁细则：[step-gates.md](references/step-gates.md)
- 版本与目录约定：[version-convention.md](references/version-convention.md)
