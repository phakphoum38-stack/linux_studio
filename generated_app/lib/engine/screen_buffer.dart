// Simple ScreenBuffer and Cell implementation for terminal rendering.
// Provides a minimal API matching renderer expectations: buffer[row][col].char, width, height, helpers.

class Cell {
  String char;
  // Add more attributes later (fgColor, bgColor, attrs) as needed.
  Cell([this.char = ' ']);
}

class ScreenBuffer {
  final int width;
  final int height;
  final List<List<Cell>> buffer;

  ScreenBuffer({required this.width, required this.height})
      : buffer = List.generate(
          height,
          (_) => List.generate(width, (_) => Cell(' ')),
        );

  String charAt(int row, int col) => buffer[row][col].char;

  void setChar(int row, int col, String ch) {
    buffer[row][col].char = ch;
  }

  void clear([String fill = ' ']) {
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        buffer[r][c].char = fill;
      }
    }
  }
}
