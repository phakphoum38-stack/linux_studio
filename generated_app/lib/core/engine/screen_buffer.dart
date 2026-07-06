import 'cursor_position.dart';
import 'terminal_cell.dart';

class ScreenBuffer {
  final int rows;
  final int cols;

  late List<List<TerminalCell>> buffer;

  final CursorPosition cursor = CursorPosition();

  int currentFg = 37;
  int currentBg = 40;

  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
  }) {
    _init();
  }

  void _init() {
    buffer = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }

  bool inBounds(int r, int c) {
    return r >= 0 && r < rows && c >= 0 && c < cols;
  }

  TerminalCell cell(int r, int c) => buffer[r][c];

  void writeChar(String ch) {
    if (!inBounds(cursor.row, cursor.col)) return;

    buffer[cursor.row][cursor.col].char = ch;
    buffer[cursor.row][cursor.col].fg = currentFg;
    buffer[cursor.row][cursor.col].bg = currentBg;

    cursor.col++;
    if (cursor.col >= cols) {
      cursor.col = 0;
      cursor.row++;
    }
  }

  void writeString(String text) {
    for (final r in text.runes) {
      writeChar(String.fromCharCode(r));
    }
  }
}
