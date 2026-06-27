---
name: frontend-release
description: Use when preparing release materials after docs/vX.Y.Z/review/*.md and test-report.md pass.
disable-model-invocation: true
---

# Frontend Release

## Goal

在审查通过后整理变更记录与 PR 描述，完成合并前清单，使迭代可发布。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/vX.Y.Z/review/*.md` | 是 | 审查结论，须无未解决 🔴 |
| `docs/vX.Y.Z/test-report.md` | 是 | 测试结果与未覆盖风险 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 需求摘要，写变更说明用 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 变更范围 |
| `docs/vX.Y.Z/progress.md` | 是 | step gate 与阻塞项 |
| 代码变更 / git 历史 | 是 | 提交记录与改动文件 |

审查未通过（存在未解决 🔴）→ **停止**，回 `frontend-review` 或上游修复。

## Output

- `docs/vX.Y.Z/release/changelog-entry.md`：本迭代 changelog 草稿
- `docs/vX.Y.Z/release/pr-description.md`：PR 描述，按 [pr-description-template.md](references/pr-description-template.md)
- 项目根 `CHANGELOG.md`（或等效文件）追加 vX.Y.Z 条目：仅在项目已有约定或用户确认后执行
- 合并前清单结果

## Invocation Contract

- 调用契约（orchestrated / standalone）见 `frontend-iteration/references/orchestrated-invocation.md`（路径见 `frontend-iteration` → Skill Path Resolution）；直接调用时须确认无 blocker。
- 本 skill 只准备发布材料；merge / push / tag 必须等待用户显式确认。

## Workflow

1. 确认 review 结论无未解决 🔴，test-report 无阻塞项，输入文档状态均为 `ACTIVE`。
2. 汇总本迭代变更：从 summarized、plans、git 历史归纳。
3. 生成 `docs/vX.Y.Z/release/changelog-entry.md`（用户视角，分类列出）。
4. 生成 `docs/vX.Y.Z/release/pr-description.md`（背景、改动摘要、测试说明、风险、关联文档）。
5. 若项目已有根 `CHANGELOG.md` 或用户要求追加，确认后再写入项目级变更记录。
6. 执行合并前清单。
7. 按 Done Checklist 自检。
8. 向用户展示摘要，**等待用户确认后再执行合并/push/tag**。

## Rules

1. **门禁前置**：未通过 review 或有阻塞测试 → 不发布。
2. **不自动合并/推送**：merge / push / 打 tag 须用户明确同意后执行。
3. **英文提交规范**：合并提交、tag、release commit 遵循 Conventional Commits，仅英文（与 `frontend-implement` 一致）。
4. **CHANGELOG 用户视角**：写「用户/调用方能感知的变化」，不堆实现细节。
5. **文档代码一致**：变更记录、PR 描述与实际改动一致，不夸大不遗漏。
6. **风险透明**：test-report 的未覆盖风险与 review 的 🟡 项须在 PR 中体现。
7. **可追溯**：PR 关联本迭代 docs 路径，便于回溯需求/方案/测试。
8. **状态门禁**：通用规则见 `frontend-iteration/references/orchestrated-invocation.md` → 状态门禁（通用）（路径见 `frontend-iteration` → Skill Path Resolution）。本 step 特异：输入 review / test-report / summarized / plan 不可用时停止；`progress.md` 有 blocker 或 Step 5 为 `blocked` 时不得发布。

## Changelog Convention

- 版本标题：`## vX.Y.Z - YYYY-MM-DD`
- 分类（仅列有内容的）：`Added` / `Changed` / `Fixed` / `Removed` / `Performance` / `Docs`
- 每条一行，用户视角，英文或项目既定语言保持一致
- 关联来源可选标注（如 PRD 名 / issue）

## Common Scenarios

| 场景 | 处理 |
|------|------|
| review 有条件通过（仅 🟡） | 可发布；PR 中列出 🟡 待办与计划 |
| 存在未解决 🔴 | 停止，不发布 |
| 上游文档为 STALE 或 BLOCKED | 停止，回对应上游步骤 |
| 项目无 CHANGELOG | 仍生成 `release/changelog-entry.md`；是否创建根 CHANGELOG 需用户确认 |
| 多 plan / 多页面 | CHANGELOG 合并归类；PR 描述分模块列出 |
| 后端未就绪用了 mock | 在风险/已知问题中标注切换点 |
| E2E 降级为手动验收 | 在测试说明中如实写明 |
| 用户要求打 tag / 发布 | 确认后用 Conventional Commits 规范执行 |
| 仅文档迭代 | CHANGELOG 用 `Docs`，PR 标注无运行时影响 |

## Pre-Merge Checklist

- [ ] review 结论无未解决 🔴
- [ ] test-report 无阻塞项，关键命令 exit 0
- [ ] review / test-report / summarized / plan 状态均为 `ACTIVE`
- [ ] `progress.md` 无 blocker
- [ ] `docs/vX.Y.Z/release/changelog-entry.md` 已生成
- [ ] PR 描述完整（背景 / 改动 / 测试 / 风险 / 关联文档）
- [ ] 提交信息符合 Conventional Commits（仅英文）
- [ ] 分支与目标分支无未解决冲突
- [ ] 已知 🟡 / 风险已在 PR 中体现

## Done Checklist

- [ ] `docs/vX.Y.Z/release/changelog-entry.md` 已生成
- [ ] `docs/vX.Y.Z/release/pr-description.md` 已生成
- [ ] Pre-Merge Checklist 全部满足
- [ ] 文档与代码一致
- [ ] 完整门禁与 `progress.md` 落盘已按 `frontend-iteration/references/orchestrated-invocation.md` → Done Checklist（通用项）完成（路径见 `frontend-iteration` → Skill Path Resolution）
- [ ] 合并 / push / tag 仅在用户确认后执行

## References

- PR 描述模板：[pr-description-template.md](references/pr-description-template.md)
