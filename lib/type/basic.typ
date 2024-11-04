#import "unit.typ": type-unit

#let draw-format-config(
  width,
  main-body-precent: none,
  left-note-precent: none,
  right-note-precent: none,
  table-stroke: none,
  table-inset: auto,
  table-fill: auto,
  table-align: auto,
  row-size-basic: 1cm,
  rows-size: (:),
  info: (),
) = {
  assert(
    table-stroke == none or type(table-stroke) == color or type(table-stroke) == length or type(table-stroke) == gradient or type(table-stroke) == pattern or type(table-stroke) == dictionary or type(table-stroke) == stroke,
    message: "stroke's type should be color or length or gradient or pattern or dictionary or stroke",
  )

  assert(
    type(table-inset) == auto or type(table-inset) == length or type(table-inset) == relative or type(table-inset) == dictionary,
    message: "table-inset's type should be auto or relative or dictionary",
  )

  assert(
    table-fill == none or type(table-fill) == auto or type(table-fill) == color or type(table-fill) == gradient or type(table-fill) == pattern or type(table-fill) == dictionary,
    message: "fill's type should be none or auto or color or gradient or pattern or dictionary",
  )

  assert(
    type(table-align) == alignment or type(table-align) == auto,
    message: "table-align's type should be alignment or auto",
  )

  assert((type(row-size-basic) == length), message: "row-size-basic's type should be length")

  assert(type(rows-size) == dictionary, message: "rows-size's type should be length or dictionary")

  if type(rows-size) == dictionary {
    for v in rows-size.values() {
      assert(type(v) == length, message: "if rows-size's type is dictionary, all values should be length")
    }
  }

  // gen ((len1, completion1), (len2, completion2), ... (len_n, completion_n)) from info
  let len-and-completions = info
  .filter(it => {
    it.draw-layout-type == type-unit
  })
  .map(it => {
    (it.len, it.completion)
  })

  // calculate row-num
  let row-num = 1
  let remaining-len = width
  for len-and-completion in len-and-completions {
    let len = len-and-completion.at(0)
    let completion = len-and-completion.at(1)
    while (len > 0) {
      if remaining-len == 0 {
        row-num = row-num + 1
        remaining-len = width
      } else if len <= remaining-len {
        remaining-len = remaining-len - len
        len = 0
      } else {
        len = len - remaining-len
        remaining-len = 0
      }
    }
    if completion and remaining-len > 0 {
      row-num = row-num + 1
      remaining-len = width
    }
  }

  // calculate every row's size
  let new-rows-size = ()
  if type(rows-size) == length {
    new-rows-size = rows-size
  } else if type(rows-size) == dictionary {
    for i in range(0, row-num) {
      if str(i) in rows-size {
        new-rows-size.push(rows-size.at(str(i)))
      } else {
        new-rows-size.push(row-size-basic)
      }
    }
  }

  return (
    width: width,
    main-body-precent: main-body-precent,
    left-note-precent: left-note-precent,
    right-note-precent: right-note-precent,
    table-stroke: table-stroke,
    table-inset: table-inset,
    table-fill: table-fill,
    table-align: table-align,
    row-num: row-num,
    rows-size: new-rows-size,
  )
}