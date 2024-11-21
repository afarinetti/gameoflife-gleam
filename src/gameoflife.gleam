import cell
import conway_sim
import gleam/io
import gleam/iterator
import gleam/list
import grid

pub fn main() {
  let grid1 =
    grid.new(10, 10)
    |> grid.set(1, 1, cell.Alive)
    |> grid.set(1, 2, cell.Alive)
    |> grid.set(2, 1, cell.Alive)
    |> grid.set(2, 2, cell.Alive)
    |> grid.set(3, 3, cell.Alive)
    |> grid.set(3, 4, cell.Alive)
    |> grid.set(4, 3, cell.Alive)
    |> grid.set(4, 4, cell.Alive)

  // let grid1 =
  //   grid.new(10, 10)
  //   |> grid.set(1, 6, cell.Alive)
  //   |> grid.set(1, 7, cell.Alive)
  //   |> grid.set(1, 8, cell.Alive)

  let sim1 = conway_sim.new_from_grid(grid1)
  io.println(conway_sim.to_string(sim1))

  iterator.range(1, 30)
  |> iterator.fold_until(sim1, fn(sim, _) {
    let any_cell_alive = grid.is_any_cell_alive(sim.grid)

    case any_cell_alive {
      True -> {
        let sim_after_step = conway_sim.step(sim)
        io.println(conway_sim.to_string(sim_after_step))
        list.Continue(sim_after_step)
      }
      False -> list.Stop(sim)
    }
  })
}
