# 技术架构

项目环境、目标平台、工程约定、测试配置。只写事实；不抄框架文档。

> 黄金路径虚构项目；技术栈中性；命令占位。

## 项目

- 目标平台：Web（桌面 + 移动响应式）
- 包管理器：npm
- 运行时：Node 20
- 构建工具：组件式框架 + 模块打包器
- 框架：组件式 SPA（示例无关具体实现）
- UI 库：项目内部组件库 `@app/ui`
- 状态管理：局部组件状态优先；跨页共享用 `src/stores/`
- 路由：文件式路由；页面位于 `src/pages/`
- API 客户端：`src/api/` 统一封装，基于 `fetch`

## 开发与命令

| 任务 | 命令 | 备注 |
|------|------|------|
| 安装依赖 | `npm install` | |
| 开发服务 | `npm run dev` | |
| 构建 | `npm run build` | |
| 代码检查 | `npm run lint` | 步骤 4 VERIFY |
| 类型检查 | `npm run typecheck` | 步骤 4 VERIFY |

## 目录约定

| 区域 | 路径 | 备注 |
|------|------|------|
| 页面/路由 | `src/pages/` | 一页一目录 |
| 组件 | `src/components/` | 可复用组件 |
| Hooks | `src/composables/` | 复用逻辑 |
| API | `src/api/` | 请求封装 |
| 类型 | `src/types/` | 共享类型 |
| 测试 | 与被测文件同目录 `*.test.ts` / `tests/e2e/` | 见下 |

## 代码风格

步骤 4 前从此节提炼 **风格锚点** 写入 `progress.md`（见 `code-style-enforcement.md`）。

| 维度 | 约定 |
|------|------|
| 命名 | 页面 PascalCase 目录 + 同名组件；API 函数 camelCase；类型 PascalCase |
| 导入 | 外部库 → 别名 `@app/` → 相对路径；同组空一行 |
| 组件 | 函数式组件；单文件单默认导出页面组件 |
| 状态 | 表单/页面临时状态用局部 state；无跨页共享则不建 store |
| API 调用 | 仅 `src/api/`；页面不直接 `fetch` |
| 错误处理 | API reject → 页面 `status='error'` + 统一文案；不在 API 层弹 UI |
| 注释与 TODO | 接口待定：`TODO(vX.Y.Z): 接口联调待定`（见 `api-integration-guide`） |
| 检查与格式化 | `npm run lint`、`npm run typecheck` |

## 测试

### 框架

| 层级 | 框架 | 版本 | 备注 |
|------|------|------|------|
| 单元 | 组件测试运行器 | latest | 与框架配套 |
| 集成 | 同单元运行器 | latest | 配 API mock |
| E2E | 浏览器自动化框架 | latest | 关键路径 |

### 命令

| 层级 | 命令 | 备注 |
|------|------|------|
| 单元 | `npm run test:unit` | |
| 集成 | `npm run test:integration` | |
| E2E | `npm run test:e2e` | 需启动开发服务 |
| 全部相关测试 | `npm test` | 单元 + 集成 |

### 文件位置

| 层级 | 路径 | 备注 |
|------|------|------|
| 单元 | `src/**/<name>.test.ts` | 与源码同目录 |
| 集成 | `src/**/<name>.integration.test.ts` | |
| E2E | `tests/e2e/<name>.spec.ts` | |
| 夹具/Mock | `tests/fixtures/` | |

### 项目约定

- Mock 策略：仅 mock 网络边界（API 客户端），不 mock 被测组件内部逻辑
- 测试数据/夹具：统一放 `tests/fixtures/`
- 稳定选择器：用 `data-testid`，不用样式类选择
- 网络拦截：集成测试拦截 `src/api/` 层
- 可访问性：表单控件须有可访问标签

### 框架 API 用法

不在此重复框架 API 文档。

需要框架语法或行为时：

1. 优先读项目内既有测试示例。
2. 查阅当前官方框架文档。
3. 遵循本文件声明的版本。
4. 不凭过期记忆写 API 细节。

## 备注

- 演示用虚构项目；真实项目请替换框架、版本与命令。
