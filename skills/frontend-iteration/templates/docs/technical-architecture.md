# Technical Architecture

描述项目开发环境、目标平台、工程约定与测试配置。保持简洁，只写项目事实，不复制框架文档。

## Project

- Target platforms:
- Package manager:
- Runtime:
- Build tool:
- Framework:
- UI library:
- State management:
- Routing:
- API client:

## Development

| Task | Command | Notes |
|------|---------|-------|
| Install | `...` | |
| Dev server | `...` | |
| Build | `...` | |
| Lint | `...` | |
| Type check | `...` | |

## Directory Conventions

| Area | Path | Notes |
|------|------|-------|
| Pages/routes | `...` | |
| Components | `...` | |
| Hooks | `...` | |
| API | `...` | |
| Types | `...` | |
| Tests | `...` | |

## Code Style

Agent 步骤 4 开始前从此节提炼 **Style Anchors** 写入 `progress.md`（见 `frontend-iteration/references/code-style-enforcement.md`）。只写项目事实，每条须可判定。

| 维度 | 约定 |
|------|------|
| 命名 | 文件、组件、变量、类型、测试文件 |
| 导入 | 顺序、路径别名、禁止相对路径层级 |
| 组件 | 函数式/选项式、props 命名、文件结构 |
| 状态 | 局部 vs store、何时抽 hook |
| API 调用 | 仅通过 `src/api/` 封装，禁止页面直接 `fetch` |
| 错误处理 | 统一模式（toast / inline / reject） |
| 注释与 TODO | 接口待定用 `TODO(vX.Y.Z): 接口联调待定`（见 api-integration-guide） |
| Lint / Format | 与 Development 表命令对应 |

## Testing

### Frameworks

| Layer | Framework | Version | Notes |
|-------|-----------|---------|-------|
| Unit | | | |
| Integration | | | |
| E2E | | | |

### Commands

| Layer | Command | Notes |
|-------|---------|-------|
| Unit | `...` | |
| Integration | `...` | |
| E2E | `...` | |
| All relevant tests | `...` | |

### File Locations

| Layer | Path | Notes |
|-------|------|-------|
| Unit | `...` | |
| Integration | `...` | |
| E2E | `...` | |
| Fixtures/mocks | `...` | |

### Project Conventions

- Mock strategy:
- Test data / fixtures:
- Stable selectors:
- Network stubbing:
- Accessibility expectations:

### Framework API Usage

Do not duplicate framework API documentation here.

When an agent needs framework-specific syntax or behavior, it should:

1. Prefer existing project test examples.
2. Fetch current official framework documentation.
3. Follow the versions declared in this file.
4. Avoid relying on stale memory for API details.

## Notes

- ...
