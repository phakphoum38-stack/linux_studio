class CursorPosition {
  int row;
  int col;

  CursorPosition({
    this.row = 0,
    this.col = 0,
  });

  CursorPosition copy() {
    return CursorPosition(
      row: row,
      col: col,
    );
  }

  void set(
    int newRow,
    int newCol,
  ) {
    row = newRow;
    col = newCol;
  }

  void reset() {
    row = 0;
    col = 0;
  }
}
