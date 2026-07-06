# Test Report Template

复制此结构生成 `docs/vX.Y.Z/test-report.md`。

```markdown
# vX.Y.Z 测试报告

> Status: DRAFT
> Version: vX.Y.Z
> Source: plans/*.md, progress.md
> Updated: YYYY-MM-DD
> Scope: [页面/功能列表]
> Stale reason:

## 摘要

- 单元：通过 / 失败 / 未配置
- 集成：通过 / 失败 / 未配置
- E2E：通过 / 失败 / 未配置 / 手动验收
- 结论：**可进入 review** / **阻塞**

## 执行命令

| 层级 | 命令 | 结果 | 备注 |
|------|------|------|------|
| 单元 | `npm run test:unit` | exit 0 | |
| 集成 | `npm run test:integration` | exit 0 | |
| E2E | `npm run test:e2e` | exit 0 | |

## TDD Evidence

| Task | RED observed | GREEN passed | Refactor verified | 备注 |
|------|--------------|--------------|-------------------|------|
| Task N | yes/no | yes/no | yes/no/not needed | |

## 验收标准覆盖

| 验收标准（来自 summarized） | 覆盖方式 | 对应用例/任务 | 结果 |
|----------------------------|----------|---------------|------|
| | 单元 / 集成 / E2E / 手动 | | 通过 |

## 测试缺口

| 缺口 | 影响 | 处理 |
|------|------|------|
| | | 回到 `frontend-implement` 用 TDD 补 |

（无则写「无」）

## 手动验收

| 项 | 步骤 | 结果 |
|----|------|------|
| | | 通过 |

（无则写「无」）

## 未覆盖风险

- …

（无则写「无」）

## 接口联调（若适用）

| 项 | 状态 | 代码位置 / TODO |
|----|------|-----------------|
| 真实后端联调 | 未做 / 已完成 | `TODO(vX.Y.Z): 接口联调待定` 清单或 — |

（无 API 依赖则写「无」）

## 阻塞项

- …

（无则写「无」）
```

## 填写要点

| 章节 | 要求 |
|------|------|
| 文首 `Status` | **文档生命周期**（`DRAFT`/`ACTIVE`/`STALE`/`BLOCKED`），非执行进度；下游 review 仅消费 `ACTIVE` |
| `摘要.结论` | 报告内容：`可进入 review` / `阻塞`；与文首 `Status` 须一致（见 document-status「test-report 专约」） |
| `阻塞项` | 非空时文首 `Status` 为 `BLOCKED` 或 `DRAFT`，且 `结论` 为 `阻塞` |
| 执行命令 | 写实际运行的完整命令；同步写入 `progress.md` Verification Log |
| TDD Evidence | 引用 `progress.md` 记录，不替代落盘 |
| 验收标准覆盖 | 每条 summarized 验收标准至少一行 |
| 未覆盖风险 | 诚实列出；含真实后端未联调与 TODO 清单；有阻塞项则结论为「阻塞」 |
