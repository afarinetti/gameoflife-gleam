pub type Cell {
  Alive
  Dead
}

pub fn from_bool(state: Bool) -> Cell {
  case state {
    False -> Dead
    True -> Alive
  }
}

pub fn to_bool(state: Cell) -> Bool {
  case state {
    Alive -> True
    Dead -> False
  }
}

pub fn to_string(cell: Cell) -> String {
  case cell {
    Alive -> "◼"
    Dead -> "◻"
  }
}
