# 文档状态

所有的作为后续步骤输入的产物文档都必须标注状态，防止后续步骤消费未确认、过期或阻塞的文档

最后步骤的输出 `release/*`、`todos.md` 无后续消费，无需标注状态

## 说明

| 适用文档 | 取值 | 含义 |
|----------|------|------|
|`prd/summarized/*.md`、`design/*.md`、`plans/*.md`、`review/*.md`、`test-report.md` 的**文首状态头** | `DRAFT` / `ACTIVE` / `STALE` / `BLOCKED` | 该文档能否作为下游输入 |

## 文首字段

下列产物文档在开头需要使用**文首状态头**：

- `prd/summarized/*.md`、`design/*.md`、`plans/*.md`、`review/*.md`
- `test-report.md`

```markdown
> 状态: ACTIVE | DRAFT | STALE | BLOCKED
> 版本: vX.Y.Z
> 来源: <relative/source/path.md>
> 更新于: YYYY-MM-DD
> 失效原因: <仅 STALE 时填写>
```

- `progress.md` 格式较特殊：状态恒为 `ACTIVE`，无“来源”和“失效原因”，有额外字段“当前步骤”：

```markdown
> 状态: ACTIVE
> 版本: vX.Y.Z
> 当前步骤: 1
> 更新于: YYYY-MM-DD
```

若文档有多个来源，`来源` 可写为列表

## 状态取值

| Status | 含义 | 下游可否消费 |
|--------|------|-------------|
| `DRAFT` | 初稿，等待用户确认 | 否，唯一例外见 [orchestrated-invocation.md](orchestrated-invocation.md)“DRAFT 消费例外”小节（总结：仅用户调用 `/frontend-iteration fast`，正在执行步骤 1–3 且该批次在 `progress.md` “草稿批次”小节中状态为 `open` 时允许，但要在进步骤 4 前批量确认转 `ACTIVE`） |
| `ACTIVE` | 已确认，可作为下游输入 | 是 |
| `STALE` | 上游变更后失效 | 否 |
| `BLOCKED` | 有未关闭阻塞项 | 否 |

## Agent 决策表

当用户调用 `/frontend-iteration` 时：

| 读到的状态 | 默认动作 | 例外 |
|------------|----------|------|
| `ACTIVE` | 可作为下游输入继续执行 | 无 |
| `DRAFT` | 停止，等待用户确认或回到产出步骤完善 | 唯一例外见 [orchestrated-invocation.md](orchestrated-invocation.md)“DRAFT 消费例外”小节（总结：仅用户调用 `/frontend-iteration fast`，正在执行步骤 1–3 且该批次在 `progress.md` “草稿批次”小节中状态为 `open` 时允许，但要在进步骤 4 前批量确认转 `ACTIVE`） |
| `STALE` | 停止，回到对应上游步骤更新，并传播下游失效状态 | 无 |
| `BLOCKED` | 停止，报告阻塞项，等待用户处理或回上游修复 | 无 |

当用户直接调用子 skill 时特殊：输入文档必须为 `ACTIVE` 状态，否则停止

## 状态传播

1. `prd/origin/*.md` 变更后，对应 `prd/summarized/*.md` 及其下游 `design/*.md`、`plans/*.md`、`test-report.md`、`review/*.md` 状态需变为 `STALE`；`progress.md` 中步骤 1–7 与相关 task 回退为 `pending` / `in_progress`（见 [progress-convention.md](progress-convention.md)）
2. `prd/summarized/*.md` 变更后，对应 `design/*.md`、`plans/*.md`、`test-report.md`、`review/*.md` 状态需变为 `STALE`；`progress.md` 中步骤 2–7 与相关 task 回退为 `pending` / `in_progress`（见 [progress-convention.md](progress-convention.md)）
3. `design/*.md` 变更后，对应 `plans/*.md`、`test-report.md`、`review/*.md` 状态需变为 `STALE`；`progress.md` 中步骤 3–7 与相关 task 回退为 `pending` / `in_progress`（见 [progress-convention.md](progress-convention.md)）
4. `plans/*.md` 变更后，对应 `test-report.md`、`review/*.md` 状态需变为 `STALE`；`progress.md` 中步骤 4–7 与相关 task 回退为 `pending` / `in_progress`

## Agent 行为

1. 读上一步的产物输入先查文首状态头，按 Agent 决策表处理；`DRAFT`/`STALE`/`BLOCKED` 须说明要返工回哪个上游步骤
2. 更新文档同步 `更新于` 日期
3. 标 `STALE` 写清 `失效原因`，例如 `origin PRD 更新` 或 `设计决策变更` 等
4. 不基于 `STALE` 产物输入执行步骤，需要一步一步回上游重做
5. 任何 `BLOCKED` 文档都必须先解除阻塞，不能被下游步骤消费
