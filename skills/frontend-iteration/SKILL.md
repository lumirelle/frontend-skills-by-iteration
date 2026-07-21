---
name: frontend-iteration
description: Use when starting, resuming, or continuing a versioned frontend iteration with docs/vX.Y.Z/ inputs.
disable-model-invocation: true
---

# 前端迭代

## 目标

按如下步骤完成前端迭代：1 需求分析/拆解 → 2 设计 → 3 TDD 计划 → 4 实现 → 5 测试 → 6 审查 → 7 发布准备

## 步骤与子 skill 对应

| 步骤 | 子 Skill |
|------|-------|
| 1 | `frontend-requirements` |
| 2 | `frontend-design` |
| 3 | `frontend-plan` |
| 4 | `frontend-implement` |
| 5 | `frontend-test` |
| 6 | `frontend-review` |
| 7 | `frontend-release` |

## 调用方式

```
/frontend-iteration v1.2.0                  # fast（默认）：1–3 连续，4–7 逐步确认
/frontend-iteration v1.2.0 strict           # 每步确认
/frontend-iteration v1.2.0 fast
/frontend-iteration v1.2.0 step 3           # 执行步骤 3
/frontend-iteration v1.2.0 strict step 3
/frontend-iteration v1.2.0 resume           # 从未完成步骤恢复执行
```

版本号结构： `vX.Y.Z`

产物输出到 `docs/vX.Y.Z/`

## 步骤编排规则

1. **执行前重读**：每步执行前重读子 skill，不凭记忆执行
2. **规范版本与目录结构**：严格基于版本与目录结构约定（见 [version-convention.md](references/version-convention.md)）执行
3. **状态驱动**：基于产物文档状态（见 [document-status.md](references/document-status.md)）判断门禁通过状态
4. **门禁驱动**：当前步骤门禁未通过（见 [step-gates.md](references/step-gates.md)）不允许进入下一步
5. **契约驱动**：编排契约见 [orchestrated-invocation.md](references/orchestrated-invocation.md)
6. **进度驱动**：`progress.md` 为恢复步骤执行的事实源。每步执行时均要按 [progress-convention.md](references/progress-convention.md)“每步最小落盘”小节完成落盘
7. **严格恢复**：先读 `progress.md`，缺少/内容不可信则按 [progress-convention.md](references/progress-convention.md)“恢复检测”小节修复
8. **跳步**：说明影响，用户确认后执行
9. **返工**：返工到对应步骤时，如有遗留的状态为 `DRAFT` 的输入产物文档，需用户确认批量确认转 `ACTIVE`，否则停止
10. **用户输出**：对用户的所有文字输出遵守沟通风格（见 [agent-communication-style.md](references/agent-communication-style.md)）

## 执行流程

```
启动检查
    ↓
读子 skill → 执行 → 门禁 → progress.md
    ↓
fast 模式步骤 1–3 自动；步骤 3 后批量确认
strict 模式或步骤 4–7 逐步确认
    ↓
下一步 / 结束
```

## 启动检查

1. 确认版本、模式（默认 fast）、起始步骤（step / resume）
2. 校验 `docs/technical-architecture.md` 及 `docs/vX.Y.Z/`：
   1. 无 `docs/technical-architecture.md`：从 `<skill-root>/templates/docs/technical-architecture.md` 复制
   2. `technical-architecture.md` 是模板（缺项目真实技术栈/命令/目录/测试等内容）：Agent 自动探库生成
   3. 无 `docs/vX.Y.Z/progress.md`：从 `<skill-root>/templates/docs/version/progress.md` 复制，替换文档内版本号
   4. `docs/vX.Y.Z/` 下缺少模板 `<skill-root>/templates/docs/version/` 下对应目录或文件：根据模板补全
   5. 无 `docs/vX.Y.Z/prd/origin/*.md`：要求用户提供并停止
3. 向用户列出 `docs/vX.Y.Z/prd/origin/*.md`、`docs/vX.Y.Z/ui/*`
4. 读/修 `progress.md`，向用户列出起点、阻塞项、草稿批次状态
5. 读目标子 skill，格式疑义参考 [examples/README.md](examples/README.md)

启动检查不通过时停止

## 模式

| 模式 | 说明 |
| -- | -- |
| `fast` | 默认，步骤 1–3 连续输出产物，统一确认；步骤 4–7 逐步输出产物并等待确认 |
| `strict` | 逐步输出产物并等待确认 |

## 文件路径解析

读 skill / reference 时按序尝试（命中即用）：

| 资源 | 路径 1（`npx skills add`） | 路径 2（源码） |
|------|------------------------------|----------------|
| 本 `SKILL.md` 目录 | `.agents/skills/frontend-iteration/` | `skills/frontend-iteration/` |
| 子 skill | `.agents/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` |
| 编排 references | `.agents/skills/frontend-iteration/references/<file>` | `skills/frontend-iteration/references/<file>` |
| 其他 references | `.agents/skills/<name>/references/<file>` | `skills/<name>/references/<file>` |
| 样例 | `.agents/skills/frontend-iteration/examples/` | `skills/frontend-iteration/examples/` |

## 参考

- 版本与目录结构约定：[version-convention.md](references/version-convention.md)
- 文档状态：[document-status.md](references/document-status.md)
- 步骤门禁：[step-gates.md](references/step-gates.md)
- 编排契约：[orchestrated-invocation.md](references/orchestrated-invocation.md)
- 进度约定：[progress-convention.md](references/progress-convention.md)
- Agent 沟通风格：[agent-communication-style.md](references/agent-communication-style.md)
- 强制代码风格：[code-style-enforcement.md](references/code-style-enforcement.md)
- 接口联调指南：[api-integration-guide.md](references/api-integration-guide.md)
- 样例说明：[examples/README.md](examples/README.md)
