# frontend-workflow

可分发的前端迭代 Agent Skills 工作流：版本化需求、设计、计划、实现、测试、审查与发布。

## Install

```bash
npx skills add <your-org>/frontend-workflow --skill '*'
```

安装后 `frontend-iteration` 会在启动时自动 Bootstrap `docs/` 脚手架，无需手动复制模板。

## Usage

```
/frontend-iteration v1.2.0              # fast（默认）：文档步骤 1–3 连续，之后逐步确认
/frontend-iteration v1.2.0 strict       # 每步均须确认
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 resume
/frontend-iteration v1.2.0 init         # 仅初始化 docs/ 脚手架后停止
```

## 你需要准备的

最少准备两项：

1. 将本迭代 **origin PRD** 放入 `docs/vX.Y.Z/prd/origin/*.md`
2. （可选）UI 稿放入 `docs/vX.Y.Z/ui/*`

`docs/technical-architecture.md` 与 `docs/vX.Y.Z/progress.md` 可由编排器自动创建；`technical-architecture.md` 必须补齐项目事实后才能进入迭代。

## Skills

| Skill | 说明 |
|-------|------|
| `frontend-iteration` | 主编排器（含 Bootstrap、`docs/` 模板、路径解析、黄金路径样例；`init` flag 可只建脚手架不进入迭代） |
| `frontend-requirements` | 步骤 1：需求理解 |
| `frontend-design` | 步骤 2：技术方案 |
| `frontend-plan` | 步骤 3：TDD 实施计划 |
| `frontend-implement` | 步骤 4：TDD 代码实现 |
| `frontend-test` | 步骤 5：全量自测 |
| `frontend-review` | 步骤 6：代码审查 |
| `frontend-release` | 步骤 7：发布 |

## 内置资源（`frontend-iteration`）

- `templates/docs/technical-architecture.md`
- `templates/docs/version/` → Bootstrap 复制为 `docs/vX.Y.Z/`
- `examples/` → 黄金路径成品样例（只读参照）
- `references/`：step-gates、progress、document-status、version、orchestrated-invocation 约定

路径解析见 `frontend-iteration` → **Skill Path Resolution**（兼容 `.agents/skills/` 与 `skills/` 两种布局）。

## Examples

黄金路径内置于 `frontend-iteration` skill，安装后位于：

- `.agents/skills/frontend-iteration/examples/feedback-form-v0.1.0/`（消费方）
- `skills/frontend-iteration/examples/feedback-form-v0.1.0/`（源码仓库）

说明见 skill 内 [`examples/README.md`](skills/frontend-iteration/examples/README.md)。

## Validation

由 agent 按 `step-gates.md` 与 `progress.md` 自检。
