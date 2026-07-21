# 代码风格约束

## 风格锚点

步骤 4 前从 `docs/technical-architecture.md` 提炼可执行规则，写入 `docs/vX.Y.Z/progress.md` “风格锚点”小节

例如：

| # | 规则 | 来源 |
|---|------|------|
| 1 | API 仅 `src/api/`，页面不 `fetch` | 目录约定 |
| 2 | 测试与源码同目录 `*.test.ts` | 测试 |
| 3 | 表单控件有可访问标签 | 项目约定 |

- 规则须可执行，禁止模糊表述
- `docs/technical-architecture.md` 改动需要同步 `progress.md` “风格锚点”小节

## 每任务风格重载

每任务进 GREEN 前：

1. 重读 `docs/vX.Y.Z/progress.md` “风格锚点”小节
2. 本任务将改文件 + 同目录邻文件 1–2 个（或 plan 指定参照），对齐命名、导入、结构、错误处理
3. GREEN 后、VERIFY 前：有 Lint/Typecheck 则跑，记 exit code

REFACTOR 不得偏离锚点或邻文件风格

## 每步重载

| 步骤 | 时机 |
|------|------|
| 2 设计 | 写涉及文件前重读目录约定 + 锚点 |
| 3 计划 | 写路径/任务前重读锚点 |
| 4 实现 | 见前述“每任务风格重载” |
| 5 测试 | 跑测/验证前重读测试约定 + 锚点 |
| 6 审查 | 审 diff 前重读锚点 + 抽查邻域 |

## 违规处理

| 违规 | 步骤 4 | 步骤 6 |
|------|--------|--------|
| 目录/命名不符 `docs/technical-architecture.md` | 本 task 修 | 🔴 |
| 与邻文件风格差大 | REFACTOR 修 | 🟡/🔴 |
| 未跑 lint/typecheck（已配置） | VERIFY 补跑 | 🟡 |
| 锚点缺/过期 | 先更新再继续 | 待确认问题 |
| ... | ... | ... |
