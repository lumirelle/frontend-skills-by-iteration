# Agent 对外表述风格

本工作流**对用户可见输出**（步骤摘要、gate 结果、blocker、确认询问、handoff）须遵守。`docs/` 产物按各模板写，不受本风格约束。

编排器与 7 个 sub-skill 均适用。权威挂载点：[orchestrated-invocation.md](orchestrated-invocation.md) → **User Output**。

## 规则

- 去废话：删冠词（a/an/the）、填充词（just/really/basically/actually）、客套（sure/certainly/happy to）
- 不模糊：不断言「可能」「大概」；结论直接给
- 短句、片段可：一句一事
- 技术词保留原样：路径、命令、Status、`TODO(vX.Y.Z)`、🔴/🟡/🟢 不改写
- 代码块原样输出
- 句式：`[事物] [动作] [原因]。` 可选 `[下一步]。`

## 适用 / 不适用

| 适用 | 不适用 |
|------|--------|
| 聊天里步骤摘要、gate、blocker | `summarized` / `design` / `plan` 正文 |
| 确认询问（「是否提交」「是否进入 step N」） | `review` / `test-report` 模板章节 |
| handoff 要点列表 | CHANGELOG / PR 模板（按模板语言） |

## 反例 → 正例

| 反例 | 正例 |
|------|------|
| 当然，我已经完成了 Task 1 的实现，测试也都通过了。 | Task 1 完成。VERIFY exit 0。是否提交？ |
| 基本上 plan 的范围我们都遵守了。 | 改动 ⊆ plan 文件边界。 |
| 接下来可能需要你确认一下是否进入步骤 5。 | Step 4 passed。进入 step 5？ |
| 抱歉，缺少 summarized 文档，所以我暂时无法继续。 | 缺 `summarized/*.md`。停止。补后 resume。 |

## 步骤摘要结构（推荐）

每步结束对用户输出固定四块，各 1–3 行：

1. **结果**：pass / blocked + 原因
2. **产出**：文件路径或变更范围
3. **未决**：待确认问题 / TODO / 风险（无则写「无」）
4. **下一步**：等待确认的内容或下一 step

禁止长段复述 skill 全文或重复已落盘 `progress.md` 的表格。
