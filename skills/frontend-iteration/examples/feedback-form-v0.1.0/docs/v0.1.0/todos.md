# v0.1.0 待确认问题（TODO）

> 状态: ACTIVE
> 版本: v0.1.0
> 来源: test-report.md, review/feedback-form.md
> 更新于: 2026-06-27

## TODO 列表

| 优先级 | 分类 | 问题 | 来源 | 影响 | 下一步 | 状态 |
|--------|------|------|------|------|--------|------|
| P1 | 接口联调 | `POST /api/feedback` 路径待后端确认 | `test-report.md` | 当前仅 mock 验证 | 联调后更新 `src/api/feedback.ts` 并回归 | 待处理 |
| P1 | 接口联调 | `submitFeedback` 入参/返回字段待后端确认 | `test-report.md`、`review/feedback-form.md` | 错误分型与返回解析暂不可细化 | 联调后补充类型和错误分支测试 | 待处理 |

## 备注

- 本清单与代码中的 `TODO(v0.1.0): 接口联调待定` 保持一致
