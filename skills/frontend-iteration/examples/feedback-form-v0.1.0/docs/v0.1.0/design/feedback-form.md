# 用户反馈表单 技术方案

> Status: ACTIVE
> Version: v0.1.0
> Source: prd/summarized/feedback-form.md
> Updated: 2026-06-27
> Stale reason:

## 方案选型

| 方案 | 优点 | 缺点 | 取舍 |
|------|------|------|------|
| A（最小改动，推荐） | 新增一个反馈页面组件 + 一个 API 封装函数；表单状态用组件局部状态 | 反馈逻辑暂不复用 | 满足当前单页需求，无跨页共享诉求 |
| B（抽 useFeedbackForm composable + 全局 store） | 逻辑可复用、便于扩展历史记录 | 当前无第二处使用，属过度设计 | 暂不需要 |

**结论**：选 A。仅一个页面消费该逻辑，局部状态足够；非目标已排除历史记录，无需为「以后可能用到」预留全局 store。

## 组件结构

```
<FeedbackFormPage>           # 新建：页面，持有表单状态与提交逻辑
├── <FeedbackTypeSelect>     # 复用：项目既有下拉组件 @app/ui Select
└── <FeedbackContentField>   # 复用：项目既有文本域 @app/ui Textarea
```

| 组件 | 职责 | 复用/新建 | 位置 |
|------|------|-----------|------|
| `FeedbackFormPage` | 表单状态、校验、提交、状态提示 | 新建 | `src/pages/feedback/FeedbackFormPage.*` |
| `Select` | 反馈类型选择 | 复用 `@app/ui` | — |
| `Textarea` | 反馈内容输入 | 复用 `@app/ui` | — |
| 「我的」入口项 | 追加「意见反馈」入口 | 修改既有页面 | `src/pages/profile/ProfilePage.*` |

## 数据流

| 状态/数据 | 归属 | 读写方 | 备注 |
|-----------|------|--------|------|
| `type` | `FeedbackFormPage` 局部 | 下拉读写 | 默认 `'suggestion'` |
| `content` | `FeedbackFormPage` 局部 | 文本域读写 | 提交前 trim 判空 |
| `status` | `FeedbackFormPage` 局部 | 提交流程读写 | `idle / submitting / success / error` |
| `contentError` | `FeedbackFormPage` 局部 | 校验读写 | 空内容时为提示文案 |

## 接口契约

**参照**：

| 类型 | 路径/符号 | 说明 |
|------|-----------|------|
| 类似页面 | （本迭代为首例，无） | — |
| 已有 API 封装 | `src/api/` 目录约定 | 遵循 technical-architecture |
| 已有类型 | `src/types/` | 新建 `feedback.ts` |

| API | 方法 | 入参 | 返回 | 前端类型 | 已有/新增 |
|-----|------|------|------|----------|-----------|
| `/api/feedback`（暂定） | POST | `{ type, content }` | `{ ok: true }` | `submitFeedback(payload): Promise<void>` | 新增 |

后端未就绪：是。封装 `src/api/feedback.ts`；占位返回；切换点仅改封装内部。

**联调待定清单**（实现写 `TODO(v0.1.0): 接口联调待定`）：

- 路径 `/api/feedback` 待后端确认
- 入参/返回字段以后端为准

先在 `src/api/feedback.ts` 封装 `submitFeedback`，按 `{ type, content }` 约定；接口就绪后仅改封装内部，不影响页面。提交失败（非 2xx 或网络异常）统一 reject。

## 路由

| 路径 | 参数 | 守卫/权限 | 说明 |
|------|------|-----------|------|
| `/feedback` | 无 | 复用既有登录拦截 | 新增反馈表单页面路由 |

## 错误处理

| 状态 | 实现策略 |
|------|----------|
| 加载中 | 无数据加载（纯表单页），不需要 |
| 空数据 | 不适用 |
| 错误 | 提交失败设 `status='error'`，展示「提交失败，请重试」，保留输入 |
| 无权限 | 复用既有登录拦截，未登录不渲染表单 |

## 兼容性

| 维度 | 说明 |
|------|------|
| 平台差异 | 无 |
| 响应式 | 沿用项目既有断点与表单布局 |
| 浏览器/版本 | 沿用项目基线 |

## 测试策略

| 层级 | 覆盖内容 |
|------|----------|
| 单元 | 表单校验（trim 判空）、各状态渲染与切换、提交中禁用、成功重置、失败保留 |
| 集成 | `FeedbackFormPage` + `submitFeedback`（mock API）：成功路径与失败路径 |
| E2E | 关键路径：进入表单 → 填写 → 提交成功 → 见提示（1 条即可） |

## 涉及文件

| 操作 | 文件 | 说明 |
|------|------|------|
| 新增 | `src/pages/feedback/FeedbackFormPage.*` | 反馈表单页面 |
| 新增 | `src/pages/feedback/FeedbackFormPage.test.*` | 单元测试 |
| 新增 | `src/pages/feedback/FeedbackFormPage.integration.test.*` | 集成测试 |
| 新增 | `src/api/feedback.ts` | `submitFeedback` 封装 |
| 新增 | `src/types/feedback.ts` | `FeedbackType`、payload 类型 |
| 新增 | `tests/e2e/feedback-form.spec.*` | E2E 关键路径 |
| 修改 | `src/pages/profile/ProfilePage.*` | 追加「意见反馈」入口 |
| 修改 | 路由配置 | 注册 `/feedback` |

## 风险与回滚

| 风险 | 影响 | 应对/回滚 |
|------|------|-----------|
| 后端字段与约定不一致 | 提交失败 | 仅改 `src/api/feedback.ts`，页面不受影响；接口就绪后对齐 |
| 「我的」入口改动影响既有布局 | 回归风险 | 仅追加一项，覆盖入口渲染测试；回滚只需移除该项与路由 |

## Open Questions

- 提交接口字段/路径以 summarized 的 mock 约定推进，待后端确认（不阻塞本方案）。
