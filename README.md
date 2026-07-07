# frontend-skills-by-iteration

可分发前端迭代 Agent Skills：版本化需求、设计、计划、实现、测试、审查、发布。

## 安装

```bash
npx skills add lumirelle/frontend-skills-by-iteration --skill '*'
```

## 前置

1. 原始 PRD → `docs/vX.Y.Z/prd/origin/*.md`
2. （可选）UI 稿 → `docs/vX.Y.Z/ui/*`

## 用法

```
/frontend-iteration v1.2.0              # fast（默认）：1–3 连续，4–7 逐步确认
/frontend-iteration v1.2.0 strict       # 每步确认
/frontend-iteration v1.2.0 step 3
/frontend-iteration v1.2.0 resume
```

## Skills 清单

| Skill | 步骤 |
|-------|------|
| `frontend-iteration` | 编排（初始化、模板、样例） |
| `frontend-requirements` | 1 需求 |
| `frontend-design` | 2 方案 |
| `frontend-plan` | 3 TDD 计划 |
| `frontend-implement` | 4 实现 |
| `frontend-test` | 5 自测 |
| `frontend-review` | 6 审查 |
| `frontend-release` | 7 发布 |
