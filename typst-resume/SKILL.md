---
name: typst-resume
description: "使用 Typst 和 typst-resume-one-page 模板生成中文简历 PDF。适用于需要精美排版、一页紧凑、带照片的中文简历场景。MANDATORY TRIGGERS: typst 简历, typst resume, 简历排版, 简历生成, 照片简历"
---

# Typst 简历生成

使用 [typst-resume-one-page](https://github.com/habaneraa/typst-resume-one-page) 模板生成带照片的中文简历 PDF。

## 环境准备

### 安装 Typst 编译器

```bash
winget install typst
# 或手动下载解压：https://github.com/typst/typst/releases
```

### 安装图标字体（电话/邮箱/地址旁的小图标）

```bash
# 下载 Nerd Font Symbols Mono 单文件
Invoke-WebRequest -Uri 'https://cdn.jsdelivr.net/gh/ryanoasis/nerd-fonts@3.4.0/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf' -OutFile 'SymbolsNerdFontMono.ttf'

# 安装字体（Windows）
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
$fonts.CopyHere('SymbolsNerdFontMono.ttf', 0x10)
```

### 模板已通过 Typst Universe 自动下载

首次编译时 typst 自动从 `@preview` 下载模板，无需手动克隆。

## 编译命令

### 编译前检查清单

每次写新 .typ 文件后，编译前必须确认：
1. ✅ 文件末尾有**两个** `]`（外层闭合 resume-header，内层闭合最后一条 resume-entry）
2. ✅ 照片路径正确，`--root` 参数覆盖到图片所在目录
3. ✅ 中文引号全部替换为「」或 \"
4. ✅ 字体栈使用 Windows 可用字体（Microsoft YaHei / SimSun）

```bash
typst compile --root "简历文件目录" "zhongliang-trade.typ" "output.pdf"
```

`--root` 用于允许 typst 访问项目根目录之外的图片文件（如照片）。

## 模板核心参数

```typst
#import "@preview/habaneraa-one-page-resume-zh:0.1.0": setup-styles

#let (resume-header, resume-entry) = setup-styles(
  font-size: 10.5pt,       // 正文大小，10-11pt 范围
  element-spaciness: 1.05,  // 全局间距系数，0.9-1.2 范围
  sans-serif-font: ("Microsoft YaHei"),  // Windows 可用字体
  serif-font: ("SimSun"),
  alt-font: ("Microsoft YaHei"),
)
```

- `font-size` 和 `element-spaciness` 联合控制一页紧凑度
- 字体栈：模板默认使用 Noto Sans/Serif CJK SC 和 Source Han Sans/Serif SC，Windows 上替换为 Microsoft YaHei + SimSun
- 如果电脑已安装思源字体，可去掉字体参数让模板使用默认

## 简历内容结构

### 教育背景规则
- **保留完整学习经历**，包括专科第一学历，不可删除
- 专科简写即可：学校 + 专业 + 时间，无需课程细节
- 硕士和本科可展开课程/学术成果

### 结构模板

```typst
#resume-header(
  author: "姓名",
  telephone: "手机号",
  email: "邮箱",
  location: "城市",
  basic-info: ("信息1", "信息2"),  // 数组，每个元素一行
)[
  = 章节标题

  #resume-entry(
    title: "条目主标题",
    subtitle: "副标题",
    date: "时间",
  )[
    - 详细描述使用无序列表
    - 支持多行
  ]
]
```

- 整个 body 内容作为 `resume-header` 的 content block 传入
- `= 标题` 渲染为带横线的章节标题
- `#resume-entry` 渲染为加粗标题行 + 日期右对齐 + 列表详情
- **最外层 content block 必须以 `][` 开始、以 `]` 结束，并额外加一个 `]` 闭合 `resume-header`**
- **⚠️ 每次写新 .typ 文件都要检查末尾是否有两个 `]`，这是最容易忘的错误**

## 照片处理（核心教训）

### 禁止的做法

| 错误 | 表现 | 原因 |
|------|------|------|
| 用模板 `profile-image` 参数 | 照片随 header 文字高度缩放，显小 | 照片高度=header三行文字高度，对证件照偏小 |
| `place(top+right, dy:负值)` 直接在 body 里 | 冲出页面上方 | body 里 place 的 top 是页面顶部，负偏移出界 |
| `place(...) + #v(-X)` 回拉 | header 和 body 重叠 | v(-X) 只拉 body 不拉 header，两者位移不同步 |
| `place(..., float: true)` | 仍然挤占文档空间 | **typst 中 float 不能消除 place 的空间占用** |
| `box(height:0pt, ...)` 不设 width | 照片飞到左边 | box 默认宽度只有内容宽，right 对齐错位 |

### 唯一正确的做法

用零高度、全宽、允许溢出的 box 包裹 place：

```typst
// 前提：element-spaciness: 1.05, font-size: 10.5pt
// body 顶部约在页面 3.76cm 处
// 照片目标：页面顶部往下 1.5cm，高度 3.0cm
// place 在 box 内的 dy = 目标位置 - box顶部 = 1.5 - 3.76 = -2.26cm

#box(clip: false, width: 100%, height: 0pt,
  place(top + right, dx: -0.5em, dy: -2.26cm,
    image("路径/照片.png", height: 3.0cm)
  )
)
```

**三个关键参数缺一不可：**
- `clip: false` — 允许照片溢出 box 边界显示
- `width: 100%` — box 拉满行宽，right 对齐才能落在右侧
- `height: 0pt` — box 占零高度，不挤占文档流

**dy 计算公式：**
```
dy = 照片上缘目标位置(页面cm) - body顶部位置(页面cm)
```
- body 顶部 ≈ 页面上边距 + header 高度
- 页面上边距 = 1.2cm × element-spaciness
- header 高度 ≈ 6.8em × font-size(pt) / 28.35

## 常见问题速查

| 问题 | 原因 | 解决 |
|------|------|------|
| 中文引号报错 `unclosed delimiter` | typst 把「"」「"」当字符串边界 | 改用「」或 \" |
| 照片路径报错 `would escape project root` | 相对路径 `../` 超出项目根 | 加 `--root` 参数扩大项目根范围 |
| Nerd Font 警告 | 图标字体未安装 | 下载安装 SymbolsNerdFontMono-Regular.ttf |
| 编译后零输出无警告 | 一切正常 | typst 静默成功不输出任何信息 |
| 内容超出一页 | spaciness 太大或照片占位 | 先确保照片用 box 零高度方案，再调小 spaciness |
