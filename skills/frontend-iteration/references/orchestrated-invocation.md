# 编排调用契约

sub-skill 调用契约、Workflow 变体、门禁落盘、**User Output** 统一约定。7 个 sub-skill 引用本文。

路径：`frontend-iteration/references/orchestrated-invocation.md`（技能路径解析）。

## 用户输出（对用户可见）

汇报（摘要、gate、blocker、确认问、handoff）遵守 [agent-communication-style.md](agent-communication-style.md)：

- 去废话、不客套、不模糊
- 技术词、代码块原样
- 句式：`[事物] [动作] [原因]。` + 可选 `[下一步]。`
- `docs/` 产物按模板，不受此约束

## 调用契约（通用）

| 调用 | 规则 |
|------|------|
| **orchestrated**（`frontend-iteration`） | 跟 fast/strict、`progress.md` 确认规则。**fast 1–3**：sub-skill 内不单步等确认；产出 `DRAFT` 记入草稿批次；step 3 末批量确认。**4–7**：编排器逐步确认（implement 仍逐 task VERIFY + 可选 commit 问）。`DRAFT` 消费见 Workflow 变体 |
| **standalone** | 自校验输入；只消费 `ACTIVE` 上游；产出 `DRAFT` 后等用户确认再 `ACTIVE` |

各 sub-skill 调用契约只补一句职责边界（做什么、不做什么）。

## 工作流变体（orchestrated）

编排器调用时，Workflow 末步「等用户确认」按下表；其余不变。

| 步骤 | fast | strict |
|------|------|--------|
| 1–3 | sub-skill 内不等确认；`DRAFT`；门禁过即下一步；3 后批量 `ACTIVE` | 每步完等确认 |
| 4–7 | 编排器逐步确认（implement：逐 task + 可选 commit） | 同左 |

**DRAFT 消费例外（唯一权威）**：下游可消费 `DRAFT` 当且仅当：

1. `frontend-iteration fast` 链 1→2→3
2. 文件列在 `progress.md` → **草稿批次**
3. batch `Status` = `open` 且 `Confirmed at` 空

进 step 4 前须展示 batch 摘要等批量确认；确认后 batch 内文件 `ACTIVE`，batch `confirmed`。standalone、strict、4–7、无 batch、batch `confirmed`/`abandoned` → 只消费 `ACTIVE`。

**遗留 DRAFT**：resume/跳步见 `DRAFT` 无 `open` batch → 展示请用户确认转 `ACTIVE`；不确认则停。

> 只读单 sub-skill：Workflow 写「等确认 / 只消费 ACTIVE」是 **standalone 默认**。编排器调用以本表为准——fast 1–3 不因上游 `DRAFT` 或本步未单步确认而停；4–7 须在编排器层面确认后再推。

## 状态门禁（通用）

读写 workflow 产物前：

1. 跟 [document-status.md](document-status.md)
2. **standalone**：上游 `ACTIVE`；产出初稿 `DRAFT`，确认后 `ACTIVE`
3. **orchestrated**：`DRAFT` 见 Workflow 变体；`STALE`/`BLOCKED` → 停，回上游

sub-skill Rules「状态门禁」只补本 step 特异条件。

## 完成检查（通用项）

各 sub-skill 完成检查末尾共享一项：

- [ ] 门禁按 [step-gates.md](step-gates.md) 核对；[progress-convention.md](progress-convention.md) → **每步最小落盘** 落盘 `progress.md`（不只聊天报）

## 相关

- 用户输出：[agent-communication-style.md](agent-communication-style.md)
- 文档状态：[document-status.md](document-status.md)
- 步骤门禁：[step-gates.md](step-gates.md)
- 进度：[progress-convention.md](progress-convention.md)
