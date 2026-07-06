class CursorPosition {
  int row;
  int col;

  CursorPosition({
    this.row = 0,
    this.col = 0,
  });

  void set(int r, int c) {
    row = r;
    col = c;
  }

  CursorPosition copy() {
    return CursorPosition(row: row, col: col);
  }
}
