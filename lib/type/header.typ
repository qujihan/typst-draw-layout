#let type-header = "type-header"
#let type-header-left = "type-header-left"
#let type-header-rifht = "type-header-right"
#let type-header-unit = "type-header-unit"
#let header-unit(
  start-pos,
  end-pos: -1,
  body,
) = {
  assert(
    type(start-pos) == int,
    message: "start-pos's type should be int",
  )

  assert(
    start-pos > 0,
    message: "start-pos should be greater than 0 (1 is the first column index)",
  )

  if end-pos == -1 {
    end-pos = start-pos
  }

  assert(
    start-pos <= end-pos,
    message: "start-pos should be less than or equal to end-pos",
  )

  start-pos = start-pos - 1
  end-pos = end-pos - 1

  return (
    draw-layout-type: type-header-unit,
    start-pos: start-pos,
    end-pos: end-pos,
    body: body,
  )
}

#let header(
  side: "top", // "top" | "bottom" (default: "top")
  fill:none,
  border-line:none,
  unit-height: 2em,
  position: left + bottom,
  ..args,
) = {
  assert(
    type(side) == str and (side == "top" or side == "bottom"),
    message: "Usage: side: top | bottom",
  )

  assert(
    type(position) == alignment,
    message: "position's type should be alignment",
  )

  let infos = args.pos()


  for pos-info in infos {
    assert(
      type(pos-info) == dictionary and "draw-layout-type" in pos-info,
      message: "Please use header-unit function to generate header content",
    )

  }

  let sorted-pos-info = infos.sorted(key: it => it.start-pos)
  let prev-unit-end = -1
  for unit in sorted-pos-info {
    assert(
      unit.start-pos > prev-unit-end,
      message: "header-unit start-pos should be greater than previous unit end-pos",
    )
    prev-unit-end = unit.end-pos
  }

  return (
    draw-layout-type: type-header,
    side: side,
    fill: fill,
    border-line: border-line,
    unit-height: unit-height,
    position: position,
    pos-info: sorted-pos-info,
  )
}