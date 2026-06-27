# Version & Directory Convention

## Version Format

- 格式：`vX.Y.Z`（语义化版本，前缀 `v`）
- 示例：`v1.0.0`、`v2.1.3`
- 路径中版本号大小写敏感，统一小写 `v`

## Directory Layout

```
docs/
├── technical-architecture.md      # 项目级，跨版本
└── vX.Y.Z/                        # 迭代级
    ├── prd/
    │   ├── origin/                # 输入：原始 PRD
    │   └── summarized/            # 步骤 1 产出
    ├── ui/                        # 输入：UI 稿（可选）
    ├── design/                    # 步骤 2 产出
    ├── plans/                     # 步骤 3 产出
    ├── review/                    # 步骤 6 产出
    └── test-report.md             # 步骤 5 产出
```

## File Naming

| 类型 | 规则 | 示例 |
|------|------|------|
| origin PRD | 页面或功能名，kebab-case | `user-profile.md` |
| summarized | 与 origin 同名 | `user-profile.md` |
| design | 与 summarized 同名 | `user-profile.md` |
| plan | 与 summarized 同名 | `user-profile.md` |
| UI 图 | 页面或板块名 | `user-profile.*`、`user-profile-header.*`（任意常见图片格式） |

多文件迭代：一个功能/页面一套 origin → summarized → design → plan，禁止混在一个文件里。

## UI Mapping

- `page-name.*`（任意常见图片格式） → 整页
- `page-name-section.*`（任意常见图片格式） → 该页某板块
- 无法从文件名推断 → 在 summarized 中列为 open question

## Resume Detection

按顺序检查产出目录，第一个不满足 Step Gates 的步骤即为 resume 起点：

1. `prd/summarized/` 不完整 → step 1
2. `design/` 不完整 → step 2
3. `plans/` 不完整 → step 3
4. 代码未按 plan 完成 → step 4
5. 无 test-report 或测试未过 → step 5
6. `review/` 缺失或有 🔴 → step 6
7. 否则 → step 7
