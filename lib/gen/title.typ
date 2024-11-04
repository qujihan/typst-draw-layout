#let title-config-to-cells(config: (:), titles-info: ()) = {
  let cells = ()
  for title-info in titles-info {
    cells.push((
      grid.cell()[
        #box(
          width: 100%,
          height: title-info.height,
          fill: title-info.fill,
          inset: 1em,
        )[
          #align(title-info.position)[
            #title-info.body
          ]
        ]
      ],
    ))
  }
  return cells
}

#let title-to-grid(config: (:), titles-info: ()) = {
  if titles-info.len() == 0 {
    return none
  }

  return grid(
    align: center,
    columns: 1fr,
    rows: auto,
    fill: none,
    stroke: none,
    ..{
      for cell in title-config-to-cells(config: config, titles-info: titles-info) {
        cell
      }
    }
  )
}