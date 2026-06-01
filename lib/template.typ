#import "icons.typ": icon
#import "contact.typ": contact-item

#let resume(
  personal: (),
  summary: none,
  education: (),
  experience: (),
  projects: (),
  skills: (),
  photo: none,
  body-font: "Arial",
  header-font: "Montserrat",
  accent-color: rgb("#222222"),
  body,
) = {
  // --- Theme Configuration ---
  let size-margin = 1.25cm
  let size-indent = 0.38cm
  let stroke-width = 0.5pt

  // Typography
  let font-body = 11pt
  let font-item = 10pt
  let font-heading = 11pt
  let font-name = if photo == none { 30pt } else { 25pt }
  let font-contact = if photo == none { 10.5pt } else { 9.5pt }

  // Spacing
  let space-leading = 0.54em
  let space-row-gutter = 4pt
  let space-list = 5pt
  let space-contact-stack = 2pt
  let space-project-stack = 3pt
  let space-skills-stack = 4pt

  // Heading Specific
  let head-space-top = 4pt
  let head-space-bottom = -8pt
  let head-space-after-line = 2pt

  // --- Page Setup ---
  set document(title: personal.at("name", default: "Resume"), author: personal.at("name", default: ""))
  set page(
    paper: "a4",
    margin: size-margin,
  )
  set text(font: body-font, size: font-body, fill: accent-color, fallback: true)
  set par(justify: true, leading: space-leading)

  // --- Styles ---
  show heading.where(level: 1): it => {
    set text(size: font-heading, weight: "bold")
    v(head-space-top)
    smallcaps(it.body)
    v(head-space-bottom)
    line(length: 100%, stroke: stroke-width)
    v(head-space-after-line)
  }

  // --- Helper Functions ---
  let section(title) = heading(level: 1, title)

  let subheading(title, location, subtitle, date) = {
    grid(
      columns: (1fr, auto),
      row-gutter: space-row-gutter,
      text(weight: "bold")[#title], align(right, text(weight: "bold", size: font-item)[#date]),
      text(style: "italic", size: font-item)[#subtitle],
      align(right, text(style: "italic", size: font-item)[#location]),
    )
  }

  let project_item(title, tech, date, url: none) = {
    grid(
      columns: (1fr, auto),
      row-gutter: space-row-gutter,
      stack(
        dir: ltr,
        spacing: space-project-stack,
        if url != none and url != "" { link(url)[#underline(text(weight: "bold", size: font-item)[#title])] } else {
          text(weight: "bold", size: font-item)[#title]
        },
        if tech != none and tech != "" { [ | ] },
        if tech != none and tech != "" { text(style: "italic", size: font-item)[#tech] },
      ),
      align(right, text(weight: "bold", size: font-item)[#date]),
    )
  }

  let list_items(bodies) = {
    if bodies != none and bodies.len() > 0 {
      set list(indent: size-indent, marker: [–], spacing: space-list)
      for body in bodies {
        list.item(text(size: font-item)[#body])
      }
    }
  }

  // --- Header ---
  let contact_block = {
    let items = ()
    if personal.at("phone", default: none) != none {
      items.push(contact-item("phone", "tel:" + personal.phone, personal.phone))
    }
    if personal.at("email", default: none) != none {
      if items.len() > 0 { items.push([|]) }
      items.push(contact-item("mail", "mailto:" + personal.email, personal.email))
    }
    if personal.at("linkedin", default: none) != none {
      if items.len() > 0 { items.push([|]) }
      items.push(contact-item("linkedin", "https://" + personal.linkedin, personal.linkedin))
    }
    if personal.at("github", default: none) != none {
      if items.len() > 0 { items.push([|]) }
      items.push(contact-item("github", "https://" + personal.github, personal.github))
    }
    stack(dir: ltr, spacing: space-contact-stack, ..items)
  }

  let name_display = {
    let name_text = personal.at("name", default: "YOUR NAME")
    let website = personal.at("website", default: none)
    if website != none and website != "" {
      link(website)[#text(size: font-name, weight: "bold")[#smallcaps(name_text)]]
    } else {
      text(size: font-name, weight: "bold")[#smallcaps(name_text)]
    }
  }

  if photo != none {
    grid(
      columns: (15%, 85%),
      align: (left + horizon, center + horizon),
      box(
        stroke: white + 0.4pt,
        inset: 3pt,
        photo,
      ),
      [
        #set text(font: header-font)
        #name_display
        #v(-8pt)
        #set text(size: font-contact, font: body-font)
        #contact_block
      ],
    )
  } else {
    align(center)[
      #set text(font: header-font)
      #name_display
      #v(-10pt)
      #set text(size: font-contact, font: body-font)
      #contact_block
    ]
  }

  v(-2pt)

  if summary != none and summary != "" {
    section("Summary")
    block(inset: (left: size-indent))[
      #set text(size: font-item)
      #summary
    ]
  }

  if experience != none and experience.len() > 0 {
    section("Experience")
    for exp in experience {
      subheading(exp.company, exp.at("location", default: ""), exp.role, exp.date)
      list_items(exp.at("items", default: ()))
    }
  }

  if education != none and education.len() > 0 {
    section("Education")
    for edu in education {
      subheading(edu.school, edu.at("location", default: ""), edu.degree, edu.date)
    }
  }

  if projects != none and projects.len() > 0 {
    section("Projects")
    for proj in projects {
      project_item(proj.title, proj.at("tech", default: none), proj.date, url: proj.at("url", default: none))
      list_items(proj.at("items", default: ()))
    }
  }

  if skills != none and skills.pairs().len() > 0 {
    section("Skills & Competencies")
    block(inset: (left: size-indent))[
      #set text(size: font-item)
      #stack(
        dir: ttb,
        spacing: space-skills-stack,
        ..skills.pairs().map(((cat, val)) => [*#cat*: #val]),
      )]
  }
}
