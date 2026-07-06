# feat(feedback-form): add user feedback form (v0.1.0)

## 背景

已登录用户需反馈渠道（`prd/summarized/feedback-form.md`）。此前无入口。

## 改动摘要

- 新页 `/feedback`：类型下拉 + 必填内容 + 提交。
- 状态机：校验拦截、提交中禁用、成功重置、失败保留。
- 「我的」增「意见反馈」入口。
- `submitFeedback` 封装：占位 + mock `{ type, content }`。

| 模块 | 改动 |
|------|------|
| 反馈表单 | 页面、校验、提交流程 |
| 我的 | 入口 + 路由 |
| API | `src/api/feedback.ts`（占位） |

## 测试说明

| 层级 | 命令 | 结果 |
|------|------|------|
| 单元 | `npm run test:unit` | exit 0 |
| 集成 | `npm run test:integration` | exit 0 |
| E2E | `npm run test:e2e` | exit 0 |

报告：`docs/v0.1.0/test-report.md`

## 风险与已知问题

- 🟡 失败未分网络/业务错误（联调后细化）。
- 真后端未联调；集成 mock 封装层。
- 接口联调待定：
  - `TODO(v0.1.0): 接口联调待定，路径 /api/feedback 待后端确认`
  - `TODO(v0.1.0): 接口联调待定，入参/返回字段以后端为准`
  - 均在 `src/api/feedback.ts`

## 关联文档

- 需求：`docs/v0.1.0/prd/summarized/feedback-form.md`
- 方案：`docs/v0.1.0/design/feedback-form.md`
- 计划：`docs/v0.1.0/plans/feedback-form.md`
- 审查：`docs/v0.1.0/review/feedback-form.md`
- 发布：`docs/v0.1.0/release/changelog-entry.md`

## 合并前确认

- [x] review 无 🔴
- [x] 测试 exit 0
- [x] changelog-entry 已生成
- [x] 无冲突
