# Progress Convention

`docs/vX.Y.Z/progress.md` 是迭代 resume 的事实源。`frontend-iteration` 启动或 resume 时先读取它；缺失时可创建；内容明显过期或不完整时，再用目录扫描规则兜底并更新。

状态约定见 [document-status.md](document-status.md)：**本文档用执行进度（表内 Status）；文首 `Status: ACTIVE` 仅表示 tracker 有效，与 summarized/design 的文档生命周期不是同一套取值。**

## Location

每个版本一份：

```text
docs/vX.Y.Z/progress.md
```

## Template

```markdown
# vX.Y.Z Progress

> Status: ACTIVE
> Current step: 1
> Updated: YYYY-MM-DD

<!-- 文首 Status 恒为 ACTIVE，见 document-status.md「progress.md 专约」 -->

## Step Status

| Step | Name | Status | Gate result | Notes |
|------|------|--------|-------------|-------|
| 1 | requirements | pending / in_progress / passed / blocked | not checked | |
| 2 | design | pending / in_progress / passed / blocked | not checked | |
| 3 | plan | pending / in_progress / passed / blocked | not checked | |
| 4 | implement | pending / in_progress / passed / blocked | not checked | |
| 5 | test | pending / in_progress / passed / blocked | not checked | |
| 6 | review | pending / in_progress / passed / blocked | not checked | |
| 7 | release | pending / in_progress / passed / blocked | not checked | |

## Plan Task Status

| Plan | Task | Status | RED | GREEN | REFACTOR | VERIFY | Commit | Notes |
|------|------|--------|-----|-------|----------|--------|--------|-------|
| plans/<name>.md | Task 1 | pending / in_progress / passed / blocked | not run | not run | not needed | not run | no | |

## Verification Log

| Date | Step / Task | Command | Exit | Result |
|------|-------------|---------|------|--------|
| YYYY-MM-DD | Step 4 / Task 1 | `<command>` | 0 / non-zero | pass / fail |

## Blockers

- None

## Notes

- None
```

## Status Values

**执行进度**（Step Status / Plan Task Status 表内 `Status` 列）：

| Value | Meaning |
|-------|---------|
| `pending` | 尚未开始 |
| `in_progress` | 正在执行 |
| `passed` | 已通过该 step / task 的门禁 |
| `blocked` | 有阻塞项，不得进入下游 |

**勿与文档生命周期混淆**：`test-report.md` 文首的 `DRAFT`/`ACTIVE`/`STALE`/`BLOCKED` 是另一套；Step 5 `passed` 时须 `test-report.md` 文首为 `ACTIVE` 且摘要结论为 `可进入 review`。

## Update Rules

1. 每个 step 开始时，将对应 Step Status 标为 `in_progress`。
2. 每个 step 完成后，记录 gate result；通过则标 `passed`，失败则标 `blocked`。
3. Step 4 每完成一个 task，必须记录 RED / GREEN / REFACTOR / VERIFY 结果与 commit 状态。
4. Step 5 必须把实际运行命令写入 Verification Log；同步更新 `test-report.md` 文首 Status 与摘要结论（见 document-status「test-report 专约」）。
5. 任何 blocker 出现时，写入 Blockers，并停止推进下游步骤。
6. 用户要求 resume 时，优先从第一个 `pending` / `in_progress` / `blocked` 的 step 或 task 继续。
7. `plans/*.md` 或实现变更导致测试需重跑时：Step 5 → `pending` 或 `in_progress`；`test-report.md` 文首 → `STALE`（并写 Stale reason）。

## Fallback Detection

`progress.md` 缺失、损坏或与文件系统明显不一致时：

1. 按 `version-convention.md` 的 Resume Detection 扫描目录。
2. 生成或修复 `progress.md`。
3. 向用户报告自动推断结果与不确定项。
