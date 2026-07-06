import 'cursor_position.dart';
import 'terminal_cell.dart';

/// Main terminal screen buffer.
///
/// This class stores every visible cell,
/// cursor state,
/// current drawing colors,
/// and provides basic VT100 operations.
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

  /// Returns true if row/column exists.
  bool inBounds(int row, int col) {
    return row >= 0 &&
        row < rows &&
        col >= 0 &&
        col < cols;
  }

  /// Returns one cell.
  TerminalCell cellAt(int row, int col) {
    return buffer[row][col];
  }

  /// Replace one cell.
  void setCell(
    int row,
    int col,
    TerminalCell cell,
  ) {
    if (!inBounds(row, col)) return;

    buffer[row][col] = cell;
  }

  /// Save cursor position.
  void saveCursor() {
    _savedCursor = cursor.copy();
  }

  /// Restore cursor position.
  void restoreCursor() {
    if (_savedCursor == null) return;

    cursor.set(
      _savedCursor!.row,
      _savedCursor!.col,
    );
  }

  /// Reset SGR attributes.
  void resetAttributes() {
    currentForeground = 37;
    currentBackground = 40;

    bold = false;
    italic = false;
    underline = false;
    inverse = false;
  }

  /// Change drawing color.
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
    /// Write a string starting at the current cursor position.
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

  /// Draw one character.
  void putChar(String ch) {
    if (ch.isEmpty) return;

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

    cursorForward();
  }

  /// Move to next column.
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

  /// Move cursor left.
  void cursorBack([int count = 1]) {
    cursor.col -= count;

    if (cursor.col < 0) {
      cursor.col = 0;
    }
  }

  /// Move cursor up.
  void cursorUp([int count = 1]) {
    cursor.row -= count;

    if (cursor.row < 0) {
      cursor.row = 0;
    }
  }

  /// Move cursor down.
  void cursorDown([int count = 1]) {
    cursor.row += count;

    if (cursor.row >= rows) {
      cursor.row = rows - 1;
    }
  }

  /// Absolute move.
  void moveCursor(int row, int col) {
    cursor.row = row.clamp(0, rows - 1);
    cursor.col = col.clamp(0, cols - 1);
  }

  /// New line.
  void newline() {
    cursor.row++;

    if (cursor.row >= rows) {
      scrollUp();
      cursor.row = rows - 1;
    }
  }

  /// Carriage return.
  void carriageReturn() {
    cursor.col = 0;
  }

  /// Backspace.
  void backspace() {
    if (cursor.col > 0) {
      cursor.col--;
    }
  }

  /// Horizontal tab (8 columns).
  void tab() {
    const tabWidth = 8;

    cursor.col =
        ((cursor.col ~/ tabWidth) + 1) * tabWidth;

    if (cursor.col >= cols) {
      newline();
      carriageReturn();
    }
  }
    /// Write a string starting at the current cursor position.
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

  /// Draw one character.
  void putChar(String ch) {
    if (ch.isEmpty) return;

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

    cursorForward();
  }

  /// Move to next column.
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

  /// Move cursor left.
  void cursorBack([int count = 1]) {
    cursor.col -= count;

    if (cursor.col < 0) {
      cursor.col = 0;
    }
  }

  /// Move cursor up.
  void cursorUp([int count = 1]) {
    cursor.row -= count;

    if (cursor.row < 0) {
      cursor.row = 0;
    }
  }

  /// Move cursor down.
  void cursorDown([int count = 1]) {
    cursor.row += count;

    if (cursor.row >= rows) {
      cursor.row = rows - 1;
    }
  }

  /// Absolute move.
  void moveCursor(int row, int col) {
    cursor.row = row.clamp(0, rows - 1);
    cursor.col = col.clamp(0, cols - 1);
  }

  /// New line.
  void newline() {
    cursor.row++;

    if (cursor.row >= rows) {
      scrollUp();
      cursor.row = rows - 1;
    }
  }

  /// Carriage return.
  void carriageReturn() {
    cursor.col = 0;
  }

  /// Backspace.
  void backspace() {
    if (cursor.col > 0) {
      cursor.col--;
    }
  }

  /// Horizontal tab (8 columns).
  void tab() {
    const tabWidth = 8;

    cursor.col =
        ((cursor.col ~/ tabWidth) + 1) * tabWidth;

    if (cursor.col >= cols) {
      newline();
      carriageReturn();
    }
  }
    /// Fill the entire screen with one character.
  void fill(String char) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        buffer[r][c] = TerminalCell(
          char: char,
          foreground: currentForeground,
          background: currentBackground,
          bold: bold,
          italic: italic,
          underline: underline,
          inverse: inverse,
        );
      }
    }
  }

  /// Erase one character.
  void eraseChar(int row, int col) {
    if (!inBounds(row, col)) return;

    buffer[row][col] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  /// Insert one blank character.
  void insertBlank(int row, int col) {
    if (!inBounds(row, col)) return;

    for (int c = cols - 1; c > col; c--) {
      buffer[row][c] = buffer[row][c - 1].copy();
    }

    buffer[row][col] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  /// Delete one character.
  void deleteChar(int row, int col) {
    if (!inBounds(row, col)) return;

    for (int c = col; c < cols - 1; c++) {
      buffer[row][c] = buffer[row][c + 1].copy();
    }

    buffer[row][cols - 1] = TerminalCell(
      char: ' ',
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  /// Reset terminal.
  void reset() {
    resetAttributes();
    clear();
  }

  /// Return one line as String.
  String lineAsString(int row) {
    if (row < 0 || row >= rows) {
      return '';
    }

    final sb = StringBuffer();

    for (final cell in buffer[row]) {
      sb.write(cell.char);
    }

    return sb.toString();
  }

  /// Return whole screen.
  List<String> dumpText() {
    return List.generate(
      rows,
      (r) => lineAsString(r),
    );
  }

  /// Current cursor row.
  int get cursorRow => cursor.row;

  /// Current cursor column.
  int get cursorCol => cursor.col;

  /// True if cursor is inside screen.
  bool get cursorValid =>
      inBounds(cursor.row, cursor.col);

  @override
  String toString() {
    return dumpText().join('\n');
  }
}
