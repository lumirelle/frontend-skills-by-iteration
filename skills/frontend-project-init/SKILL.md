---
name: frontend-project-init
description: Use when a project lacks docs/technical-architecture.md or docs/vX.Y.Z/ before running frontend-iteration.
disable-model-invocation: true
---

# Frontend Project Init

## Goal

创建最小 `docs/` 脚手架，并提示用户补齐项目事实。

## Input

| 输入 | 必需 | 说明 |
|------|------|------|
| 版本号 `vX.Y.Z` | 是 | 要初始化的迭代版本 |
| `frontend-iteration` skill 根目录 | 是 | 用于读取内置模板 |

## Output

- `docs/technical-architecture.md`：从 `frontend-iteration/templates/docs/technical-architecture.md` 创建（若缺失）
- `docs/vX.Y.Z/`：从 `frontend-iteration/templates/docs/version/` 创建（若缺失）
- `docs/vX.Y.Z/prd/origin/`：用户放置原始 PRD 的目录
- `docs/vX.Y.Z/ui/`：用户放置设计稿的可选目录

## Invocation Contract

- 直接调用：初始化指定版本的 `docs/` 脚手架，然后停止，等待用户补齐项目事实与 origin PRD。
- 由 `frontend-iteration` 提示调用：只负责补齐缺失结构，不进入需求、设计或实现步骤。
- 本 skill 不覆盖已有文件、不生成业务需求、不运行测试。

## Workflow

1. 按 `frontend-iteration` 的 Skill Path Resolution 定位 `frontend-iteration` 根目录。
2. 校验版本号格式为 `vX.Y.Z`。
3. 若缺 `docs/technical-architecture.md`，从模板复制；若已存在，不覆盖。
4. 若缺 `docs/vX.Y.Z/` 或 `progress.md`，从版本模板复制，并把模板中的 `vX.Y.Z` 替换为实际版本号。
5. 确保 `docs/vX.Y.Z/prd/origin/` 与 `docs/vX.Y.Z/ui/` 存在。
6. 检查 `technical-architecture.md` 是否仍含明显占位（如空字段或 `` `...` ``）；若有，停止并提示用户补齐项目事实。
7. 汇报创建/保留的文件与用户下一步需要放入的 PRD / UI 稿。

## Rules

1. **不覆盖用户文件**：已有文件只读检查，不重写。
2. **不编造项目事实**：技术栈、命令、目录、测试框架必须由项目事实或用户提供；未知项保持待补齐。
3. **不进入迭代流程**：本 skill 只初始化目录；PRD 就绪后再调用 `frontend-iteration`。
4. **路径兼容**：模板路径遵循 `frontend-iteration` 的 Skill Path Resolution，兼容 `.agents/skills/` 与 `skills/`。

## Done Checklist

- [ ] `docs/technical-architecture.md` 存在
- [ ] `docs/vX.Y.Z/progress.md` 存在且版本号已替换
- [ ] `docs/vX.Y.Z/prd/origin/` 存在
- [ ] `docs/vX.Y.Z/ui/` 存在
- [ ] 已提示用户补齐 technical architecture 与 origin PRD
