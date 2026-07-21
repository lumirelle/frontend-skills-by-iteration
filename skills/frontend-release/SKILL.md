---
name: frontend-release
description: Use when preparing release materials after docs/vX.Y.Z/review/*.md and test-report.md pass.
disable-model-invocation: true
---

# 前端发布

## 目标

审查通过后整理 changelog、PR 描述、合并前清单，迭代可发布

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/vX.Y.Z/review/*.md` | 是 | 审查；无未解决 🔴 |
| `docs/vX.Y.Z/test-report.md` | 是 | 结果、风险 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 变更说明 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 范围 |
| `docs/vX.Y.Z/progress.md` | 是 | 门禁、阻塞项 |
| 代码 / git | 是 | 提交、文件 |

有未解决 🔴 则**停止**，回上游

## 输出

- `docs/vX.Y.Z/release/changelog-entry.md`
- `docs/vX.Y.Z/release/pr-description.md`（模板 [pr-description-template.md](references/pr-description-template.md)）
- `docs/vX.Y.Z/todos.md`（模板 [todos-template.md](references/todos-template.md)，汇总本迭代待确认问题的 TODO 列表）
- 根 `CHANGELOG.md` 追加：仅项目已有约定或用户确认后
- 合并前清单结果

## 调用契约与要求

- 调用契约见 `frontend-iteration/references/orchestrated-invocation.md`
- Agent 沟通风格见 `frontend-iteration/references/agent-communication-style.md`
- 只备发布材料，merge/push/tag 须用户显式确认或由用户执行

## 工作流

1. 确认 review 无 🔴、test-report 无阻塞、输入均 `ACTIVE`
2. 汇总变更：summarized、plans、git
3. 出 changelog-entry（用户视角、分类）
4. 出 pr-description（背景、改动、文档链）
5. 汇总待确认问题到 `docs/vX.Y.Z/todos.md`（去重，按优先级排序）
6. 根 CHANGELOG：有约定或用户要求时，确认后写
7. 合并前检查
8. 完成检查
9. 摘要，**用户确认后再 merge/push/tag，或由用户执行**

## 规则

1. **门禁前置**：review 不过或测试阻塞 → 不发布
2. **不自动 merge/push**：须用户同意
3. **commit 英文**：merge、tag、release commit 用 Conventional Commits（同 implement）
4. **CHANGELOG 用户视角**：可感知变化；不堆实现细节
5. **文档代码一致**：记录与改动一致；不夸大不遗漏
6. **风险透明**：test-report 风险、review 🟡、`TODO(vX.Y.Z): 接口联调待定` 汇总进 `docs/vX.Y.Z/todos.md`，并在 PR 关联
7. **可追溯**：PR 链本迭代 docs
8. **状态门禁**：见 `frontend-iteration/references/orchestrated-invocation.md`；阻塞项或步骤 5 `blocked` → 不发布

## 变更日志

- 标题：`## vX.Y.Z - YYYY-MM-DD`
- 分类（有内容才列）：`Added`/`Changed`/`Fixed`/`Removed`/`Performance`/`Docs`
- 每行用户视角；语言跟项目
- 可标 PRD/issue

## 常见场景

| 场景 | 处理 |
|------|------|
| 有条件通过（仅 🟡） | 可发布；PR 列 🟡 待办 |
| 未解决 🔴 | 停 |
| 上游 STALE/BLOCKED | 停；回上游 |
| 无根 CHANGELOG | 仍出 release/changelog-entry；建根须确认 |
| 后端 mock | PR 列 TODO + 封装切换点 |
| E2E 降级手动 | 测试说明如实写 |
| 用户要打 tag | 确认后 Conventional Commits |

## 合并前检查

- [ ] review 无未解决 🔴
- [ ] test-report 无阻塞；关键命令 exit 0
- [ ] review/test-report/summarized/plan 均 `ACTIVE`
- [ ] `progress.md` 无阻塞项
- [ ] changelog-entry 已生成
- [ ] PR 完整（背景/改动/文档）
- [ ] commit 符合 Conventional Commits（英文）
- [ ] 无未解冲突
- [ ] 🟡/风险已在 PR

## 完成检查

- [ ] changelog-entry、pr-description 已生成
- [ ] `docs/vX.Y.Z/todos.md` 已生成且覆盖待确认问题
- [ ] 合并前检查全满足
- [ ] 文档与代码一致
- [ ] 门禁按 `frontend-iteration/references/step-gates.md` 核对
- [ ] 按 `frontend-iteration/references/progress-convention.md` “每步最小落盘” 小节落盘 `progress.md`
- [ ] merge/push/tag 仅用户确认后

## 参考

- PR 模板：[pr-description-template.md](references/pr-description-template.md)
- TODO 模板：[todos-template.md](references/todos-template.md)
- 接口联调指南：`frontend-iteration/references/api-integration-guide.md`
