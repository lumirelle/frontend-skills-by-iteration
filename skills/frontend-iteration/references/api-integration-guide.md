# API Integration Guide

全流程中「接口联调」的获取信息 → 设计 → 实现 → 验证 → 发布指引。后端未就绪**不阻塞** UI 实现；待定项须**可追溯、可检索**。

版本号 `vX.Y.Z` 与当前迭代目录 `docs/vX.Y.Z/` 一致。

## 原则

1. **先找参照**：优先复用项目已有 API 封装、类型、错误处理；再找类似页面的类似接口。
2. **封装边界**：页面/组件只调 `src/api/`（或 architecture 约定路径），不散落 `fetch`。
3. **占位推进**：新增接口可先返回占位数据，让 UI 与测试走通；待定处用统一 TODO 标记。
4. **单点切换**：后端就绪后，优先只改 API 封装层，页面逻辑尽量不动。

## TODO 标记格式（强制）

凡字段名、路径、入参/返回体、错误码等**待联调确认**处，在代码中加：

```ts
// TODO(vX.Y.Z): 接口联调待定
// TODO(vX.Y.Z): 接口联调待定，字段名以后端为准
// TODO(vX.Y.Z): 接口联调待定，路径 /api/foo 待后端确认
```

- 前缀固定：`TODO(vX.Y.Z): 接口联调待定`
- 逗号后 **xxx 为可选**补充说明
- 一行一事；多处待定则多个 TODO
- 禁止用 `FIXME`、`待确认` 等非统一格式替代

## 分步指引

### 步骤 1 — 需求（`frontend-requirements`）

在 summarized → **数据与展示** 标明每条数据的来源（已有 API / 新增 API / 本地 / 用户输入）。

有接口依赖时：
- 列出需调用的能力（查、增、改、删、提交等），**不要求**最终路径/字段
- 若 origin 已写「接口待定」，记入 Open Questions，并写**默认假设**（供下游占位）

### 步骤 2 — 设计（`frontend-design`）

**获取信息（必做）**：

1. 在代码库搜索：同资源名、同模块 `src/api/`、同类型请求。
2. 找 **类似页面**：列表/详情/表单提交等与本次最像的页面，记录其 API 封装与类型定义路径。
3. 将发现写入 design → **接口契约** →「参照」行（见模板）。

**设计产出**：

| 项 | 要求 |
|----|------|
| 已有 API | 写清封装函数、类型路径，**复用** |
| 新增 API | 方法、暂定路径、暂定入参/返回、前端类型；标「后端未就绪」 |
| 占位策略 | 封装内 mock / 静态占位 / 延迟 resolve；标切换点 |
| 待定清单 | 与契约表格对应，供实现写 TODO |

### 步骤 3 — 计划（`frontend-plan`）

- 新增或修改 API 封装**单独成 task**（或与 types 同 task），早于消费该 API 的页面 task。
- RED：对封装函数或页面 mock 边界写失败测试（拦截网络或 mock `src/api/`）。
- GREEN：实现占位返回 + TODO；页面 task 依赖 API task。
- 测试矩阵含「API 结果」维度；未联调真实后端须在风险中说明。

### 步骤 4 — 实现（`frontend-implement`）

- 新增封装函数：若后端未就绪，**直接返回占位数据**（与 design 一致），勿在页面硬编码假数据。
- 每个待定字段/路径/错误码：按 TODO 格式标注。
- 页面只依赖封装签名与类型，便于联调时只改封装层。

占位示例（示意）：

```ts
export async function submitFeedback(payload: FeedbackPayload): Promise<void> {
  // TODO(v0.1.0): 接口联调待定，路径 /api/feedback 待后端确认
  await Promise.resolve();
  return;
}
```

### 步骤 5 — 测试（`frontend-test`）

- 集成测试 mock **API 封装层**或网络边界，不测真实后端（除非环境已就绪）。
- test-report → **未覆盖风险**须列出：真实联调未做、TODO 数量或清单引用。
- 可用 `rg "TODO\\(vX\\.Y\\.Z\\): 接口联调待定"` 核对标记是否遗漏。

### 步骤 6 — 审查（`frontend-review`）

- 对照 design 接口契约：封装位置、类型、占位、TODO 是否一致。
- 待定项未标 TODO → 🟡；页面绕过封装直接写死占位 → 🔴。
- 未联调真实接口通常为 🟡 + 记入发布已知问题，不单独 🔴（除非 summarized 要求真实联调）。

### 步骤 7 — 发布（`frontend-release`）

- PR 描述 / changelog → **已知问题**列出接口联调项与 TODO 版本号。
- 后端就绪后的迭代：搜索 `TODO(vX.Y.Z): 接口联调待定` 逐项关闭。

## 检索命令（Agent 探查）

```text
# 已有封装
rg "export (async )?function" src/api/
# 类似页面的 API 引用
rg "from ['\"].*api" src/pages/
# 本迭代待定标记
rg "TODO\\(v[0-9]+\\.[0-9]+\\.[0-9]+\\): 接口联调待定"
```

## 与 Open Questions 的关系

| 情况 | 处理 |
|------|------|
| 阻塞 UI 的未知（无合理默认） | Open Question，不进入实现 |
| 有合理默认、后端未就绪 | design 记假设 + 实现用占位 + TODO |
| 联调中发现不一致 | 只改 API 层 + 更新 design/types + 删/改 TODO |
