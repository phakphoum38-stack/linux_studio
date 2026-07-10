import 'cursor.dart';

class ScreenBuffer {
  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
  }) {
    _allocate();
  }

  final int rows;
  final int cols;

  final Cursor cursor = Cursor();

  late List<StringBuffer> _lines;

  int currentForeground = 37;
  int currentBackground = 40;

  bool bold = false;
  bool underline = false;
  bool inverse = false;

  void _allocate() {
    _lines = List.generate(
      rows,
      (_) => StringBuffer(),
    );
  }

  List<String> get lines =>
      _lines
          .map(
            (e) => e.toString(),
          )
          .toList();

  void clear() {
    _allocate();

    cursor.row = 0;
    cursor.col = 0;
  }

  void clearLine(
    int row,
  ) {
    if (row < 0 || row >= rows) {
      return;
    }

    _lines[row] = StringBuffer();

    if (cursor.row == row) {
      cursor.col = 0;
    }
  }

  void writeText(
    String text,
  ) {
    for (final rune in text.runes) {
      final ch = String.fromCharCode(
        rune,
      );

      switch (ch) {
        case '\r':
          cursor.col = 0;
          break;

        case '\n':
          cursor.row++;

          cursor.col = 0;

          if (cursor.row >= rows) {
            _scroll();
          }
          break;

        case '\b':
          if (cursor.col > 0) {
            cursor.col--;
          }
          break;

        default:
          _put(ch);
          break;
      }
    }
  }

  void _put(
    String ch,
  ) {
    if (cursor.row >= rows) {
      _scroll();
    }

    if (cursor.col >= cols) {
      cursor.row++;
      cursor.col = 0;

      if (cursor.row >= rows) {
        _scroll();
      }
    }

    _lines[cursor.row].write(ch);

    cursor.col++;
  }

  void _scroll() {
    _lines.removeAt(0);

    _lines.add(
      StringBuffer(),
    );

    cursor.row = rows - 1;

    cursor.col = 0;
  }

  String line(
    int row,
  ) {
    if (row < 0 || row >= rows) {
      return '';
    }

    return _lines[row].toString();
  }

  void setLine(
    int row,
    String text,
  ) {
    if (row < 0 || row >= rows) {
      return;
    }

    _lines[row] = StringBuffer(text);
  }
}
