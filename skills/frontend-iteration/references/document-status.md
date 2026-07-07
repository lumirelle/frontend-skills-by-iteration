# 文档状态

所有迭代产物都必须标注状态，防止下游消费未确认、过期或阻塞的文档

## 说明

两套状态勿混用：

| 体系 | 适用文件 | 取值 | 含义 |
|------|----------|------|------|
| **文档状态** | `summarized/`、`design/`、`plans/`、`review/`、`test-report.md` 的**文首状态头** | `DRAFT` / `ACTIVE` / `STALE` / `BLOCKED` | 该文档能否作为下游输入 |
| **执行进度** | 仅 `progress.md` 内 **步骤状态 / 计划任务状态** 表 | `pending` / `in_progress` / `passed` / `blocked` | 某步骤或任务跑到哪了 |

常见对应关系：

| 场景 | 文档状态（文首 Status） | 执行进度（progress 表） |
|------|---------------------------|-------------------------|
| 测试未过、不能进 review | `test-report.md` → `DRAFT` 或 `BLOCKED` | 步骤 5 → `blocked` |
| 测试通过、用户已确认报告 | `test-report.md` → `ACTIVE` | 步骤 5 → `passed` |
| plan 变更需重跑测试 | `test-report.md` → `STALE` | 步骤 5 → `pending` 或 `in_progress` |
| 步骤 4 某 task 失败 | （无单独文档） | 该 task → `blocked`，步骤 4 → `blocked` 或 `in_progress` |


## 文首字段

下列 workflow 产物在标题下使用**文档状态**头：

- `prd/summarized/*.md`、`design/*.md`、`plans/*.md`、`review/*.md`
- `test-report.md`
- `progress.md`（文首固定 `ACTIVE`）

```markdown
> 状态: ACTIVE | DRAFT | STALE | BLOCKED
> 版本: vX.Y.Z
> 来源: <relative/source/path.md>
> 更新于: YYYY-MM-DD
> 失效原因: <仅 STALE 时填写>
```

`progress.md` 额外字段（执行进度，非文档状态）：

```markdown
> 状态: ACTIVE
> 当前步骤: 1
> 更新于: YYYY-MM-DD
```

若文档有多个来源，`来源` 可用逗号分隔或写为列表

## 状态取值

| Status | 含义 | 下游可否消费 |
|--------|------|-------------|
| `DRAFT` | 初稿，等待用户确认 | 否 |
| `ACTIVE` | 已确认，可作为下游输入 | 是 |
| `STALE` | 上游变更后失效 | 否 |
| `BLOCKED` | 有未关闭阻塞项 | 否 |

## Agent 决策表

| 读到的状态 | 默认动作 | 例外 |
|------------|----------|------|
| `ACTIVE` | 可作为下游输入继续执行 | 无 |
| `DRAFT` | 停止，等待用户确认或回到产出步骤完善 | 唯一例外见 [orchestrated-invocation.md](orchestrated-invocation.md) → DRAFT 消费例外（仅 `frontend-iteration fast` 步骤 1–3 且 `progress.md` → **草稿批次** 为 `open` 时可消费，进步骤 4 前须批量确认转 `ACTIVE`） |
| `STALE` | 停止，回到对应上游步骤更新，并传播下游失效状态 | 无 |
| `BLOCKED` | 停止，报告阻塞项，等待用户处理或回上游修复 | 无 |

用户直接调用子 skill 时例外：输入必须为 `ACTIVE`，否则停止

## test-report.md 专约

| 字段 | 体系 | 规则 |
|------|------|------|
| 文首 `Status` | 文档状态 | 下游 review 仅消费 `ACTIVE` |
| `摘要.结论` | 报告内容 | `可进入 review` / `阻塞`；**不是** Status 取值 |
| `阻塞项` 章节 | 报告内容 | 非空 → 文首 `Status` 须为 `BLOCKED` 或 `DRAFT`，且 `结论` 为 `阻塞` |
| 与 progress 分工 | — | TDD 证据、命令退出码以 `progress.md` **验证记录** 为准；test-report 只汇总 |

步骤 5 完成且用户确认后：文首 `Status` → `ACTIVE`，`结论` → `可进入 review`，步骤 5 → `passed`

## progress.md 专约

| 字段 | 体系 | 规则 |
|------|------|------|
| 文首 `状态` | 固定 `ACTIVE` | 仅表示 resume 事实源有效，迭代是否结束看步骤 7 是否为 `passed` |
| `当前步骤` | 执行进度 | 当前或最近完成的步骤编号 |
| 步骤/任务表 `状态` 列 | 执行进度 | `pending` / `in_progress` / `passed` / `blocked` |
| `## 草稿批次` | 编排草稿批次 | fast 步骤 1–3 的 `DRAFT` 文件清单与确认状态；仅 `open` 批次可触发 DRAFT 消费例外 |
| `## 阻塞项` | 执行阻塞 | 非「无」→ 相关步骤/任务标 `blocked`，停止下游 |
| 与 test-report | — | 步骤 5 `passed` 要求 test-report 文首 `ACTIVE` 且结论「可进入 review」 |

## 传播规则

1. `origin/*.md` 变更后，对应 `prd/summarized/*.md` 及其下游 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`
2. `summarized/*.md` 变更后，对应 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`
3. `design/*.md` 变更后，对应 `plans/*.md`、`review/*.md` 标为 `STALE`
4. `plans/*.md` 变更后，对应 `test-report.md`、`review/*.md` 标为 `STALE`；`progress.md` 中步骤 4–7 与相关 task 回退为 `pending` / `in_progress`（见 progress-convention）
5. 任何 `BLOCKED` 文档都必须先解除阻塞，不能被下游步骤消费

## Agent 行为

1. 读输入先查 `Status`，按 Agent 决策表处理；`DRAFT`/`STALE`/`BLOCKED` 须说明回哪个上游步骤
2. 更新文档同步 `更新于` 日期
3. 标 `STALE` 写清 `失效原因`，例如 `origin PRD updated` 或 `design decision changed`
4. 不叠加过期方案，替换失效文档或回上游重做
