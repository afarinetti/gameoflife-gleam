import cell
import fmglee

pub type Operation {
  Operation(row: Int, col: Int, state: cell.Cell)
}

pub fn new(row: Int, col: Int, state: cell.Cell) {
  Operation(row, col, state)
}

pub fn to_string(op: Operation) -> String {
  fmglee.new("Operation[row: %d, col: %d, state: '%s']")
  |> fmglee.d(op.row)
  |> fmglee.d(op.col)
  |> fmglee.s(cell.to_string(op.state))
  |> fmglee.build
}
