import cell
import conway_sim
import grid

pub fn main() {
  let grid1 =
    grid.new(10, 10)
    |> grid.set(0, 0, cell.Alive)
    |> grid.set(5, 5, cell.Alive)
    |> grid.display

  let game = conway_sim.new_from_grid(grid1)
  conway_sim.neighbor_count(game, 0, 0)
}
