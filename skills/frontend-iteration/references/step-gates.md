# Step Gates

每步结束前的检查清单。编排器在调用 sub-skill 后逐项核对。

## Step 1 — 需求理解

- [ ] `docs/vX.Y.Z/prd/summarized/` 存在
- [ ] 每个 `origin/*.md` 有同名 `summarized/*.md`
- [ ] 每份 summarized 含：页面/模块、用户流程、状态与交互、边界情况、非目标、验收标准
- [ ] UI 图已映射到页面/板块，或列出 open questions
- [ ] 未引入 origin PRD 未提及的功能

## Step 2 — 技术方案

- [ ] `docs/vX.Y.Z/design/` 存在且非空
- [ ] 每份 design 对应 summarized PRD（文件名一致或可追溯）
- [ ] 含：方案概述、涉及模块/文件、数据流、API/类型变更、错误处理、兼容性、测试策略、风险与回滚
- [ ] 与 `docs/technical-architecture.md` 无冲突；冲突已标注并待确认

## Step 3 — 实施计划

- [ ] `docs/vX.Y.Z/plans/` 存在且非空
- [ ] 任务粒度：单步 2–5 分钟可完成
- [ ] 每项含：目标文件路径、改动说明、测试点
- [ ] 测试矩阵每条验收标准含测试维度与覆盖方式
- [ ] 依赖顺序明确；可并行任务已标注

## Step 4 — 代码实现

- [ ] 改动范围 ⊆ plan 范围
- [ ] 遵循项目目录与命名约定
- [ ] 无 plan 外大重构
- [ ] 新增/变更 API 与 design 一致

## Step 5 — 自测

- [ ] 单元测试覆盖 plan 标注的核心逻辑
- [ ] 集成测试覆盖 API / 模块协作（若适用）
- [ ] E2E 覆盖关键用户路径（若适用）
- [ ] `docs/vX.Y.Z/test-report.md` 含：执行命令、结果、未覆盖风险
- [ ] 所有相关测试命令 exit 0

## Step 6 — 代码审查

- [ ] `docs/vX.Y.Z/review/` 含审查记录
- [ ] 问题分级：🔴 必须修复 / 🟡 建议 / 🟢 可选
- [ ] 无未解决 🔴

## Step 7 — 发布

- [ ] CHANGELOG 或等效变更记录已更新
- [ ] PR 描述含：背景、改动摘要、测试说明、风险
- [ ] 文档与代码一致
- [ ] 合并前清单完成（见 sub-skill `frontend-release`）
