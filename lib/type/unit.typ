#let type-unit = "type-unit"

#let unit(len, fill: none, keeping-line: false, completion: false, ..body) = {
  assert(type(len) == int, message: "len's type should be int")
  assert(
    fill == none or type(fill) == color or type(fill) == gradient or type(fill) == pattern,
    message: "fill's type should be color or gradient or pattern",
  )
  assert(type(keeping-line) == bool, message: "keeping-line's type should be bool")
  assert(type(completion) == bool, message: "completion's type should be bool")

  return (
    draw-layout-type: type-unit,
    len: len,
    fill: fill,
    keeping-line: keeping-line,
    completion: completion,
    body: body.pos(),
  )
}