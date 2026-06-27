# Minimal Plan Template

用于小 bugfix 或低风险小改。仅当改动范围清晰、无需新增架构决策、无需完整 design 比选时使用。删除不适用章节，不留空占位。

```markdown
# [问题/功能名] Minimal Plan

> Status: DRAFT
> Version: vX.Y.Z
> Source: summarized/<name>.md 或 用户请求 / issue
> Updated: YYYY-MM-DD
> Stale reason:

## 适用性判定

| 项 | 结论 | 说明 |
|----|------|------|
| 改动范围是否清晰 | 是 / 否 | |
| 是否无需新增架构决策 | 是 / 否 | |
| 是否不改变公共 API / 数据契约 | 是 / 否 | |
| 是否可用 1–3 个 task 完成 | 是 / 否 | |

任一项为「否」时，停止并回到完整 `frontend-design` + `frontend-plan`。

## 问题描述

一句话说明现象、影响用户、触发条件。

## 范围

**包含：**

- …

**不包含：**

- …

## 文件边界

| 操作 | 文件 | 说明 |
|------|------|------|
| 修改 | `src/...` | |
| 测试 | `src/...` / `tests/...` | |

## TDD Task

### Task 1: [任务名]

**目标**：…

**依赖**：无

**RED：失败测试**

- 测试文件：`src/...`
- 测试行为：…
- 预期失败原因：…
- 运行：`<test command>`

**GREEN：最小实现**

- 修改：`src/...`
- 实现：…

**REFACTOR：保持通过下清理**

- 无 / …

**VERIFY：验证**

- 运行：`<test command>`
- 通过条件：…

## 回归测试

| 风险 | 覆盖方式 | 命令 / 手动步骤 |
|------|----------|-----------------|
| | 单元 / 集成 / E2E / 手动 | |

## 发布风险

- …

（无则写「无」）

## Open Questions

- …

（无则写「无」）
```

## Rules

1. minimal plan 仍然必须包含文件边界、RED / GREEN / REFACTOR / VERIFY、回归测试。
2. minimal plan 不能绕过 `frontend-implement` 的 TDD 规则。
3. 发现需要新增公共抽象、跨模块状态、API 契约或大范围重构时，停止并回完整 design。
4. 用户确认后才将状态从 `DRAFT` 改为 `ACTIVE`。
