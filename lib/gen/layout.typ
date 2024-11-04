#import "../type/unit.typ": type-unit
#import "../type/note.typ": type-note, type-note-left, type-note-right
#import "../type/title.typ": type-title
#import "../type/header.typ": type-header

#import "header.typ": header-to-gird
#import "note.typ": notes-to-grid
#import "title.typ": title-to-grid
#import "unit.typ": units-to-grid

#let gen-draw-layout(
  config: (:),
  info: (),
) = {
  // unit-grid
  let unit-grid = units-to-grid(
    config: config,
    units-info: info.filter(it => {
      it.draw-layout-type == type-unit
    }),
  )

  // left-note
  let left-note-grid = notes-to-grid(
    config: config,
    notes-info: info.filter(it => {
      it.draw-layout-type == type-note and it.side == "left"
    }),
  )

  // right-note
  let right-note-grid = notes-to-grid(
    config: config,
    notes-info: info.filter(it => {
      it.draw-layout-type == type-note and it.side == "right"
    }),
  )


  // top-title
  let top-title-grid = title-to-grid(
    config: config,
    titles-info: info.filter(it => {
      it.draw-layout-type == type-title and it.side == "top"
    }),
  )

  // bottom-title
  let bottom-title-grid = title-to-grid(
    config: config,
    titles-info: info.filter(it => {
      it.draw-layout-type == type-title and it.side == "bottom"
    }),
  )

  // top-header
  let top-header-grid = header-to-gird(
    config: config,
    headers-info: info.filter(it => {
      it.draw-layout-type == type-header and it.side == "top"
    }),
  )

  // bottom-header
  let bottom-header-grid = header-to-gird(
    config: config,
    headers-info: info.filter(it => {
      it.draw-layout-type == type-header and it.side == "bottom"
    }),
  )

  let unit-and-note = grid(
    columns: ((1fr) * (config.left-width), (1fr) * (config.width), (1fr) * (config.right-width)),
    if (not left-note-grid == none) {
      grid.cell()[#left-note-grid]
    },
    grid.cell()[#unit-grid],
    if (not right-note-grid == none) {
      grid.cell()[#right-note-grid]
    }
  )

  return grid(
    gutter: 2pt,
    columns: 1fr,
    rows: 5,
    grid.cell()[#top-title-grid],
    grid.cell()[#top-header-grid],
    grid.cell()[#unit-and-note],
    grid.cell()[#bottom-header-grid],
    grid.cell()[#bottom-title-grid],
  )
}