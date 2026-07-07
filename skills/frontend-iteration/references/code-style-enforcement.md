# 代码风格约束

长会话易忘代码风格。用 **风格锚点 + 重复重读** 对抗上下文丢失。适用步骤 2–7（读/写/审代码）

权威：`docs/technical-architecture.md` → **代码风格**、**目录约定**。本文管「怎么反复加载」，不替代项目事实

## 风格锚点

步骤 4 前从 `docs/technical-architecture.md` 提炼 **5–10 条**可执行规则，写入 `progress.md` → **风格锚点**

例如：

| # | 规则 | 来源 |
|---|------|------|
| 1 | API 仅 `src/api/`，页面不 `fetch` | 目录约定 |
| 2 | 测试与源码同目录 `*.test.ts` | 测试 |
| 3 | 表单控件有可访问标签 | 项目约定 |

规则须可执行，禁止模糊表述

每 task 完、步骤 6 审前 **重读锚点**（不凭记忆）；`docs/technical-architecture.md` 变则同步 `progress.md` → **风格锚点**

## 每任务风格重载

每 task 进 GREEN 前：

1. 重读 `progress.md` → 风格锚点
2. 开本 task 将改文件 + 同目录邻文件 1–2 个（或 plan 指定参照），对齐命名、导入、结构、错误处理
3. GREEN 后、VERIFY 前：有 Lint/Typecheck 则跑，记 exit code

REFACTOR 不得偏离锚点或邻文件风格

## 每步重载

| 步骤 | 时机 |
|------|------|
| 2 设计 | 写涉及文件前重读目录约定 + 代码风格 |
| 3 计划 | 写路径/task 前重读锚点或 `docs/technical-architecture.md` |
| 4 实现 | 每 task 见上 |
| 5 测试 | 补测前重读测试约定 + 锚点 |
| 6 审查 | 审 diff 前重读锚点 + 抽查邻域 |

## 违规处理

| 违规 | 步骤 4 | 步骤 6 |
|------|--------|--------|
| 目录/命名不符 `docs/technical-architecture.md` | 本 task 修 | 🔴 |
| 与邻文件风格差大 | REFACTOR 修 | 🟡/🔴 |
| 未跑 lint/typecheck（已配置） | VERIFY 补跑 | 🟡 |
| 锚点缺/过期 | 先更新再继续 | 待确认问题 |

## progress.md

锚点为 resume 最快风格入口

步骤 4 首步确保表存在，后续 task 读表 + 邻文件即可（`docs/technical-architecture.md` 变除外）
