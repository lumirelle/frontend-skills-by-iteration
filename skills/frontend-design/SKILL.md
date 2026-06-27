---
name: frontend-design
description: Use when turning docs/vX.Y.Z/prd/summarized/*.md into frontend technical designs for a versioned iteration.
disable-model-invocation: true
---

# Frontend Design

## Goal

将 summarized 需求转化为可落地的前端技术方案，明确改动范围与测试策略。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、目标平台、目录与约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 步骤 1 产出，一对一处理 |
| `docs/vX.Y.Z/ui/*` | 否 | 设计稿，用于确认组件拆分与交互 |
| 现有代码库 | 是 | 复用现有组件/模式，遵循既有结构 |

缺失必需项 → **停止**，报告缺什么，不产出 design。

## Output

- 目录：`docs/vX.Y.Z/design/`
- 命名：与 `summarized/` 同名（如 `summarized/user-profile.md` → `design/user-profile.md`）
- 模板：[technical-design-template.md](references/technical-design-template.md)
- 状态：初次产出为 `DRAFT`；用户确认后标记为 `ACTIVE`

## Invocation Contract

- 调用契约（orchestrated / standalone）与 Workflow 变体见 `frontend-iteration/references/orchestrated-invocation.md`（路径见 `frontend-iteration` → Skill Path Resolution）。
- 本 skill 只处理技术方案，不执行计划、实现、测试、审查或发布。

## Workflow

1. 读取 `technical-architecture.md`，确定技术栈、目录结构、状态管理、路由、请求层等约束。
2. 读取 summarized 状态；直接调用时仅 `ACTIVE` 可作为输入。由 `frontend-iteration fast` 步骤 2 调用时，可消费本轮步骤 1 生成的编排草稿。
3. 探查现有代码库：可复用的组件、hooks、工具、类型、API 封装。
4. 有 UI 稿时，参考 `frontend-requirements` 的 ui-reading-guide（路径见 `frontend-iteration` → Skill Path Resolution），按组件清单/层级/重复单元确认组件拆分与复用。
5. 逐份 summarized 生成 design；**先列出最小改动路径**，非平凡处再比选 2–3 方案（含最小改动方案）。
6. 标出涉及文件（新增/修改）、数据流、API/类型变更、错误处理、测试策略、风险回滚。
7. 按 Done Checklist 自检。
8. 向用户展示摘要（每页方案选型、改动文件清单、风险、open questions），等待确认；确认后将对应 design 状态更新为 `ACTIVE`。

> **编排器调用变体（fast）**：由 `frontend-iteration` 调用时，步骤 8 的「等待确认」**不在本 skill 内单步触发**——产出保持 `DRAFT`，门禁通过即由编排器进入下一步，步骤 3 后由编排器批量确认并统一标 `ACTIVE`；其间可消费本轮步骤 1 的编排草稿。strict 模式仍逐步确认。详见 `frontend-iteration/references/orchestrated-invocation.md` → Workflow 变体。

## Rules

1. **最小改动**：默认选改动文件最少、侵入最低、不新增抽象层的方案。能改现有文件就不新建；能内联就不抽 hook/工具；能局部 state 就不用全局 store；能直接调用就不加中间层。不为「以后可能用到」做通用化或预留扩展；若确需超出最小方案，须说明理由。
2. **先比选后定案**：非平凡处给 2–3 选项，**其中必须含一个最小改动方案**；优先推荐最小改动方案，除非有明确理由选复杂方案。
3. **架构对齐**：遵循 `technical-architecture.md` 与现有代码模式；冲突须显式标注。
4. **复用优先**：先找现有组件/hooks/工具，再考虑新建；说明为何不复用。
5. **范围可控**：仅设计满足 summarized 所需的改动，不夹带无关重构。
6. **可追溯**：每条设计决策能对应到 summarized 的某项需求或验收标准。
7. **测试前置**：方案须包含测试策略（单元/集成/E2E 各覆盖什么），供步骤 3 拆解。
8. **不写代码**：本步产出设计文档，不落实现代码（伪代码/接口签名可用）。
9. **状态门禁**：遵循 `frontend-iteration/references/document-status.md`。直接调用时不得消费不可用 summarized；由 `frontend-iteration fast` 调用时，仅步骤 1→2 的编排草稿例外可用。有阻塞 open questions 的 design 保持 `DRAFT` 或标记 `BLOCKED`。

## Design Coverage

每份 design 至少覆盖：

| 维度 | 内容 |
|------|------|
| 方案选型 | 备选方案、权衡、推荐理由 |
| 组件结构 | 组件树/拆分、职责、复用 vs 新建 |
| 数据流 | 状态归属、props/事件、全局 vs 局部状态 |
| 接口契约 | 调用的 API、入参/返回、前端类型定义 |
| 路由 | 新增/变更路由、参数、守卫/权限 |
| 错误处理 | 加载/空/错/无权限态的实现策略 |
| 兼容性 | 平台差异、响应式、浏览器/版本约束 |
| 测试策略 | 单元/集成/E2E 各测什么 |
| 风险与回滚 | 主要风险、降级/回滚方式 |

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 复用现有组件即可 | 说明复用点与改动，避免新建 |
| 倾向过度设计 | 回退到最小改动：删多余抽象/新建文件，在方案选型中说明为何不选复杂方案 |
| 需新建通用组件 | 设计 props/事件接口，置于约定的 shared 目录 |
| 涉及全局状态 | 明确状态归属（全局 store vs 局部），避免滥用全局 |
| 新增 API 依赖 | 定义前端类型与请求封装位置；后端未就绪则用 mock 并标注 |
| 多页面迭代 | 每页独立 design；跨页公共部分抽到一份共享设计或在各 design 引用 |
| 跨平台差异 | 在兼容性维度写明各端实现差异与适配方案 |
| 性能敏感（长列表/大表单） | 给出虚拟化/分页/懒加载等方案与取舍 |
| 改动影响现有功能 | 列出受影响模块与回归测试范围 |
| summarized 有 open questions | 设计中标注「依赖确认」，给出默认假设方案 |
| summarized 与现有架构冲突 | 列为 open question，给出兼容/改造两套思路 |
| summarized 更新 | 将对应 design 及下游 plan / review 标记为 `STALE`，写明原因 |

## Done Checklist

- [ ] 每份 summarized 有同名 design，且含状态头
- [ ] design 覆盖方案选型、组件结构、数据流、接口契约、错误处理、兼容性、测试策略、风险回滚
- [ ] 涉及文件已列出，且未夹带无关重构
- [ ] 已选最小可行方案，或充分说明为何选更复杂方案
- [ ] 完整门禁与 `progress.md` 落盘已按 `frontend-iteration/references/orchestrated-invocation.md` → Done Checklist（通用项）完成（路径见 `frontend-iteration` → Skill Path Resolution）

## References

- 产出模板：[technical-design-template.md](references/technical-design-template.md)
- UI 读图指引：`frontend-requirements` 的 `references/ui-reading-guide.md`（路径见 `frontend-iteration` → Skill Path Resolution）
