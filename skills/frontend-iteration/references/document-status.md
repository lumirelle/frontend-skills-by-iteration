# Document Status

迭代产物必须标注状态，防止下游消费过期需求、方案或计划。

## 两套状态（勿混用）

| 体系 | 适用文件 | 取值 | 含义 |
|------|----------|------|------|
| **文档生命周期** | `summarized/`、`design/`、`plans/`、`review/`、`test-report.md` 的**文首 Status 头** | `DRAFT` / `ACTIVE` / `STALE` / `BLOCKED` | 该文档能否作为下游输入 |
| **执行进度** | 仅 `progress.md` 内 **Step Status / Plan Task Status 表** | `pending` / `in_progress` / `passed` / `blocked` | 某 step 或 task 跑到哪了 |

**对应关系（易混点）**

| 场景 | 文档生命周期（文首 Status） | 执行进度（progress 表） |
|------|---------------------------|-------------------------|
| 测试未过、不能进 review | `test-report.md` → `DRAFT` 或 `BLOCKED` | Step 5 → `blocked` |
| 测试通过、用户已确认报告 | `test-report.md` → `ACTIVE` | Step 5 → `passed` |
| plan 变更需重跑测试 | `test-report.md` → `STALE` | Step 5 → `pending` 或 `in_progress` |
| 步骤 4 某 task 失败 | （无单独文档） | 该 task → `blocked`；Step 4 → `blocked` 或 `in_progress` |

`progress.md` **文首 `Status` 恒为 `ACTIVE`**（表示本文件是当前有效的 resume 事实源），**不**表示「迭代已完成」；完成与否看 Step Status 表。

## Header

下列 workflow 产物在标题下使用**文档生命周期**状态头：

- `prd/summarized/*.md`、`design/*.md`、`plans/*.md`、`review/*.md`
- `test-report.md`
- `progress.md`（文首固定 `ACTIVE`，见上）

```markdown
> Status: ACTIVE | DRAFT | STALE | BLOCKED
> Version: vX.Y.Z
> Source: <relative/source/path.md>
> Updated: YYYY-MM-DD
> Stale reason: <仅 STALE 时填写>
```

`progress.md` 额外字段（执行进度，非文档生命周期）：

```markdown
> Status: ACTIVE
> Current step: 1
> Updated: YYYY-MM-DD
```

若文档有多个来源，`Source` 可用逗号分隔或写为列表。

## Status Values

| Status | Meaning | Can be consumed downstream |
|--------|---------|----------------------------|
| `DRAFT` | 初稿，等待用户确认 | No |
| `ACTIVE` | 已确认，可作为下游输入 | Yes |
| `STALE` | 上游变更后失效 | No |
| `BLOCKED` | 有未关闭阻塞项 | No |

## test-report.md 专约

| 字段 | 体系 | 规则 |
|------|------|------|
| 文首 `Status` | 文档生命周期 | 同上文；下游 review 仅消费 `ACTIVE` |
| `摘要.结论` | 报告内容 | `可进入 review` / `阻塞`；**不是** Status 取值 |
| `阻塞项` 章节 | 报告内容 | 非空 → 文首 `Status` 须为 `BLOCKED` 或 `DRAFT`，且 `结论` 为 `阻塞` |
| 与 progress 分工 | — | TDD 证据、命令 exit code 以 `progress.md` Verification Log 为准；test-report 引用并汇总，不替代落盘 |

步骤 5 完成且用户确认后：文首 `Status` → `ACTIVE`，`结论` → `可进入 review`，Step 5 → `passed`。

## progress.md 专约

| 字段 | 体系 | 规则 |
|------|------|------|
| 文首 `Status` | 固定 `ACTIVE` | 仅表示 tracker 有效；迭代是否结束看 Step 7 是否为 `passed` |
| `Current step` | 执行进度 | 当前或最近完成的 step 编号 |
| Step / Task 表 `Status` | 执行进度 | `pending` / `in_progress` / `passed` / `blocked` |
| `## Blockers` | 执行阻塞 | 非 `None` → 相关 step/task 标 `blocked`，停止下游 |
| 与 test-report | — | Step 5 `passed` 要求 `test-report.md` 文首为 `ACTIVE` 且 `结论` 为 `可进入 review` |

## Propagation Rules

1. `origin/*.md` 变更后，对应 `prd/summarized/*.md` 及其下游 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`。
2. `summarized/*.md` 变更后，对应 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`。
3. `design/*.md` 变更后，对应 `plans/*.md`、`review/*.md` 标为 `STALE`。
4. `plans/*.md` 变更后，对应 `test-report.md`、`review/*.md` 标为 `STALE`；`progress.md` 中 Step 4–7 与相关 task 回退为 `pending` / `in_progress`（见 progress-convention）。
5. 任何 `BLOCKED` 文档都必须先解除阻塞，不能被下游步骤消费。

## Agent Behavior

1. 读取输入文档时先检查 `Status`。
2. 遇到 `DRAFT`、`STALE`、`BLOCKED` 时停止，并向用户说明需要回到哪个上游步骤。
3. 更新文档时同步更新 `Updated` 日期。
4. 标记 `STALE` 时写清 `Stale reason`，例如 `origin PRD updated` 或 `design decision changed`。
5. 不为保持兼容而叠加过期方案；应替换失效文档或回到上游重做。
