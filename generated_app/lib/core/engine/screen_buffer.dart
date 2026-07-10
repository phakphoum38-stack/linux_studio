import 'cursor.dart';

class TerminalCell {
  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.underline = false,
    this.inverse = false,
  });

  String char;

  int foreground;
  int background;

  bool bold;
  bool underline;
  bool inverse;

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      foreground: foreground,
      background: background,
      bold: bold,
      underline: underline,
      inverse: inverse,
    );
  }
}

class ScreenBuffer {
  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
    this.maxScrollback = 10000,
  }) {
    _allocate();
  }

  final int maxScrollback;

  int rows;
  int cols;

  final Cursor cursor = Cursor();

  int currentForeground = 37;
  int currentBackground = 40;

  bool bold = false;
  bool underline = false;
  bool inverse = false;

  late List<List<TerminalCell>> lines;

  void _allocate() {
    lines = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }

    void clear() {
    _allocate();

    cursor.reset();

    currentForeground = 37;
    currentBackground = 40;

    bold = false;
    underline = false;
    inverse = false;
  }

  void clearLine(
    int row,
  ) {
    if (row < 0 || row >= rows) {
      return;
    }

    lines[row] = List.generate(
      cols,
      (_) => TerminalCell(),
    );
  }

  TerminalCell cellAt(
    int row,
    int col,
  ) {
    return lines[row][col];
  }

  void setCell(
    int row,
    int col,
    TerminalCell cell,
  ) {
    lines[row][col] = cell;
  }


    void resize(
    int newRows,
    int newCols,
  ) {
    rows = newRows;
    cols = newCols;

    _allocate();

    if (cursor.row >= rows) {
      cursor.row = rows - 1;
    }

    if (cursor.col >= cols) {
      cursor.col = cols - 1;
    }
  }

    /// เขียนข้อความลง Buffer
  void writeText(
    String text,
  ) {
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);

      switch (ch) {
        case '\n':
          newLine();
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

  /// วางตัวอักษร 1 ตัว
  void putChar(
    String ch,
  ) {
    if (cursor.row < 0 || cursor.row >= rows) {
      return;
    }

    if (cursor.col < 0 || cursor.col >= cols) {
      newLine();
    }

    lines[cursor.row][cursor.col] = TerminalCell(
      char: ch,
      foreground: currentForeground,
      background: currentBackground,
      bold: bold,
      underline: underline,
      inverse: inverse,
    );

    cursor.col++;

    if (cursor.col >= cols) {
      newLine();
    }
  }

  /// ขึ้นบรรทัดใหม่
  void newLine() {
    cursor.col = 0;
    cursor.row++;

    if (cursor.row >= rows) {
      scrollUp();
      cursor.row = rows - 1;
    }
  }

  /// กลับต้นบรรทัด
  void carriageReturn() {
    cursor.col = 0;
  }

  /// ลบย้อนหลัง
  void backspace() {
    if (cursor.col > 0) {
      cursor.col--;

      lines[cursor.row][cursor.col] = TerminalCell(
        foreground: currentForeground,
        background: currentBackground,
      );
    }
  }

  /// Tab = 4 ช่อง
  void tab() {
    const tabSize = 4;

    final next =
        ((cursor.col ~/ tabSize) + 1) * tabSize;

    cursor.col =
        next.clamp(
      0,
      cols - 1,
    );
  }

  /// Scroll ขึ้น 1 บรรทัด
  void scrollUp() {
    if (lines.isNotEmpty) {
      lines.removeAt(0);
    }

    lines.add(
      List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }

  /// ลบตัวอักษรตำแหน่งปัจจุบัน
  void deleteChar() {
    if (cursor.row >= rows) {
      return;
    }

    if (cursor.col >= cols) {
      return;
    }

    lines[cursor.row][cursor.col] = TerminalCell(
      foreground: currentForeground,
      background: currentBackground,
    );
  }

  /// แทรกช่องว่าง
  void insertChar() {
    if (cursor.row >= rows) {
      return;
    }

    final row = lines[cursor.row];

    row.insert(
      cursor.col,
      TerminalCell(),
    );

    if (row.length > cols) {
      row.removeLast();
    }
  }

    /// ลบตั้งแต่ Cursor ถึงท้ายบรรทัด
  void eraseToEndOfLine() {
    if (cursor.row < 0 || cursor.row >= rows) {
      return;
    }

    for (int i = cursor.col; i < cols; i++) {
      lines[cursor.row][i] = TerminalCell(
        foreground: currentForeground,
        background: currentBackground,
      );
    }
  }

    /// ลบตั้งแต่ต้นบรรทัดถึง Cursor
  void eraseToBeginningOfLine() {
    if (cursor.row < 0 || cursor.row >= rows) {
      return;
    }

    for (int i = 0; i <= cursor.col && i < cols; i++) {
      lines[cursor.row][i] = TerminalCell(
        foreground: currentForeground,
        background: currentBackground,
      );
    }
  }

    /// ลบตั้งแต่ Cursor ถึงท้ายจอ
    void eraseToEndOfScreen() {
       eraseToEndOfLine();

       for (int r = cursor.row + 1; r < rows; r++) {
         clearLine(r);
       }
     }

     /// ลบตั้งแต่ต้นจอถึง Cursor
  void eraseToBeginningOfScreen() {
    for (int r = 0; r < cursor.row; r++) {
      clearLine(r);
    }

    eraseToBeginningOfLine();
  }

  /// คัดลอกทั้งบรรทัด
  List<TerminalCell> copyLine(int row) {
    if (row < 0 || row >= rows) {
      return [];
    }

    return lines[row]
        .map((cell) => cell.copy())
        .toList();
  }

  /// ดึงข้อความทั้งหมดใน Buffer
  List<String> getText() {
    return lines.map((row) {
      return row
          .map((cell) => cell.char)
          .join()
          .replaceFirst(RegExp(r'\s+$'), '');
    }).toList();
  }

  /// รีเซ็ต Style ปัจจุบัน
  void resetStyle() {
    currentForeground = 37;
    currentBackground = 40;

    bold = false;
    underline = false;
    inverse = false;
  }
}


  


  

  
