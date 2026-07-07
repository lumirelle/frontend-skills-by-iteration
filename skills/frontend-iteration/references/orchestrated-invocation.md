# 编排调用契约

子 skill 调用契约、编排工作流变体、门禁落盘统一约定；7 个子 skill 引用本文

## 调用契约

| 调用方式 | 编排规则 |
|------|------|
| **orchestrated** | 用户直接调用 `/frontend-iteration` 编排器，由调用模式（`fast` 或 `strict`）决定 |
| **standalone** | 自校验输入；只消费上游 `ACTIVE` 输出；产出 `DRAFT` 后等用户确认转为 `ACTIVE` |

## 编排工作流变体

orchestrated 调用时末步「等用户确认」按下表，其余不变：

| 步骤 | fast | strict |
|------|------|--------|
| 1–3 | 子 skill 内不等确认；`DRAFT`；门禁过即下一步；3 后批量 `ACTIVE` | 每步完等确认 |
| 4–7 | 编排器逐步确认 | 同左 |

**DRAFT 消费例外**：下游可消费 `DRAFT` 当且仅当：

1. `frontend-iteration fast` 链 1→2→3
2. 文件列在 `progress.md` → 草稿批次
3. 批次 `状态` = `open` 且 `确认时间` 为空

进步骤 4 前须展示批次摘要等批量确认；确认后批次内文件转 `ACTIVE`，批次 `confirmed`；standalone、strict、步骤 4–7、无批次、批次 `confirmed`/`abandoned` → 只消费 `ACTIVE`

**遗留 DRAFT**：resume/跳步发现 `DRAFT` 无 `open` 批次 → 展示请用户确认转 `ACTIVE`；不确认则停

## 状态门禁（共享项）

各子 skill 状态门禁共享：

1. 基于 [document-status.md](document-status.md)
2. **standalone**：上游 `ACTIVE`；产出初稿 `DRAFT`，确认后 `ACTIVE`
3. **orchestrated**：`DRAFT` 见编排工作流变体；`STALE`/`BLOCKED` → 停，回上游

## 完成检查（共享项）

各子 skill 完成检查末尾共享：

- [ ] 门禁按 [step-gates.md](step-gates.md) 核对
- [ ] 按 [progress-convention.md](progress-convention.md) → **每步最小落盘** 落盘 `progress.md`（不只聊天报）

## 相关

- 文档状态：[document-status.md](document-status.md)
- 步骤门禁：[step-gates.md](step-gates.md)
- 进度：[progress-convention.md](progress-convention.md)
