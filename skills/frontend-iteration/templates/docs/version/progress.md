# vX.Y.Z Progress

> Status: ACTIVE
> Current step: 1
> Updated: YYYY-MM-DD

## Step Status

| Step | Name | Status | Gate result | Notes |
|------|------|--------|-------------|-------|
| 1 | requirements | pending | not checked | |
| 2 | design | pending | not checked | |
| 3 | plan | pending | not checked | |
| 4 | implement | pending | not checked | |
| 5 | test | pending | not checked | |
| 6 | review | pending | not checked | |
| 7 | release | pending | not checked | |

## Plan Task Status

| Plan | Task | Status | RED | GREEN | REFACTOR | VERIFY | Commit | Notes |
|------|------|--------|-----|-------|----------|--------|--------|-------|
| plans/<name>.md | Task 1 | pending | not run | not run | not needed | not run | no | |

## Style Anchors

步骤 4 开始前从 `technical-architecture.md` → Code Style 提炼 5–10 条；每 task 进入 GREEN 前重读。细则见 `code-style-enforcement.md`。

| # | 规则 | 来源 |
|---|------|------|
| 1 | | technical-architecture |

## Draft Batch

| Batch | Status | Created at | Confirmed at | Files |
|-------|--------|------------|--------------|-------|
| fast-docs-YYYYMMDD-HHMM | none | YYYY-MM-DD HH:MM | — | — |

## Verification Log

| Date | Step / Task | Command | Exit | Result |
|------|-------------|---------|------|--------|
| YYYY-MM-DD | Step N | `<command>` | 0 / non-zero | pass / fail |

## Blockers

- None

## Notes

- None

## Per-Step Minimal Update（Agent 每步结束前必做）

| Step | 落盘清单（3–5 行） |
|------|-------------------|
| 1 | `Current step`、Step 1 状态 + Gate result、summarized 路径、fast 时更新 Draft Batch、Updated、Blockers |
| 2 | `Current step`、Step 2 状态 + Gate result、design 路径、fast 时追加 Draft Batch、Updated、Blockers |
| 3 | `Current step`、Step 3 状态 + Gate result、plan 路径、fast 确认后标 ACTIVE 并将 Draft Batch 标 `confirmed`、Updated、Blockers |
| 4 | 每 task 更新 Plan Task Status（RED/GREEN/REFACTOR/VERIFY/Commit）+ Verification Log 一行；Step 4 完成后 `passed` |
| 5 | Step 5 状态、Verification Log 全量命令、test-report Status/结论 同步、Blockers |
| 6 | Step 6 状态 + Gate result（结论/🔴 数）、有 🔴 则 `blocked`、Updated、Blockers |
| 7 | Step 7 状态 + Gate result、release 文件就绪、Updated、Blockers → None |

细则见编排器 `references/progress-convention.md` → Per-Step Minimal Update。
