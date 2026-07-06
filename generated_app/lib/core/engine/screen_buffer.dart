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

  CursorPosition? _savedCursor;

  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
  }) {
    _initialize();
  }

  // =====================
  // INIT
  // =====================
  void _initialize() {
    buffer = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => TerminalCell(
          char: ' ',
          foreground: currentForeground,
          background: currentBackground,
        ),
      ),
    );
  }

  // =====================
  // COMPAT GETTERS (IMPORTANT FIX)
  // =====================
  int get height => rows;
  int get width => cols;

  // =====================
  // BASIC BUFFER OPS
  // =====================
  bool inBounds(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < cols;
  }

  TerminalCell cellAt(int row, int col) {
    return buffer[row][col];
  }

  void setCell(int row, int col, TerminalCell cell) {
    if (!inBounds(row, col)) return;
    buffer[row][col] = cell;
  }

  void clear() {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer[r][c] = TerminalCell(
          char: ' ',
          foreground: currentForeground,
          background: currentBackground,
        );
      }
    }
  }

  // =====================
  // WRITE API (FIXED ONCE ONLY)
  // =====================
  void write(String text) {
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);

      switch (ch) {
        case '\n':
          newline();
          break;
        case '\r':
          carriageReturn();
          break;
        case '\b':
          backspace();
          break;
        case '\t':
          tab();
          break;
        default:
          putChar(ch);
      }
    }
  }

  void putChar(String ch) {
    if (!inBounds(cursor.row, cursor.col)) return;

    buffer[cursor.row][cursor.col] = TerminalCell(
      char: ch,
      foreground: currentForeground,
      background: currentBackground,
      bold: bold,
      italic: italic,
      underline: underline,
      inverse: inverse,
    );

    cursorForward();
  }

  // =====================
  // CURSOR MOVEMENT
  // =====================
  void cursorForward([int count = 1]) {
    cursor.col += count;

    if (cursor.col >= cols) {
      cursor.col = 0;
      cursor.row++;

      if (cursor.row >= rows) {
        scrollUp();
        cursor.row = rows - 1;
      }
    }
  }

  void cursorBack([int count = 1]) {
    cursor.col = (cursor.col - count).clamp(0, cols - 1);
  }

  void cursorUp([int count = 1]) {
    cursor.row = (cursor.row - count).clamp(0, rows - 1);
  }

  void cursorDown([int count = 1]) {
    cursor.row = (cursor.row + count).clamp(0, rows - 1);
  }

  void moveCursor(int row, int col) {
    cursor.row = row.clamp(0, rows - 1);
    cursor.col = col.clamp(0, cols - 1);
  }

  // =====================
  // LINE OPS
  // =====================
  void newline() {
    cursor.row++;
    cursor.col = 0;

    if (cursor.row >= rows) {
      scrollUp();
      cursor.row = rows - 1;
    }
  }

  void carriageReturn() {
    cursor.col = 0;
  }

  void backspace() {
    if (cursor.col > 0) cursor.col--;
  }

  void tab() {
    const tabWidth = 8;

    cursor.col =
        ((cursor.col ~/ tabWidth) + 1) * tabWidth;

    if (cursor.col >= cols) {
      newline();
    }
  }

  // =====================
  // SCROLL (IMPORTANT MISSING FIX)
  // =====================
  void scrollUp() {
    buffer.removeAt(0);

    buffer.add(List.generate(
      cols,
      (_) => TerminalCell(
        char: ' ',
        foreground: currentForeground,
        background: currentBackground,
      ),
    ));
  }

  // =====================
  // CURSOR SAVE/RESTORE
  // =====================
  void saveCursor() {
    _savedCursor = cursor.copy();
  }

  void restoreCursor() {
    if (_savedCursor == null) return;
    cursor.set(_savedCursor!.row, _savedCursor!.col);
  }

  // =====================
  // COLORS
  // =====================
  void setColor(
    int foreground,
    int background,
    bool boldValue,
    bool underlineValue,
  ) {
    currentForeground = foreground;
    currentBackground = background;
    bold = boldValue;
    underline = underlineValue;
  }
}
