#let type-note = "type-note"
#let type-note-left = "type-note-left"
#let type-note-right = "type-note-right"

#let note(
  start-row,
  end-row: none,
  side: "right", // "right" | "left" (defaule: "right")
  postion: none,
  bracket: none, // none | "square"[] | "curly"{} (default:"curly")
  fill: none,
  body,
) = {
  assert(
    bracket == none or (type(bracket) == str and (bracket == "curly" or bracket == "square")),
    message: "Usage: bracket: none | square | curly",
  )
  assert(type(side) == str and (side == "right" or side == "left"), message: "Usage: side: right | left")
  assert(type(start-row) == int and start-row > 0, message: "start-row should be greater than 0")

  if postion == none {
    if side == "right" {
      postion = left + horizon
    } else {
      postion = right + horizon
    }
  }

  if end-row == none {
    end-row = start-row
  }

  assert(end-row >= start-row, message: "end-row should be greater than start-row")

  return (
    draw-layout-type: type-note,
    start-row: start-row - 1,
    end-row: end-row - 1,
    side: side,
    position: postion,
    bracket: bracket,
    fill: fill,
    body: body,
  )
}

