---
name: frontend-requirements
description: Use when summarizing frontend PRD for a versioned iteration (vX.Y.Z). Requires docs/technical-architecture.md and docs/vX.Y.Z/prd/origin/*.md. Produces docs/vX.Y.Z/prd/summarized/*.md. Invoked by frontend-iteration step 1 or directly.
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

## Workflow

1. 读取 `technical-architecture.md`，提取与本次相关的平台、组件库、路由、状态管理等约束。
2. 列出 `origin/*.md` 与 `ui/*`（若有），建立 UI → 页面/板块映射表。
3. 逐份 origin PRD 生成 summarized；有 UI 稿的页面必须对照设计稿。
4. 按 Done Checklist 自检。
5. 向用户展示摘要（文件列表、映射表、open questions、自检结果），等待确认；确认后将对应 summarized 状态更新为 `ACTIVE`。

## Rules

1. **忠实 origin**：不得引入 origin 未提及的功能；推断须标注「假设」。
2. **前端聚焦**：写页面结构、交互、状态、数据展示、校验、权限、响应式/平台差异；不写后端实现细节。
3. **可验收**：每条验收标准可测试、可判定通过/失败。
4. **非目标明确**：origin 模糊时，主动收窄范围并写入「非目标」。
5. **UI 优先**：有设计稿时以稿为准；与 origin 冲突时列入 open questions，不擅自裁决。
6. **架构对齐**：与 `technical-architecture.md` 冲突的需求标注为 open question 或「待确认」。
7. **状态明确**：summarized 作为下游输入前必须是 `ACTIVE`；有阻塞 open questions 时保持 `DRAFT` 或标记 `BLOCKED`。

## UI Mapping

| 文件名模式 | 含义 |
|------------|------|
| `page-name.*` | 整页 |
| `page-name-section.*` | 该页某板块 |

- 扫描 `ui/` 下所有常见图片格式（png、jpg、jpeg、webp、gif、svg 等）。
- 无法映射的文件 → open questions。
- 无 `ui/` 或为空 → summarized 头部标注「无 UI 稿」，交互细节标为 open questions 或假设。

## Common Scenarios

| 场景 | 处理 |
|------|------|
| 仅 origin，无 UI | 标注「无 UI 稿」；布局/视觉写假设或 open questions |
| 部分页面有 UI | 有稿对照写；无稿页面单独标注 |
| origin 一页多模块 | 一份 summarized 内分模块写，不拆文件 |
| 多 origin 文件 | 各生成同名 summarized，不合并 |
| origin 含糊 | 收窄为可行范围，假设与 open questions 分开写 |
| 跨平台（Web + H5） | 在「平台差异」写明各端行为 |
| 含权限/登录态 | 写清各角色可见性与未授权表现 |
| 列表/表单/详情 | 覆盖空态、加载态、错误态、无权限态 |
| 迭代改需求 | 覆盖对应 summarized，文首标注「更新于」及变更摘要 |
| origin 与 UI 冲突 | open questions 列出差异，交用户确认 |
| origin 更新 | 将对应 summarized 及下游 design / plan / review 标记为 `STALE`，写明原因 |

## Done Checklist

- [ ] 每个 origin 有同名 summarized，且含状态头
- [ ] summarized 覆盖页面/模块、用户流程、状态与交互、边界情况、非目标、验收标准
- [ ] UI 已映射或 open questions 已列出
- [ ] 未引入 origin 外功能
- [ ] 完整门禁已按 `frontend-iteration/references/step-gates.md` 记录到 `progress.md`

## References

- 产出模板：[summarized-prd-template.md](references/summarized-prd-template.md)
