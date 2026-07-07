# 示例 — 黄金路径

`frontend-iteration/examples/`（安装后 `.agents/skills/frontend-iteration/examples/`）。**只读**，不复制到项目 `docs/`

虚构小迭代走通 7 步；每步产出落盘

- **Agent**：成品参照，产出稳定
- **人**：看 summarized/design/plan 该写多细

> 无真实业务源码；步骤 4 以 plan、`progress.md` TDD 证据、review 体现

## feedback-form-v0.1.0

单页：**登录用户提交反馈**（类型 + 内容、校验、提交态）

```
feedback-form-v0.1.0/docs/
├── technical-architecture.md
└── v0.1.0/
    ├── progress.md
    ├── prd/origin/、summarized/
    ├── design/、plans/
    ├── test-report.md
    ├── review/
    └── release/
```

### 步骤对照

| 步骤 | Skill | 产出 |
|------|-------|------|
| 1 | `frontend-requirements` | `summarized/feedback-form.md` |
| 2 | `frontend-design` | `design/feedback-form.md` |
| 3 | `frontend-plan` | `plans/feedback-form.md` |
| 4 | `frontend-implement` | `progress.md` TDD + commit |
| 5 | `frontend-test` | `test-report.md` |
| 6 | `frontend-review` | `review/feedback-form.md` |
| 7 | `frontend-release` | `release/*` |

### 要点

- 1 份 origin → 6 条验收
- 最小改动（局部 state）
- **4** 个 TDD 任务：API 占位 → 校验 → 提交流程 → 入口（1→2→3→4）
- 三层测试过；验收逐条映射
- 审查无 🔴；🟡 未联调 → PR 列 2 处 `TODO(v0.1.0): 接口联调待定`
- `progress.md`：风格锚点（5 条）+ 每任务 lint/typecheck VERIFY
- 七步均已 `passed`；无 `STALE` / `BLOCKED` 文档

对用户汇报格式见 `frontend-iteration/references/agent-communication-style.md`
