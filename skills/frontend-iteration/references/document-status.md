# Document Status

迭代产物必须标注状态，防止下游消费过期需求、方案或计划。

## Header

所有 `docs/vX.Y.Z/` 下由 workflow 生成的 markdown 产物，在标题下使用统一状态头：

```markdown
> Status: ACTIVE | DRAFT | STALE | BLOCKED
> Version: vX.Y.Z
> Source: <relative/source/path.md>
> Updated: YYYY-MM-DD
> Stale reason: <仅 STALE 时填写>
```

若文档有多个来源，`Source` 可用逗号分隔或写为列表。

## Status Values

| Status | Meaning | Can be consumed downstream |
|--------|---------|----------------------------|
| `DRAFT` | 初稿，等待用户确认 | No |
| `ACTIVE` | 已确认，可作为下游输入 | Yes |
| `STALE` | 上游变更后失效 | No |
| `BLOCKED` | 有未关闭阻塞项 | No |

## Propagation Rules

1. `origin/*.md` 变更后，对应 `prd/summarized/*.md` 及其下游 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`。
2. `summarized/*.md` 变更后，对应 `design/*.md`、`plans/*.md`、`review/*.md` 标为 `STALE`。
3. `design/*.md` 变更后，对应 `plans/*.md`、`review/*.md` 标为 `STALE`。
4. `plans/*.md` 变更后，对应 step 4 进度、`test-report.md`、`review/*.md` 标为 `STALE` 或在 `progress.md` 记录需重跑。
5. 任何 `BLOCKED` 文档都必须先解除阻塞，不能被下游步骤消费。

## Agent Behavior

1. 读取输入文档时先检查 `Status`。
2. 遇到 `DRAFT`、`STALE`、`BLOCKED` 时停止，并向用户说明需要回到哪个上游步骤。
3. 更新文档时同步更新 `Updated` 日期。
4. 标记 `STALE` 时写清 `Stale reason`，例如 `origin PRD updated` 或 `design decision changed`。
5. 不为保持兼容而叠加过期方案；应替换失效文档或回到上游重做。
