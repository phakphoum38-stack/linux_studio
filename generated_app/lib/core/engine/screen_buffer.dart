import 'cursor_position.dart';
import 'terminal_cell.dart';

class ScreenBuffer {
  final int rows;
  final int cols;

  late List<List<TerminalCell>> buffer;

  final CursorPosition cursor = CursorPosition();

  int currentForeground = 37;
  int currentBackground = 40;

  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool inverse = false;

  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
  }) {
    _initialize();
  }

  void _initialize() {
    buffer = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }

  // Compatibility
  int get width => cols;
  int get height => rows;

  bool inBounds(int row, int col) {
    return row >= 0 &&
        row < rows &&
        col >= 0 &&
        col < cols;
  }

  TerminalCell cellAt(int row, int col) {
    return buffer[row][col];
  }

  void write(int row, int col, String ch) {
    if (!inBounds(row, col)) return;

    buffer[row][col].char = ch;
  }

  void setColor(
    int row,
    int col,
    int fg,
    int bg,
  ) {
    if (!inBounds(row, col)) return;

    buffer[row][col].foreground = fg;
    buffer[row][col].background = bg;
  }

  void clear() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        buffer[r][c].reset();
      }
    }

    cursor.reset();
  }

  void scrollUp() {
    buffer.removeAt(0);

    buffer.add(
      List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }

  void putChar(String ch) {
    if (!inBounds(cursor.row, cursor.col)) {
      return;
    }

    buffer[cursor.row][cursor.col] = TerminalCell(
      char: ch,
      foreground: currentForeground,
      background: currentBackground,
      bold: bold,
      italic: italic,
      underline: underline,
      inverse: inverse,
    );

    cursor.col++;

    if (cursor.col >= cols) {
      cursor.col = 0;
      cursor.row++;

      if (cursor.row >= rows) {
        scrollUp();
        cursor.row = rows - 1;
      }
    }
  }

  void writeText(String text) {
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);

      switch (ch) {
        case '\n':
          cursor.row++;

          if (cursor.row >= rows) {
            scrollUp();
            cursor.row = rows - 1;
          }

          cursor.col = 0;
          break;

        case '\r':
          cursor.col = 0;
          break;

        default:
          putChar(ch);
      }
    }
  }

  // Compatibility aliases
  void writeChar(String ch) => putChar(ch);

  void writeString(String text) => writeText(text);

  TerminalCell cell(int row, int col) => cellAt(row, col);
}
