import 'cursor_position.dart';
import 'terminal_cell.dart';

/// Main terminal screen buffer.
/// Stores screen cells, cursor state, and drawing attributes.
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

  // =========================
  // INIT
  // =========================

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

  // =========================
  // BASIC PROPERTIES (FIX for renderer)
  // =========================

  int get height => rows;
  int get width => cols;

  // =========================
  // BOUNDS
  // =========================

  bool _inBounds(int r, int c) {
    return r >= 0 && r < rows && c >= 0 && c < cols;
  }

  // =========================
  // CELL ACCESS
  // =========================

  TerminalCell cellAt(int row, int col) {
    return buffer[row][col];
  }

  void setCell(int row, int col, TerminalCell cell) {
    if (!_inBounds(row, col)) return;
    buffer[row][col] = cell;
  }

  // =========================
  // WRITE API (FIX for pty_bridge)
  // =========================

  void write(int row, int col, String char) {
    if (!_inBounds(row, col)) return;
    buffer[row][col].char = char;
  }

  void setColor(int row, int col, int fg, int bg) {
    if (!_inBounds(row, col)) return;
    buffer[row][col].fg = fg;
    buffer[row][col].bg = bg;
  }

  // =========================
  // CURSOR SAVE/RESTORE
  // =========================

  void saveCursor() {
    _savedCursor = cursor.copy();
  }

  void restoreCursor() {
    if (_savedCursor == null) return;
    cursor.set(_savedCursor!.row, _savedCursor!.col);
  }

  // =========================
  // ATTRIBUTES
  // =========================

  void resetAttributes() {
    currentForeground = 37;
    currentBackground = 40;

    bold = false;
    italic = false;
    underline = false;
    inverse = false;
  }

  void setColorAttr(
    int fg,
    int bg,
    bool boldValue,
    bool underlineValue,
  ) {
    currentForeground = fg;
    currentBackground = bg;
    bold = boldValue;
    underline = underlineValue;
  }

  // =========================
  // WRITE STRING
  // =========================

  void writeText(String text) {
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
    if (ch.isEmpty) return;
    if (!_inBounds(cursor.row, cursor.col)) return;

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

  // =========================
  // CURSOR MOVEMENT
  // =========================

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

  // =========================
  // CONTROL CHARS
  // =========================

  void newline() {
    cursor.row++;
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

    cursor.col = ((cursor.col ~/ tabWidth) + 1) * tabWidth;

    if (cursor.col >= cols) {
      newline();
      carriageReturn();
    }
  }

  // =========================
  // SCREEN OPS
  // =========================

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

  void fill(String char) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer[r][c] = TerminalCell(
          char: char,
          foreground: currentForeground,
          background: currentBackground,
        );
      }
    }
  }

  void eraseChar(int row, int col) {
    if (!_inBounds(row, col)) return;

    buffer[row][col] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  void insertBlank(int row, int col) {
    if (!_inBounds(row, col)) return;

    for (int c = cols - 1; c > col; c--) {
      buffer[row][c] = buffer[row][c - 1].copy();
    }

    buffer[row][col] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  void deleteChar(int row, int col) {
    if (!_inBounds(row, col)) return;

    for (int c = col; c < cols - 1; c++) {
      buffer[row][c] = buffer[row][c + 1].copy();
    }

    buffer[row][cols - 1] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  void reset() {
    resetAttributes();
    clear();
  }

  // =========================
  // SCROLL (FIX missing)
  // =========================

  void scrollUp() {
    buffer.removeAt(0);

    buffer.add(
      List.generate(
        cols,
        (_) => TerminalCell(
          char: ' ',
          foreground: currentForeground,
          background: currentBackground,
        ),
      ),
    );
  }

  // =========================
  // DEBUG
  // =========================

  String lineAsString(int row) {
    if (row < 0 || row >= rows) return '';

    final sb = StringBuffer();
    for (final cell in buffer[row]) {
      sb.write(cell.char);
    }
    return sb.toString();
  }

  List<String> dumpText() {
    return List.generate(rows, (r) => lineAsString(r));
  }

  @override
  String toString() => dumpText().join('\n');
}
