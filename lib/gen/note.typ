#let note-info-check(config: (:), notes-info-after-sortd: ()) = {
  let prev-note-end = -1
  for note-info in notes-info-after-sortd {
    assert(
      note-info.start-row > prev-note-end,
      message: "note start-row should be greater than previous note end-row",
    )
    prev-note-end = note-info.end-row
  }

  assert(
    notes-info-after-sortd.filter(it => it.end-row > config.row-num).len() == 0,
    message: "note end-row should be less than or equal to totol rows, totol rows is: " + str(config.row-num),
  )
}

#let get-body(note-info) = {
  if note-info.bracket == "curly" {
    if note-info.side == "right" {
      return box(
        height: 100%,
        inset: (left: 0pt),
        layout(size => {
          math.lr("}", size: size.height)
        }),
      )
    } else if note-info.side == "left" {
      return box(
        height: 100%,
        inset: (right: 0pt),
        layout(size => {
          math.lr("{", size: size.height)
        }),
      )
    }
  }
}

#let note-config-to-cells(config: (:), notes-info: ()) = {
  let notes-info-after-sortd = notes-info.sorted(key: it => it.start-row)
  note-info-check(config: config, notes-info-after-sortd: notes-info-after-sortd)
  let cells = ()

  let used-space = 0
  for note-info in notes-info-after-sortd {
    let rowspan = note-info.end-row - note-info.start-row + 1
    used-space = used-space + rowspan
    let get-symbol = get-body(note-info)

    cells.push(
      grid.cell(
        fill: note-info.fill,
        align: note-info.position,
        inset: 2pt,
        y: note-info.start-row,
        rowspan: rowspan,
      )[
        #align(note-info.position)[
          #if note-info.side == "right" {
            block(fill: note-info.fill)[
              #get-symbol
              #box(height: 100%)[
                #note-info.body
              ]
            ]
          } else if note-info.side == "left" {
            block(fill: note-info.fill)[
              #box(height: 100%)[
                #note-info.body
              ]
              #get-symbol
            ]
          }
        ]
      ],
    )
  }

  for i in range(0, config.row-num * 2 - used-space) {
    cells.push(grid.cell(inset: config.table-inset)[#sym.space])
  }

  return cells
}


#let notes-to-grid(config: (:), notes-info: ()) = {
  if notes-info.len() == 0 {
    return none
  }

  let cells = note-config-to-cells(config: config, notes-info: notes-info)
  let side = notes-info.at(0).side

  return grid(
    // stroke: 1pt,
    fill: config.table-fill,
    align: config.table-align,
    columns: (1fr, 0pt),
    rows: config.rows-size,
    ..{
      for cell in cells {
        (cell,)
      }
    },
  )
}