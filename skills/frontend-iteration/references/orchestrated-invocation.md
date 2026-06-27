# Orchestrated Invocation

本文件统一规定 sub-skill 在**两种调用方式**下的契约、Workflow 变体与门禁落盘要求，供 7 个 sub-skill 引用，避免各自重复同一段落。

按 `frontend-iteration` → **Skill Path Resolution** 定位本文件（`frontend-iteration/references/orchestrated-invocation.md`）。

## Invocation Contract（通用）

| 调用方式 | 规则 |
|----------|------|
| **由 `frontend-iteration` 调用**（orchestrated） | 遵循编排器的 fast / strict 模式、`progress.md` 更新与确认规则。**fast 步骤 1–3**：不在 sub-skill 内单步等待确认，产出保持 `DRAFT` 并记录到 `progress.md` → `Draft Batch`，直至步骤 3 末批量确认。**步骤 4–7**：由编排器逐步确认（implement 仍逐 task 验证 + 可选 commit 询问）。`DRAFT` 消费范围见 **Workflow 变体** |
| **直接调用**（standalone） | 自行校验输入；仅消费 `ACTIVE` 上游文档；产出 `DRAFT` 后等待用户确认，再改为 `ACTIVE` |

各 sub-skill 仅需在自身 Invocation Contract 补「本 skill 的职责边界」一句（处理什么、不处理什么）。

## Workflow 变体（orchestrated）

由 `frontend-iteration` 调用时，sub-skill 的 Workflow **末步「等待用户确认」按下表调整**，其余步骤不变。

| 步骤 | fast 模式 | strict 模式 |
|------|-----------|-------------|
| 1 requirements / 2 design / 3 plan | **不在 sub-skill 内单步等待确认**；产出保持 `DRAFT`，门禁通过即由编排器自动进入下一步；步骤 3 后由编排器**批量确认**并统一标 `ACTIVE` | 每步完成后由编排器等待确认 |
| 4 implement / 5 test / 6 review / 7 release | 按编排器**逐步确认**（implement 仍逐 task 验证 + 可选 commit 询问） | 同左 |

**DRAFT 消费例外（唯一权威定义）**：仅当以下条件同时满足时，下游 sub-skill 可消费 `DRAFT`：

1. 调用来自 `frontend-iteration fast` 步骤 1→2→3 链式执行。
2. 该 `DRAFT` 文件列在 `docs/vX.Y.Z/progress.md` → `Draft Batch` 中。
3. 对应 batch 的 `Status` 为 `open`，且 `Confirmed at` 为空。

进入步骤 4 前，编排器必须展示 batch 摘要并等待用户批量确认；确认后将 batch 内文件统一标为 `ACTIVE`，把 batch 标为 `confirmed`。直接调用、strict 模式、步骤 4–7、无 batch 记录、或 batch 为 `confirmed` / `abandoned` 时，一律只消费 `ACTIVE`。本仓库其他位置出现的「编排草稿例外」均以本段为准。

**遗留 DRAFT 处理**：resume 或跳步时若读到 `DRAFT` 但没有 `open` batch 记录，按 `frontend-iteration` → Orchestration Rules Rule 1「遗留 DRAFT 转正」处理：先展示并请用户确认，转 `ACTIVE` 后再继续；不确认则停止。

> **只读单个 sub-skill 时注意**：sub-skill Workflow 写的「等待确认 / 仅消费 ACTIVE」是 **standalone 默认**。由编排器调用时以本表为准——**fast 步骤 1–3** 不要因为上游是编排草稿 `DRAFT`、或本步未单步确认而停止；**步骤 4–7** 仍须在编排器层面逐步确认后再推进。

## 状态门禁（通用）

读取或写入任何 workflow 产物前：

1. 遵循 [document-status.md](document-status.md)（Agent Decision Table、Propagation Rules、各产物专约）。
2. **standalone**：上游输入须为 `ACTIVE`；产出初稿为 `DRAFT`，用户确认后改为 `ACTIVE`。
3. **orchestrated**：`DRAFT` 消费与确认时机见上文 **Workflow 变体** 与 **DRAFT 消费例外**；`STALE` / `BLOCKED` 一律停止并回上游。

各 sub-skill Rules 的「状态门禁」仅补充**本 step 特异条件**；通用部分不再重复。

## Done Checklist（通用项）

每个 sub-skill 的 Done Checklist 末尾共享以下一项，不再各自展开：

- [ ] 完整门禁已按 `frontend-iteration` → [step-gates.md](step-gates.md) 核对，并按 [progress-convention.md](progress-convention.md) → **Per-Step Minimal Update** 落盘到 `docs/vX.Y.Z/progress.md`（不得只在聊天汇报）

## 相关

- 文档状态体系：[document-status.md](document-status.md)
- 步骤门禁：[step-gates.md](step-gates.md)
- 进度落盘：[progress-convention.md](progress-convention.md)
