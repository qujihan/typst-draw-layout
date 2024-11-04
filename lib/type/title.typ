#let type-title = "type-title"
#let type-title-left = "type-title-left"
#let type-title-rifht = "type-title-right"

#let title(
  side: "top", // "top" | "bottom" (default: "top")
  fill: none,
  height: 2em,
  position: center + horizon,
  body,
) = {
  assert(
    type(side) == str and (side == "top" or side == "bottom"),
    message: "Usage: side: top | bottom",
  )

  assert(
    type(position) == alignment,
    message: "position's type should be alignment",
  )

  assert(
    fill == none or type(fill) == color or type(fill) == gradient or type(fill) == pattern,
    message: "fill's type should be color or gradient or pattern",
  )

  return (
    draw-layout-type: type-title,
    side: side,
    fill: fill,
    height: height,
    position: position,
    body: body,
  )
}