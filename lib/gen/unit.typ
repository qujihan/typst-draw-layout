#let cell-for-completion-line(row: 0, col: 0, len: 0, unit-info: none) = {
  let grid-body = ()

  let body = if unit-info == none or unit-info.body.len() < 2 {
    sym.space
  } else {
    unit-info.body.at(1)
  }

  grid-body.push(grid.cell(colspan: len, stroke: none)[#body])

  return grid-body
}

#let gen-grid-cell(draw-config: (:), config: (:), unit-info: (:), content-body-index: 0) = {
  let grid-body = ()

  // 如果 content-body-index 超过了 body 的长度，则取最后一个
  // If the body-index exceeds the length of the body, take the last
  if content-body-index >= unit-info.body.len() {
    content-body-index = unit-info.body.len() - 1
  }

  grid-body.push(grid.cell(
    colspan: draw-config.len,
    fill: unit-info.fill,
    stroke: config.table-stroke,
  )[#unit-info.body.at(content-body-index)])

  if not unit-info.keeping-line and draw-config.curr-cell-end > draw-config.prev-cell-start {
    grid-body.push(grid.hline(
      position: top,
      y: draw-config.row-num,
      start: draw-config.prev-cell-start,
      end: draw-config.curr-cell-end,
      stroke: none,
    ))
  }

  return grid-body
}

#let units-to-main-grid-cells(config: (:), units-info: (:)) = {
  let cells = ()
  let max-col = config.width
  let curr-row = 0
  let curr-col = 0

  // cell body
  for unit-info in units-info {
    let len-need-process = unit-info.len
    let prev-cell-start = max-col
    let prev-cell-end = 0
    let content-body-index = 0
    // 这个 unit 可能会被分成多个 cell
    // 大多数是需要换行
    // This unit may be divided into multiple cells
    // Most of them need to wrap
    while len-need-process > 0 {
      let curr-cell-len = calc.min(max-col - curr-col, len-need-process)
      let curr-cell-start = curr-col
      let curr-cell-end = curr-cell-start + curr-cell-len
      len-need-process = len-need-process - curr-cell-len

      cells.push(gen-grid-cell(
        // 这个注释为了防止这段代码被被 typstfmt 格式化
        // This comment is to prevent this code from being formatted by typstfmt
        draw-config: (
          len: curr-cell-len,
          row-num: curr-row,
          // 记录上一个 cell 的开始和结束位置
          // 为了绘制 cell 之间的分割线
          // Record the start and end positions of the previous cell
          // To draw the dividing line between cells
          prev-cell-start: prev-cell-start,
          prev-cell-end: prev-cell-end,
          curr-cell-start: curr-cell-start,
          curr-cell-end: curr-cell-end,
        ),
        config: config,
        unit-info: unit-info,
        content-body-index: content-body-index,
      ))

      if (curr-cell-end >= max-col) {
        curr-row = curr-row + 1
      }
      content-body-index = content-body-index + 1
      curr-col = calc.rem(curr-col + curr-cell-len, max-col)

      prev-cell-start = curr-cell-start
      prev-cell-end = curr-cell-end
    }

    // 如果当前是第一列，则不需要换行
    // 如果设置了 completion 且当前行还有剩余空间，则换行
    // If it is the first column, no need to wrap
    // If completion is set and there is still space on the current line, wrap
    if not curr-col == 0 and unit-info.completion {
      cells.push(cell-for-completion-line(row: curr-row, col: curr-col, len: max-col - curr-col, unit-info: unit-info))
      curr-col = 0
      curr-row = curr-row + 1
    }
  }

  return cells
}

#let units-to-grid(config: (:), units-info: (:)) = {
  if units-info.len() == 0 {
    return none
  }

  return grid(
    stroke: none,
    fill: config.table-fill,
    align: config.table-align,
    columns: (1fr,) * config.width,
    rows: config.rows-size,
    ..{
      for cell in units-to-main-grid-cells(config: config, units-info: units-info) {
        cell
      }
    },
  )
}