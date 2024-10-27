import gleam/io
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

  let neighbors = []

  case row, col {
    // check the top left neighbor
    row, col if row > 0 && col > 0 -> {
      io.debug("top left")
    }

    // check the top center neighbor
    row, _ if row > 0 -> {
      io.debug("top center")
    }

    // check the top right neighbor
    row, col if row > 0 && col + 1 < this.grid.num_cols -> {
      io.debug("top right")
    }

    _, _ -> io.debug("todo")
  }

  0
}
