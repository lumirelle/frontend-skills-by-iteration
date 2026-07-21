---
name: frontend-review
description: Use when reviewing implemented frontend iteration work against docs/vX.Y.Z/ requirements, design, plans, and test report.
disable-model-invocation: true
---

# 前端审查

## 目标

对照需求、方案、计划、测试审代码，分级记问题。无未解决 🔴 才可发布

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 架构、约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收 |
| `docs/vX.Y.Z/design/*.md` | 是 | 方案 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 边界 |
| `docs/vX.Y.Z/test-report.md` | 是 | 结果、风险 |
| `docs/vX.Y.Z/progress.md` | 是 | task、TDD 证据 |
| 代码变更 | 是 | diff / 文件 |

缺必需项或 test-report「阻塞」则**停止**，回 implement/test 补 TDD、实现或测试

## 输出

- `docs/vX.Y.Z/review/`；与 `plans/` 同名或单份 `review.md`
- 模板：[review-template.md](references/review-template.md)

## 调用契约与要求

- 调用契约见 `frontend-iteration/references/orchestrated-invocation.md`
- Agent 沟通风格见 `frontend-iteration/references/agent-communication-style.md`
- 只出审查记录，若要修复则回上游

## 工作流

1. 读 summarized、design、plans；定预期与边界
2. 读 `progress.md`、`test-report.md`；task、TDD、结论、风险
3. 审 diff；对照 plan、design；审前重读风格锚点
4. 按审查维度；核对 API 封装、占位、`TODO(vX.Y.Z): 接口联调待定`
5. 出 `review/*.md`；结论：**通过** / **有条件通过** / **不通过**
6. 门禁结果写 `progress.md`
7. 完成检查
8. 摘要：结论、🔴/🟡/🟢、建议；等确认

## 规则

1. **证据导向**：问题指向文件/行/行为；不空泛
2. **对照上游**：基准 summarized + design + plan；非 Agent 偏好
3. **分级**：🔴 必修；🟡 建议；🟢 可选
4. **不改代码**：修复回 implement/test
5. **🔴 阻断**：未解决 🔴 → 不通过；不进 release
6. **最小改动**：标 plan 外改、多余抽象、重复逻辑
7. **测审交叉**：test-report 过但审查有缺口 → 🔴/🟡
8. **进度交叉**：task 未完/blocked/缺 VERIFY → 不得「通过」
9. **状态门禁**：见 `frontend-iteration/references/orchestrated-invocation.md`；上游不可用或步骤 5 `blocked` → 不得通过

## 审查维度

| 维度 | 检查 |
|------|------|
| 需求符合 | 行为 = summarized 验收 |
| 方案符合 | = design；偏离须解释 |
| 范围符合 | ⊆ plan；无隐藏重构 |
| 架构一致 | 目录、命名、状态、请求；`docs/technical-architecture.md` + 风格锚点 |
| 代码风格 | = 邻文件、风格锚点；lint 可过（若配置） |
| 接口联调 | 封装、占位、TODO = design；页面无硬编码假数据 |
| 正确性 | 逻辑、边界、错误、权限 |
| 可维护性 | 可读、重复、过度抽象 |
| 测试充分 | = test-report；关键路径有覆盖 |
| 安全 | XSS、敏感信息、不安全 DOM（适用时） |
| 性能 | 多余渲染、重复请求、大列表（适用时） |
| 回归风险 | 既有功能影响已评估 |

## 严重级别

| 级别 | 含义 | 例 |
|------|------|-----|
| 🔴 | 发布前必修 | 功能错、越权、plan 外大改、假通过 |
| 🟡 | 建议，可协商 | 命名差、缺错误处理、覆盖弱但可接受 |
| 🟢 | 可选 | 风格、微重构、文档 |

## 常见场景

| 场景 | 处理 |
|------|------|
| 偏离 design 但更优 | 🟡；回 design 补记或回滚 |
| plan 外文件改 | 🔴；除非 plan 已同步 |
| test-report 有风险 | 引用；评是否阻塞发布 |
| progress 与 test-report 不一致 | 🔴 或待确认问题；回步骤 4/5 补证据 |
| 上游 STALE | 停；回上游 |
| 有 🔴 | 不通过；指明回步骤 4 或 5 |
| 需求歧义 | 待确认问题；不扩范围 |

## 完成检查

- [ ] `review/` 有记录
- [ ] summarized/design/plan/test-report 均 `ACTIVE`
- [ ] 问题已分级
- [ ] 结论明确
- [ ] 通过/有条件通过时无未解决 🔴
- [ ] 与 test-report、plan、design、progress 交叉完成
- [ ] 门禁按 `frontend-iteration/references/step-gates.md` 核对
- [ ] 按 `frontend-iteration/references/progress-convention.md` “每步最小落盘” 小节落盘 `progress.md`

## 交接下游 → 步骤 7

（无 🔴 或用户接受有条件通过）

- `review/*.md`、`test-report.md`
- 变更摘要、已知 🟡

## 参考

- 产物模板：[review-template.md](references/review-template.md)
- 代码风格强制：`frontend-iteration/references/code-style-enforcement.md`
- 接口联调指南：`frontend-iteration/references/api-integration-guide.md`
