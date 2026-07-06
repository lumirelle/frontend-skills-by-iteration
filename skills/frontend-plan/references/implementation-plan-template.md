# Implementation Plan Template

复制此结构生成 `docs/vX.Y.Z/plans/<name>.md`。删除不适用的章节，不留空占位。

```markdown
# [页面/功能名] 实施计划

> Status: DRAFT
> Version: vX.Y.Z
> Source: design/<name>.md
> Updated: YYYY-MM-DD
> Stale reason:

## 目标

一句话说明本计划交付什么。

## 范围

**包含：**

- …

**不包含：**

- …

## 前置确认

| 项 | 状态 | 说明 |
|----|------|------|
| summarized 已确认 | 是/否 | |
| design 已确认 | 是/否 | |
| open questions 已关闭 | 是/否 | |

未确认项必须在进入代码实现前处理。

## 文件边界

| 操作 | 文件 | 说明 |
|------|------|------|
| 新增 | `src/...` | |
| 修改 | `src/...` | |
| 测试 | `src/...` / `tests/...` | |

## TDD 任务列表

### Task 1: [任务名]

**目标**：…

**依赖**：无

**文件：**

- 新增：`src/...`
- 修改：`src/...`
- 测试：`src/...`

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

### Task 2: [任务名]

**目标**：…

**依赖**：Task 1

**文件：**

- 修改：`src/...`
- 测试：`src/...`

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

## 测试矩阵

| 验收标准 | 测试维度 | 覆盖方式 | 对应任务 |
|----------|----------|----------|----------|
| | 主流程 / 输入边界 / 状态变化 / 用户交互 / 数据展示 / 权限与角色 / API 结果 / 平台差异 / 回归风险 | 单元 / 集成 / E2E / 手动 | Task N |

## 执行顺序

1. Task 1
2. Task 2
3. …

可并行任务：无 / Task X 与 Task Y

## 风险

| 风险 | 应对 |
|------|------|
| 后端未就绪 | API task 占位 + `TODO(vX.Y.Z): 接口联调待定`；见 api-integration-guide |
| | |

## Open Questions

- …
```

## 填写要点

| 章节 | 要求 |
|------|------|
| 范围 | 与 design 对齐，避免实现阶段扩大范围 |
| 文件边界 | 精确到文件路径；未知则先探查，不猜 |
| TDD 任务列表 | 每个行为任务包含 RED / GREEN / REFACTOR / VERIFY |
| RED | 先写失败测试，说明预期失败原因 |
| GREEN | 写最小生产代码，不扩大范围 |
| REFACTOR | 只做不改变行为的清理，保持测试通过 |
| 验证 | 尽量写具体命令；未知命令从 technical-architecture 获取 |
| 测试矩阵 | 每条验收标准至少有一个测试维度和覆盖方式 |
| Open Questions | 有阻塞问题时不得进入代码实现 |
