class ScreenCell {
  String char;
  int fg;
  int bg;

  ScreenCell(this.char, this.fg, this.bg);
}

class ScreenBuffer {
  final int width;
  final int height;

  late List<List<ScreenCell>> buffer;

  ScreenBuffer(this.width, this.height) {
    buffer = List.generate(
      height,
      (_) => List.generate(width, (_) => ScreenCell(' ', 37, 40)),
    );
  }

  void setChar(int row, int col, String char) {
    if (!_inBounds(row, col)) return;
    buffer[row][col].char = char;
  }

  void clear() {
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        buffer[r][c] = ScreenCell(' ', 37, 40);
      }
    }
  }

  void clearLine(int row) {
    if (row < 0 || row >= height) return;
    for (var c = 0; c < width; c++) {
      buffer[row][c] = ScreenCell(' ', 37, 40);
    }
  }

  bool _inBounds(int r, int c) =>
      r >= 0 && r < height && c >= 0 && c < width;
}
