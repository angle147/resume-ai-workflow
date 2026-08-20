# resume-ai-workflow

给中文求职者与他们的 AI 助手的**简历工作流三件套**：JD 解析匹配 → 素材选材 → Typst 排版成稿。三个 SKILL 装进任意 AI agent 即用，从一条 JD 到一页成品简历，全程可复现、可追问、不编造。

## 这个项目解决什么问题

投一份简历，重复劳动远不止"写"本身：逐条读 JD 判断匹配度、翻素材库挑经历、来回调排版、对付不同招聘平台的表单……这些步骤本可以让 AI 助手承担。

本项目把「从 JD 到成品简历」的完整方法论沉淀为三个可直接装进 AI agent 的技能（SKILL 格式，纯 Markdown，无黑盒）：

| 模块 | 定位 | 输入 → 输出 |
|------|------|------------|
| `typst-resume` | 排版引擎 | 简历内容 → 一页紧凑的专业 PDF（含照片） |
| `resume-workflow` | 流程编排 | 一条或多条 JD → 匹配度排序 + 定制简历 |
| `resume-jd-optimizer` | 策略层 | 单个 JD → 深度解析 + 证据映射 + 简历重写 + 面试弹药 |

## 工作流

```mermaid
flowchart LR
    A[招聘 JD] --> B[resume-jd-optimizer<br/>JD 解析 / 权重 / 证据映射]
    B --> C[resume-workflow<br/>多岗对比 / 素材选材 / 流程编排]
    C --> D[typst-resume<br/>Typst 排版 / 照片处理 / 一页约束]
    D --> E[成品简历 PDF]
    E --> F[投递 + 面试]
```

## 快速开始

1. 克隆本仓库
2. 将三个目录（或整个仓库）作为 SKILL 安装进你的 AI agent（兼容支持 SKILL 格式的 agent，如 Claude 系列、Copilot 及自定义 agent 平台）
3. 给 agent 一条 JD，让它按对应模块的 `SKILL.md` 执行：
   - 深度定制单岗简历 → 用 `resume-jd-optimizer`
   - 快速判断多岗投哪个、批量产出 → 用 `resume-workflow`
   - 只需排版 → 直接读 `typst-resume`
4. 生成 PDF 需要 Typst 编译器：

```bash
winget install typst
```

环境要求：核心方法论零依赖（纯 Markdown）；仅 PDF 排版需要 Typst。

## 设计原则

- **真实性红线**：所有 prompt 强制「不编造学历、公司、岗位、数据」，每条经历必须能被面试追问验证。美化只提信息密度与结构，不抬高职责与结果。
- **可审计**：16 个策略 prompt、6 个评分 rubric 全部开放，AI 怎么打分、怎么改写，每一步都有据可查。
- **针对性而非万能**：明确拒绝生成"万能简历"，所有输出绑定具体 JD 与可验证事实。
- **隐私优先**：模板与示例全部脱敏，不含任何真实个人信息。

## 与同类方案的区别

| | 本方案 | 简历生成网站 / 大模型直出 |
|---|---|---|
| 匹配逻辑 | 显式 JD 解析 + 权重 + 证据映射，可审计 | 黑盒，靠模型感觉 |
| 真实控制 | 四档美化级别，硬性真实性红线 | 容易编造经历 |
| 排版 | Typst 可编程排版，一页紧凑 | 固定模板，难定制 |
| 复用性 | 素材库 + 多版本，一次采集多次产出 | 每次从零开始 |

## 目录结构

```
resume-ai-workflow/
├── typst-resume/            # 排版引擎：Typst 模板方法论 + 照片处理 + 常见坑
├── resume-workflow/         # 流程编排：JD 解析、多岗对比、资源库选材、交付检查
│   ├── assets/              # 编译脚本 build.ps1 / check.ps1
│   └── references/          # 资源库组织指南
└── resume-jd-optimizer/     # 策略层：16 prompts + 6 rubrics + 7 templates + 测试
    ├── prompts/             # JD 解析 / 重写 / ATS 检查 / HR 审查 / 面试题生成等
    ├── rubrics/             # 匹配度 / 可信度 / ATS / HR 视角评分标准
    ├── templates/           # 简历模板 / 网申档案 / Boss 直聘话术等
    ├── docs/                # 工作流、评分字典、角色分类、场景手册
    └── tests/               # 失败模式与评估清单
```

## 谁在用

作者本人用它完成了多轮真实求职投递（供应链、物流、交通、AI 应用等方向），所有方法论来自实战迭代而非纸面设计。

## License

MIT © angle147
