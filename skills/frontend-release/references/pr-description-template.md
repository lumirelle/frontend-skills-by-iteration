# PR Description Template

复制此结构生成 PR 描述。语言与项目一致；标题遵循 Conventional Commits（仅英文）。

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

## 测试说明

| 层级 | 命令 | 结果 |
|------|------|------|
| 单元 | `...` | exit 0 |
| 集成 | `...` | exit 0 |
| E2E | `...` | exit 0 / 手动验收 |

测试报告：`docs/vX.Y.Z/test-report.md`

## 风险与已知问题

- 🟡 …（来自 review）
- 未覆盖风险 …（来自 test-report）
- mock / 降级项 …

（无则写「无」）

## 关联文档

- 需求：`docs/vX.Y.Z/prd/summarized/*.md`
- 方案：`docs/vX.Y.Z/design/*.md`
- 计划：`docs/vX.Y.Z/plans/*.md`
- 审查：`docs/vX.Y.Z/review/*.md`

## 合并前确认

- [ ] review 无未解决 🔴
- [ ] 测试通过 / 已记录手动验收
- [ ] CHANGELOG 已更新
- [ ] 无未解决冲突
```

## 填写要点

| 章节 | 要求 |
|------|------|
| 标题 | Conventional Commits，仅英文 |
| 改动摘要 | 用户视角，避免逐文件罗列 |
| 测试说明 | 与 test-report 一致，写真实命令与结果 |
| 风险 | review 的 🟡 与 test-report 未覆盖项必须体现 |
| 关联文档 | 指向本迭代 docs，便于回溯 |
