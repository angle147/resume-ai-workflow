# resume_facts.yml 完整 Schema

## 顶层结构

```yaml
version: "1.0"             # Schema 版本
last_updated: "YYYY-MM-DD" # 最后更新日期
experiences: []            # 经历列表
education: []              # 教育背景
skills: []                 # 技能
certificates: []           # 证书
optimization_levels: {}    # 四档定义（只读参考，不在生成时修改）
```

## experiences 条目

```yaml
- id: kebab-case-id              # 唯一标识，用于引用。如 g104-bid
  title: "经历标题"              # 如 "G104 京岚线修复养护工程投标"
  organization: "所属组织"       # 可选，如公司名。无组织则省略此字段
  role: "你的角色"               # 如 "投标方代表""独立开发者""交换生"
  date: "时间段"                 # 如 "2026.05" 或 "2021.08 - 2023.03"
  jd_tags: [tag1, tag2]          # 关键词标签数组，用于 JD 匹配和经历排序
  evidence_dir: null             # 证据素材子目录名。null 表示暂无
  raw_facts:                     # 原子级原始事实数组
    - "事实陈述1"
    - "事实陈述2"
```

### jd_tags 命名建议

使用中文关键词，每标签 2-4 字，覆盖该经历可能对接的岗位方向：

- 技术岗：Python, JavaScript, Chrome Extension, 爬虫
- 业务岗：招投标, 合规采购, 风险识别, 数据分析
- 素质：全英文, 跨文化沟通, 国际协作
- 工具：AutoCAD, ArcGIS, AMPL, Git

### raw_facts 编写标准

| 规则 | 示例（正确） | 示例（错误） |
|---|---|---|
| 原子级，一句一事 | "临时被叫去充当投标代表人" | "参与了投标并负责了很多工作" |
| 用户原话 | "让 AI 帮忙模仿搭了架子" | "独立从零构建系统架构" |
| 不利事实照录 | "项目实际已安排给山东省交通设计院，我方为陪标方" | 省略不写 |
| 不录入默认能力 | 不写"使用 Word 编制文档" | "熟练使用 Office 办公套件" |
| 标记不确定性 | "约两万公里" | "20000.5 公里"（无精确数据时） |

### evidence_dir 约定

指向 `evidence/` 目录下的子目录，用于存放该经历的证明材料：

```
evidence/
├── 交通影响评价/     ← evidence_dir: "交通影响评价"
│   ├── 交评报告.pdf
│   └── 评审意见.pdf
└── 中俄跨境项目/     ← evidence_dir: "中俄跨境项目"
    └── 甘特图.png
```

暂无证据时设为 `null`，不要删除该字段。

## education 条目

```yaml
- institution: "学校全称"
  degree: "学位"              # 硕士/本科/专科/交换
  major: "专业"
  date: "时间段"
  raw_facts:                  # 可选，仅硕士阶段需要列出学术成果
    - "论文或专利信息"
```

要求：所有高等教育经历全部保留，按学位倒序排列。不合并、不删除。

## skills 条目

```yaml
- category: "技能类别"        # 编程与自动化 / 运筹与建模 / 制图与空间分析 / 办公工具
  items: [技能1, 技能2]
```

## certificates

```yaml
- 证书名称
```

## optimization_levels（只读）

定义四档美化级别的行为规则。这部分在 `resume_facts.yml` 中以只读形式存在，实际转换逻辑在 `resume-jd-optimizer-cn` 的 `prompts/facts_to_resume.md` 中执行。
