# frontend-workflow

可分发的前端迭代 Agent Skills 工作流。

## Install

```bash
npx skills add <your-org>/frontend-workflow --skill '*'
```

## Skills

| Skill | 状态 | 说明 |
|-------|------|------|
| `frontend-iteration` | ✅ | 主编排器 |
| `frontend-requirements` | ✅ | 步骤 1：需求理解 |
| `frontend-design` | ✅ | 步骤 2：技术方案 |
| `frontend-plan` | ✅ | 步骤 3：TDD 实施计划 |
| `frontend-implement` | ✅ | 步骤 4：TDD 代码实现 |
| `frontend-test` | ✅ | 步骤 5：全量自测 |
| `frontend-review` | ✅ | 步骤 6：代码审查 |
| `frontend-release` | ✅ | 步骤 7：发布 |

## Usage

```
/frontend-iteration v1.2.0
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 resume
```

## Prerequisites

- `docs/technical-architecture.md`
- `docs/vX.Y.Z/prd/origin/*.md`
- `docs/vX.Y.Z/ui/*`可选，任意常见图片格式
- `docs/vX.Y.Z/progress.md`（可从模板复制；缺失时由 `frontend-iteration` 创建或修复）

## Templates

- `templates/docs/technical-architecture.md`：项目技术架构模板，包含 Testing 章节；只记录框架、命令、目录和项目约定，具体框架 API 由 Agent 查询官方文档。
- `templates/docs/version/`：单次迭代的目录脚手架，复制为 `docs/vX.Y.Z/` 后放入 `prd/origin/*.md` 与 `ui/*`。

PowerShell 初始化示例：

```powershell
Copy-Item -Recurse templates/docs/version docs/v1.2.0
(Get-Content docs/v1.2.0/progress.md) -replace 'vX.Y.Z', 'v1.2.0' | Set-Content docs/v1.2.0/progress.md
```

## Workflow Conventions

- `skills/frontend-iteration/references/progress-convention.md`：`progress.md` 格式、resume 规则、TDD 证据记录。
- `skills/frontend-iteration/references/document-status.md`：`ACTIVE` / `DRAFT` / `STALE` / `BLOCKED` 文档状态与失效传播规则。
- `skills/frontend-iteration/references/step-gates.md`：每一步完成前的门禁清单。
- `skills/frontend-iteration/references/version-convention.md`：版本号、目录、命名和 resume fallback 规则。
- `skills/frontend-plan/references/minimal-plan-template.md`：小 bugfix 的精简 TDD plan 模板。

## Testing Guidance

- `skills/frontend-test/references/test-writing-guide.md`：通用测试思维，包含测试维度、分层选择、功能类型 checklist 和反模式。

## Validation

使用 PowerShell 校验版本目录：

```powershell
./scripts/validate-iteration.ps1 -Version v1.2.0
```
