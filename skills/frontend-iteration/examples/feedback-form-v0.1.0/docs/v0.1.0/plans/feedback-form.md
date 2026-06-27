# 用户反馈表单 实施计划

> Status: ACTIVE
> Version: v0.1.0
> Source: design/feedback-form.md
> Updated: 2026-06-27
> Stale reason:

## 目标

按 design 以 TDD 交付反馈表单页面、API 封装与「我的」入口，覆盖校验、提交中、成功、失败状态。

## 范围

**包含：**

- `submitFeedback` API 封装与类型。
- `FeedbackFormPage`：校验、提交流程与四类状态。
- 「我的」页面新增「意见反馈」入口与 `/feedback` 路由。

**不包含：**

- 图片上传、历史记录、内容长度上限（见 summarized 非目标）。

## 前置确认

| 项 | 状态 | 说明 |
|----|------|------|
| summarized 已确认 | 是 | ACTIVE |
| design 已确认 | 是 | ACTIVE |
| open questions 已关闭 | 是 | 接口字段用 mock 约定推进，不阻塞实现 |

## 文件边界

| 操作 | 文件 | 说明 |
|------|------|------|
| 新增 | `src/types/feedback.ts` | `FeedbackType`、payload 类型 |
| 新增 | `src/api/feedback.ts` | `submitFeedback` |
| 新增 | `src/pages/feedback/FeedbackFormPage.*` | 页面组件 |
| 新增 | `src/pages/feedback/FeedbackFormPage.test.*` | 单元测试 |
| 新增 | `src/pages/feedback/FeedbackFormPage.integration.test.*` | 集成测试 |
| 新增 | `tests/e2e/feedback-form.spec.*` | E2E |
| 修改 | `src/pages/profile/ProfilePage.*` | 追加入口 |
| 修改 | 路由配置 | 注册 `/feedback` |

## TDD 任务列表

### Task 1: 反馈内容必填校验

**目标**：内容 trim 后为空时，提交被拦截并显示提示，不发起请求。

**依赖**：无

**文件：**

- 新增：`src/pages/feedback/FeedbackFormPage.*`、`src/types/feedback.ts`
- 测试：`src/pages/feedback/FeedbackFormPage.test.*`

**RED：失败测试**

- 测试文件：`src/pages/feedback/FeedbackFormPage.test.*`
- 测试行为：渲染表单，内容留空（或纯空格）点击提交，断言出现「请填写反馈内容」且未调用 `submitFeedback`。
- 预期失败原因：`FeedbackFormPage` 尚未实现，组件/校验不存在。
- 运行：`npm run test:unit`

**GREEN：最小实现**

- 修改：`src/pages/feedback/FeedbackFormPage.*`
- 实现：组件渲染类型下拉 + 内容文本域 + 提交按钮；提交时 trim 判空，置 `contentError`，空则 return。

**REFACTOR：保持通过下清理**

- 无

**VERIFY：验证**

- 运行：`npm run test:unit`
- 通过条件：校验用例通过，exit 0。

### Task 2: 提交流程（提交中 / 成功 / 失败）

**目标**：内容非空提交时，按钮进入提交中；成功后提示并重置；失败后提示并保留输入。

**依赖**：Task 1

**文件：**

- 新增：`src/api/feedback.ts`
- 修改：`src/pages/feedback/FeedbackFormPage.*`
- 测试：`src/pages/feedback/FeedbackFormPage.test.*`、`src/pages/feedback/FeedbackFormPage.integration.test.*`

**RED：失败测试**

- 测试文件：`FeedbackFormPage.integration.test.*`
- 测试行为：mock `submitFeedback` 分别 resolve / reject；提交后断言：提交中按钮 disabled 且文案「提交中…」；成功后见「反馈已提交」且内容清空；失败后见「提交失败，请重试」且内容保留。
- 预期失败原因：提交逻辑与状态机尚未实现。
- 运行：`npm run test:integration`

**GREEN：最小实现**

- 修改：`FeedbackFormPage.*` 接入 `submitFeedback`，维护 `status`（idle/submitting/success/error），成功重置、失败保留。
- 新增：`src/api/feedback.ts` 封装 POST `/api/feedback`，非 2xx/异常 reject。

**REFACTOR：保持通过下清理**

- 将状态文案抽为常量（不改行为）。

**VERIFY：验证**

- 运行：`npm run test:unit && npm run test:integration`
- 通过条件：全部通过，exit 0。

### Task 3: 「我的」入口与路由接入

**目标**：「我的」页面新增「意见反馈」入口，点击进入 `/feedback`。

**依赖**：Task 2

**文件：**

- 修改：`src/pages/profile/ProfilePage.*`、路由配置
- 测试：`src/pages/profile/ProfilePage.test.*`、`tests/e2e/feedback-form.spec.*`

**RED：失败测试**

- 测试文件：`ProfilePage.test.*`
- 测试行为：渲染「我的」页面，断言存在「意见反馈」入口并指向 `/feedback`。
- 预期失败原因：入口尚未添加。
- 运行：`npm run test:unit`

**GREEN：最小实现**

- 修改：`ProfilePage.*` 追加入口项；路由配置注册 `/feedback`。

**REFACTOR：保持通过下清理**

- 无

**VERIFY：验证**

- 运行：`npm run test:unit`，并补 E2E `tests/e2e/feedback-form.spec.*`（进入 → 填写 → 提交成功 → 见提示）。
- 通过条件：单元通过；E2E 关键路径通过，exit 0。

## 测试矩阵

| 验收标准 | 测试维度 | 覆盖方式 | 对应任务 |
|----------|----------|----------|----------|
| 「我的」存在入口并进入表单 | 用户交互 / 主流程 | 单元 + E2E | Task 3 |
| 类型默认「功能建议」可切换 | 数据展示 / 状态变化 | 单元 | Task 1 |
| 空内容提交被拦截并提示 | 输入边界 | 单元 | Task 1 |
| 提交中按钮 disabled 显示「提交中…」 | 状态变化 | 集成 | Task 2 |
| 成功后提示并重置 | API 结果 / 主流程 | 集成 + E2E | Task 2 / Task 3 |
| 失败后提示并保留内容 | API 结果 | 集成 | Task 2 |

## 执行顺序

1. Task 1
2. Task 2
3. Task 3

可并行任务：无（依赖链 1 → 2 → 3）。

## 风险

| 风险 | 应对 |
|------|------|
| 后端字段未定 | mock 约定 `{ type, content }`，仅封装层承接变更 |
| 入口改动影响既有布局 | Task 3 补入口渲染测试 |

## Open Questions

- 无（接口字段以 mock 约定推进，已在 design 记录）。
