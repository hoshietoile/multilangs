fun encode(s: string, shift: int)
  fun encode-char(c)
    if c < 'a' || c > 'z' then return c
    val base = (c - 'a').int
    val rot = (base + shift) % 26
    (rot.char + 'a')
  s.map(encode-char)

fun caesar(s: string): string
  s.encode(3)

// NOTE: Point. Trailing Lambda
fun encode2(s: string, shift: int)
  s.map fn(c)
    if c < 'a' || c > 'z' then return c
    val base = (c - 'a').int
    val rot = (base + shift) % 26
    (rot.char + 'a')

// fun println10()
//   repeat(10, fn() {
//       println("hi")
//     }
//   )
// ↕ Same ↕
// fun println10()
//   repeat(10)
//     println("hi")

fun twice(f)
  f()
  f()

fun test-twice()
  twice
    twice
      println("Hello twice")
    
fun test-twice-with()
  with twice
  with twice
  println("Hello twice")

// NOTE: Point. with expression
fun map-with-encode(s: string, shift: int): string
  with c <- s.map
  if c < 'a' || c > 'z' then return c
  val base = (c - 'a').int
  val rot = (base + shift) % 26
  (rot.char + 'a')

fun test-finally()
  with finally { println("exiting..") }
  println("entering..")
  throw("oops") + 42

fun test-finally-desugar()
  finally(
    fn() { println("exiting..") },
    fn() {
      println("entering..")
      throw("oops") + 42
    })

// Desugar process --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> -->  --> --> 
// fun test-twice()             | fun test-twice()              | fun test-twice()             | fun test-twice()                  
//   twice(fn() {               |   twice fn() {                |   twice fn()                 |   twice
//     twice(fn() {             |     twice fn() {              |     twice fn()               |     twice
//       println("Hello Twice") |       println("Hello Twice")  |       println("Hello Twice") |       println("Hello Twice")
//     })                       |     }                         |                              |
  // })                         |   }                           |                              |

// https://qiita.com/sparklingbaby/items/c819f3a88fe63341390f
effect is-verbose
  val is-verbose : bool

// same as
// effect val is-verbose : bool

effect log
  fun log-debug(msg : string) : ()
  fun log-info(msg : string) : ()

effect ctl throw-string(msg : string) : a

effect<a> ctl get() : a

fun safe-div(m : int, n : int) : throw-string int
  if n == 0
    then throw-string("ZeroDivision")
    else m / n

fun get-and-div() : <get<int>, throw-string, console> ()
  val m = get()
  val n = get()
  val result = safe-div(m, n)
  println(m.show() ++ " / " ++ n.show() ++ " = " ++ result.show())

// fun log-verbose(msg : string) : <is-verbose, console> ()
//   if is-verbose
//     println("DEBUG - " ++ msg)

// fun run-server(port : int) : <is-verbose, console> ()
//   log-verbose("Server is preparing for running...")

fun run-server() : log ()
  log-debug("Server is preparing for running...")
  log-info("Server is running...")





fun main() {
  // Hello world
  // NOTE: Point. Dot Notation
  "Hello World".caesar.println
  // "Hello World".encode2(3).println
  // "Hello World".map-with-encode(3).println
  // test-twice-with()
  // test-finally()
  // test-finally-desugar()

  // // All the same from:
  // val h = handler
  //   val is-verbose = True
  // h {
  //   run-server(1000)
  // }

  // val h' = handler val is-verbose = True
  // h' {
  //   run-server(1000)
  // }

  // with handler val is-verbose = True
  // run-server(10000)

  // with val is-verbose = True
  // run-server(50000)
  // // All the same to:

  // with handler
  //   fun log-debug(msg) println("DEBUG - " ++ msg)
  //   fun log-info(msg) println("INFO - " ++ msg)
  // run-server(1000)
  with ctl throw-string(msg) println("Fatal : " ++ msg)
  with ctl get() resume(10)
  get-and-div()
  // println("1 / 0 + 10 = " ++ show(result))
}