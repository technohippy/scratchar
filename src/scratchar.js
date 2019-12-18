const parser = require("./scratchar-parser")

let tree = parser.parse(`
^|when FLAG clicked|
:|go to x: (0) y: (0)|
:|show|

^|when FLAG clicked|
:|set [*TYPE*] to (1)|
:{forever
::|set [*last type*] to (TYPE)|
::|broadcast (*clear*) and wait|
::|setup|
::{repeat until <not <(TYPE) = (last type)>>
:::|broadcast (*first*)|
:::|broadcast (*tick*)|
::}
_}

~|make a block |Setup Dragon||
:|set [*SPACING*] to (6)|
:|set [*SCROLL X*] to (1)|
:|set [*BOUNDED*] to (0)|
:|set [*id*] to (0)|
:|set size to (65) %|
:|switch costume to (*costume3*)|
:{repeat (5)
::{repeat (5)
:::|goto (*random position*)|
:::|create clone of (*myself*)|
::}
::|next costume|
:}
:{repeat (1)
::{repeat (2)
::}
:}
`)
console.log(tree)

/*
let tree = parser.parse(`
^|when FLAG clicked|
:|go to x: (0) y: (0)|
:|show|
`)
console.log(tree)
*/

/*
let tree = parser.parse(`
^|when FLAG clicked|
:|set [*TYPE*] to (1)|
:{forever
::|set [*last type*] to (TYPE)|
::|broadcast (*clear*) and wait|
::|setup|
::{repeat until <not <(TYPE) = (last type)>>
:::|broadcast (*first*)|
:::|broadcast (*tick*)|
::}
_}
`)
console.log(tree)
*/

/*
let tree = parser.parse(`
~|make a block |Setup Dragon||
:|set [*SPACING*] to (6)|
:|set [*SCROLL X*] to (1)|
:|set [*BOUNDED*] to (0)|
:|set [*id*] to (0)|
:|set size to (65) %|
:|switch costume to (*costume3*)|
:{repeat (5)
::{repeat (5)
:::|goto (*random position*)|
:::|create clone of (*myself*)|
::}
::|next costume|
:}
:{repeat (1)
::{repeat (2)
::}
:}
`)
console.log(tree)
*/
