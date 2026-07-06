---
name: frontend-requirements
description: Use when turning docs/vX.Y.Z/prd/origin/*.md into frontend-focused summarized PRDs for a versioned iteration.
disable-model-invocation: true
---

# Frontend Requirements

## Goal

基于前端视角，将 origin PRD 归纳为可实施、可验收的需求文档。

## Input

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、目标平台、环境、项目约定 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 本迭代原始 PRD，一对一处理 |
| `docs/vX.Y.Z/ui/*` | 否 | 设计稿，任意常见图片格式 |

缺失必需项 → **停止**，报告缺什么，不产出 summarized。

## Output

- 目录：`docs/vX.Y.Z/prd/summarized/`
- 命名：与 `origin/` 同名（如 `origin/user-profile.md` → `summarized/user-profile.md`）
- 模板：[summarized-prd-template.md](references/summarized-prd-template.md)
- 状态：初次产出为 `DRAFT`；用户确认后标记为 `ACTIVE`

## Invocation Contract

- orchestrated / standalone 差异以 `frontend-iteration/references/orchestrated-invocation.md` 为准。
- 本 skill 只处理需求归纳，不执行设计、计划、实现、测试、审查或发布。

## Workflow

1. 读取 `technical-architecture.md`，提取与本次相关的平台、组件库、路由、状态管理等约束。
2. 列出 `origin/*.md` 与 `ui/*`（若有），建立 UI → 页面/板块映射表。
3. 有 UI 稿时，先读 [ui-reading-guide.md](references/ui-reading-guide.md)，按提取维度逐图读图。
4. 逐份 origin PRD 生成 summarized；有 UI 稿的页面必须对照设计稿。
5. 按 Done Checklist 自检。
6. 向用户展示摘要（文件列表、映射表、open questions、自检结果）；确认时机按调用契约处理。

## Rules

1. **忠实 origin**：不得引入 origin 未提及的功能；推断须标注「假设」。
2. **前端聚焦**：写页面结构、交互、状态、数据展示、校验、权限、响应式/平台差异；不写后端实现细节。
3. **可验收**：每条验收标准可测试、可判定通过/失败。
4. **接口依赖可追溯**：数据来自 API 的项在「数据与展示」标来源；origin 写「接口待定」时给默认假设并记入 Open Questions（见 api-integration-guide）。
5. **非目标明确**：origin 模糊时，主动收窄范围并写入「非目标」。
6. **UI 优先**：有设计稿时以稿为准；与 origin 冲突时列入 open questions，不擅自裁决。
7. **架构对齐**：与 `technical-architecture.md` 冲突的需求标注为 open question 或「待确认」。
8. **状态门禁**：通用规则见 `frontend-iteration/references/orchestrated-invocation.md`；有阻塞 open questions 时 summarized 保持 `DRAFT` 或标记 `BLOCKED`。

## UI Mapping

| 文件名模式 | 含义 |
|------------|------|
| `page-name.*` | 整页 |
| `page-name-section.*` | 该页某板块 |
| `page-name-<state>.*` | 该页某状态稿（如 `-empty`、`-error`） |

- 扫描 `ui/` 下所有常见图片格式（png、jpg、jpeg、webp、gif、svg 等）。
- 无法映射的文件 → open questions。
- 无 `ui/` 或为空 → summarized 头部标注「无 UI 稿」，交互细节标为 open questions 或假设。

读图方法（提取维度、多状态稿、确定 vs 不确定、反模式）见 [ui-reading-guide.md](references/ui-reading-guide.md)。

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 仅 origin，无 UI | 标注「无 UI 稿」；布局/视觉写假设或 open questions |
| 部分页面有 UI | 有稿对照写；无稿页面单独标注 |
| 多 origin 文件 | 各生成同名 summarized，不合并 |
| origin 含糊 | 收窄为可行范围，假设与 open questions 分开写 |
| 迭代改需求 | 覆盖对应 summarized，文首标注「更新于」及变更摘要 |
| origin 与 UI 冲突 | open questions 列出差异，交用户确认 |
| origin 更新 | 将对应 summarized 及下游 design / plan / review 标记为 `STALE`，写明原因 |

## Done Checklist

- [ ] 每个 origin 有同名 summarized，且含状态头
- [ ] summarized 覆盖页面/模块、用户流程、状态与交互、边界情况、非目标、验收标准
- [ ] UI 已映射或 open questions 已列出
- [ ] 未引入 origin 外功能
- [ ] 通用门禁与 `progress.md` 落盘已按 `frontend-iteration/references/orchestrated-invocation.md` 完成

## References

- 产出模板：[summarized-prd-template.md](references/summarized-prd-template.md)
- UI 读图指引：[ui-reading-guide.md](references/ui-reading-guide.md)
- 接口联调指引：`frontend-iteration/references/api-integration-guide.md`
