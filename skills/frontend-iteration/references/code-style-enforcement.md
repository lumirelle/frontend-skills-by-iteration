# Code Style Enforcement

长会话中 Agent 容易「开头遵守、后面遗忘」代码风格。本约定通过**重复注入锚点**对抗上下文丢失，适用于步骤 2–7（凡涉及读/写代码或审查代码）。

权威来源：`docs/technical-architecture.md` → **Code Style** 与 **Directory Conventions**。本文定义如何**反复加载**这些约定，而非替代项目事实。

## Style Anchors（风格锚点）

步骤 4 开始前，从 `technical-architecture.md` 提炼 **5–10 条**与本迭代相关的可执行规则，写入 `docs/vX.Y.Z/progress.md` → **Style Anchors** 表。示例：

| # | 规则 | 来源 |
|---|------|------|
| 1 | API 封装放 `src/api/`，页面不直接 `fetch` | technical-architecture → Directory |
| 2 | 组件测试与被测文件同目录 `*.test.ts` | technical-architecture → Testing |
| 3 | 表单控件须有可访问标签 | technical-architecture → Project Conventions |

规则须**具体、可判定**（能回答「这段代码是否违反」），禁止空泛如「写好代码」。

步骤 4 每完成一个 task、步骤 6 审查前，**必须重读 Style Anchors**（不得凭记忆）。`technical-architecture.md` 或项目约定变更时，同步更新锚点表。

## Per-Task Style Reload（实现阶段）

`frontend-implement` 每个 task 进入 GREEN 前：

1. 重读 `progress.md` → Style Anchors。
2. 打开本 task **将修改的文件**及**同目录最近邻 1–2 个文件**（或 plan 指定的参照文件），对齐命名、导入顺序、组件结构、错误处理模式。
3. GREEN 完成后、VERIFY 前：若项目有 Lint / Type check 命令，纳入 VERIFY 并记录 exit code。

REFACTOR 阶段不得引入与锚点或邻文件不一致的风格。

## Per-Step Style Reload（文档阶段）

| Step | 重载时机 |
|------|----------|
| 2 design | 写「涉及文件」前重读 Directory Conventions + Code Style |
| 3 plan | 写文件路径与 task 步骤前重读 Style Anchors（若已有）或 technical-architecture |
| 4 implement | 每 task 见上 |
| 5 test | 补测前重读 Testing 约定与锚点 |
| 6 review | 审查 diff 前重读 Style Anchors，并抽查变更文件邻域 |

## 常见违规与处理

| 违规 | 步骤 4 | 步骤 6 |
|------|--------|--------|
| 目录/命名与 architecture 不符 | 本 task 内修正 | 🔴 |
| 与邻文件风格明显不一致 | REFACTOR 修正 | 🟡 或 🔴（视范围） |
| 未跑 lint/typecheck 且项目已配置 | VERIFY 补跑 | 🟡 |
| Style Anchors 未维护或过期 | 先更新锚点再继续 | open question |

## 与 progress.md 的关系

Style Anchors 是 resume 时**最快恢复风格上下文**的入口。步骤 4 第一步须确保该表存在；后续 task 只读表 + 邻文件，不必每次重读整份 architecture（architecture 变更时除外）。
