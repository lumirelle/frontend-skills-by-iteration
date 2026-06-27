---
name: frontend-project-init
description: Optional alias for frontend-iteration Bootstrap only — use when you need docs/ scaffolding without starting an iteration. Prefer /frontend-iteration which auto-bootstraps.
disable-model-invocation: true
---

# Frontend Project Init

## Status

**降级为可选别名**。正常路径：直接 `/frontend-iteration vX.Y.Z`——编排器 **On Start → Bootstrap** 会自动创建缺失的 `docs/` 结构与 `progress.md`。

仅当用户**明确要求只初始化目录、不进入任何迭代步骤**时，才单独调用本 skill。

## Goal

执行与 `frontend-iteration` Bootstrap 相同的脚手架创建，然后停止。

## Input

| 输入 | 必需 | 说明 |
|------|------|------|
| 版本号 `vX.Y.Z` | 是 | 要初始化的迭代版本 |
| `frontend-iteration` skill 根目录 | 是 | 读取内置模板（Skill Path Resolution） |

## Output

与 `frontend-iteration` On Start Bootstrap 相同：

- `docs/technical-architecture.md`（若缺失，从模板复制）
- `docs/vX.Y.Z/`（若缺失，从版本模板复制；`progress.md` 内版本号已替换）
- `docs/vX.Y.Z/prd/origin/`、`docs/vX.Y.Z/ui/` 目录就绪

## Workflow

1. 按 `frontend-iteration` → **Skill Path Resolution** 定位编排器根目录。
2. 执行 `frontend-iteration` → **On Start** 第 2 步 **Bootstrap**（相同逻辑：不覆盖已有文件）。
3. 若 `technical-architecture.md` 仍为占位，停止并提示用户补齐项目事实。
4. 汇报创建/保留的文件；提示用户放入 `prd/origin/*.md` 后调用 `/frontend-iteration vX.Y.Z`。

## Rules

1. **不重复 Bootstrap**：`frontend-iteration` 已含相同逻辑；禁止在本 skill 再写一套模板路径或复制规则。
2. **不覆盖用户文件**、**不编造项目事实**、**不进入迭代步骤**——与编排器 Bootstrap 一致。
3. **默认不用本 skill**：有 origin PRD 时直接 `/frontend-iteration`。

## Done Checklist

- [ ] Bootstrap 产物与 `frontend-iteration` On Start 一致
- [ ] 已提示下一步：`补齐 technical-architecture` → 放入 origin PRD → `/frontend-iteration vX.Y.Z`

## References

- 主路径：[frontend-iteration/SKILL.md](../frontend-iteration/SKILL.md) → On Start → Bootstrap
- 进度约定：`frontend-iteration/references/progress-convention.md`
