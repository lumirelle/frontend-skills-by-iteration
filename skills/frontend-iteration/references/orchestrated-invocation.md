# 编排调用契约

子 skill 调用契约、步骤执行编排、门禁落盘统一约定；7 个子 skill 引用本文

## 调用契约

| 调用方式 | 说明 |
|------|------|
| **orchestrated** | 用户调用 `/frontend-iteration` 编排 skill，编排方式由模式（`fast` 或 `strict`）决定 |
| **standalone** | 用户直接调用子 skill，调用时自校验输入：只消费上游 `ACTIVE` 输出、产出 `DRAFT` 后等用户确认转为 `ACTIVE` |

## orchestrated 调用时的编排方式

每步末尾「等用户确认」时参考下表编排，其余不变：

| 步骤 | fast 模式 | strict 模式 |
|------|------|--------|
| 1–3 | 子 skill 内不等确认，产物状态为 `DRAFT`，门禁过即下一步，下一步允许消费上一步 `DRAFT` 产物。步骤 3 后所有产物汇总，批量确认转 `ACTIVE` | 产物逐步确认 |
| 4–7 | 产物逐步确认 | 同左 |

## 允许 DRAFT 消费的例外

下游步骤可消费 `DRAFT` 输入当且仅当：

1. 用户调用 `frontend-iteration fast`：orchestrated 调用方式，fast 模式
2. 文件列出在 `progress.md` → 草稿批次
3. 批次 `状态` = `open` 且 `确认时间` 为空

进步骤 4 前须展示批次摘要并等待用户批量确认，确认后批次内文件转 `ACTIVE`，本批次转 `confirmed`；

## 状态门禁（共用规则）

各子 skill 状态门禁：

1. 基于状态定义 [document-status.md](document-status.md)
2. **standalone 调用方式**：输入须为 `ACTIVE`，否则停止；产出初稿 `DRAFT`，确认后 `ACTIVE`
3. **orchestrated 调用方式**：输入须为 `ACTIVE` 或 `DRAFT`（见前述“允许 `DRAFT` 消费的例外”），否则停止，回上游返工；产物初稿 `DRAFT`，何时确认参考前述“orchestrated 调用时的编排方式”

## 步骤执行门禁（共用规则）

各步骤子 skill 末尾的执行门禁：

1. 按步骤门禁 [step-gates.md](step-gates.md) 一一核对通过

## 相关

- 文档状态：[document-status.md](document-status.md)
- 步骤门禁：[step-gates.md](step-gates.md)
- 进度：[progress-convention.md](progress-convention.md)
