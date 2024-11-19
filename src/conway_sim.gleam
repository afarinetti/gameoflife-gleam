import cell
import gleam/list
import gleam/option
import grid
import operation

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
  |> list.filter(fn(pos) { grid.is_cell_alive(this.grid, pos.0, pos.1) })
  |> list.length
}

fn is_valid_position(this: ConwaySim, pos: #(Int, Int)) -> Bool {
  let #(row, col) = pos
  row >= 0 && row < this.grid.num_rows && col >= 0 && col < this.grid.num_cols
}

fn apply_rules(
  this: ConwaySim,
  row: Int,
  col: Int,
) -> option.Option(operation.Operation) {
  let neighbor_count = neighbor_count(this, row, col)
  let alive = grid.is_cell_alive(this.grid, row, col)

  // case alive {
  //   // RULES FOR LIVE CELLS //////////////////////////////////////////
  //   True -> {
  //     case neighbor_count {
  //       // rule 1: any live cell with fewer than two live neighbors dies,
  //       //          as if caused by under-population.
  //       c if c < 2 -> option.Some(operation.new(row, col, cell.Dead))
  //
  //       // rule 2: any live cell with two or three live neighbors lives on
  //       //          to the next generation.
  //       c if c <= 3 -> option.None
  //
  //       // rule 3: any live cell with more than three neighbors dies, as if
  //       //          caused by overcrowding.
  //       _ -> option.Some(operation.new(row, col, cell.Dead))
  //     }
  //   }
  //   // RULES FOR DEAD CELLS //////////////////////////////////////////
  //   False -> {
  //     case neighbor_count {
  //       // rule 4: any dead cell with exactly three live neighbors becomes
  //       //          a live cell, as if by reproduction.
  //       c if c == 3 -> option.Some(operation.new(row, col, cell.Alive))
  //
  //       // otherwise
  //       _ -> option.None
  //     }
  //   }
  // }

  case alive, neighbor_count {
    // RULES FOR LIVE CELLS ////////////////////////////////////////////////////
    // rule 1: any live cell with fewer than two live neighbors dies,
    //          as if caused by under-population.
    True, c if c < 2 -> option.Some(operation.new(row, col, cell.Dead))

    // rule 2: any live cell with two or three live neighbors lives on
    //          to the next generation.
    True, c if c <= 3 -> option.None

    // rule 3: any live cell with more than three neighbors dies, as if
    //          caused by overcrowding.
    True, _ -> option.Some(operation.new(row, col, cell.Dead))

    // RULES FOR DEAD CELLS ////////////////////////////////////////////////////
    // rule 4: any dead cell with exactly three live neighbors becomes
    //          a live cell, as if by reproduction.
    False, c if c == 3 -> option.Some(operation.new(row, col, cell.Alive))

    // otherwise
    False, _ -> option.None
  }
}

pub fn step(this: ConwaySim) -> ConwaySim {
  todo
}
