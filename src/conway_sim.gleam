import gleam/list
import grid

pub type ConwaySim {
  ConwaySim(grid: grid.Grid, generation: Int)
}

pub fn new(num_rows: Int, num_cols: Int) -> ConwaySim {
  ConwaySim(grid.new(num_rows, num_cols), 0)
}

pub fn new_from_grid(grid: grid.Grid) -> ConwaySim {
  ConwaySim(grid, 0)
}

pub fn neighbor_count(this: ConwaySim, row: Int, col: Int) -> Int {
  // 0 1 2
  // 3 X 4
  // 5 6 7

  // define all possible neighbor positions relative to current cell
  let neighbors = [
    // top left
    #(row - 1, col - 1),
    // top center
    #(row - 1, col),
    // top right
    #(row - 1, col + 1),
    // left
    #(row, col - 1),
    // right
    #(row, col + 1),
    // bottom left
    #(row + 1, col - 1),
    // bottom center
    #(row + 1, col),
    // bottom right
    #(row + 1, col + 1),
  ]

  // filter out neighbors that are not alive
  neighbors
  |> list.filter(fn(pos) { is_valid_position(this, pos) })
  |> list.filter(fn(pos) {
    let #(r, c) = pos
    grid.is_cell_alive(this.grid, r, c)
  })
  |> list.length
}

fn is_valid_position(this: ConwaySim, pos: #(Int, Int)) -> Bool {
  let #(row, col) = pos
  row >= 0 && row < this.grid.num_rows && col >= 0 && col < this.grid.num_cols
}
