fun square(x : int)
  x * x

fun divide(x : int, y : int)
  if y == 0 then throw("divide by zero")
  x / y

fun fact(n : int) : div int
  if n == 0 then 1
  else n * fact (n - 1)

fun log(i : int)
  println(i)
  i

fun map-maybe(m : maybe<a>, f : a -> e b) : e maybe<b>
  match m
    Just(v) -> v.f.Just
    Nothing -> Nothing

fun main()
  Just(3).map-maybe(square)
  Just(10).map-maybe(fact)
