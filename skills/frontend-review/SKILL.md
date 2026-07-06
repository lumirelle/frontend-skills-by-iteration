---
name: frontend-review
description: Use when reviewing implemented frontend iteration work against docs/vX.Y.Z/ requirements, design, plans, and test report.
disable-model-invocation: true
---

# Frontend Review

## Goal

对照需求、方案、计划与测试报告审查代码，分级记录问题，无 🔴 未解决项方可进入发布。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 架构与代码约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 需求与验收标准 |
| `docs/vX.Y.Z/design/*.md` | 是 | 技术方案 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 改动边界 |
| `docs/vX.Y.Z/test-report.md` | 是 | 测试结果与未覆盖风险 |
| `docs/vX.Y.Z/progress.md` | 是 | step / task 状态与 TDD 证据 |
| 代码变更 | 是 | 实现 diff / 变更文件 |

缺失必需项或 test-report 结论为「阻塞」→ **停止**，不产出 review 通过结论。

## Output

- 目录：`docs/vX.Y.Z/review/`
- 命名：与 `plans/` 同名，或单份 `review.md`（多页面迭代时优先按 plan 拆分）
- 模板：[review-template.md](references/review-template.md)

## Invocation Contract

- orchestrated / standalone 差异以 `frontend-iteration/references/orchestrated-invocation.md` 为准；直接调用时须确认步骤 4–5 已完成。
- 本 skill 只产出审查记录；发现问题时给出回到 `frontend-implement` 或 `frontend-test` 的建议，不擅自修代码。

## Workflow

1. 读取 summarized、design、plans，明确预期行为与改动边界。
2. 读取 `progress.md` 与 `test-report.md`，确认 task 状态、TDD 证据、测试结论与未覆盖风险。
3. 审查代码变更（diff），对照 plan 文件边界与 design 方案；审查前重读 `progress.md` → Style Anchors。
4. 按 Review Dimensions 逐项检查；对照 `api-integration-guide` 核对 API 封装、占位与 `TODO(vX.Y.Z): 接口联调待定`。
5. 生成 `review/*.md`，给出结论：**通过** / **有条件通过** / **不通过**。
6. 将 review gate 结果写入 `progress.md`。
7. 按 Done Checklist 自检。
8. 向用户展示摘要（结论、🔴/🟡/🟢 统计、建议动作），等待确认。

## Rules

1. **证据导向**：每条问题须指向具体文件/行或行为，不空泛批评。
2. **对照上游**：审查基准是 summarized + design + plan，不是 Agent 个人偏好。
3. **分级明确**：🔴 必须修复；🟡 建议改进；🟢 可选优化。
4. **不擅自改代码**：本步只产出审查记录；修复回到 `frontend-implement` 或 `frontend-test`。
5. **🔴 阻断**：存在未解决 🔴 → 结论为「不通过」，不进入 `frontend-release`。
6. **最小改动视角**：标记 plan 外改动、多余抽象、可合并的重复逻辑。
7. **测试交叉验证**：test-report 声称通过但代码审查发现明显缺口 → 标为 🔴 或 🟡。
8. **进度交叉验证**：`progress.md` 中未完成、blocked 或缺少 VERIFY 的 task，不得给出「通过」结论。
9. **状态门禁**：通用规则见 `frontend-iteration/references/orchestrated-invocation.md`；输入 summarized / design / plan / test-report 不可用时停止；Step 4 task 未完成或 Step 5 `blocked` 时不得给出「通过」。

## Review Dimensions

| 维度 | 检查点 |
|------|--------|
| 需求符合 | 行为与 summarized 验收标准一致 |
| 方案符合 | 实现与 design 一致，无未解释的偏离 |
| 范围符合 | 改动 ⊆ plan 文件边界，无隐藏重构 |
| 架构一致 | 目录、命名、状态管理、请求封装符合 technical-architecture 与 Style Anchors |
| 代码风格 | 与邻文件、Style Anchors 一致；lint 可过（若已配置） |
| 接口联调 | 封装边界、占位、TODO 格式与 design 一致；页面无硬编码假数据 |
| 正确性 | 逻辑、边界、错误处理、权限态 |
| 可维护性 | 可读性、重复代码、过度抽象 |
| 测试充分 | 与 test-report 一致；关键路径有覆盖 |
| 安全 | XSS、敏感信息暴露、不安全 DOM 操作（适用时） |
| 性能 | 明显不必要渲染、重复请求、大列表无优化（适用时） |
| 回归风险 | 对既有功能的影响是否已评估 |

## Severity Guide

| 级别 | 含义 | 示例 |
|------|------|------|
| 🔴 | 必须修复才能发布 | 功能错误、越权、plan 外大改、测试虚假通过 |
| 🟡 | 建议修复，可协商 | 命名不佳、缺错误处理、测试覆盖不足但可接受 |
| 🟢 | 可选优化 | 风格、微重构、文档补充 |

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 实现偏离 design 但更优 | 标 🟡，建议回 design 补记录或回滚实现 |
| plan 外文件被修改 | 标 🔴，除非 plan 已同步更新 |
| test-report 有未覆盖风险 | 在 review 中引用，评估是否阻塞发布 |
| progress 与 test-report 不一致 | 标 🔴 或 open question，要求回步骤 4/5 补齐证据 |
| 上游文档为 STALE | 停止，回对应上游步骤更新，不产出通过结论 |
| 有 🔴 | 结论「不通过」，指明回步骤 4 或 5 |
| 审查中发现需求歧义 | 标 open question，不擅自扩大范围 |

## Done Checklist

- [ ] `review/` 含审查记录
- [ ] 输入 summarized / design / plan / test-report 状态均为 `ACTIVE`
- [ ] 问题已分级：🔴 / 🟡 / 🟢
- [ ] 结论明确：通过 / 有条件通过 / 不通过
- [ ] 无未解决 🔴（通过或有条件通过时）
- [ ] 与 test-report、plan、design 交叉核对完成
- [ ] 与 `progress.md` 的 task 状态和 TDD 证据交叉核对完成
- [ ] 通用门禁与 `progress.md` 落盘已按 `frontend-iteration/references/orchestrated-invocation.md` 完成

## Handoff to Step 7

交给 `frontend-release`（仅当无 🔴 或用户接受有条件通过）：

- `review/*.md`
- `test-report.md`
- 变更摘要与已知 🟡 项

## References

- 审查模板：[review-template.md](references/review-template.md)
- 代码风格：`frontend-iteration/references/code-style-enforcement.md`
- 接口联调：`frontend-iteration/references/api-integration-guide.md`
