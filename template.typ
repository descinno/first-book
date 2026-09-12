#import "@preview/headcount:0.1.0": dependent-numbering, reset-counter

// ============================================================
// Chinese Book Template
// Typst 0.15.1
// ============================================================
//
// 用法：
//   #show: book.with(
//     title: "书名",
//     author: "作者",
//     chapters: ("ch01.typ", "ch02.typ"),
//   )
//
// ============================================================

// ==========================================================
// Fonts
// ==========================================================

/// 正文字体配置。
///
/// - CJK: Source Han Serif SC
/// - Latin: Lato
///
/// `latin-in-cjk` 让 Latin 字符优先使用指定西文字体。
#let body-font = (
  (name: "Lato", covers: "latin-in-cjk"),
  "Source Han Serif SC",
)

/// 标题字体配置。
///
/// - CJK: Source Han Sans SC
/// - Latin: Lato
#let heading-font = (
  (name: "Lato", covers: "latin-in-cjk"),
  "Source Han Sans SC",
)

/// 等宽字体。
#let mono-font = "JetBrains Mono"

// ==========================================================
// Marginalia
// ==========================================================

#import "@preview/marginalia:0.3.1" as marginalia: note

#let margin-note = note.with(
  side: "outer",
  counter: none,
)

// ==========================================================
// Callout Styles (data-driven)
// ==========================================================

/// 所有 callout 的样式定义。
///
/// 每个条目包含：
/// - `title`:  默认显示标题
/// - `fill`:   背景色
/// - `accent`: 强调色（左边框与标题颜色）
///
/// 新增一种 callout 只需在此字典中添加一行，
/// 并在下方具名函数区添加对应的一行包装。
///
/// 键名与具名函数对照：
///   fact -> #fact, reference -> #reference, ...
#let callout-styles = (
  fact: (title: "事实 Fact", fill: rgb("#F3F3F1"), accent: rgb("#4A4A46")),
  reference: (title: "参考资料 Reference", fill: rgb("#F1F4F6"), accent: rgb("#526A7A")),
  memory: (title: "记忆 Memory", fill: rgb("#F5F1F5"), accent: rgb("#765C73")),
  evidence: (title: "证据 Evidence", fill: rgb("#F0F4F1"), accent: rgb("#4F6B58")),
  inference: (title: "推断 Inference", fill: rgb("#F3F4F7"), accent: rgb("#596579")),
  citation: (title: "引用 Citation", fill: rgb("#F1F3F3"), accent: rgb("#53696A")),
  hypothesis: (title: "假设 Hypothesis", fill: rgb("#F5F3EC"), accent: rgb("#8A6D3B")),
  speculation: (title: "猜想 Speculation", fill: rgb("#F5F1EC"), accent: rgb("#8A6652")),
  reflection: (title: "反思 Reflection", fill: rgb("#F4F2F5"), accent: rgb("#695F78")),
  question: (title: "问题 Question", fill: rgb("#F3F3F5"), accent: rgb("#5B6070")),
  principle: (title: "原则 Principle", fill: rgb("#F2F2EF"), accent: rgb("#625F4F")),
  definition: (title: "定义 Definition", fill: rgb("#F0F4F8"), accent: rgb("#3B6E9E")),
  note: (title: "注意 Note", fill: rgb("#F5F3EC"), accent: rgb("#8A6D3B")),
  tip: (title: "提示 Tip", fill: rgb("#EEF5EF"), accent: rgb("#4E7A57")),
  example: (title: "示例 Example", fill: rgb("#F2F0F7"), accent: rgb("#6B5A8E")),
  warning: (title: "警告 Warning", fill: rgb("#F8EEEE"), accent: rgb("#A04B4B")),
)

#let callout(
  kind,
  body,
  title: auto,
  fill: auto,
  accent: auto,
) = {
  let cfg = callout-styles.at(kind)
  let t = if title == auto { cfg.title } else { title }
  let f = if fill == auto { cfg.fill } else { fill }
  let a = if accent == auto { cfg.accent } else { accent }

  block(
    fill: f,
    stroke: (left: 3pt + a),
    inset: (x: 10pt, y: 8pt),
    radius: 2pt,
    above: 10pt,
    below: 10pt,
  )[
    // callout 内部取消首行缩进
    #set par(first-line-indent: 0pt)

    #if t != none and t != "" [
      #text(
        font: heading-font,
        weight: "bold",
        size: 10.5pt,
        fill: a,
      )[#t]

      #v(4pt)
    ]

    #body
  ]
}

#let callout-list() = callout-styles.keys()

// ----------------------------------------------------------
// 具名 callout 函数
// ----------------------------------------------------------
// 每个函数是 `callout` 的薄包装，保留具名调用形式。
//
// 调用方式：
//   #fact[...]
//   #fact(title: "自定义标题")[...]
//   #fact(title: none)[无标题]
//
// 注意：新增 callout 时，需在 `callout-styles` 和此处各加一行。

#let fact(body, title: auto) = callout("fact", body, title: title)
#let reference(body, title: auto) = callout("reference", body, title: title)
#let memory(body, title: auto) = callout("memory", body, title: title)
#let evidence(body, title: auto) = callout("evidence", body, title: title)
#let inference(body, title: auto) = callout("inference", body, title: title)
#let citation(body, title: auto) = callout("citation", body, title: title)
#let hypothesis(body, title: auto) = callout("hypothesis", body, title: title)
#let speculation(body, title: auto) = callout("speculation", body, title: title)
#let reflection(body, title: auto) = callout("reflection", body, title: title)
#let question(body, title: auto) = callout("question", body, title: title)
#let principle(body, title: auto) = callout("principle", body, title: title)
#let definition(body, title: auto) = callout("definition", body, title: title)
#let note(body, title: auto) = callout("note", body, title: title)
#let tip(body, title: auto) = callout("tip", body, title: title)
#let example(body, title: auto) = callout("example", body, title: title)
#let warning(body, title: auto) = callout("warning", body, title: title)

// ==========================================================
// Book Template
// ==========================================================

#let chapter-info(this-page) = {
  let headings = query(heading.where(level: 1))

  if headings == () {
    return (none, false)
  }

  let current = none
  for h in headings {
    if h.location().page() <= this-page {
      current = h
    } else {
      break
    }
  }

  if current == none {
    return (none, false)
  }

  let is-start = current.location().page() == this-page
  (current.body, is-start)
}

/// 书籍主入口。
///
/// 参数：
/// - `title`:           书名
/// - `author`:          作者
/// - `keywords`:        PDF 关键词
/// - `description`:     PDF 描述
/// - `date`:            PDF 日期；默认为 `none`，不写入
/// - `chapters`:        章节文件路径数组；若提供则依次 `include`
/// - `page-numbering`:  页码样式，可选 `"book"`（默认）或 `"simple"`
/// - `header-rule`:     是否显示页眉横线
/// - `code-block`:      代码块配置字典
/// - `body`:            正文内容（位置参数，由 `show` 规则自动传入）
///
/// 示例：
///   #show: book.with(
///     title: "示例书",
///     author: "张三",
///     chapters: ("ch01.typ", "ch02.typ"),
///   )

#let book(
  title: "",
  author: "",
  keywords: (),
  description: none,
  date: none,
  chapters: (),
  page-numbering: "book",
  header-rule: true,
  code-block: (
    fill: rgb("#F7F7F5"),
    stroke: rgb("#DDDDD8"),
    radius: 3pt,
    inset: 10pt,
  ),
  body,
) = {
  // ==========================================================
  // Document metadata
  // ==========================================================

  set document(
    title: title,
    author: author,
    keywords: keywords,
    description: description,
    date: date,
  )

  // ==========================================================
  // Language
  // ==========================================================

  set text(
    lang: "zh",
    region: "CN",
  )

  // ==========================================================
  // Marginalia setup
  // ==========================================================

  show: marginalia.setup.with(
    book: true,
    outer: (width: 20mm),
  )

  // ==========================================================
  // Body text
  // ==========================================================

  set text(
    font: body-font,
    size: 10.5pt,
    weight: "regular",
    cjk-latin-spacing: auto,
  )

  // ==========================================================
  // Paragraph
  // ==========================================================

  set par(
    first-line-indent: (amount: 2em, all: true),
    leading: 0.65em,
    justify: true,
    spacing: 0.8em,
  )

  // ==========================================================
  // Headings
  // ==========================================================

  show heading: set text(
    font: heading-font,
    weight: "bold",
  )

  import "@preview/numbly:0.1.0": numbly
  set heading(numbering: numbly(
    "{1:一}.", // 一级标题：一、二、三
    "{1}.{2}", // 二级标题：1.1, 1.2, 2.1
  ))

  // 一级标题：分页 + 间距
  show heading.where(level: 1): it => {
    pagebreak(weak: true, to: "odd")
    block(above: 0pt, below: 24pt, it)
  }
  show heading.where(level: 1): set text(size: 20pt)
  show heading: reset-counter(counter(footnote), levels: 1)

  // 二级标题
  show heading.where(level: 2): set text(
    size: 15pt,
    weight: "medium",
  )
  show heading.where(level: 2): set block(above: 18pt, below: 10pt)

  // 三级标题
  show heading.where(level: 3): set text(
    size: 12pt,
    weight: "medium",
  )
  show heading.where(level: 3): set block(above: 14pt, below: 12pt)

  // 四级标题
  show heading.where(level: 4): set text(
    size: 10pt,
    weight: "medium",
  )
  show heading.where(level: 4): set block(above: 12pt, below: 12pt)

  // ==========================================================
  // Code blocks
  // ==========================================================

  show raw: set text(
    font: mono-font,
    size: 10pt,
  )

  set raw(tab-size: 2)

  // 块级代码
  show raw.where(block: true): it => block(
    fill: code-block.fill,
    stroke: code-block.stroke,
    radius: code-block.radius,
    inset: code-block.inset,
    above: 10pt,
    below: 10pt,
    width: 100%,
    it,
  )

  // 行内代码
  show raw.where(block: false): it => box(
    fill: code-block.fill,
    inset: (x: 2pt, y: 0pt),
    radius: 1pt,
    it,
  )

  // ==========================================================
  // Footnotes
  // ==========================================================

  set footnote(numbering: dependent-numbering("1", levels: 0))

  show footnote: set text(size: 8.5pt)
  show footnote.entry: set block(above: 4pt, below: 4pt)

  // ==========================================================
  // Page
  // ==========================================================

  set page(
    paper: "a5",

    margin: (
      inside: 15mm,
      outside: 30mm,
      top: 20mm,
      bottom: 20mm,
    ),

    background: context {
      let this-page = counter(page).get().first()
      let is-odd = calc.odd(this-page)
      let (_, is-chapter-start) = chapter-info(this-page)

      let pw = 148mm
      let ph = 210mm
      let outside-margin = 27.5mm
      let x = if is-odd { pw - outside-margin } else { outside-margin }

      place(
        dx: x,
        dy: 20mm,
        line(
          start: (0pt, 0pt),
          end: (0pt, ph - 40mm),
          stroke: 0.4pt + rgb("#CCCCCC"),
        ),
      )
    },

    header: context {
      let this-page = counter(page).get().first()
      let is-odd = calc.odd(this-page)

      let (chapter-title, is-chapter-start) = chapter-info(this-page)

      if is-chapter-start {
        return
      }

      set text(size: 9pt)

      if is-odd {
        if chapter-title != none {
          align(right, chapter-title)
          if header-rule {
            v(-2pt)
            line(length: 100%, stroke: 0.4pt)
          }
        }
      } else {
        align(left, title)
        if header-rule {
          v(-2pt)
          line(length: 100%, stroke: 0.4pt)
        }
      }
    },

    footer: context {
      let this-page = counter(page).get().first()
      let is-odd = calc.odd(this-page)

      let (_, is-chapter-start) = chapter-info(this-page)

      set text(size: 9pt)

      if page-numbering == "book" {
        if is-odd {
          align(right, counter(page).display())
        } else {
          align(left, counter(page).display())
        }
      } else {
        align(center, counter(page).display())
      }
    },
  )

  // ==========================================================
  // Body
  // ==========================================================

  if chapters != () {
    for path in chapters {
      include path
    }
  }

  body
}
