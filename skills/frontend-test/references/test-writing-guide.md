# Test Writing Guide

用于指导 Agent 设计和补写测试用例。这里放通用测试思维，不放具体框架 API。

## Test Dimensions

| 维度 | 说明 |
|------|------|
| 主流程 | 用户最关键的成功路径，优先覆盖 |
| 输入边界 | 空值、非法值、极限值、重复输入 |
| 状态变化 | loading、success、empty、error、disabled、unauthorized |
| 用户交互 | 点击、输入、提交、取消、跳转、确认弹窗 |
| 数据展示 | 字段格式、条件渲染、排序、筛选、分页 |
| 权限与角色 | 不同角色的可见性、可操作性、不可访问状态 |
| API 结果 | 成功、失败、超时、空返回、字段缺失 |
| 平台差异 | Web / H5 / 响应式 / 浏览器差异 |
| 回归风险 | 本次改动可能影响的既有行为 |

## Layer Selection

| 层级 | 适合测试 | 不适合测试 |
|------|----------|------------|
| 单元 | 纯逻辑、格式化、校验、组件局部交互 | 跨页面完整流程 |
| 集成 | 组件 + store + API mock、模块协作 | 浏览器真实导航 |
| E2E | 关键用户路径、跨页面流程、真实路由 | 细小分支和纯逻辑 |
| 手动 | 无自动化框架、环境不可用、一次性视觉确认 | 可稳定自动化的行为 |

优先级：主流程 E2E 少而关键；复杂逻辑单元测充分；模块协作用集成测兜底。

## Feature Type Checklist

### Form

- 默认值、必填、格式校验、边界输入
- submit 成功、submit 失败、重复提交防护
- disabled/loading 状态
- reset/cancel 行为

### List / Table

- loading、empty、error
- 数据渲染、字段格式、缺失字段
- pagination、sorting、filtering（需求包含时）
- row action 与权限控制

### Detail Page

- 数据加载、字段展示、缺失字段
- loading、error、not found、unauthorized
- 返回、跳转、编辑入口

### Modal / Drawer

- open/close、confirm/cancel
- 表单校验或异步提交
- loading/error 状态
- 键盘/焦点行为（项目要求时）

### Navigation / Route

- 正确跳转、参数传递
- 未登录/无权限拦截
- deep link 与返回路径

## Case Design

- 用用户可见行为命名，不用实现细节命名。
- 一个用例验证一个主要行为；共享 setup 可抽，但不要为了抽象而抽象。
- 优先 Arrange / Act / Assert 或 Given / When / Then 结构。
- 断言用户能观察到的结果：文本、状态、URL、请求结果、可访问性状态。
- Mock 只 mock 边界外依赖；不要 mock 被测逻辑本身。

## Anti-patterns

- 测私有实现、内部 state 名称、组件内部方法。
- 滥用 snapshot 覆盖交互行为。
- 用 E2E 测大量纯逻辑分支。
- 一个用例断言多个不相关行为。
- 为了让测试通过修改业务行为但不回到 implementation。
- 用固定等待替代可观察条件等待。

## Framework Usage

具体框架用法不写在本指南中。

1. 先读 `docs/technical-architecture.md` 的 Testing 章节，确认框架、命令、目录和项目约定。
2. 参考项目已有测试示例，优先保持一致。
3. 遇到框架 API、mock、异步等待、E2E locator 等细节时，Agent 应自行查询当前官方文档。
4. 不依赖过期记忆硬写框架语法。
