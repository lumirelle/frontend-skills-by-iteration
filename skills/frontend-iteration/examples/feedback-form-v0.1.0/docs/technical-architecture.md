# Technical Architecture

描述项目开发环境、目标平台、工程约定与测试配置。保持简洁，只写项目事实，不复制框架文档。

> 本文件为黄金路径样例的虚构项目，技术栈尽量中性，命令以占位约定为主。

## Project

- Target platforms: Web（桌面 + 移动端响应式）
- Package manager: npm
- Runtime: Node 20
- Build tool: 组件式前端框架 + 模块打包器
- Framework: 组件式 SPA 框架（示例无关具体实现）
- UI library: 项目内部组件库 `@app/ui`
- State management: 局部组件状态优先，跨页共享用 `src/stores/`
- Routing: 文件式路由，页面位于 `src/pages/`
- API client: `src/api/` 下统一封装，基于 `fetch`

## Development

| Task | Command | Notes |
|------|---------|-------|
| Install | `npm install` | |
| Dev server | `npm run dev` | |
| Build | `npm run build` | |
| Lint | `npm run lint` | |
| Type check | `npm run typecheck` | |

## Directory Conventions

| Area | Path | Notes |
|------|------|-------|
| Pages/routes | `src/pages/` | 一个页面一个目录 |
| Components | `src/components/` | 可复用组件 |
| Hooks | `src/composables/` | 复用逻辑 |
| API | `src/api/` | 请求封装 |
| Types | `src/types/` | 共享类型 |
| Tests | 与被测文件同目录 `*.test.ts` / `tests/e2e/` | 见下 |

## Testing

### Frameworks

| Layer | Framework | Version | Notes |
|-------|-----------|---------|-------|
| Unit | 组件测试运行器 | latest | 与框架配套 |
| Integration | 同单元运行器 | latest | 配 API mock |
| E2E | 浏览器自动化框架 | latest | 关键路径 |

### Commands

| Layer | Command | Notes |
|-------|---------|-------|
| Unit | `npm run test:unit` | |
| Integration | `npm run test:integration` | |
| E2E | `npm run test:e2e` | 需启动 dev server |
| All relevant tests | `npm test` | 单元 + 集成 |

### File Locations

| Layer | Path | Notes |
|-------|------|-------|
| Unit | `src/**/<name>.test.ts` | 与源码同目录 |
| Integration | `src/**/<name>.integration.test.ts` | |
| E2E | `tests/e2e/<name>.spec.ts` | |
| Fixtures/mocks | `tests/fixtures/` | |

### Project Conventions

- Mock strategy: 仅 mock 网络边界（API client），不 mock 被测组件内部逻辑
- Test data / fixtures: 统一放 `tests/fixtures/`
- Stable selectors: 用 `data-testid`，不用样式类选择
- Network stubbing: 集成测试拦截 `src/api/` 层
- Accessibility expectations: 表单控件须有可访问标签

### Framework API Usage

Do not duplicate framework API documentation here.

When an agent needs framework-specific syntax or behavior, it should:

1. Prefer existing project test examples.
2. Fetch current official framework documentation.
3. Follow the versions declared in this file.
4. Avoid relying on stale memory for API details.

## Notes

- 这是一个演示用虚构项目；真实项目请用实际框架、版本与命令替换。
