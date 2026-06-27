---
name: frontend-plan
description: Use when decomposing frontend technical designs for a versioned iteration (vX.Y.Z) into implementation tasks. Requires docs/technical-architecture.md, docs/vX.Y.Z/prd/summarized/*.md, and docs/vX.Y.Z/design/*.md. Produces docs/vX.Y.Z/plans/*.md. Invoked by frontend-iteration step 3 or directly.
disable-model-invocation: true
---

# Frontend Plan

## Goal

将 design 拆成最小、顺序明确、可验证的 TDD 实施计划，作为代码实现边界。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、目录、测试命令、工程约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收标准与需求边界 |
| `docs/vX.Y.Z/design/*.md` | 是 | 技术方案与涉及文件 |
| 现有代码库 | 是 | 确认文件路径、复用点、测试位置 |

缺失必需项 → **停止**，报告缺什么，不产出 plan。

## Output

- 目录：`docs/vX.Y.Z/plans/`
- 命名：与 `design/` 同名（如 `design/user-profile.md` → `plans/user-profile.md`）
- 模板：[implementation-plan-template.md](references/implementation-plan-template.md)

## Workflow

1. 读取 `technical-architecture.md`，确认构建、测试、目录、代码风格约定。
2. 读取对应 summarized 与 design，确认需求、验收标准、推荐方案、涉及文件。
3. 探查现有代码路径，校正 design 中的文件位置与测试位置。
4. 将 design 拆成 TDD task：RED（失败测试）→ GREEN（最小实现）→ REFACTOR（保持通过下清理）→ VERIFY（验证命令）。
5. 填写测试矩阵时，参考 `frontend-test` 的 test-writing-guide 确定测试维度。
6. 按 Done Checklist 自检。
7. 向用户展示摘要（任务列表、文件边界、测试命令、风险），等待确认。

## Rules

1. **最小任务**：计划只覆盖 design 已确认的最小方案；不得新增 design 未提到的抽象、重构或功能。
2. **文件边界**：任务必须列出精确文件路径。未知路径先探查；仍不确定则写 open question，不猜。
3. **可执行粒度**：每个任务应能独立完成和验证；过大的任务拆小，过细的机械步骤合并。
4. **TDD 内置**：每个行为改动必须先写失败测试，再写最小实现；无法 TDD 的项须说明原因。
5. **顺序明确**：标出依赖关系；能并行的任务可标注，但默认顺序执行。
6. **不重新设计**：发现 design 缺口或不合理时，停止并回到 `frontend-design` 修正，不在 plan 中暗改方案。
7. **不写代码**：本步只写实施计划，不改业务代码。

## Task Shape

每个任务至少包含：

| 字段 | 要求 |
|------|------|
| 目标 | 一句话说明完成什么 |
| 文件 | 新增/修改/测试文件路径 |
| 步骤 | 2–6 个可执行动作 |
| 验证 | 相关测试命令或手动验收点 |
| 依赖 | 依赖的前置任务；无则写「无」 |

每个行为 task 必须包含：

| 阶段 | 要求 |
|------|------|
| RED | 写一个最小失败测试，并说明预期失败原因 |
| GREEN | 写最小生产代码让该测试通过 |
| REFACTOR | 如需清理，只做不改变行为的调整，并保持测试通过 |
| VERIFY | 运行相关测试命令，记录通过条件 |

## Common Scenarios

| 场景 | 处理 |
|------|------|
| design 涉及多个页面 | 每页生成独立 plan；共享改动放在最早依赖任务 |
| 只改现有组件 | 任务聚焦修改与测试，不新增目录结构 |
| 需要新组件 | 先写组件测试/故事或渲染用例，再实现，再接入页面 |
| API 未就绪 | 计划 mock/契约类型与切换点，不阻塞 UI 实施 |
| 有全局状态变更 | 单独任务处理 store/type/test，避免混入 UI 任务 |
| 表单/校验 | 单独列校验规则测试与提交路径测试 |
| 列表/表格 | 覆盖分页、空态、加载、错误、筛选/排序（若需求包含） |
| E2E 成本高 | 只覆盖关键路径；其余用单元/集成说明 |
| design 有 open questions | 不生成受影响任务，列为阻塞项等待确认 |
| 发现需超出最小改动 | 停止，要求回到 design 更新方案 |

## Done Checklist

- [ ] `plans/` 存在且非空
- [ ] 每份 design 有同名 plan
- [ ] 每个任务含：目标、文件、步骤、验证、依赖
- [ ] 每个行为任务含 RED / GREEN / REFACTOR / VERIFY
- [ ] 任务顺序能从空实现推进到可验收功能
- [ ] 测试覆盖与 summarized 验收标准对应
- [ ] 改动范围不超过 design 涉及文件；超出项已标注并待确认
- [ ] 无隐藏重构、无未解释的新抽象

## References

- 产出模板：[implementation-plan-template.md](references/implementation-plan-template.md)
- 测试维度参考：`frontend-test` 的 `references/test-writing-guide.md`
