# 接口联调指引

接口联调：获取信息 → 设计 → 实现 → 验证 → 发布。后端未就绪不阻塞 UI；待定项可追溯、可检索

`vX.Y.Z` = 当前 `docs/vX.Y.Z/`

## 原则

1. **先找参照**：已有 API 封装、类型、错误处理 → 类似页面类似接口
2. **封装边界**：参考 `docs/technical-architecture.md` 约定或已有实现
3. **占位推进**：新接口可先占位返回，UI/测试走通；待定用统一 TODO
4. **单点切换**：后端就绪优先只改封装层

## TODO 格式（强制）

字段、路径、入参/返回、错误码等待确认处：

```ts
// TODO(vX.Y.Z): 接口联调待定
// TODO(vX.Y.Z): 接口联调待定，字段名以后端为准
// TODO(vX.Y.Z): 接口联调待定，路径 /api/foo 待后端确认
```

- 前缀固定：`TODO(vX.Y.Z): 接口联调待定`
- 逗号后 xxx 可选
- 一行一事

## 分步

### 步骤 1 — 需求

summarized → **数据与展示** 标来源：已有 API / 新增 API / 本地 / 用户输入

有接口依赖：列能力（查增改删提交等），不要求最终路径/字段。origin 写「接口待定」→ 待确认问题 + **默认假设**

### 步骤 2 — 设计

**获取信息（必做）**：

1. 搜同资源、同类型请求
2. 找类似页面，记封装与类型路径
3. 写入 design → 接口契约 → 参照（见模板）

**产出**：

| 项 | 要求 |
|----|------|
| 已有 API | 封装函数、类型路径；复用 |
| 新增 API | 方法、暂定路径/入参/返回、前端类型；标后端未就绪 |
| 占位策略 | mock/静态/延迟 resolve；标切换点 |
| 待定清单 | 对应契约表；供实现写 TODO |

### 步骤 3 — 计划

- API 封装单独 task（或连 types），早于页面 task
- RED：mock 封装或网络边界
- GREEN：占位 + TODO；页面 task 依赖 API task
- 测试矩阵含「API 结果」；未联调真后端记入风险

### 步骤 4 — 实现

- 后端未就绪：封装**直接占位返回**（跟 design）；页面不硬编码假数据
- 待定处按 TODO 格式
- 页面只依赖封装签名与类型

```ts
export async function submitFeedback(payload: FeedbackPayload): Promise<void> {
  // TODO(v0.1.0): 接口联调待定，路径 /api/feedback 待后端确认
  await Promise.resolve()
  return
}
```

### 步骤 5 — 测试

- 集成 mock 封装层或网络边界；不测真后端（除非环境就绪）
- test-report 未覆盖风险：真联调未做、TODO 清单
- 核对：`rg "TODO\\(vX\\.Y\\.Z\\): 接口联调待定"`

### 步骤 6 — 审查

- 对照 design 契约：封装、类型、占位、TODO
- 待定无 TODO → 🟡；页面绕过封装写死占位 → 🔴
- 未联调真接口通常 🟡 + 发布已知问题（summarized 要求真联调除外）

### 步骤 7 — 发布

- PR/changelog 已知问题列联调项与 TODO 版本
- 后端就绪迭代：`rg "TODO(vX.Y.Z): 接口联调待定"` 逐项关

## 检索

```text
rg "export (async )?function" src/api/
rg "from ['\"].*api" src/pages/
rg "TODO\\(v[0-9]+\\.[0-9]+\\.[0-9]+\\): 接口联调待定"
```

## 与待确认问题区分

| 情况 | 处理 |
|------|------|
| 无合理默认、阻塞 UI | 待确认问题；不进实现 |
| 有默认、后端未就绪 | design 假设 + 占位 + TODO |
| 联调不一致 | 只改 API 层 + 更新 design/types + 删改 TODO |
