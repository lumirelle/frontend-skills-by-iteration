# feat(feedback-form): add user feedback form

## 背景

已登录用户需反馈渠道（`prd/summarized/feedback-form.md`）。此前无入口

## 改动摘要

- 新页 `/feedback`：类型下拉 + 必填内容 + 提交
- 状态机：校验拦截、提交中禁用、成功重置、失败保留
- 「我的」增「意见反馈」入口
- `submitFeedback` 封装：占位 + mock `{ type, content }`

| 模块 | 改动 |
|------|------|
| 反馈表单 | 页面、校验、提交流程 |
| 我的 | 入口 + 路由 |
| API | `src/api/feedback.ts`（占位） |

## 关联文档

- 需求：`docs/v0.1.0/prd/summarized/feedback-form.md`
- 方案：`docs/v0.1.0/design/feedback-form.md`
- 计划：`docs/v0.1.0/plans/feedback-form.md`
- 审查：`docs/v0.1.0/review/feedback-form.md`
- 发布：`docs/v0.1.0/release/changelog-entry.md`
