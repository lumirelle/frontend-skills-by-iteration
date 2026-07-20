# 进度约定

`docs/vX.Y.Z/progress.md` 是迭代步骤恢复的事实源，通过 `/frontend-iteration` 启动或 resume 时先读。此文档缺失可重新创建，明显过期或不完整时，用目录扫描兜底并更新/修复。

## 位置

每个版本一份：

```text
docs/vX.Y.Z/progress.md
```

## 模板

```markdown
# vX.Y.Z 进度

> 状态: ACTIVE
> 版本: vX.Y.Z
> 当前步骤: 1
> 更新于: YYYY-MM-DD

## 步骤状态

| 步骤 | 名称 | 状态 | 门禁结果 | 备注 |
|------|------|------|----------|------|
| 1 | 需求 | pending / in_progress / passed / blocked | 未检查 | |
| 2 | 设计 | pending / in_progress / passed / blocked | 未检查 | |
| 3 | 计划 | pending / in_progress / passed / blocked | 未检查 | |
| 4 | 实现 | pending / in_progress / passed / blocked | 未检查 | |
| 5 | 测试 | pending / in_progress / passed / blocked | 未检查 | |
| 6 | 审查 | pending / in_progress / passed / blocked | 未检查 | |
| 7 | 发布 | pending / in_progress / passed / blocked | 未检查 | |

## 计划任务状态

| 计划 | 任务 | 状态 | RED | GREEN | REFACTOR | VERIFY | 提交 | 备注 |
|------|------|------|-----|-------|----------|--------|------|------|
| plans/<name>.md | 任务 1 | pending / in_progress / passed / blocked | 未执行 | 未执行 | 不需要 | 未执行 | 否 | |

## 风格锚点

步骤 4 开始前从 `docs/technical-architecture.md`“代码风格”小节提炼，每任务进入 GREEN 前重读

细则见 [code-style-enforcement.md](code-style-enforcement.md)

| 序号 | 规则 | 来源 |
|------|------|------|
| 1 | | 技术架构 |

## 草稿批次

| 批次 | 状态 | 创建时间 | 确认时间 | 文件 |
|------|------|----------|----------|------|
| fast-docs-YYYYMMDD-HHMM | none / open / confirmed / abandoned | YYYY-MM-DD HH:MM | — | prd/summarized/<name>.md, design/<name>.md, plans/<name>.md |

## 验证记录

| 日期 | 步骤/任务 | 命令 | 退出码 | 结果 |
|------|-----------|------|--------|------|
| YYYY-MM-DD | 步骤 4 / 任务 1 | `<command>` | 0 / 非零 | 通过 / 失败 |

## 阻塞项

- 无

## 备注

- 无
```

## 状态取值

**执行进度**（步骤状态 / 计划任务状态 表内「状态」列，机器可读，勿改写法，勿与文档状态混淆）：

| 取值 | 含义 |
|------|------|
| `pending` | 尚未开始 |
| `in_progress` | 正在执行 |
| `passed` | 已通过该步骤/任务门禁 |
| `blocked` | 有阻塞项，不得进入下游 |

**草稿批次状态**（仅 fast 步骤 1–3）：

| 取值 | 含义 |
|------|------|
| `none` | 当前没有 fast 编排草稿 |
| `open` | 步骤 1–3 链式产出或等待步骤 3 末批量确认 |
| `confirmed` | 用户已批量确认，文件内文档已转 `ACTIVE` |
| `abandoned` | 用户拒绝或放弃该批；文件内文档不得作下游输入 |

**TDD / 验证列常用取值**（计划任务状态表）：

| 列 | 常用取值 |
|----|----------|
| RED | `未执行` / `已观察` |
| GREEN | `未执行` / `通过` |
| REFACTOR | `不需要` / `已验证` |
| VERIFY | `未执行` / `通过` / `失败` |
| 提交 | `否` / `是` |

**门禁结果列**：`未检查` / `通过` / `失败` 等自然语言；与步骤「状态」列的 `passed` 不同义

## 每步最小落盘

每步结束前**必须**落盘以下字段（3–5 行），不得只在聊天汇报

| 步骤 | 最小更新清单 |
|------|-------------|
| **1** 需求 | ① 当前步骤 → `1` ② 步骤 1 → `in_progress` → 完成则 `passed` ③ 门禁结果写明 summarized 文件与 ACTIVE/DRAFT ④ fast 将 summarized 写入草稿批次（`open`）⑤ 更新于、阻塞项 |
| **2** 设计 | ① 当前步骤 → `2` ② 步骤 2 状态与门禁结果（design 文件列表）③ 步骤 1 保持 `passed` ④ fast 把 design 追加到当前 `open` 批次 ⑤ 更新于、阻塞项 |
| **3** 计划 | ① 当前步骤 → `3` ② 步骤 3 状态与门禁结果（plan 文件列表）③ fast 把 plan 追加到 `open` 批次 ④ 批量确认后：summarized/design/plan 标 `ACTIVE`，草稿批次 → `confirmed` 并填确认时间 ⑤ 更新于、阻塞项 |
| **4** 实现 | ① 当前步骤 → `4` ② 步骤 4 → `in_progress` ③ 若无风格锚点表则先提炼写入 ④ **每任务一行**：计划任务状态填 RED/GREEN/REFACTOR/VERIFY/提交 ⑤ 验证记录追加该任务命令与退出码（含 lint/typecheck 若配置）⑥ 任务全完 → 步骤 4 `passed` |
| **5** 测试 | ① 当前步骤 → `5` ② 步骤 5 状态；失败 → `blocked` ③ 验证记录追加全量命令与退出码 ④ 同步 test-report 文首状态与摘要结论 ⑤ 阻塞项列失败项 |
| **6** 审查 | ① 当前步骤 → `6` ② 步骤 6 状态与门禁结果（结论、🔴 数）③ 有未解决 🔴 → 步骤 6 `blocked` ④ 更新于 ⑤ 阻塞项 |
| **7** 发布 | ① 当前步骤 → `7` ② 步骤 7 状态与门禁结果（release 文件已生成）③ 全部步骤 `passed` 时迭代完成 ④ 更新于 ⑤ 阻塞项清为「无」 |

**恢复执行时**：先读步骤状态、计划任务状态、草稿批次，再读阻塞项；缺行按上表补全后再继续。存在 `open` 草稿批次 → 只能继续 fast 1–3 或停在步骤 3 末批量确认；不得进步骤 4。存在 `DRAFT` 文档但无 `open` 批次 → 遗留 DRAFT：展示请用户确认转 `ACTIVE` 后继续

## 更新规则

1. 每步落盘见 **每步最小落盘**（不得只聊天报）
2. resume 时从第一个 `pending` / `in_progress` / `blocked` 的步骤或任务继续
3. `plans/*.md` 或实现变更需重跑测试：步骤 5 → `pending` 或 `in_progress`；test-report 文首 → `STALE`（写失效原因）
4. fast 1–3 生成或消费 `DRAFT` 时须维护草稿批次；批量确认/拒绝/废弃时标 `confirmed` 或 `abandoned`

## 恢复检测

优先读取 `docs/vX.Y.Z/progress.md`；从第一个 `pending` / `in_progress` / `blocked` 的步骤或任务继续；若存在 `blocked`，先报告阻塞项

`progress.md` 缺失、损坏或与文件系统明显不一致时，按顺序检查产出目录，第一个不满足步骤门禁的步骤即为 resume 起点：

1. `prd/summarized/` 不完整 → 步骤 1
2. `design/` 不完整 → 步骤 2
3. `plans/` 不完整 → 步骤 3
4. 代码未按 plan 完成 → 步骤 4
5. 无 test-report 或测试未过 → 步骤 5
6. `review/` 缺失或有 🔴 → 步骤 6
7. 否则 → 步骤 7

推断完成后，创建或修复 `progress.md`，并向用户说明哪些状态是自动推断的
