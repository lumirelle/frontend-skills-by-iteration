# 变更日志条目

> 样例片段；用户确认后可追加根 `CHANGELOG.md`

## v0.1.0 - 2026-06-27

### 新增

- 登录用户反馈表单：类型 + 内容，从「我的」「意见反馈」→ `/feedback`
- `submitFeedback` API 占位；真后端待定（`TODO(v0.1.0): 接口联调待定`）

### 备注

- 后端就绪前 mock 契约 `{ type, content }`；切换点仅在 `src/api/feedback.ts`
