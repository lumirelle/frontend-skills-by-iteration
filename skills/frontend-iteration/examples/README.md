# Examples — 黄金路径

内置在 `frontend-iteration` skill 根目录的 `examples/`（安装后：`.agents/skills/frontend-iteration/examples/`）。**只读参照**，不复制到项目 `docs/`。

这里放「黄金路径」样例：用一个虚构的小迭代，把 `frontend-iteration` 的 7 个步骤完整走一遍，每一步的真实产出都落盘。

它有两个用途：

- **给 Agent 看**：执行 workflow 时有一份成品参照，产出更稳定。
- **给人看**：想知道 summarized / design / plan 该写多细，打开对应文件即可。

> 样例为演示用，技术栈中性、不含真实业务代码；步骤 4「代码实现」以 plan、progress 的 TDD 证据与 review 体现，不放假项目源码。

## feedback-form-v0.1.0

一个最简单的单页面迭代：**已登录用户提交反馈表单**（反馈类型 + 内容，含校验与提交状态）。

目录即真实项目中 `docs/` 的样子：

```
feedback-form-v0.1.0/docs/
├── technical-architecture.md              # 项目级（跨版本）
└── v0.1.0/
    ├── progress.md                         # 全程进度 + TDD 证据（resume 事实源）
    ├── prd/
    │   ├── origin/feedback-form.md         # 输入：原始 PRD
    │   └── summarized/feedback-form.md     # 步骤 1 产出
    ├── design/feedback-form.md             # 步骤 2 产出
    ├── plans/feedback-form.md              # 步骤 3 产出
    ├── test-report.md                      # 步骤 5 产出
    ├── review/feedback-form.md             # 步骤 6 产出
    └── release/                            # 步骤 7 产出
        ├── changelog-entry.md              # 样例片段（真实项目可追加到根 CHANGELOG）
        └── pr-description.md
```

### 按步骤对照

| 步骤 | Sub-skill | 产出文件 |
|------|-----------|----------|
| 1 需求 | `frontend-requirements` | `prd/summarized/feedback-form.md` |
| 2 方案 | `frontend-design` | `design/feedback-form.md` |
| 3 计划 | `frontend-plan` | `plans/feedback-form.md` |
| 4 实现 | `frontend-implement` | 体现在 `progress.md` 的 TDD 证据与 commit 记录 |
| 5 自测 | `frontend-test` | `test-report.md` |
| 6 审查 | `frontend-review` | `review/feedback-form.md` |
| 7 发布 | `frontend-release` | `release/changelog-entry.md`、`release/pr-description.md` |

### 这条路径「黄金」在哪

- 需求只有 1 份 origin PRD，归纳出 6 条可验收标准。
- 方案选最小改动（局部状态，不抽全局 store）。
- 计划拆成 3 个 TDD task，依赖链清晰。
- 测试三层全过，验收标准逐条映射。
- 审查无 🔴，仅 1 条 🟡（接口未联调）顺延到发布说明。
- 全程无回退、无 STALE/BLOCKED；`progress.md` 七步全 `passed`。
