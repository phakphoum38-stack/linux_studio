class CursorPosition {
  int row;
  int col;

  CursorPosition({
    this.row = 0,
    this.col = 0,
  });

  CursorPosition copy() =>
      CursorPosition(row: row, col: col);

  void set(int r, int c) {
    row = r;
    col = c;
  }
}
