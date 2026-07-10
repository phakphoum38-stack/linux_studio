class Cursor {
  Cursor({
    this.row = 0,
    this.col = 0,
  });

  int row;
  int col;

  void reset() {
    row = 0;
    col = 0;
  }

  void moveTo(
    int newRow,
    int newCol,
  ) {
    row = newRow;
    col = newCol;
  }

  void moveUp([
    int count = 1,
  ]) {
    row -= count;

    if (row < 0) {
      row = 0;
    }
  }

  void moveDown(
    int maxRows, [
    int count = 1,
  ]) {
    row += count;

    if (row >= maxRows) {
      row = maxRows - 1;
    }
  }

  void moveLeft([
    int count = 1,
  ]) {
    col -= count;

    if (col < 0) {
      col = 0;
    }
  }

  void moveRight(
    int maxCols, [
    int count = 1,
  ]) {
    col += count;

    if (col >= maxCols) {
      col = maxCols - 1;
    }
  }

  Cursor copy() {
    return Cursor(
      row: row,
      col: col,
    );
  }

  @override
  String toString() {
    return 'Cursor(row: $row, col: $col)';
  }
}
