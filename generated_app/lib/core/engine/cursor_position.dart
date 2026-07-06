/// Cursor position inside the terminal buffer.
class CursorPosition {
  int row;
  int col;

  CursorPosition({
    this.row = 0,
    this.col = 0,
  });

  /// Move cursor to an absolute position.
  void moveTo(int newRow, int newCol) {
    row = newRow;
    col = newCol;
  }

  /// Alias used by other engine components.
  void set(int newRow, int newCol) {
    moveTo(newRow, newCol);
  }

  /// Move cursor relative to its current position.
  void moveBy(int dRow, int dCol) {
    row += dRow;
    col += dCol;
  }

  /// Move one row up.
  void up([int count = 1]) {
    row -= count;
    if (row < 0) row = 0;
  }

  /// Move one row down.
  void down(int maxRows, [int count = 1]) {
    row += count;
    if (row >= maxRows) {
      row = maxRows - 1;
    }
  }

  /// Move one column left.
  void left([int count = 1]) {
    col -= count;
    if (col < 0) col = 0;
  }

  /// Move one column right.
  void right(int maxCols, [int count = 1]) {
    col += count;
    if (col >= maxCols) {
      col = maxCols - 1;
    }
  }

  /// Reset to origin.
  void home() {
    row = 0;
    col = 0;
  }

  CursorPosition copy() {
    return CursorPosition(
      row: row,
      col: col,
    );
  }

  @override
  String toString() => 'Cursor(row: $row, col: $col)';
}
