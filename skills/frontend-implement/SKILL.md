---
name: frontend-implement
description: Use when implementing frontend code for a versioned iteration (vX.Y.Z) according to approved plans. Requires docs/technical-architecture.md and docs/vX.Y.Z/plans/*.md. Produces code changes within plan boundaries. Invoked by frontend-iteration step 4 or directly.
disable-model-invocation: true
---

# Frontend Implement

## Goal

严格按 plan 以 TDD 执行前端代码实现，改动范围不超出已确认方案。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、目录、构建/测试命令、代码约定 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 实施计划与任务边界 |
| `docs/vX.Y.Z/design/*.md` | 是 | 方案细节，plan 不清时查阅 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收标准，行为边界 |
| `docs/vX.Y.Z/progress.md` | 是 | 当前 step / task 状态、TDD 证据与阻塞项 |
| 现有代码库 | 是 | 遵循既有模式与风格 |

缺失必需项 → **停止**，报告缺什么，不写代码。

## Output

- 代码变更：仅限 plan「文件边界」与任务列出的文件
- 测试代码：plan 要求的部分一并提交
- 无额外设计/计划文档；偏离须先回到 `frontend-design` 或 `frontend-plan`

## Invocation Contract

- 由 `frontend-iteration` 调用：遵循编排器的 step 4 流程、progress 更新、per-task 验证与可选 commit 询问。
- 直接调用：自行校验输入；仅消费 `ACTIVE` plan / design / summarized，并从 `progress.md` 或用户指定 task 确定范围。
- 本 skill 只执行 plan 内实现；发现方案或计划缺口时停止并回上游，不现场补设计。

## Workflow

1. 读取 `technical-architecture.md` 与目标 `plans/*.md`，确认无未关闭 open questions。
2. 读取 `progress.md`，确定执行范围：全部 plan、用户指定 plan / task，或 resume 的首个未完成 task。
3. 将当前 step / task 标为 `in_progress`。
4. **按任务顺序执行 TDD**：RED → GREEN → REFACTOR → VERIFY → 询问是否提交 → 通过后再下一任务。
5. 每完成一个 task：把 RED/GREEN/REFACTOR/VERIFY 证据与 commit 状态写入 `progress.md`，汇报结果，**询问用户是否提交**；用户确认后再 commit，不自动 push。
6. 全部 task 完成后按 Done Checklist 与 `frontend-iteration` 的 step gate 自检。
7. 向用户展示摘要（变更文件、未覆盖风险、待步骤 5 验证项），等待确认。

## Rules

1. **严守 plan**：只改 plan 列出的文件；不新增 plan 外文件，除非任务明确要求。
2. **最小改动**：能改现有实现就不新建；能局部改就不重构；不为「顺手优化」扩 scope。
3. **TDD 铁律**：行为变更必须先写失败测试并观察到正确失败；没有 RED 不写生产代码。
4. **不重新设计**：实现中发现 plan/design 不足 → **停止**，说明缺口，回上游修正，不边写边改方案。
5. **遵循现有模式**：目录、命名、状态管理、请求封装、组件风格与项目一致。
6. **测试先行**：写测试参考 `frontend-test` 的 test-writing-guide；确认 RED 正确失败后才进入 GREEN。
7. **单任务验证**：每个 task 完成后执行其「验证」项；失败则在本 task 内修复，不带着失败进入下一 task。
8. **一任务一提交（可选）**：验证通过后询问用户是否提交；用户同意则 commit 当前 task 改动，message 对应 task 目标；用户拒绝则保持工作区变更，继续下一 task 前须知晓未提交状态。不自动 push。
9. **提交 message 规范**：仅英文，遵循 Conventional Commits（见 Commit Message）。
10. **进度落盘**：不得只在聊天中记录 TDD 证据；`progress.md` 是 resume 与 step 5 的输入。
11. **状态门禁**：遵循 `frontend-iteration/references/document-status.md`；plan / design / summarized 不可用时停止并回上游。

## Commit Message

- 语言：**仅英文**
- 格式：[Conventional Commits](https://www.conventionalcommits.org/) — `<type>(<scope>): <description>`
- `type`：`feat` / `fix` / `refactor` / `style` / `test` / `docs` / `chore` / `perf` / `build` / `ci`
- `scope`：可选，用页面/模块名（如 `user-profile`）
- `description`：祈使语气、小写开头、不加句号；概括该 task 目标
- 跨 task 不混提交；body / footer 按需，保持简洁

示例：

```
feat(user-profile): add avatar upload field
fix(login): handle empty token response
test(user-profile): cover avatar validation rules
```

## Per-Task Execution

对每个 task：

```
读目标与依赖 → 确认前置 task 已完成
    ↓
RED：写最小失败测试并运行，确认失败原因正确
    ↓
GREEN：写最小生产代码让测试通过
    ↓
REFACTOR：必要时清理，保持测试通过
    ↓
VERIFY：运行 task 验证命令
    ↓
通过 → 汇报 → 询问是否提交 → 用户确认后 commit（可选）
    ↓
进入下一 task；失败 → 修复或停止并说明
```

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 多份 plan | 按 plan 依赖与执行顺序逐个完成；共享文件注意合并冲突 |
| 从 Task N 续做 | 优先读取 `progress.md`；确认 Task 1…N-1 已完成且验证通过 |
| API 用 mock | 仅按 design/plan 约定接入 mock，不擅自改契约 |
| 类型/API 与后端不一致 | 停止，回 design 或列 open question |
| plan / design / summarized 为 STALE | 停止，回对应上游步骤更新 |
| 验证命令不存在 | 从 technical-architecture 查找等价命令；仍无则停止 |
| 实现需新增 plan 外文件 | 停止，回 plan 补充任务后再做 |
| 测试失败 | 在当前 task 内修，不跳过 |
| 用户暂不提交 | 记录未提交状态，继续前告知后续 task 将与当前变更混合 |
| 发现 dead code 想清理 | 不清理，除非 plan 明确包含 |
| 样式/交互与 UI 稿偏差 | 以 summarized + design 为准；稿有则对照 ui/ |

## Done Checklist

- [ ] 所有目标 task 已完成
- [ ] 输入 plan / design / summarized 状态均为 `ACTIVE`
- [ ] 每个行为 task 的 RED / GREEN / REFACTOR / VERIFY 已执行并写入 `progress.md`
- [ ] 改动范围 ⊆ plan 文件边界
- [ ] 无 plan 外重构、无未解释的新抽象
- [ ] 完整门禁已按编排器 step-gates 记录到 `progress.md`（路径见 `frontend-iteration` → Skill Path Resolution）

## Handoff to Step 5

实现完成后交给 `frontend-test`：

- 全量测试命令（来自 technical-architecture）
- 每个 task 的 RED/GREEN/REFACTOR 证据摘要
- 已知未覆盖风险
