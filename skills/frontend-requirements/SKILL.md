---
name: frontend-requirements
description: Use when turning docs/vX.Y.Z/prd/origin/*.md into frontend-focused summarized PRDs for a versioned iteration.
disable-model-invocation: true
---

# 前端需求

## 目标

读 origin PRD，以前端视角总结成可实施、可验收的 summarized PRD

## 输入

| 路径 | 必需 | 说明 |
|------|------|------|
| `docs/technical-architecture.md` | 是 | 技术栈、平台、约定 |
| `docs/vX.Y.Z/prd/origin/*.md` | 是 | 原始 PRD，一对一 |
| `docs/vX.Y.Z/ui/*` | 否 | 设计稿 |

缺必需项则**停止**

## 输出

- `docs/vX.Y.Z/prd/summarized/`，与 `origin/` 同名
- 模板：[summarized-prd-template.md](references/summarized-prd-template.md)
- 初稿 `DRAFT`，确认后转 `ACTIVE`

## 调用契约与要求

- 调用契约见 `frontend-iteration/references/orchestrated-invocation.md`
- Agent 沟通风格见 `frontend-iteration/references/agent-communication-style.md`
- 只做需求归纳，不做其它事情

## 工作流

1. 读 `docs/technical-architecture.md`：平台、组件库、路由、状态等约束
2. 列 `origin/*.md`、`ui/*`；建 UI → 页面/板块映射
3. 有 UI：读 [ui-reading-guide.md](references/ui-reading-guide.md)；逐图
4. 逐份 origin → summarized；有 UI 页须对照稿
5. 完成检查
6. 摘要：文件、映射、待确认问题、自检；确认按契约

## 规则

1. **忠实 origin**：不加 origin 外功能；推断标「假设」
2. **前端聚焦**：页面、交互、状态、展示、校验、权限、响应式；不写后端实现
3. **可验收**：每条验收可测、可判过/败
4. **接口可追溯**：API 数据在「数据与展示」标来源；origin「接口待定」→ 默认假设 + 待确认问题（见 `frontend-iteration/references/api-integration-guide.md`）
5. **非目标明确**：origin 模糊 → 收窄 +「非目标」
6. **UI 优先**：有稿以稿为准；与 origin 冲突 → 待确认问题
7. **架构对齐**：与 `docs/technical-architecture.md` 冲突 → 待确认问题
8. **状态门禁**：见 `frontend-iteration/references/orchestrated-invocation.md`；阻塞待确认问题 → `DRAFT`/`BLOCKED`

## UI 映射

| 文件名 | 含义 |
|--------|------|
| `page-name.*` | 整页 |
| `page-name-section.*` | 板块 |
| `page-name-<state>.*` | 状态稿（`-empty`、`-error` 等） |

- 扫 `ui/` 常见图格式（png/jpg/jpeg/webp/gif/svg…）
- 无法映射 → 待确认问题
- 无 `ui/` → 头标「无 UI 稿」；交互细节 → 待确认问题或假设

读图细节见 [ui-reading-guide.md](references/ui-reading-guide.md)

## 常见场景

| 场景 | 处理 |
|------|------|
| 仅 origin | 标「无 UI 稿」；布局/视觉 → 假设或待确认问题 |
| 部分有 UI | 有稿对照；无稿单独标 |
| 多 origin | 各同名 summarized；不合并 |
| origin 含糊 | 收窄；假设与待确认问题分开 |
| 改需求 | 覆盖 summarized；头标更新与摘要 |
| origin 与 UI 冲突 | 待确认问题列差异；用户确认 |
| origin 更新 | summarized 及下游 `STALE`；写原因 |

## 完成检查

- [ ] 每 origin 有同名 summarized + 状态头
- [ ] 覆盖页面、流程、交互、边界、非目标、验收
- [ ] UI 已映射或待确认问题已列
- [ ] 无 origin 外功能
- [ ] 门禁按 `frontend-iteration/references/step-gates.md` 核对
- [ ] 按 `frontend-iteration/references/progress-convention.md` “每步最小落盘” 小节落盘 `progress.md`

## 文件路径解析

读 skill / reference 时按序尝试（命中即用）：

| 资源 | 路径 1（`npx skills add`） | 路径 2（源码） |
|------|------------------------------|----------------|
| 本子 `SKILL.md` 目录 | `.agents/skills/frontend-requirements/` | `skills/frontend-requirements/` |
| 编排 references | `.agents/skills/frontend-iteration/references/<file>` | `skills/frontend-iteration/references/<file>` |
| 其他 references | `.agents/skills/<name>/references/<file>` | `skills/<name>/references/<file>` |
| 样例 | `.agents/skills/frontend-iteration/examples/` | `skills/frontend-iteration/examples/` |

## 参考

- 产物模板：[summarized-prd-template.md](references/summarized-prd-template.md)
- UI 读取指南：[ui-reading-guide.md](references/ui-reading-guide.md)
- 接口联调指南：`frontend-iteration/references/api-integration-guide.md`
