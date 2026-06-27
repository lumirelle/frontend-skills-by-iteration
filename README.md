# frontend-workflow

可分发的前端迭代 Agent Skills 工作流。

## Install

```bash
npx skills add <your-org>/frontend-workflow --skill frontend-iteration
npx skills add <your-org>/frontend-workflow --skill frontend-requirements
npx skills add <your-org>/frontend-workflow --skill frontend-design
npx skills add <your-org>/frontend-workflow --skill frontend-plan
npx skills add <your-org>/frontend-workflow --skill frontend-implement
npx skills add <your-org>/frontend-workflow --skill frontend-test
npx skills add <your-org>/frontend-workflow --skill frontend-review
```

## Skills

| Skill | 状态 | 说明 |
|-------|------|------|
| `frontend-iteration` | ✅ | 主编排器 |
| `frontend-requirements` | ✅ | 步骤 1：需求理解 |
| `frontend-design` | ✅ | 步骤 2：技术方案 |
| `frontend-plan` | ✅ | 步骤 3：实施计划 |
| `frontend-implement` | ✅ | 步骤 4：代码实现 |
| `frontend-test` | ✅ | 步骤 5：自测 |
| `frontend-review` | ✅ | 步骤 6：代码审查 |
| `frontend-release` | 待建 | 步骤 7：发布 |

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

## Templates

- `templates/docs/technical-architecture.md`：项目技术架构模板，包含 Testing 章节；只记录框架、命令、目录和项目约定，具体框架 API 由 Agent 查询官方文档。

## Testing Guidance

- `skills/frontend-test/references/test-writing-guide.md`：通用测试思维，包含测试维度、分层选择、功能类型 checklist 和反模式。
