# feat(feedback-form): add user feedback form (v0.1.0)

## 背景

为已登录用户提供反馈入口，收集产品改进意见（关联 v0.1.0 需求 `prd/summarized/feedback-form.md`）。当前产品无任何反馈渠道。

## 改动摘要

- 新增反馈表单页面 `/feedback`：反馈类型下拉（默认「功能建议」）+ 必填内容文本域 + 提交。
- 实现提交状态机：校验失败拦截、提交中禁用、成功提示并重置、失败提示并保留输入。
- 「我的」页面新增「意见反馈」入口。
- 新增 `submitFeedback` API 封装（基于 mock 契约 `{ type, content }`）。

| 模块 | 改动 |
|------|------|
| 反馈表单 | 新增页面、校验与提交流程 |
| 我的页面 | 追加反馈入口与路由 |
| API | 新增 `src/api/feedback.ts` |

## 测试说明

| 层级 | 命令 | 结果 |
|------|------|------|
| 单元 | `npm run test:unit` | exit 0 |
| 集成 | `npm run test:integration` | exit 0 |
| E2E | `npm run test:e2e` | exit 0 |

测试报告：`docs/v0.1.0/test-report.md`

## 风险与已知问题

- 🟡 失败提示未区分网络错误与业务错误（接口就绪后细化）。
- 未覆盖风险：真实后端接口尚未联调，集成测试基于 mock；接口就绪后需补一次真实联调。

## 关联文档

- 需求：`docs/v0.1.0/prd/summarized/feedback-form.md`
- 方案：`docs/v0.1.0/design/feedback-form.md`
- 计划：`docs/v0.1.0/plans/feedback-form.md`
- 审查：`docs/v0.1.0/review/feedback-form.md`

## 合并前确认

- [x] review 无未解决 🔴
- [x] 测试通过 / 已记录手动验收
- [x] CHANGELOG 已更新
- [x] 无未解决冲突
