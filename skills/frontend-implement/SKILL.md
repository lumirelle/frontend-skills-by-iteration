---
name: frontend-implement
description: Use when implementing approved docs/vX.Y.Z/plans/*.md tasks with frontend TDD.
disable-model-invocation: true
---

# 前端实现

## 目标

按 plan TDD 实现；改动不超出已确认方案。

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、目录、命令、约定 |
| `docs/vX.Y.Z/plans/*.md` | 是 | 任务边界 |
| `docs/vX.Y.Z/design/*.md` | 是 | plan 不清时查 |
| `docs/vX.Y.Z/prd/summarized/*.md` | 是 | 验收、行为边界 |
| `docs/vX.Y.Z/progress.md` | 是 | step/task、TDD 证据、阻塞 |
| 代码库 | 是 | 跟既有模式 |

缺必需项 → **停**；报缺什么；不写代码。

## 输出

- 代码：限 plan 文件边界与任务列文件
- 测试：plan 要求一并提交
- 无额外设计/计划；偏离先回 `frontend-design` 或 `frontend-plan`

## 调用契约

- orchestrated/standalone 见 `frontend-iteration/references/orchestrated-invocation.md`；step 4 保留逐 task VERIFY + 可选 commit 问。
- 只执行 plan；方案/计划缺口 → 停，回上游；不现场补设计。
- 对用户摘要遵守 `agent-communication-style.md`。

## 工作流

1. 读 `technical-architecture.md`、目标 `plans/*.md`；plan `ACTIVE`，待确认问题已关。
2. 读 `progress.md`；定范围：全 plan / 指定 plan·task / resume 首未完成 task。
3. **Style Anchors**：`progress.md` 无表则从 architecture → Code Style 提炼 5–10 条写入；见 `code-style-enforcement.md`。
4. 当前 step/task → `in_progress`。
5. 按序 TDD：RED → **Style Reload** → GREEN → REFACTOR → VERIFY → 问是否提交 → 过再下一 task。
6. 每 task 完：RED/GREEN/REFACTOR/VERIFY、commit 状态写 `progress.md`；问是否提交；确认后 commit；不自动 push。
7. 全 task 完：完成检查 + step gate。
8. 摘要给用户：变更文件、风险、接口 TODO、待 step 5 项；等确认。

## 规则

1. **严守 plan**：只改 plan 列文件；plan 外文件须任务明确要求。
2. **最小改动**：能改现有不新建；能局部不重构；不顺手优化扩范围。
3. **TDD**：行为变更先失败测试、见正确失败；无 RED 不写生产代码。
4. **不重新设计**：plan/design 不足 → **停**；报缺口；回上游；边写边改方案禁止。
5. **跟现有模式**：目录、命名、状态、请求、组件一致；每 task GREEN 前重读 Style Anchors + 邻文件。
6. **测试先行**：见 `frontend-test` → test-writing-guide；RED 失败正确才 GREEN。
7. **单 task 验证**：跑 task「验证」；有 Lint/Typecheck 纳入 VERIFY 记 exit；失败本 task 内修。
8. **一 task 一提交（可选）**：VERIFY 过问提交；拒则记未提交；继续前告知变更混合；不 push。
9. **commit**：仅英文；Conventional Commits（见下）。
10. **落盘**：TDD 证据写 `progress.md`；不只聊天。
11. **接口联调**：见 `api-integration-guide`；封装占位；`TODO(vX.Y.Z): 接口联调待定`；页面不 `fetch`、不写死占位。
12. **状态门禁**：见 `orchestrated-invocation.md`；上游不可用 → 停。

## 提交说明

- 语言：仅英文
- 格式：`<type>(<scope>): <description>` — [Conventional Commits](https://www.conventionalcommits.org/)
- `type`：`feat`/`fix`/`refactor`/`style`/`test`/`docs`/`chore`/`perf`/`build`/`ci`
- `scope`：可选，页面/模块名
- `description`：祈使、小写起、无句号；概括 task 目标
- 不跨 task 混提交

```
feat(user-profile): add avatar upload field
fix(login): handle empty token response
test(user-profile): cover avatar validation rules
```

## 单任务执行

```
读目标与依赖 → 前置 task 已过
    ↓
RED：最小失败测试；确认失败原因
    ↓
Style Reload：progress.md → Style Anchors + 邻文件
    ↓
GREEN：最小实现（API 占位/TODO 见 api-integration-guide）
    ↓
REFACTOR：必要时清理；测试仍过
    ↓
VERIFY：task 验证命令（+ lint/typecheck 若配置）
    ↓
过 → 汇报 → 问提交 → 确认后 commit（可选）
    ↓
下一 task；失败 → 修或停
```

## 常见场景

| 场景 | 处理 |
|------|------|
| 多 plan | 按依赖顺序；共享文件注意冲突 |
| 从 Task N 续 | 读 `progress.md`；Task 1…N-1 已过 VERIFY |
| API 与后端不一致 | 封装标 `TODO(vX.Y.Z): 接口联调待定` + 占位；阻塞 UI → design |
| 上游 STALE | 停；回对应 step |
| 验证命令不存在 | architecture 找等价；仍无 → 停 |
| 需 plan 外文件 | 停；回 plan 补 task |
| 用户暂不提交 | 记未提交；告知后续混合 |
| dead code | 不清理，除非 plan 含 |

## 完成检查

- [ ] 目标 task 全完
- [ ] plan/design/summarized 均 `ACTIVE`
- [ ] 每行为 task RED/GREEN/REFACTOR/VERIFY 已写 `progress.md`
- [ ] Style Anchors 在；每 task 已 Style Reload
- [ ] 改动 ⊆ plan 边界
- [ ] 新 API 有封装占位 + 规范 TODO（若有待定）
- [ ] 无 plan 外重构、无未解释抽象
- [ ] 通用门禁与 `progress.md` 落盘（`orchestrated-invocation.md`）

## 交接下游 → 步骤 5

- 全量测试命令（architecture）
- 每 task RED/GREEN/REFACTOR 摘要
- 未覆盖风险
- `TODO(vX.Y.Z): 接口联调待定` 清单（若有）
