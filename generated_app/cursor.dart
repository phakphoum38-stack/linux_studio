class Cursor {
  int row = 0;
  int col = 0;

  void reset() {
    row = 0;
    col = 0;
  }

  void moveLeft() {
    if (col > 0) col--;
  }

  void moveRight(int maxCols) {
    if (col < maxCols - 1) col++;
  }

  void moveDown(int maxRows) {
    if (row < maxRows - 1) row++;
  }

  void moveUp() {
    if (row > 0) row--;
  }
}
