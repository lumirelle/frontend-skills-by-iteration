# 用户反馈表单 实施计划

> 状态: ACTIVE
> 版本: v0.1.0
> 来源: design/feedback-form.md
> 更新于: 2026-06-27
> 失效原因:

## 目标

TDD 交付：API 封装（占位）→ 表单校验 → 提交流程 → 「我的」入口与路由

## 范围

**包含：**

- `FeedbackType`、payload 类型；`submitFeedback` 占位封装 + `TODO(v0.1.0): 接口联调待定`
- `FeedbackFormPage`：校验、提交中/成功/失败
- `ProfilePage` 入口；`/feedback` 路由

**不包含：**

- 图片上传、历史记录、内容长度上限（summarized 非目标）

## 前置确认

| 项 | 状态 | 说明 |
|----|------|------|
| summarized 已确认 | 是 | ACTIVE |
| design 已确认 | 是 | ACTIVE |
| 待确认问题已关闭 | 是 | mock `{ type, content }` 推进，不阻塞 |

## 文件边界

| 操作 | 文件 | 说明 |
|------|------|------|
| 新增 | `src/types/feedback.ts` | 类型 |
| 新增 | `src/api/feedback.ts` | 封装 + TODO |
| 新增 | `src/api/feedback.v0.1.0.test.unit.ts` | 封装单测 |
| 新增 | `src/pages/feedback/FeedbackFormPage.*` | 页面 |
| 新增 | `src/pages/feedback/FeedbackFormPage.v0.1.0.test.unit.*` | 单元 |
| 新增 | `src/pages/feedback/FeedbackFormPage.v0.1.0.test.integration.*` | 集成 |
| 新增 | `src/pages/feedback/FeedbackFormPage.v0.1.0.test.e2e.*` | E2E |
| 修改 | `src/pages/profile/ProfilePage.*` | 入口 |
| 修改 | 路由配置 | `/feedback` |

## TDD 任务列表

### 任务 1：API 类型与封装（占位）

**目标**：`submitFeedback` 按 design 签名存在；后端未就绪时占位返回；待定处标 TODO

**依赖**：无

**文件：**

- 新增：`src/types/feedback.ts`、`src/api/feedback.ts`
- 测试：`src/api/feedback.v0.1.0.test.unit.ts`

**RED：失败测试**

- 行为：调用 `submitFeedback({ type: 'suggestion', content: 'hi' })` resolve；mock 未实现时失败
- 预期失败：`feedback.ts` 不存在
- 运行：`npm run test:unit`

**GREEN：最小实现**

- `feedback.ts`：`Promise.resolve()` 占位返回
- 注释：`// TODO(v0.1.0): 接口联调待定，路径 /api/feedback 待后端确认`
- 注释：`// TODO(v0.1.0): 接口联调待定，入参/返回字段以后端为准`

**REFACTOR**：无

**VERIFY**

- `npm run test:unit` exit 0
- `npm run lint`、`npm run typecheck` exit 0（若已配置）

### 任务 2：反馈内容必填校验

**目标**：内容 trim 为空 → 提示「请填写反馈内容」；不调用 `submitFeedback`。

**依赖**：任务 1

**文件：**

- 新增：`src/pages/feedback/FeedbackFormPage.*`
- 测试：`src/pages/feedback/FeedbackFormPage.v0.1.0.test.unit.*`

**RED：失败测试**

- 行为：空/纯空格提交 → 见提示；`submitFeedback` 未调用
- 预期失败：页面/校验未实现
- 运行：`npm run test:unit`

**GREEN：最小实现**

- 类型下拉 + 文本域 + 提交；trim 判空 → `contentError`；空则 return
- mock `submitFeedback`；校验路径不触发调用

**REFACTOR**：无

**VERIFY**

- `npm run test:unit` exit 0
- `npm run lint`、`npm run typecheck` exit 0

### 任务 3：提交流程（提交中 / 成功 / 失败）

**目标**：非空提交 → 提交中 disabled；成功提示+重置；失败提示+保留

**依赖**：任务 2

**文件：**

- 修改：`src/pages/feedback/FeedbackFormPage.*`
- 测试：`FeedbackFormPage.v0.1.0.test.unit.*`、`FeedbackFormPage.v0.1.0.test.integration.*`

**RED：失败测试**

- 行为：mock `submitFeedback` resolve/reject；断言 submitting/success/error UI
- 预期失败：状态机未实现
- 运行：`npm run test:integration`

**GREEN：最小实现**

- 接 `submitFeedback`；`status`: idle/submitting/success/error。
- 页面不写死占位数据；只调封装

**REFACTOR**：状态文案抽常量；测试仍过

**VERIFY**

- `npm run test:unit && npm run test:integration` exit 0
- `npm run lint`、`npm run typecheck` exit 0

### 任务 4：「我的」入口与路由

**目标**：`ProfilePage` 有「意见反馈」→ `/feedback`；E2E 关键路径过。

**依赖**：任务 3

**文件：**

- 修改：`ProfilePage.*`、路由配置
- 测试：`ProfilePage.v0.1.0.test.unit.*`、`ProfilePage.v0.1.0.test.e2e.*`

**RED：失败测试**

- 行为：渲染「我的」→ 存在入口且指向 `/feedback`
- 预期失败：入口未加
- 运行：`npm run test:unit`

**GREEN：最小实现**

- 追加入口；注册 `/feedback`

**REFACTOR**：无

**VERIFY**

- `npm run test:unit`；E2E 进入→填写→提交成功→见提示 exit 0
- `npm run lint`、`npm run typecheck` exit 0

## 测试矩阵

| 验收标准 | 测试维度 | 覆盖 | 任务 |
|----------|----------|------|------|
| 「我的」入口进表单 | 交互 / 主流程 | 单元 + E2E | 4 |
| 类型默认可切换 | 展示 / 状态 | 单元 | 2 |
| 空内容拦截提示 | 输入边界 | 单元 | 2 |
| 提交中 disabled | 状态变化 | 集成 | 3 |
| 成功提示重置 | API 结果 / 主流程 | 集成 + E2E | 3 / 4 |
| 失败提示保留 | API 结果 | 集成 | 3 |
| 封装占位可调用 | API 结果 | 单元 | 1 |

## 执行顺序

1. 任务 1（API）
2. 任务 2（校验）
3. 任务 3（提交流程）
4. 任务 4（入口）

可并行：无（1→2→3→4）

## 风险

| 风险 | 应对 |
|------|------|
| 后端字段未定 | 占位 + `TODO(v0.1.0): 接口联调待定`；只改 `src/api/feedback.ts` |
| 入口影响布局 | 任务 4 补入口渲染测 |

## 待确认问题

无（mock 约定在 design；不阻塞）
