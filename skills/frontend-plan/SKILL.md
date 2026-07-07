---
name: frontend-plan
description: Use when turning docs/vX.Y.Z/design/*.md into TDD implementation plans for a versioned frontend iteration.
disable-model-invocation: true
---

# 前端计划

## 目标

design → 最小、有序、可验证 TDD plan；作实现边界

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、测试命令、约定 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收、边界 |
| `docs/vX.Y.Z/design/*.md` | 是 | 方案、文件 |
| 代码库 | 是 | 路径、复用、测试位置 |

缺必需项 → **停**；不产出 plan

## 输出

- `docs/vX.Y.Z/plans/`；与 `design/` 同名
- 模板：[implementation-plan-template.md](references/implementation-plan-template.md)
- 初稿 `DRAFT`；确认后 `ACTIVE`

## 调用契约

- 见 `frontend-iteration/references/orchestrated-invocation.md`
- 只写 plan；不改业务代码、不跑实现
- 对用户摘要见 `frontend-iteration/references/agent-communication-style.md`

## 工作流

1. 读 `docs/technical-architecture.md`：构建、测试、目录、**代码风格**
2. 读 summarized、design；状态按契约
3. 探路径；校正 design 文件与测试位置
4. design → TDD task：RED → GREEN → REFACTOR → VERIFY
5. 测试矩阵参考 `frontend-test` → test-writing-guide
6. 完成检查
7. 摘要：任务、文件边界、命令、风险；确认按契约

## 规则

1. **最小任务**：只覆盖 design 已确认方案；不加 design 外抽象/重构/功能
2. **文件边界**：精确路径；未知先探；仍不确定 → 待确认问题，不猜
3. **可执行粒度**：每 task 独立完成+验证；过大拆小，过细合并
4. **TDD 内置**：行为改动先失败测试；无法 TDD 须说明
5. **顺序明确**：标依赖；可并行可注；默认顺序
6. **不重新设计**：design 缺口 → 停，回 `frontend-design`；plan 不暗改方案
7. **不写代码**
8. **状态门禁**：见 `frontend-iteration/references/orchestrated-invocation.md`；阻塞待确认问题 → `DRAFT`/`BLOCKED`

## 任务结构

每 task 至少：

| 字段 | 要求 |
|------|------|
| 目标 | 一句话 |
| 文件 | 新增/改/测路径 |
| 步骤 | 2–6 动作 |
| 验证 | 命令或手动点 |
| 依赖 | 前置 task；无写「无」 |

行为 task 还须：

| 阶段 | 要求 |
|------|------|
| RED | 最小失败测试 + 预期失败原因 |
| GREEN | 最小生产代码过测 |
| REFACTOR | 不改行为清理；测试仍过 |
| VERIFY | 跑命令；记通过条件 |

## 常见场景

| 场景 | 处理 |
|------|------|
| 多页 design | 每页独立 plan；共享放最早依赖 task |
| 只改组件 | 聚焦改+测；不新目录 |
| API 未就绪 | 单独 API task（占位 + `TODO(vX.Y.Z): 接口联调待定`）；页面 task 依赖；见 `frontend-iteration/references/api-integration-guide.md` |
| E2E 贵 | 只关键路径；余单元/集成 |
| design 有待确认问题 | 受影响 task 不生成；列阻塞 |
| 超最小改动 | 停；回 design |
| design 更新 | plan、步骤 4 进度、test-report、review → `STALE` 或重跑 |

## 完成检查

- [ ] 每 design 有同名 plan + 状态头
- [ ] 每 task 含目标、文件、步骤、验证、依赖、RED/GREEN/REFACTOR/VERIFY
- [ ] 测试矩阵对应 summarized 验收
- [ ] 范围 ≤ design 文件边界
- [ ] 门禁按 `frontend-iteration/references/step-gates.md` 核对
- [ ] 按 `frontend-iteration/references/progress-convention.md` → **每步最小落盘** 落盘 `progress.md`

## 参考

- 模板：[implementation-plan-template.md](references/implementation-plan-template.md)
- 测试：`frontend-test/references/test-writing-guide.md`
- 接口：`frontend-iteration/references/api-integration-guide.md`
