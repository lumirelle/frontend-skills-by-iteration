# 步骤门禁

每步结束前必须核对本清单，并把结果写入 `docs/vX.Y.Z/progress.md`。

## 全局门禁

- [ ] 已按技能路径解析读取当前步骤 sub-skill `SKILL.md`
- [ ] 输入文档没有 `STALE`、`BLOCKED` 状态
- [ ] 输入文档没有 `DRAFT` 状态；唯一例外见 [orchestrated-invocation.md](orchestrated-invocation.md) → DRAFT 消费例外（fast 步骤 1→2→3 且 `progress.md` → **草稿批次** 为 `open`）
- [ ] 当前步骤门禁结果已记录到 `docs/vX.Y.Z/progress.md`
- [ ] 已按 [progress-convention.md](progress-convention.md) → **每步最小落盘** 完成本步落盘（不得只在聊天汇报）

## 步骤 1 — 需求理解

- [ ] `docs/vX.Y.Z/prd/summarized/` 存在
- [ ] 每个 `origin/*.md` 有同名 `summarized/*.md`
- [ ] 每份 summarized 状态为 `ACTIVE` 或等待用户确认的 `DRAFT`
- [ ] 每份 summarized 含：页面/模块、用户流程、状态与交互、边界情况、非目标、验收标准
- [ ] UI 图已映射到页面/板块，或列出待确认问题
- [ ] 未引入 origin PRD 未提及的功能

## 步骤 2 — 技术方案

- [ ] `docs/vX.Y.Z/design/` 存在且非空
- [ ] 每份 design 对应 summarized PRD（同名或可追溯）
- [ ] 每份 design 状态为 `ACTIVE` 或等待用户确认的 `DRAFT`
- [ ] 含：方案概述、涉及模块/文件、数据流、API/类型变更（含参照与占位策略）、错误处理、兼容性、测试策略、风险与回滚
- [ ] 与 `docs/technical-architecture.md` 无冲突；冲突已标注并待确认

## 步骤 3 — 实施计划

- [ ] `docs/vX.Y.Z/plans/` 存在且非空
- [ ] 每份 plan 状态为 `ACTIVE` 或等待用户确认的 `DRAFT`
- [ ] 每份 plan 对应 design
- [ ] 任务粒度：每个任务可独立完成与验证（约 2–6 个可执行步骤，见 `frontend-plan` → Task Shape）
- [ ] 每项含：目标文件路径、改动说明、测试点
- [ ] 每个行为任务含 RED / GREEN / REFACTOR / VERIFY 步骤
- [ ] 测试矩阵每条验收标准含测试维度与覆盖方式
- [ ] 依赖顺序明确；可并行任务已标注

## 步骤 4 — 代码实现

- [ ] 改动范围 ⊆ plan 范围
- [ ] `progress.md` → **风格锚点** 已填写（步骤 4 首任务前）
- [ ] 每个任务进入 GREEN 前已重读风格锚点与邻文件（见 code-style-enforcement.md）
- [ ] 每个行为改动先观察到失败测试（RED）再写生产代码
- [ ] 每个 task 的 RED / GREEN / REFACTOR / VERIFY 证据已记录到 `progress.md`
- [ ] VERIFY 含 lint/typecheck（若 technical-architecture 已配置）
- [ ] 遵循项目目录与命名约定
- [ ] 无 plan 外大重构
- [ ] 新增/变更 API 与 design 一致；待定处已标 `TODO(vX.Y.Z): 接口联调待定`（见 api-integration-guide.md）

## 步骤 5 — 全量自测

- [ ] `docs/vX.Y.Z/test-report.md` 存在
- [ ] test-report **文首 Status** 为 `ACTIVE` 或等待确认的 `DRAFT`（非 `摘要.结论`）
- [ ] test-report 文首 Status 与 `摘要.结论` 一致（`ACTIVE` ↔ `可进入 review`；`DRAFT`/`BLOCKED` ↔ `阻塞`）
- [ ] test-report 记录关键 TDD 证据（RED/GREEN/REFACTOR），与 `progress.md` 一致
- [ ] `progress.md` Step 5 为 `passed` 时，test-report 文首须为 `ACTIVE`
- [ ] 单元测试覆盖 plan 标注的核心逻辑
- [ ] 集成测试覆盖 API / 模块协作（若适用）；真实后端未联调须在未覆盖风险中说明
- [ ] E2E 覆盖关键用户路径（若适用）
- [ ] test-report 含：执行命令、结果、未覆盖风险
- [ ] 所有相关测试命令 exit 0

## 步骤 6 — 代码审查

- [ ] `docs/vX.Y.Z/review/` 含审查记录
- [ ] review 文档状态为 `ACTIVE` 或等待用户确认的 `DRAFT`
- [ ] 问题分级：🔴 必须修复 / 🟡 建议 / 🟢 可选
- [ ] 已对照风格锚点与 api-integration-guide 检查风格与接口 TODO
- [ ] 无未解决 🔴

## 步骤 7 — 发布

- [ ] `docs/vX.Y.Z/release/changelog-entry.md` 已生成
- [ ] `docs/vX.Y.Z/release/pr-description.md` 含：背景、改动摘要、测试说明、风险
- [ ] 项目级 CHANGELOG / release notes 如需更新，已在用户确认后处理
- [ ] 文档与代码一致
- [ ] 合并前清单完成（见 sub-skill `frontend-release`）
