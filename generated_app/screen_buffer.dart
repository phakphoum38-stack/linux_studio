class CursorState {
  int row = 0;
  int col = 0;

  bool visible = true;

  void reset() {
    row = 0;
    col = 0;
  }
}
class ScreenBuffer {
  final int rows;
  final int cols;

  late List<List<Cell>> grid;

  final CursorState cursor = CursorState();

  ScreenBuffer(this.rows, this.cols) {
    grid = List.generate(
      rows,
      (_) => List.generate(cols, (_) => Cell(' ', 'default')),
    );
  }

  void moveCursor(int r, int c) {
    cursor.row = r.clamp(0, rows - 1);
    cursor.col = c.clamp(0, cols - 1);
  }

  void write(String char, String color) {
    if (char == '\n') {
      cursor.row++;
      cursor.col = 0;
      return;
    }

    grid[cursor.row][cursor.col] = Cell(char, color);

    cursor.col++;

    if (cursor.col >= cols) {
      cursor.row++;
      cursor.col = 0;
    }

    if (cursor.row >= rows) {
      scroll();
      cursor.row = rows - 1;
    }
  }

  void scroll() {
    grid.removeAt(0);
    grid.add(List.generate(cols, (_) => Cell(' ', 'default')));
  }
}
