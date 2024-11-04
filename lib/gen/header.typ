#let pos-info-check(config: (:), pos-info: (:)) = {
  assert(
    pos-info.filter(it => it.end-pos > config.width).len() == 0,
    message: "header-unit end-pos should be less than or equal to totol columns, totol columns is: " + str(config.width),
  )
}

#let contern-header-grid(config: (:), header-info: ()) = {
  let pos-info = header-info.pos-info
  pos-info-check(config: config, pos-info: pos-info)
  let cells = ()
  for unit in pos-info {
    if unit.start-pos > config.width {
      continue
    }
    cells.push(
      grid.cell(
        x: unit.start-pos,
        colspan: unit.end-pos - unit.start-pos + 1,
      )[#unit.body],
    )
  }

  for i in range(0, config.width - pos-info.map(it => it.end-pos - it.start-pos + 1).sum()) {
    cells.push(grid.cell()[#sym.space])
  }

  return grid(
    rows: header-info.unit-height,
    align: header-info.position,
    stroke: header-info.border-line,
    columns: (1fr,) * config.width,
    ..{
      for cell in cells {
        (cell,)
      }
    }
  )
}

#let faker-note-and-header(config: (:), header-info: ()) = grid(
  columns: ((1fr) * (config.left-width), (1fr) * (config.width), (1fr) * (config.right-width)),
  grid.cell()[#sym.space],
  grid.cell()[#contern-header-grid(config: config, header-info: header-info)],
  grid.cell()[#sym.space]
)


#let header-to-gird(config: (:), headers-info: (:)) = {
  if headers-info.len() == 0 {
    return none
  }

  let cells = ()
  for header-info in headers-info {
    cells.push(faker-note-and-header(config: config, header-info: header-info))
  }

  return grid(
    ..{
      for cell in cells {
        (cell,)
      }
    }
  )


  // return faker-note-and-header(config: config)
}