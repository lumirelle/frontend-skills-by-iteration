# PR 描述模板

复制此结构生成 PR 描述；语言跟项目；标题用 Conventional Commits（仅英文）

```markdown
# <type>(<scope>): <short summary>   <!-- e.g. feat(user-profile): add avatar upload -->

## 背景

为什么做这个迭代（关联 vX.Y.Z 需求）。

## 改动摘要

- …（用户/调用方可感知的变化）
- …

按模块（多页面时）：

| 模块 | 改动 |
|------|------|
| | |

## 关联文档

- 需求：`docs/vX.Y.Z/prd/summarized/*.md`
- 方案：`docs/vX.Y.Z/design/*.md`
- 计划：`docs/vX.Y.Z/plans/*.md`
- 审查：`docs/vX.Y.Z/review/*.md`
- 发布草稿：`docs/vX.Y.Z/release/changelog-entry.md`
```

## 填写要点

| 章节 | 要求 |
|------|------|
| 标题 | Conventional Commits，仅英文 |
| 改动摘要 | 用户视角，避免逐文件罗列 |
| 测试说明 | 与 test-report 一致，写真实命令与结果 |
| 风险 | review 的 🟡 与 test-report 未覆盖项必须体现 |
| 关联文档 | 指向本迭代 docs，便于回溯 |
