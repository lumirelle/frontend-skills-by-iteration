# 版本与目录约定

## 版本格式

- 格式：`vX.Y.Z`（语义化版本，前缀 `v`）
- 示例：`v1.0.0`、`v2.1.3`
- 路径中版本号大小写敏感，统一小写 `v`

## 目录布局

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
    ├── release/                   # 步骤 7 产出
    ├── progress.md                # 迭代进度与 resume 事实源
    └── test-report.md             # 步骤 5 产出
```

## 文件命名

| 类型 | 规则 | 示例 |
|------|------|------|
| origin PRD | 页面或功能名 | `user-profile.md` |
| summarized | 与 origin 同名 | `user-profile.md` |
| design | 与 summarized 同名 | `user-profile.md` |
| plan | 与 summarized 同名 | `user-profile.md` |
| release | 固定文件名 | `release/changelog-entry.md`、`release/pr-description.md` |
| UI 图 | 页面或板块名 | `user-profile.*`、`user-profile-header.*`（任意常见图片格式） |
