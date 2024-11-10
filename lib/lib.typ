#import "gen/mod.typ": *
#import "type/mod.typ": *

#let draw-layout(
  width: 32,
  main-body-precent: 50,
  left-note-precent: 25,
  right-note-precent: 25,
  table-stroke: 1pt,
  table-inset: 1em,
  table-fill: none,
  table-align: center + horizon,
  row-size-basic: 1cm,
  rows-size: (:),
  ..args,
) = {
  let info = args.pos()

  for i in info {
    assert(
      "draw-layout-type" in i,
      message: "draw-layout: you must use header/title/note/unit function, reference: github.com/qujihan/type-draw-layout/doc/help.md",
    )
  }

  return gen-draw-layout(
    config: draw-format-config(
      width,
      row-size-basic: row-size-basic,
      rows-size: rows-size,
      main-body-precent: main-body-precent,
      left-note-precent: left-note-precent,
      right-note-precent: right-note-precent,
      table-stroke: table-stroke,
      table-inset: table-inset,
      table-fill: table-fill,
      table-align: table-align,
      info: info,
    ),
    info: info,
  )
}