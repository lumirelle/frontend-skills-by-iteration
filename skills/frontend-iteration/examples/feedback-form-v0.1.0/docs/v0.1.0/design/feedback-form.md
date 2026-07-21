# 用户反馈表单 技术方案

> 状态: ACTIVE
> 版本: v0.1.0
> 来源: prd/summarized/feedback-form.md
> 更新于: 2026-06-27
> 失效原因:

## 方案选型

| 方案 | 优点 | 缺点 | 取舍 |
|------|------|------|------|
| A（最小，推荐） | 1 页面 + 1 API 封装；局部 state | 逻辑暂不复用 | 单页无跨页共享 |
| B（composable + store） | 可复用 | 无第二处使用 | 过度设计 |

**结论**：A。非目标已排除历史记录；不预留 store

## 组件结构

```
<FeedbackFormPage>           # 新建：状态 + 提交
├── <FeedbackTypeSelect>     # 复用 @app/ui Select
└── <FeedbackContentField>   # 复用 @app/ui Textarea
```

| 组件 | 职责 | 复用/新建 | 位置 |
|------|------|-----------|------|
| `FeedbackFormPage` | 校验、提交、提示 | 新建 | `src/pages/feedback/FeedbackFormPage.*` |
| `Select` / `Textarea` | 类型、内容 | 复用 `@app/ui` | — |
| 入口项 | 「意见反馈」 | 改 ProfilePage | `src/pages/profile/ProfilePage.*` |

## 数据流

| 状态/数据 | 归属 | 读写方 | 备注 |
|-----------|------|--------|------|
| `type` | 页面局部 | 下拉 | 默认 `'suggestion'` |
| `content` | 页面局部 | 文本域 | trim 判空 |
| `status` | 页面局部 | 提交流程 | idle/submitting/success/error |
| `contentError` | 页面局部 | 校验 | 空内容提示 |

## 接口契约

**参照**：

| 类型 | 路径 | 说明 |
|------|------|------|
| 类似页面 | — | 本迭代首例 |
| API 目录 | `src/api/` | `docs/technical-architecture.md` 目录约定 |
| 类型 | `src/types/` | 新建 `feedback.ts` |

| API | 方法 | 入参 | 返回 | 前端 | 已有/新增 |
|-----|------|------|------|------|-----------|
| `/api/feedback`（暂定） | POST | `{ type, content }` | `{ ok: true }` | `submitFeedback(payload): Promise<void>` | 新增 |

后端未就绪：是。封装 `src/api/feedback.ts` 占位返回；切换点仅改封装

**联调待定清单**（实现 `TODO(v0.1.0): 接口联调待定`）：

- 路径 `/api/feedback`
- 入参/返回字段

页面只调 `submitFeedback`；失败（非 2xx/网络）统一 reject

## 路由

| 路径 | 参数 | 守卫 | 说明 |
|------|------|------|------|
| `/feedback` | 无 | 既有登录拦截 | 新表单页 |

## 错误处理

| 状态 | 策略 |
|------|------|
| 加载中 | 无（纯表单） |
| 空数据 | 不适用 |
| 错误 | `status='error'`；「提交失败，请重试」；保留输入 |
| 无权限 | 既有登录拦截 |

## 兼容性

| 维度 | 说明 |
|------|------|
| 平台 | 无 |
| 响应式 | 既有断点 |
| 浏览器 | 项目基线 |

## 测试策略

| 层级 | 覆盖 |
|------|------|
| 单元 | 封装占位；trim 校验；状态 UI；提交中禁用 |
| 集成 | 页面 + mock `submitFeedback` 成功/失败 |
| E2E | 进入→填写→提交成功→提示（1 条） |

## 涉及文件

| 操作 | 文件 |
|------|------|
| 新增 | `src/types/feedback.ts`、`src/api/feedback.ts`、`src/api/feedback.v0.1.0.test.unit.ts` |
| 新增 | `src/pages/feedback/FeedbackFormPage.*`、`.v0.1.0.test.unit.*`、`.v0.1.0.test.integration.*`、`.v0.1.0.test.e2e.*` |
| 修改 | `ProfilePage.*`、路由配置 |

## 风险与回滚

| 风险 | 应对 |
|------|------|
| 后端字段不一致 | 只改 `src/api/feedback.ts` |
| 入口回归 | 追加一项 + 入口渲染测；回滚移除入口与路由 |

## 待确认问题

无阻塞。字段/路径 mock 推进，待后端确认
