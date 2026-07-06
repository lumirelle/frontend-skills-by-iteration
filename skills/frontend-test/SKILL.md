---
name: frontend-test
description: Use when verifying implemented frontend iteration work and producing docs/vX.Y.Z/test-report.md.
disable-model-invocation: true
---

# 前端测试

## 目标

按 plan、summarized 全量回归；核对覆盖；出可审计 test-report。

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 命令、框架、环境 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 测试矩阵 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收 |
| `docs/vX.Y.Z/design/*.md` | 否 | 测试策略 |
| `docs/vX.Y.Z/progress.md` | 是 | step 4 TDD、验证记录 |
| 已实现代码 | 是 | step 4 产出 |

缺必需项或实现未完 → **停**；不进 review。

## 输出

- `docs/vX.Y.Z/test-report.md`
- 模板：[test-report-template.md](references/test-report-template.md)
- 指南：[test-writing-guide.md](references/test-writing-guide.md)

## 调用契约

- 见 `orchestrated-invocation.md`；standalone 须 step 4 完成。
- 只验证+报告；缺口回 `frontend-implement`；本步不改代码。
- 对用户摘要见 `agent-communication-style.md`。

## 工作流

1. 读 architecture：单元/集成/E2E 命令与环境。
2. 读 test-writing-guide；用维度查 plans 矩阵。
3. 读矩阵、summarized、`progress.md` step 4 证据；列待执行项。
4. 查测试是否存在；缺 → 记缺口回 implement；本步不补。
5. 分层回归：单元 → 集成 → E2E；失败记并回 implement；不进下一层。
6. 命令、exit、结果写 `progress.md` Verification Log。
7. 出 test-report：命令、覆盖、风险、接口 TODO。
8. 完成检查。
9. 摘要；等确认。

## 规则

1. **以 plan 为准**：范围 ≤ 矩阵 + summarized 验收。
2. **只全量验证**：不新测、不改逻辑；缺口回 implement TDD 补。
3. **核对 TDD**：报告记关键 task RED/GREEN/REFACTOR（源 `progress.md`）。
4. **真跑**：实际执行；以 exit、输出为准；不臆断过。
5. **分层门禁**：单元不过不跑集成；集成不过不跑 E2E（无层则跳）。
6. **失败不推**：相关命令失败 → 停本步；test-report `DRAFT`/`BLOCKED`，结论「阻塞」；step 5 `blocked`。
7. **状态一致**：确认后 test-report `ACTIVE`，结论「可进入 review」，step 5 `passed`（见 document-status test-report 专约）。
8. **框架**：测试 API 从项目示例或官方文档取。
9. **证据**：TDD 与命令结果以 `progress.md` 为准；report 汇总引用。
10. **状态门禁**：见 `orchestrated-invocation.md`；上游不可用 → 停。

## 测试层级

| 层 | 覆盖 | 源 |
|----|------|-----|
| 单元 | 逻辑、工具、组件 | plan 矩阵 |
| 集成 | API 封装协作（mock）；真联调 = 未覆盖风险 | plan + design |
| E2E | 关键路径 | summarized 主流程 |

未配置某层 → 报告标「未配置」+ 替代方式。

## 常见场景

| 场景 | 处理 |
|------|------|
| 缺用例 | 记缺口；回 implement TDD 补 |
| 上游 STALE | 停；回上游；重跑实现/验证 |
| 单元过、集成败 | 记失败；回 implement 修再跑 |
| E2E 环境未就绪 | 标阻塞；与用户确认手动验收 |
| Flaky | 重跑 1 次；仍败按败处理 |
| 无 E2E | 报告说明；关键路径手动清单 |
| 验收无自动化 | 手动步骤+结果；标风险 |
| 真后端未联调 | mock 封装；报告列 `TODO(vX.Y.Z): 接口联调待定` |

## 完成检查

- [ ] test-report 已生成
- [ ] plan/summarized/design（若用）均 `ACTIVE`
- [ ] 报告含关键 TDD 证据
- [ ] 命令与 exit 已写 `progress.md`
- [ ] 含命令、结果、验收映射、风险
- [ ] 通用门禁与 `progress.md` 落盘

## 交接下游 → 步骤 6

- test-report
- 变更范围（plan）
- 风险、未覆盖项

## 参考

- 模板：[test-report-template.md](references/test-report-template.md)
- 指南：[test-writing-guide.md](references/test-writing-guide.md)
- 接口：`frontend-iteration/references/api-integration-guide.md`
