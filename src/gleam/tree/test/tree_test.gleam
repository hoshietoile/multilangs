import gleeunit
import gleeunit/should
import tree as t

pub fn main() {
  gleeunit.main()
}

pub fn nil_test() {
  let nil = t.null()
  nil |> should.equal(t.Null)
}

pub fn node_test() {
  let node = t.node(10)
  node |> should.equal(t.Node(#(10, t.Null, t.Null)))
}

pub fn insert_test() {
  // insert into empty node.
  let root = t.null()

  // insert empty node into empty node.
  let tree = root |> t.insert(t.null())
  tree |> should.equal(t.null())

  // insert single node into empty node.
  let tree = root |> t.insert(t.node(10))
  tree |> should.equal(t.node(10)) 

  // insert into single node.
  let root = t.node(100)

  // insert empty node into single node.
  let tree = root |> t.insert(t.null())
  tree |> should.equal(root)

  // insert single node.
  let nd = t.node(10)
  let tree = root |> t.insert(nd)
  tree |> should.equal(t.Node(#(100, t.Node(#(10, t.Null, t.Null)), t.Null)))

  // insert tree into single node.
  // 200
  //   L: 10
  //     L: Null
  //     R: Null
  //   R: 300
  //     L: Null
  //     R: 400
  let tr = t.Node(#(200, t.Node(#(10, t.Null, t.Null)), t.Node(#(300, t.Null, t.Node(#(400, t.Null, t.Null))))))
  let tree = root |> t.insert(tr)
  // 100
  //  L: Null
  //  R: 200
  //   L: 10
  //     L: Null
  //     R: Null
  //   R: 300
  //     L: Null
  //     R: 400
  tree |> should.equal(
    t.Node(#(
      100,
      t.Null,
      t.Node(#(
        200,
        t.Node(#(10, t.Null, t.Null)),
        t.Node(#(
          300,
          t.Null,
          t.Node(#(400, t.Null, t.Null)))))),
    ))
  )

  // insert tree into tree.
  // 200
  //  L: 100
  //   L: 50
  //    L: Null
  //    R: Null
  //   R: Null
  //  R: 1000
  //   L: Null
  //   R: Null
  let root = t.Node(#(
    200,
    t.Node(#(
      100,
      t.Node(#(
        50,
        t.Null,
        t.Null,
      )),
      t.Null)),
    t.Node(#(
      1000,
      t.Null,
      t.Null))))
  // 400
  //  L: Null
  //  R: 500
  //   L: Null
  //   R: 600
  //    L: 700
  //     L: Null
  //     R: Null
  //    R: Null
  let tr = t.Node(#(
    400,
    t.Null,
    t.Node(#(
      500,
      t.Null,
      t.Node(#(
        600,
        t.Null,
        t.Node(#(
          700,
          t.Null,
          t.Null,
        )),
      )),
    )),
  )) 

  // 200
  //  L: 100
  //   L: 50
  //    L: Null
  //    R: Null
  //   R: Null
  //  R: 1000
  //   L: 400
  //    L: Null
  //    R: 500
  //     L: Null
  //     R: 600
  //      L: 700
  //       L: Null
  //       R: Null
  //      R: Null
  //   R: Null
  let tree = root |> t.insert(tr)
  tree |> should.equal(
    t.Node(#(
      200,
      t.Node(#(
        100,
        t.Node(#(
          50,
          t.Null,
          t.Null,
        )),
        t.Null)),
      t.Node(#(
        1000,
        t.Node(#(
          400,
          t.Null,
          t.Node(#(
            500,
            t.Null,
            t.Node(#(
              600,
              t.Null,
              t.Node(#(
                700,
                t.Null,
                t.Null,
              )),
            )),
          )),
        )) ,
        t.Null))))
  )
}

pub fn from_list_test() {
  // insert empty list to empty tree.
  let list = []
  let tree = list |> t.from_list(t.Null)
  tree |> should.equal(t.Null)

  let node = t.Node(#(
    2,
    t.node(1),
    t.node(3),
  ))

  // insert empty list to tree.
  let list = []
  let tree = list |> t.from_list(node)
  tree |> should.equal(node)

  // insert list to empty tree.
  let list = [2,1,3]
  let tree = list |> t.from_list(t.Null)
  tree |> should.equal(node)

  // insert list to tree.
  let node2 = node |> t.insert(t.node(4)) |> t.insert(t.node(5))
  let list = [4,5]
  let tree = list |> t.from_list(node)
  tree |> should.equal(node2)
}

pub fn delete_test() {
  let list = [2,1,3,4,5]
  let tree = list |> t.from_list(t.null())

  // case delete target not found.
  let tr = tree |> t.delete(10)
  tr |> should.equal(tree)

  // case delete target found.
  let delete_result_tree = tree |> t.delete(3)
  let comp_list = [2,1,4,5]
  let comp_tree = comp_list |> t.from_list(t.null())
  delete_result_tree |> should.equal(comp_tree)
}

pub fn search_test() {
  let list = [2,1,3,4,5]
  let tree = list |> t.from_list(t.null())

  // case search target not found.
  let nothing = tree |> t.search(10)
  nothing |> should.equal(Error(Nil))

  // case search target found.
  let depth = tree |> t.search(3)
  depth |> should.equal(Ok(1))

  let list = [1,2,3,4,5,6,7,8,9,10]
  let tree = list |> t.from_list(t.null())

  // case search target found at depth 10(9).
  let depth = tree |> t.search(10)
  depth |> should.equal(Ok(9))
}