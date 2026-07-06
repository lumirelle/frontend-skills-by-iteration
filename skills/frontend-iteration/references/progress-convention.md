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

## Style Anchors

步骤 4 开始前从 `technical-architecture.md` → Code Style 提炼 5–10 条；每 task 进入 GREEN 前重读。细则见 [code-style-enforcement.md](code-style-enforcement.md)。

| # | 规则 | 来源 |
|---|------|------|
| 1 | | technical-architecture |

## Draft Batch

| Batch | Status | Created at | Confirmed at | Files |
|-------|--------|------------|--------------|-------|
| fast-docs-YYYYMMDD-HHMM | none / open / confirmed / abandoned | YYYY-MM-DD HH:MM | — | prd/summarized/<name>.md, design/<name>.md, plans/<name>.md |

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

**Draft Batch 状态**（仅用于 fast 步骤 1–3 编排草稿）：

| Value | Meaning |
|-------|---------|
| `none` | 当前没有 fast 编排草稿 |
| `open` | 步骤 1–3 正在链式产出或等待步骤 3 末批量确认 |
| `confirmed` | 用户已批量确认，Files 内文档已转为 `ACTIVE` |
| `abandoned` | 用户拒绝或放弃该批草稿；Files 内文档不得作为下游输入 |

## Per-Step Minimal Update

每步结束前**必须**落盘以下字段（3–5 行）；不得只在聊天汇报。

| Step | 最小更新清单 |
|------|-------------|
| **1** requirements | ① `Current step` → `1` ② Step 1 → `in_progress` → 完成则 `passed` ③ `Gate result` 写明 summarized 文件与 ACTIVE/DRAFT ④ fast 模式将 summarized 写入 `Draft Batch`（`open`）⑤ `Updated`、Blockers |
| **2** design | ① `Current step` → `2` ② Step 2 状态与 `Gate result`（design 文件列表）③ Step 1 保持 `passed` ④ fast 模式把 design 追加到当前 `open` batch ⑤ `Updated`、Blockers |
| **3** plan | ① `Current step` → `3` ② Step 3 状态与 `Gate result`（plan 文件列表）③ fast 模式把 plan 追加到当前 `open` batch ④ 批量确认后：将 summarized/design/plan 标 `ACTIVE`，`Draft Batch` → `confirmed` 并填写 `Confirmed at` ⑤ `Updated`、Blockers |
| **4** implement | ① `Current step` → `4` ② Step 4 → `in_progress` ③ 若无 Style Anchors 表则先提炼并写入 ④ **每个 task 一行**：Plan Task Status 填 RED/GREEN/REFACTOR/VERIFY/Commit ⑤ Verification Log 追加该 task 验证命令与 exit（含 lint/typecheck 若已配置）⑥ task 全完 → Step 4 `passed` |
| **5** test | ① `Current step` → `5` ② Step 5 状态；失败 → `blocked` ③ Verification Log 追加全量命令与 exit ④ 同步 `test-report.md` 文首 Status 与摘要结论 ⑤ Blockers 有失败项则列出 |
| **6** review | ① `Current step` → `6` ② Step 6 状态与 `Gate result`（结论、🔴 数）③ 有未解决 🔴 → Step 6 `blocked` ④ `Updated` ⑤ Blockers |
| **7** release | ① `Current step` → `7` ② Step 7 状态与 `Gate result`（release 文件已生成）③ 全部 step `passed` 时迭代完成 ④ `Updated` ⑤ Blockers 清为 `None` |

**Resume 时**：先读 Step Status、Plan Task Status、Draft Batch，再读 Blockers；缺行按上表补全后再继续。若存在 `open` Draft Batch，只能继续 fast 步骤 1–3 或停在步骤 3 末批量确认；不得进入步骤 4。若存在 `DRAFT` 文档但没有 `open` batch，按遗留 DRAFT 处理：展示给用户确认，转 `ACTIVE` 后继续。

## Update Rules

1. 每个 step 开始时，将对应 Step Status 标为 `in_progress`。
2. 每个 step 完成后，记录 gate result；通过则标 `passed`，失败则标 `blocked`。
3. Step 4 每完成一个 task，必须记录 RED / GREEN / REFACTOR / VERIFY 结果与 commit 状态。
4. Step 5 必须把实际运行命令写入 Verification Log；同步更新 `test-report.md` 文首 Status 与摘要结论（见 document-status「test-report 专约」）。
5. 任何 blocker 出现时，写入 Blockers，并停止推进下游步骤。
6. 用户要求 resume 时，优先从第一个 `pending` / `in_progress` / `blocked` 的 step 或 task 继续。
7. `plans/*.md` 或实现变更导致测试需重跑时：Step 5 → `pending` 或 `in_progress`；`test-report.md` 文首 → `STALE`（并写 Stale reason）。
8. fast 步骤 1–3 生成或消费 `DRAFT` 时，必须同步维护 `Draft Batch`；批量确认、拒绝或废弃时必须把 batch 标为 `confirmed` 或 `abandoned`。

## Fallback Detection

`progress.md` 缺失、损坏或与文件系统明显不一致时：

1. 按 `version-convention.md` 的 Resume Detection 扫描目录。
2. 生成或修复 `progress.md`。
3. 向用户报告自动推断结果与不确定项。
