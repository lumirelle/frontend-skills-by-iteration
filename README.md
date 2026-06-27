# frontend-workflow

可分发的前端迭代 Agent Skills 工作流。

## Install

```bash
npx skills add <your-org>/frontend-workflow --skill '*'
```

安装后 `frontend-iteration` 内置文档模板，**On Start 会自动 Bootstrap** `docs/` 脚手架，无需手动复制。

## Usage

```
/frontend-iteration v1.2.0              # fast（默认）：文档步骤 1–3 连续，之后逐步确认
/frontend-iteration v1.2.0 strict       # 每步均须确认
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 resume
```

## 你需要准备的

仅两项（其余由编排器自动创建）：

1. 将本迭代 **origin PRD** 放入 `docs/vX.Y.Z/prd/origin/*.md`
2. （可选）UI 稿放入 `docs/vX.Y.Z/ui/*`

`docs/technical-architecture.md` 与 `docs/vX.Y.Z/progress.md` 在首次运行时从 `frontend-iteration` 内置模板自动生成；其中 `technical-architecture.md` 必须补齐项目事实后才能进入迭代。

## Skills

| Skill | 说明 |
|-------|------|
| `frontend-project-init` | 初始化 `docs/` 脚手架与版本目录 |
| `frontend-iteration` | 主编排器（含模板、脚本、路径解析） |
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
- `references/`：step-gates、progress、document-status、version 约定
- `scripts/validate-iteration.ps1`：仓库自检工具，消费方工作流不依赖它

路径解析见 `frontend-iteration` → **Skill Path Resolution**（兼容 `.agents/skills/` 与 `skills/` 两种布局）。

## Examples

黄金路径内置于 `frontend-iteration` skill，安装后位于：

- `.agents/skills/frontend-iteration/examples/feedback-form-v0.1.0/`（消费方）
- `skills/frontend-iteration/examples/feedback-form-v0.1.0/`（源码仓库）

说明见 skill 内 [`examples/README.md`](skills/frontend-iteration/examples/README.md)。

## Validation

可选：维护本 skill 仓库时，可用内置脚本检查样例结构。消费方项目按 `step-gates.md` 与 `progress.md` 由 agent 自检即可，不要求引入脚本门禁。

```powershell
& "skills/frontend-iteration/scripts/validate-iteration.ps1" -Version v0.1.0 -DocsRoot "skills/frontend-iteration/examples/feedback-form-v0.1.0/docs"
```
