---
name: frontend-design
description: Use when turning docs/vX.Y.Z/prd/summarized/*.md into frontend technical designs for a versioned iteration.
disable-model-invocation: true
---

# 前端设计

## 目标

基于 summarized PRD，做可落地的技术方案，明确改动范围与测试策略

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、平台、目录、约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 步骤 1 产出，一对一 |
| `docs/vX.Y.Z/ui/*` | 否 | 组件拆分、交互 |
| 代码库 | 是 | 复用组件/模式 |

缺必需项则**停止**

## 输出

- `docs/vX.Y.Z/design/`，与 `summarized/` 同名
- 模板：[technical-design-template.md](references/technical-design-template.md)
- 初稿 `DRAFT`，确认后 `ACTIVE`

## 调用契约与要求

- 调用契约见 `frontend-iteration/references/orchestrated-invocation.md`
- Agent 沟通风格见 `frontend-iteration/references/agent-communication-style.md`
- 只做技术方案，不做其它

## 工作流

1. 读 `docs/technical-architecture.md`：技术栈、目录、状态、路由、请求层、**代码风格**
2. 读 summarized；可消费状态按调用契约
3. 探库：组件、hooks、工具、类型、API；接口见 `frontend-iteration/references/api-integration-guide.md`（搜已有 API、类似页）
4. 有 UI：读 `ui-reading-guide.md`；按清单/层级/重复单元拆组件
5. 逐份 summarized 出 design；**先最小改动路径**；非平凡处比选 2–3 方案（含最小方案）
6. 标文件、数据流、API/类型、错误处理、测试、风险
7. 完成检查
8. 摘要：选型、文件、风险、待确认问题；确认时机按契约

## 规则

1. **最小改动**：默认最少文件、最低侵入、不新抽象。能改现有不新建；能内联不抽 hook；能局部 state 不用 store。不为「以后」预留。超最小须说明理由
2. **先比选后定案**：非平凡 2–3 选项，**必含最小方案**；默认推最小，除非有理由选复杂
3. **架构对齐**：跟 `docs/technical-architecture.md` 与现有模式；冲突显式标
4. **复用优先**：先找现有；新建说明为何不复用
5. **范围可控**：只满足 summarized；不夹无关重构
6. **可追溯**：决策对应 summarized 需求或验收项
7. **测试前置**：方案含单元/集成/E2E 覆盖，供步骤 3 拆
8. **不写代码**：只出 design；伪代码/接口签名可
9. **状态门禁**：见 `frontend-iteration/references/orchestrated-invocation.md`；阻塞待确认问题 → `DRAFT`/`BLOCKED`

## 方案覆盖

| 维度 | 内容 |
|------|------|
| 方案选型 | 备选、权衡、推荐 |
| 组件结构 | 树、职责、复用 vs 新建 |
| 数据流 | 状态归属、props/事件、全局 vs 局部 |
| 接口契约 | API、入参/返回、类型 |
| 路由 | 路径、参数、守卫 |
| 错误处理 | 加载/空/错/无权限 |
| 兼容性 | 平台、响应式、浏览器 |
| 测试策略 | 单元/集成/E2E |
| 风险与回滚 | 风险、降级/回滚 |

## 常见场景

| 场景 | 处理 |
|------|------|
| 复用即可 | 标复用点；避免新建 |
| 过度设计 | 回最小；选型说明为何不复杂 |
| 新 API | 搜 `src/api/`、类似页；类型与封装；未就绪 mock+待定清单 |
| 多页 | 每页独立 design；公共部分共享或互引 |
| 影响现有功能 | 列模块 + 回归范围 |
| summarized 有待确认问题 | 标依赖确认；给默认假设 |
| summarized 更新 | design 及下游标 `STALE`；写原因 |

## 完成检查

- [ ] 每 summarized 有同名 design + 状态头
- [ ] 覆盖选型、结构、数据流、契约、错误、兼容、测试、风险
- [ ] 文件已列；无无关重构
- [ ] 最小方案或充分说明选复杂理由
- [ ] 门禁按 `frontend-iteration/references/step-gates.md` 核对
- [ ] 按 `frontend-iteration/references/progress-convention.md` “每步最小落盘” 小节落盘 `progress.md`

## 参考

- 产物模板：[technical-design-template.md](references/technical-design-template.md)
- UI 读取指南：`frontend-requirements/references/ui-reading-guide.md`
- 接口联调指南：`frontend-iteration/references/api-integration-guide.md`
- 代码风格强制：`frontend-iteration/references/code-style-enforcement.md`
