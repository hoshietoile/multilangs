import gleam/string
import gleam/iterator as it
import gleam/io
import gleam/erlang/process

const tick_time = 1_000

pub type Status {
  Alive
  Dead
}

pub fn loop(accum: Int, list: List(Status)) {
  let new_list = list |> update_outer
  io.println(new_list |> print)
  process.sleep(tick_time)
  loop(accum + 1, new_list)
}

pub fn initialize_list() -> List(Status) {
  it.range(0, 400)
  |> it.map(fn(i) {
    case i % 5 {
      0 -> Dead
      1 -> Alive
      _ -> Dead
    }
  })
  |> it.to_list
}

pub fn initialize_list2() -> List(Int) {
  it.range(0, 400)
  |> it.map(fn(i) { i })
  |> it.to_list
}

pub fn take_n_from(iter: it.Iterator(t), from: Int, n: Int) -> it.Iterator(t) {
  iter
  |> it.drop(from)
  |> it.take(n)
}

pub fn count_alives(iter: it.Iterator(Status)) -> Int {
  iter
  |> it.map(fn(st) {
    case st {
      Alive -> 1
      Dead -> 0
    }
  })
  |> it.fold(0, fn(ac, cur) { ac + cur })
}

pub fn count_surroundings(list: List(Status), index: Int) {
  let iter = it.from_list(list)
  let lowest_index = {index - 20 - 1 + 400} % 400
  let upper_index = {index + 20 - 1 + 400} % 400
  
  let uppers = iter
    |> take_n_from(lowest_index, 3)
    |> it.to_list

  let lowers = iter 
    |> take_n_from(upper_index, 3)
    |> it.to_list

  let left = iter |> it.at(index - 1)
  let right = iter |> it.at(index + 1)

  let counts = case left, right {
    Ok(Alive), Ok(Alive) -> 2
    Ok(Alive), Ok(Dead) -> 1
    Ok(Dead), Ok(Alive) -> 1
    _1, _2 -> 0
  }

  let upper_cnt = count_alives(it.from_list(uppers))
  let lower_cnt = count_alives(it.from_list(lowers))

  counts + upper_cnt + lower_cnt
}

pub fn print(list: List(Status)) -> String {
  let chunked = list
  |> it.from_list
  |> it.map(fn(el) {
    case el {
      Alive -> "■"
      Dead -> "□"
    }
  })
  |> it.sized_chunk(into: 20)

  chunked
  |> it.map(fn(ls) { ls |> string.join("") })
  |> it.to_list
  |> string.join("\n")
}

pub fn update(whole_list: List(Status), list: List(Status), index: Int, new_list: List(Status)) -> List(Status) {
  case list {
    [] -> new_list
    [_, ..rest] -> {
      let alive_count = count_surroundings(whole_list, index)
      case alive_count {
        3 -> update(whole_list, rest, index + 1, [Alive, ..new_list]) 
        _ -> update(whole_list, rest, index + 1, [Dead, ..new_list]) 
      }
    }
  }
}

pub fn update_outer(list: List(Status)) -> List(Status) {
  list |> update(list, 0, [])
}

pub fn main() {
  let list = initialize_list()
  loop(0, list)
}
