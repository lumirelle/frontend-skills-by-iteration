# frontend-skills-by-iteration

可分发前端迭代 Agent Skills：版本化需求、设计、计划、实现、测试、审查、发布。

## 安装

```bash
npx skills add lumirelle/frontend-skills-by-iteration --skill '*'
```

安装后 `frontend-iteration` 启动时 Bootstrap `docs/`，无需手抄模板。

## 用法

```
/frontend-iteration v1.2.0              # fast（默认）：1–3 连续，之后逐步确认
/frontend-iteration v1.2.0 strict       # 每步确认
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 resume
/frontend-iteration v1.2.0 init         # 仅 docs 脚手架
```

## 需准备

1. **origin PRD** → `docs/vX.Y.Z/prd/origin/*.md`
2. （可选）UI 稿 → `docs/vX.Y.Z/ui/*`

`technical-architecture.md`、`progress.md` 可编排器自动建；技术架构须补项目事实后才能迭代。

## Skills

| Skill | 步骤 |
|-------|------|
| `frontend-iteration` | 编排（Bootstrap、模板、样例、`init`） |
| `frontend-requirements` | 1 需求 |
| `frontend-design` | 2 方案 |
| `frontend-plan` | 3 TDD 计划 |
| `frontend-implement` | 4 实现 |
| `frontend-test` | 5 自测 |
| `frontend-review` | 6 审查 |
| `frontend-release` | 7 发布 |

## 内置资源（`frontend-iteration`）

- `templates/docs/technical-architecture.md`
- `templates/docs/version/` → `docs/vX.Y.Z/`
- `examples/`（只读样例）
- `references/`：步骤门禁、进度、文档状态、版本约定、编排调用契约、Agent 对外表述风格、代码风格约束、接口联调指引

路径解析见 `frontend-iteration` → 技能路径解析。

## 示例

- `.agents/skills/frontend-iteration/examples/feedback-form-v0.1.0/`
- 源码：`skills/frontend-iteration/examples/feedback-form-v0.1.0/`

见 [`examples/README.md`](skills/frontend-iteration/examples/README.md)。

## 验证

Agent 按 `step-gates.md` 与 `progress.md` 自检。

## Agent 对用户输出

聊天摘要、门禁、阻塞项、确认问遵守 `agent-communication-style.md`（经 `orchestrated-invocation.md` 挂载）。`docs/` 产物按各模板写。
