import cell
import gleam/io
import gleam/iterator
import gleam/set
import gleam/string
import gleam/string_tree

pub type Grid {
  Grid(num_rows: Int, num_cols: Int, data: set.Set(Int))
}

pub fn new(num_rows: Int, num_cols: Int) -> Grid {
  Grid(num_rows, num_cols, set.new())
}

fn cell_to_index(this: Grid, row: Int, col: Int) -> Int {
  row * this.num_cols + col
}

fn index_to_cell(this: Grid, index: Int) -> #(Int, Int) {
  let row = index / this.num_cols
  let col = index - { row * this.num_cols }
  #(row, col)
}

pub fn get(this: Grid, row: Int, col: Int) -> cell.Cell {
  let index = cell_to_index(this, row, col)
  cell.from_bool(set.contains(this.data, index))
}

pub fn set(this: Grid, row: Int, col: Int, state: cell.Cell) -> Grid {
  let index = cell_to_index(this, row, col)
  let data_edit = case state {
    cell.Alive -> set.insert(this.data, index)
    cell.Dead -> set.delete(this.data, index)
  }
  Grid(num_rows: this.num_rows, num_cols: this.num_cols, data: data_edit)
}

pub fn is_cell_alive(this: Grid, row: Int, col: Int) -> Bool {
  let index = cell_to_index(this, row, col)
  set.contains(this.data, index)
}

pub fn is_any_cell_alive(this: Grid) -> Bool {
  set.size(this.data) > 0
}

pub type GridCell {
  GridCell(row: Int, col: Int, state: cell.Cell)
}

pub fn to_iterator_coords(this: Grid) -> iterator.Iterator(#(Int, Int)) {
  iterator.range(0, { this.num_rows * this.num_cols } - 1)
  |> iterator.map(fn(idx: Int) { index_to_cell(this, idx) })
}

pub fn to_iterator(this: Grid) -> iterator.Iterator(GridCell) {
  iterator.range(0, { this.num_rows * this.num_cols } - 1)
  |> iterator.map(fn(idx: Int) {
    let #(row, col) = index_to_cell(this, idx)
    let value = cell.from_bool(set.contains(this.data, idx))
    GridCell(row, col, value)
  })
}

pub fn to_string(this: Grid) -> String {
  to_iterator(this)
  |> iterator.map(fn(grid_cell: GridCell) {
    // append the cell state
    let b = string_tree.from_string(cell.to_string(grid_cell.state))

    // append a newline if needed
    case grid_cell.col {
      c if c == this.num_cols - 1 -> string_tree.append(b, "\n")
      _ -> b
    }
  })
  |> iterator.to_list
  |> string_tree.join("")
  |> string_tree.to_string
}
