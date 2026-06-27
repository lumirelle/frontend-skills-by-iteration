# Document Status

所有迭代产物都必须标注状态，防止下游消费未确认、过期或阻塞的文档。

## 两套状态（勿混用）

| 体系 | 适用文件 | 取值 | 含义 |
|------|----------|------|------|
| **文档生命周期** | `summarized/`、`design/`、`plans/`、`review/`、`test-report.md` 的**文首 Status 头** | `DRAFT` / `ACTIVE` / `STALE` / `BLOCKED` | 该文档能否作为下游输入 |
| **执行进度** | 仅 `progress.md` 内 **Step Status / Plan Task Status 表** | `pending` / `in_progress` / `passed` / `blocked` | 某 step 或 task 跑到哪了 |

**常见对应关系**

| 场景 | 文档生命周期（文首 Status） | 执行进度（progress 表） |
|------|---------------------------|-------------------------|
| 测试未过、不能进 review | `test-report.md` → `DRAFT` 或 `BLOCKED` | Step 5 → `blocked` |
| 测试通过、用户已确认报告 | `test-report.md` → `ACTIVE` | Step 5 → `passed` |
| plan 变更需重跑测试 | `test-report.md` → `STALE` | Step 5 → `pending` 或 `in_progress` |
| 步骤 4 某 task 失败 | （无单独文档） | 该 task → `blocked`；Step 4 → `blocked` 或 `in_progress` |

`progress.md` 文首 `Status` 恒为 `ACTIVE`，只表示它是当前 resume 事实源；迭代完成与否看 Step Status 表。

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

## Agent Decision Table

| 读到的状态 | 默认动作 | 例外 |
|------------|----------|------|
| `ACTIVE` | 可作为下游输入继续执行 | 无 |
| `DRAFT` | 停止，等待用户确认或回到产出步骤完善 | `frontend-iteration fast` 的步骤 1→2→3 可消费本轮编排草稿；步骤 3 批量确认前不得进入步骤 4 |
| `STALE` | 停止，回到对应上游步骤更新，并传播下游失效状态 | 无 |
| `BLOCKED` | 停止，报告阻塞项，等待用户处理或回上游修复 | 无 |

直接调用 sub-skill 时没有编排草稿例外：输入必须为 `ACTIVE`，否则停止。通过 `frontend-iteration` 调用时，交互模式与例外范围由编排器决定。

## test-report.md 专约

| 字段 | 体系 | 规则 |
|------|------|------|
| 文首 `Status` | 文档生命周期 | 下游 review 仅消费 `ACTIVE` |
| `摘要.结论` | 报告内容 | `可进入 review` / `阻塞`；**不是** Status 取值 |
| `阻塞项` 章节 | 报告内容 | 非空 → 文首 `Status` 须为 `BLOCKED` 或 `DRAFT`，且 `结论` 为 `阻塞` |
| 与 progress 分工 | — | TDD 证据、命令 exit code 以 `progress.md` Verification Log 为准；test-report 只汇总 |

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
2. 遇到 `DRAFT`、`STALE`、`BLOCKED` 时按 Agent Decision Table 处理，并向用户说明需要回到哪个上游步骤。
3. 更新文档时同步更新 `Updated` 日期。
4. 标记 `STALE` 时写清 `Stale reason`，例如 `origin PRD updated` 或 `design decision changed`。
5. 不为保持兼容而叠加过期方案；应替换失效文档或回到上游重做。
