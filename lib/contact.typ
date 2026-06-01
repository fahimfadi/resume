#import "icons.typ": icon

// --- Helper for contact items (icon + link) ---
#let contact-item(name, url, label) = {
  stack(
    dir: ltr,
    spacing: 3pt,
    icon(name),
    link(url)[#underline(label)],
  )
}
