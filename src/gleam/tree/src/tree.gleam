import gleam/int
import gleam/string
import gleam/iterator
import gleam/io

pub type Tree {
  Node(#(Int, Tree, Tree))
  Null
}

pub fn null() -> Tree {
  Null
}

pub fn node(i: Int) -> Tree {
  Node(#(i, Null, Null))
}

pub fn insert(tree: Tree, node: Tree) -> Tree {
  case tree, node {
    Node(#(value1, left1, right1)), Node(#(value2, _1, _2)) -> {
      case value1 > value2 {
        True -> Node(#(value1, left1 |> insert(node), right1))
        _ -> Node(#(value1, left1, right1 |> insert(node)))
      }
    }
    Node(_), Null -> tree
    Null, Node(_) -> node
    _1, _2 -> tree
  }
}

pub fn delete(tree: Tree, i: Int) -> Tree {
  case tree {
    Null -> tree
    Node(#(value, left, right)) ->
      case value == i, value > i  {
        True, _1 -> right |> insert(left)
        False, True -> Node(#(value, left |> delete(i), right))
        False, False -> Node(#(value, left, right |> delete(i)))
      }
  }
}

fn search_priv(tree: Tree, i: Int, depth: Int) -> Result(Int, Nil) {
  case tree {
    Null -> Error(Nil)
    Node(#(v, left, right)) -> {
      case v == i, v > i {
        True, _1 -> Ok(depth)
        False, True -> left |> search_priv(i, depth + 1)
        False, False -> right |> search_priv(i, depth + 1)
      }
    }
  }
}

pub fn search(tree: Tree, i: Int) -> Result(Int, Nil) {
  search_priv(tree, i, 0)
}

pub fn from_list(list: List(Int), tree: Tree) -> Tree {
  case list {
    [] -> tree
    [fst, ..rest] -> {
      let node = node(fst)
      let new_tree = tree |> insert(node)
      from_list(rest, new_tree)
    }
  }
}

pub fn indent(depth: Int) -> String {
  iterator.from_list(["  "])
  |> iterator.cycle
  |> iterator.take(depth)
  |> iterator.to_list
  |> string.join("")
}

fn format_priv(tree: Tree, depth: Int, thunk: String, left_or_right: Int) -> String {
  let prepend = case left_or_right {
    1 -> "L: "
    2 -> "R: "
    _ -> ""
  }
  case tree {
    Null -> indent(depth) <> prepend <> "Null\n"
    Node(#(v, left, right)) -> {
      let new_thunk = indent(depth) <> prepend <> "node(" <> int.to_string(v) <> ")\n"
      let new_depth = depth + 1
      let left_output = format_priv(left, new_depth, "", 1)
      let right_output = format_priv(right, new_depth, "", 2)
      thunk <> new_thunk <> left_output <> right_output
    }
  }
}

pub fn format(tree: Tree) -> String {
  format_priv(tree, 0, "", 0)
}

pub fn main() {
  let list = [30, 20, 10, 40, 50, 100, 90]
  let result = list |> from_list(null())
  io.debug(result)
  let result2 = result |> delete(100) |> delete(20) |> delete(40)

  io.println(format(result))
  io.debug(result |> search(100))
  io.debug(result |> search(90))
  io.println("-----")
  io.println(format(result2))
  io.debug(result2 |> search(100))
  io.debug(result2 |> search(90))
}
