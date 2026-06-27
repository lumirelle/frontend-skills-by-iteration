---
name: frontend-test
description: Use when running and completing frontend self-tests for a versioned iteration (vX.Y.Z). Requires docs/technical-architecture.md, docs/vX.Y.Z/plans/*.md, and implemented code. Produces docs/vX.Y.Z/test-report.md. Invoked by frontend-iteration step 5 or directly.
disable-model-invocation: true
---

# Frontend Test

## Goal

按 plan 与 summarized 验收标准完成自测（单元 / 集成 / E2E），产出可审计的测试报告。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 测试命令、框架、环境要求 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 测试矩阵与验证项 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收标准 |
| `docs/vX.Y.Z/design/*.md` | 否 | 测试策略参考 |
| 已实现代码 | 是 | 步骤 4 产出 |

缺失必需项或实现未完成 → **停止**，报告缺什么，不进入 review。

## Output

- `docs/vX.Y.Z/test-report.md`
- 测试代码补全（仅限 plan 测试矩阵要求且步骤 4 未覆盖的部分）
- 模板：[test-report-template.md](references/test-report-template.md)
- 用例指南：[test-writing-guide.md](references/test-writing-guide.md)

## Workflow

1. 读取 `technical-architecture.md`，确认单元 / 集成 / E2E 命令与环境。
2. 读取 [test-writing-guide.md](references/test-writing-guide.md)，用测试维度检查 plans 测试矩阵。
3. 读取 plans 测试矩阵与 summarized 验收标准，列出待执行项。
4. 对照矩阵检查测试是否已存在；缺失则补写（最小范围，不改业务逻辑）。
5. 分层执行：单元 → 集成 → E2E；失败则修复后重跑，不进入下一层。
6. 生成 `test-report.md`（命令、结果、覆盖映射、未覆盖风险）。
7. 按 Done Checklist 自检。
8. 向用户展示摘要，等待确认。

## Rules

1. **以 plan 为准**：测试范围不超过 plan 测试矩阵与 summarized 验收标准。
2. **先跑再补**：优先执行已有测试；仅补矩阵要求且缺失的用例。
3. **测试改动最小化**：补测试时不改业务实现；需改实现则回到 `frontend-implement`。
4. **真实执行**：必须实际运行命令，用 exit code 与输出作为结果依据，不臆断通过。
5. **分层门禁**：单元未全过不跑集成；集成未全过不跑 E2E（无该层则跳过）。
6. **失败不推进**：任一相关命令失败 → 停留本步修复，不进入 `frontend-review`。
7. **不写 test-report 前不宣称完成**：报告须含每条验收标准的覆盖情况。
8. **框架用法不过度沉淀**：具体测试 API、mock、locator、异步等待等用法从项目既有示例或当前官方文档获取，不写死在 Skill 中。

## Test Layers

| 层级 | 覆盖 | 来源 |
|------|------|------|
| 单元 | 纯逻辑、工具、组件渲染/交互 | plan 测试矩阵 |
| 集成 | API 联调、模块协作、请求封装 | plan + design |
| E2E | 关键用户路径 | summarized 主流程 |

项目未配置某层 → 在报告中标注「未配置」及替代覆盖方式。

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 步骤 4 已跑过 task 验证 | 纳入报告，避免重复；未覆盖项补跑 |
| 缺测试用例 | 按矩阵补最小用例，不改 plan 外行为 |
| 单元过、集成失败 | 修集成问题（实现或 mock），重跑集成 |
| E2E 环境未就绪 | 标注阻塞项；与用户确认是否降级为手动验收 |
| Flaky 测试 | 重跑 1 次；仍失败则按失败处理并记录 |
| 无 E2E 框架 | 报告说明；关键路径改手动验收清单 |
| 多份 plan | 合并矩阵，统一报告 |
| 验收标准无自动化覆盖 | 列手动步骤与结果，标注未覆盖风险 |

## Done Checklist

- [ ] `test-report.md` 已生成
- [ ] 单元测试覆盖 plan 标注的核心逻辑
- [ ] 集成测试覆盖 API / 模块协作（若适用）
- [ ] E2E 覆盖关键用户路径（若适用）
- [ ] 报告含：执行命令、结果、验收标准映射、未覆盖风险
- [ ] 所有相关测试命令 exit 0（或已记录的手动验收通过）
- [ ] 无未修复的失败用例

## Handoff to Step 6

交给 `frontend-review`：

- `test-report.md`
- 变更文件范围（来自 plan）
- 已知风险与未覆盖项

## References

- 测试报告模板：[test-report-template.md](references/test-report-template.md)
- 用例编写指南：[test-writing-guide.md](references/test-writing-guide.md)
