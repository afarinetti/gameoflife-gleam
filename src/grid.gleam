import cell
import gleam/io
import gleam/iterator
import gleam/set

pub type Grid {
  Grid(num_rows: Int, num_cols: Int, grid: set.Set(Int))
}

pub fn new(num_rows: Int, num_cols: Int) -> Grid {
  Grid(num_rows, num_cols, set.new())
}

fn cell_to_index(this: Grid, row: Int, col: Int) -> Int {
  row * this.num_cols + col
}

pub fn get(this: Grid, row: Int, col: Int) -> cell.Cell {
  let index = cell_to_index(this, row, col)
  cell.from_bool(set.contains(this.grid, index))
}

pub fn set(this: Grid, row: Int, col: Int, state: cell.Cell) -> Grid {
  let index = cell_to_index(this, row, col)
  let grid = case state {
    cell.Alive -> set.insert(this.grid, index)
    cell.Dead -> set.delete(this.grid, index)
  }
  Grid(num_rows: this.num_rows, num_cols: this.num_cols, grid: grid)
}

pub fn is_cell_alive(this: Grid, row: Int, col: Int) -> Bool {
  let index = cell_to_index(this, row, col)
  set.contains(this.grid, index)
}

pub fn is_any_cell_alive(this: Grid) -> Bool {
  set.size(this.grid) > 0
}

pub type GridCell {
  GridCell(row: Int, col: Int, state: cell.Cell)
}

pub fn to_iterator(this: Grid) -> iterator.Iterator(#(Int, cell.Cell)) {
  iterator.range(0, { this.num_rows * this.num_cols } - 1)
  |> iterator.map(fn(idx) {
    #(idx, cell.from_bool(set.contains(this.grid, idx)))
  })
}

// pub fn to_iterator2(this: Grid) -> iterator.Iterator(GridCell) {
//   iterator.range(0, this.num_rows - 1)
//   |> iterator.zip(iterator.range(0, this.num_cols - 1))
//   |> iterator.to_list
//   |> io.debug
//   iterator.empty()
// }

pub fn display(this: Grid) -> Grid {
  to_iterator(this)
  |> iterator.each(fn(tuple) {
    io.print(cell.to_string(tuple.1))
    case tuple.0 {
      idx if { idx + 1 } % this.num_cols == 0 -> io.println("")
      _ -> Nil
    }
  })
  this
}
